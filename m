Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3FDWuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:50:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35842 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3FDWoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:04 -0400
Message-Id: <20130604172133.704900067@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 082/184] keys: fix race with concurrent
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 install_user_keyrings()

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 security/keys/process_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 931cfda..75fb18c 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -56,7 +56,7 @@ int install_user_keyrings(void)
 
 	kenter("%p{%u}", user, user->uid);
 
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" = 0 [exist]");
 		return 0;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



