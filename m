Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3H2Xx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:53:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52805 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3H2XxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:53:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>
References: <87ob8gys0d.fsf@xmission.com>
Date: Thu, 29 Aug 2013 16:53:16 -0700
In-Reply-To: <87ob8gys0d.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 29 Aug 2013 16:52:18 -0700")
Message-ID: <87ioyoyryr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Uq2QGal2rD09GdCzInIl7AktJ+zuRYD4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0553]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 1/5] namespaces: Simplify copy_namespaces so it is clear what is going on.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the test for the impossible case where tsk->nsproxy == NULL.  Fork
will never be called with tsk->nsproxy == NULL.

Only call get_nsproxy when we don't need to generate a new_nsproxy,
and mark the case where we don't generate a new nsproxy as likely.

Remove the code to drop an unnecessarily acquired nsproxy value.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/nsproxy.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index d9afd2563..a1ed011 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -125,22 +125,16 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
-	int err = 0;
 
-	if (!old_ns)
+	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
+			      CLONE_NEWPID | CLONE_NEWNET)))) {
+		get_nsproxy(old_ns);
 		return 0;
-
-	get_nsproxy(old_ns);
-
-	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-				CLONE_NEWPID | CLONE_NEWNET)))
-		return 0;
-
-	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto out;
 	}
 
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/*
 	 * CLONE_NEWIPC must detach from the undolist: after switching
 	 * to a new ipc namespace, the semaphore arrays from the old
@@ -149,22 +143,15 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	 * it along with CLONE_NEWIPC.
 	 */
 	if ((flags & (CLONE_NEWIPC | CLONE_SYSVSEM)) ==
-		(CLONE_NEWIPC | CLONE_SYSVSEM)) {
-		err = -EINVAL;
-		goto out;
-	}
+		(CLONE_NEWIPC | CLONE_SYSVSEM)) 
+		return -EINVAL;
 
 	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
-	if (IS_ERR(new_ns)) {
-		err = PTR_ERR(new_ns);
-		goto out;
-	}
+	if (IS_ERR(new_ns))
+		return  PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
-
-out:
-	put_nsproxy(old_ns);
-	return err;
+	return 0;
 }
 
 void free_nsproxy(struct nsproxy *ns)
-- 
1.7.5.4

