Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3DVOmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:42:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51538 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847Ab3DVOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.288457047@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [52/75] net: fix incorrect credentials passing
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: scm_set_cred() does user namespace conversion
 of euid/egid using cred_to_ucred().  Add and use cred_real_to_ucred() to
 do the same thing for real uid/gid.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/scm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -50,7 +50,7 @@ static __inline__ void scm_set_cred(stru
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_real_to_ucred(pid, cred, &scm->creds);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -761,6 +761,20 @@ void cred_to_ucred(struct pid *pid, cons
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
 
+void cred_real_to_ucred(struct pid *pid, const struct cred *cred,
+			struct ucred *ucred)
+{
+	ucred->pid = pid_vnr(pid);
+	ucred->uid = ucred->gid = -1;
+	if (cred) {
+		struct user_namespace *current_ns = current_user_ns();
+
+		ucred->uid = user_ns_map_uid(current_ns, cred, cred->uid);
+		ucred->gid = user_ns_map_gid(current_ns, cred, cred->gid);
+	}
+}
+EXPORT_SYMBOL_GPL(cred_real_to_ucred);
+
 int sock_getsockopt(struct socket *sock, int level, int optname,
 		    char __user *optval, int __user *optlen)
 {
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -317,6 +317,7 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+extern void cred_real_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,

