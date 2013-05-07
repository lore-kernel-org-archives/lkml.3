Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab3EGOFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:05:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42347 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3EGNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/118] net: fix incorrect credentials passing
Date: Tue,  7 May 2013 14:38:23 +0100
Message-Id: <1367933964-1564-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 83f1b4ba917db5dc5a061a44b3403ddb6e783494 upstream.

Commit 257b5358b32f ("scm: Capture the full credentials of the scm
sender") changed the credentials passing code to pass in the effective
uid/gid instead of the real uid/gid.

Obviously this doesn't matter most of the time (since normally they are
the same), but it results in differences for suid binaries when the wrong
uid/gid ends up being used.

This just undoes that (presumably unintentional) part of the commit.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backport to 3.5 based on davem backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/socket.h |  3 ++-
 include/net/scm.h      |  2 +-
 net/core/sock.c        | 14 ++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 25d6322..2a32b9d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -316,7 +316,8 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred,
+			  bool use_effective);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
diff --git a/include/net/scm.h b/include/net/scm.h
index 0c0017c..9f211cf 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -50,7 +50,7 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_to_ucred(pid, cred, &scm->creds, false);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
diff --git a/net/core/sock.c b/net/core/sock.c
index c5f765c..5d30122 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -807,15 +807,20 @@ EXPORT_SYMBOL(sock_setsockopt);
 
 
 void cred_to_ucred(struct pid *pid, const struct cred *cred,
-		   struct ucred *ucred)
+		   struct ucred *ucred, bool use_effective)
 {
 	ucred->pid = pid_vnr(pid);
 	ucred->uid = ucred->gid = -1;
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = from_kuid(current_ns, cred->euid);
-		ucred->gid = from_kgid(current_ns, cred->egid);
+		if (use_effective) {
+			ucred->uid = from_kuid(current_ns, cred->euid);
+			ucred->gid = from_kgid(current_ns, cred->egid);
+		} else {
+			ucred->uid = from_kuid(current_ns, cred->uid);
+			ucred->gid = from_kgid(current_ns, cred->gid);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
@@ -976,7 +981,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
-		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred,
+			      &peercred, true);
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
-- 
1.8.1.2

