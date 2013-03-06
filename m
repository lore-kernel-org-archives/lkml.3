Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3CFWYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:24:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab3CFWY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:24:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, pmatouse@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org, mguzik@redhat.com, jmorris@namei.org,
        ben@decadent.org.uk
Date: Wed, 06 Mar 2013 22:24:12 +0000
Message-ID: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes CVE-2013-1792.

There is a race in install_user_keyrings() that can cause a NULL pointer
dereference when called concurrently for the same user if the uid and
uid-session keyrings are not yet created.  It might be possible for an
unprivileged user to trigger this by calling keyctl() from userspace in
parallel immediately after logging in.

Assume that we have two threads both executing lookup_user_key(), both looking
for KEY_SPEC_USER_SESSION_KEYRING.

	THREAD A			THREAD B
	===============================	===============================
					==>call install_user_keyrings();
	if (!cred->user->session_keyring)
	==>call install_user_keyrings()
					...
					user->uid_keyring = uid_keyring;
	if (user->uid_keyring)
		return 0;
	<==
	key = cred->user->session_keyring [== NULL]
					user->session_keyring = session_keyring;
	atomic_inc(&key->usage); [oops]

At the point thread A dereferences cred->user->session_keyring, thread B hasn't
updated user->session_keyring yet, but thread A assumes it is populated because
install_user_keyrings() returned ok.

The race window is really small but can be exploited if, for example, thread B
is interrupted or preempted after initializing uid_keyring, but before doing
setting session_keyring.

This couldn't be reproduced on a stock kernel.  However, after placing
systemtap probe on 'user->session_keyring = session_keyring;' that introduced
some delay, the kernel could be crashed reliably.

Fix this by checking both pointers before deciding whether to return.
Alternatively, the test could be done away with entirely as it is checked
inside the mutex - but since the mutex is global, that may not be the best way.

Reported-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/process_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 58dfe08..c5ec083 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -57,7 +57,7 @@ int install_user_keyrings(void)
 
 	kenter("%p{%u}", user, uid);
 
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" = 0 [exist]");
 		return 0;
 	}

