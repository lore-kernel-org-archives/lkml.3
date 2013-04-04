Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3DDD2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 23:28:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53959 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762092Ab3DDD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 23:28:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "David S. Miller" <davem@davemloft.net>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<1365035424.13853.48.camel@edumazet-glaptop>
	<878v4zjei0.fsf@xmission.com> <87li8zhwkw.fsf_-_@xmission.com>
	<87d2ubhwiw.fsf_-_@xmission.com>
Date: Wed, 03 Apr 2013 20:28:16 -0700
In-Reply-To: <87d2ubhwiw.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Wed, 03 Apr 2013 19:14:47 -0700")
Message-ID: <87li8zezzj.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/K/O3PHhCRT09t6hyqp9fcPzusGxgZCL8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"David S. Miller" <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH 3/2] scm: Stop passing struct cred
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that uids and gids are completely encapsulated in kuid_t
and kgid_t we no longer need to pass struct cred which allowed
us to test both the uid and the user namespace for equality.

Passing struct cred potentially allows us to pass the entire group
list as BSD does but I don't believe the cost of cache line misses
justifies retaining code for a future potential application.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Included in this patchset because there are trivial dependencies,
and since we are sort of arguing about this anyway.  This definitely is
not for stable.

 include/net/af_unix.h |    3 ++-
 include/net/scm.h     |   16 ++++++----------
 net/core/scm.c        |   16 ----------------
 net/unix/af_unix.c    |   16 ++++++++--------
 4 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 0a996a3..a8836e8 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -29,7 +29,8 @@ struct unix_address {
 
 struct unix_skb_parms {
 	struct pid		*pid;		/* Skb credentials	*/
-	const struct cred	*cred;
+	kuid_t			uid;
+	kgid_t			gid;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
 	u32			secid;		/* Security ID		*/
diff --git a/include/net/scm.h b/include/net/scm.h
index 975cca0..5a4c6a9 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -26,7 +26,6 @@ struct scm_fp_list {
 
 struct scm_cookie {
 	struct pid		*pid;		/* Skb credentials */
-	const struct cred	*cred;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 	struct scm_creds	creds;		/* Skb credentials	*/
 #ifdef CONFIG_SECURITY_NETWORK
@@ -51,23 +50,18 @@ static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_co
 #endif /* CONFIG_SECURITY_NETWORK */
 
 static __inline__ void scm_set_cred(struct scm_cookie *scm,
-				    struct pid *pid, const struct cred *cred)
+				    struct pid *pid, kuid_t uid, kgid_t gid)
 {
 	scm->pid  = get_pid(pid);
-	scm->cred = cred ? get_cred(cred) : NULL;
 	scm->creds.pid = pid_vnr(pid);
-	scm->creds.uid = cred ? cred->euid : INVALID_UID;
-	scm->creds.gid = cred ? cred->egid : INVALID_GID;
+	scm->creds.uid = uid;
+	scm->creds.gid = gid;
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
 {
 	put_pid(scm->pid);
 	scm->pid  = NULL;
-
-	if (scm->cred)
-		put_cred(scm->cred);
-	scm->cred = NULL;
 }
 
 static __inline__ void scm_destroy(struct scm_cookie *scm)
@@ -81,8 +75,10 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 			       struct scm_cookie *scm, bool forcecreds)
 {
 	memset(scm, 0, sizeof(*scm));
+	scm->creds.uid = INVALID_UID;
+	scm->creds.gid = INVALID_GID;
 	if (forcecreds)
-		scm_set_cred(scm, task_tgid(current), current_cred());
+		scm_set_cred(scm, task_tgid(current), current_euid(), current_egid());
 	unix_get_peersec_dgram(sock, scm);
 	if (msg->msg_controllen <= 0)
 		return 0;
diff --git a/net/core/scm.c b/net/core/scm.c
index 2dc6cda..83b2b38 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -187,22 +187,6 @@ int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *p)
 
 			p->creds.uid = uid;
 			p->creds.gid = gid;
-
-			if (!p->cred ||
-			    !uid_eq(p->cred->euid, uid) ||
-			    !gid_eq(p->cred->egid, gid)) {
-				struct cred *cred;
-				err = -ENOMEM;
-				cred = prepare_creds();
-				if (!cred)
-					goto error;
-
-				cred->uid = cred->euid = uid;
-				cred->gid = cred->egid = gid;
-				if (p->cred)
-					put_cred(p->cred);
-				p->cred = cred;
-			}
 			break;
 		}
 		default:
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2db702d..f5594b5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1340,7 +1340,6 @@ static void unix_destruct_scm(struct sk_buff *skb)
 	struct scm_cookie scm;
 	memset(&scm, 0, sizeof(scm));
 	scm.pid  = UNIXCB(skb).pid;
-	scm.cred = UNIXCB(skb).cred;
 	if (UNIXCB(skb).fp)
 		unix_detach_fds(&scm, skb);
 
@@ -1391,8 +1390,8 @@ static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool sen
 	int err = 0;
 
 	UNIXCB(skb).pid  = get_pid(scm->pid);
-	if (scm->cred)
-		UNIXCB(skb).cred = get_cred(scm->cred);
+	UNIXCB(skb).uid = scm->creds.uid;
+	UNIXCB(skb).gid = scm->creds.gid;
 	UNIXCB(skb).fp = NULL;
 	if (scm->fp && send_fds)
 		err = unix_attach_fds(scm, skb);
@@ -1409,13 +1408,13 @@ static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool sen
 static void maybe_add_creds(struct sk_buff *skb, const struct socket *sock,
 			    const struct sock *other)
 {
-	if (UNIXCB(skb).cred)
+	if (UNIXCB(skb).pid)
 		return;
 	if (test_bit(SOCK_PASSCRED, &sock->flags) ||
 	    !other->sk_socket ||
 	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags)) {
 		UNIXCB(skb).pid  = get_pid(task_tgid(current));
-		UNIXCB(skb).cred = get_current_cred();
+		current_euid_egid(&UNIXCB(skb).uid, &UNIXCB(skb).gid);
 	}
 }
 
@@ -1819,7 +1818,7 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 		siocb->scm = &tmp_scm;
 		memset(&tmp_scm, 0, sizeof(tmp_scm));
 	}
-	scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
+	scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).uid, UNIXCB(skb).gid);
 	unix_set_secdata(siocb->scm, skb);
 
 	if (!(flags & MSG_PEEK)) {
@@ -1991,11 +1990,12 @@ again:
 		if (check_creds) {
 			/* Never glue messages from different writers */
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
-			    (UNIXCB(skb).cred != siocb->scm->cred))
+			    !uid_eq(UNIXCB(skb).uid, siocb->scm->creds.uid) ||
+			    !gid_eq(UNIXCB(skb).gid, siocb->scm->creds.gid))
 				break;
 		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
-			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
+			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).uid, UNIXCB(skb).gid);
 			check_creds = 1;
 		}
 
-- 
1.7.5.4

