Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab3D2TNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:13:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878Ab3D2TDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 33/34] net: fix incorrect credentials passing
Date: Mon, 29 Apr 2013 12:02:40 -0700
Message-Id: <20130429184704.642438507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 83f1b4ba917db5dc5a061a44b3403ddb6e783494 ]

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/socket.h |    3 ++-
 include/net/scm.h      |    2 +-
 net/core/sock.c        |   14 ++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

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
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -50,7 +50,7 @@ static __inline__ void scm_set_cred(stru
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_to_ucred(pid, cred, &scm->creds, false);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -815,15 +815,20 @@ EXPORT_SYMBOL(sock_setsockopt);
 
 
 void cred_to_ucred(struct pid *pid, const struct cred *cred,
-		   struct ucred *ucred)
+		   struct ucred *ucred, bool use_effective)
 {
 	ucred->pid = pid_vnr(pid);
 	ucred->uid = ucred->gid = -1;
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = user_ns_map_uid(current_ns, cred, cred->euid);
-		ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
+		if (use_effective) {
+			ucred->uid = user_ns_map_uid(current_ns, cred, cred->euid);
+			ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
+		} else {
+			ucred->uid = user_ns_map_uid(current_ns, cred, cred->uid);
+			ucred->gid = user_ns_map_gid(current_ns, cred, cred->gid);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
@@ -984,7 +989,8 @@ int sock_getsockopt(struct socket *sock,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
-		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred,
+			      &peercred, true);
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;


