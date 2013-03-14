Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3CNKl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:41:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3CNKiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 79/88] keys: fix race with concurrent install_user_keyrings()
Date: Thu, 14 Mar 2013 10:36:12 +0000
Message-Id: <1363257381-15900-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 0da9dfdd2cd9889201bc6f6f43580c99165cd087 upstream.

This fixes CVE-2013-1792.

There is a race in install_user_keyrings() that can cause a NULL pointer
dereference when called concurrently for the same user if the uid and
uid-session keyrings are not yet created.  It might be possible for an
unprivileged user to trigger this by calling keyctl() from userspace in
parallel immediately after logging in.

Assume that we have two threads both executing lookup_user_key(), both
looking for KEY_SPEC_USER_SESSION_KEYRING.

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

At the point thread A dereferences cred->user->session_keyring, thread B
hasn't updated user->session_keyring yet, but thread A assumes it is
populated because install_user_keyrings() returned ok.

The race window is really small but can be exploited if, for example,
thread B is interrupted or preempted after initializing uid_keyring, but
before doing setting session_keyring.

This couldn't be reproduced on a stock kernel.  However, after placing
systemtap probe on 'user->session_keyring = session_keyring;' that
introduced some delay, the kernel could be crashed reliably.

Fix this by checking both pointers before deciding whether to return.
Alternatively, the test could be done away with entirely as it is checked
inside the mutex - but since the mutex is global, that may not be the best
way.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/keys/process_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index bb6f6ef..6f601ab 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -54,7 +54,7 @@ int install_user_keyrings(void)
 
 	kenter("%p{%u}", user, user->uid);
 
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" = 0 [exist]");
 		return 0;
 	}
-- 
1.8.1.2

