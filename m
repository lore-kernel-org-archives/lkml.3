Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab3EGEoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:44:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3EGEZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:37 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3P-kHQg8RFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bUDKN9DriwMA:10 a=Z4Rwk6OoAAAA:8 a=SOq6UgPBAAAA:8 a=PtDNVHqPAAAA:8 a=hBqU3vQJAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=Z9hppVypvsQCDiRzgicA:9 a=jbrJJM5MRmoA:10 a=5y_flRe8UpcA:10 a=wYE_KDyynt4A:10 a=4gZ4WExUoD4A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035901.477713771@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [123/126] net: fix incorrect credentials passing
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0123-net-fix-incorrect-credentials-passing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/socket.h |    3 ++-
 include/net/scm.h      |    2 +-
 net/core/sock.c        |   14 ++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index ba7b2e8..9b9b3cb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -317,7 +317,8 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred,
+			  bool use_effective);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
diff --git a/include/net/scm.h b/include/net/scm.h
index 7dc0854..5e1c8d2 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -49,7 +49,7 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_to_ucred(pid, cred, &scm->creds, false);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
diff --git a/net/core/sock.c b/net/core/sock.c
index a6000fb..e794a4a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -862,15 +862,20 @@ EXPORT_SYMBOL(sock_setsockopt);
 
 
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
@@ -1031,7 +1036,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
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
1.7.10.4


