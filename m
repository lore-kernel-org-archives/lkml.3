Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab3DWQKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:10:17 -0400
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:28567
	"EHLO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756718Ab3DWQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:10:15 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 12:10:15 EDT
X-Yahoo-Newman-Id: 235963.32066.bm@smtp110.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r2u_4t0VM1kINvn0NAsVJLt1N4OksPyCD7HOKTfzQcJrxP3
 yxlf5b5A8xRnspZZq7Jz.kOIT6FQCxTL7vgXDuN5etjGne.hp.xrtAufkvxd
 GPxyTsx5zRwSO1H7JS0wr.jTYEXh1PrxCUPz4bHW_6DXWjqfoLNStRSFyuN3
 s9hYkxgD78R0sooyMNsP4CiyGWkndCHqMz7MfBFd6wMjcp0Em8pqU3_lg27V
 rZN_Vx7OfTokN.1T2J490I66s.WD7.ccCLpERwHgaPgUonFEa57uufV.sEAx
 svArLgCcAIBIoNfkSyIor_wFshjEM2hAEEF_oJZp_.ST2D98oiiBpcmpcc3j
 Z_Z8iWvZeBE6ptGH2oOochppYVkndmecNLHh150F3x8i9x1UzsXicdMP0zHe
 d8ePft6aQHiLPfmwtGHRKc0NqzPdz1dHW.LfSw8CBRQ4mMhAgpFfwsDHofw3
 _ug--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp110.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:15 -0700 PDT
Message-ID: <5176B0FF.3050602@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:15 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v13 2/9] LSM: Complete conversion to kill_pid_info_as_cred
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 2/9] LSM: Complete conversion to kill_pid_info_as_cred

The kill_pid_info_as_cred() function takes a secid as a parameter,
but the value is always taken from the cred that is also passed as
a parameter. Remove the secid parameter. Change the LSM interface
to take the cred rather than the secid, eliminating the need to get
or pass the secid in cases where it is unused.

The two LSMs that use this hook, SELinux and Smack, are updated.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 drivers/usb/core/devio.c   |   10 ++--------
 include/linux/sched.h      |    2 +-
 include/linux/security.h   |    9 +++++----
 kernel/signal.c            |    6 +++---
 security/selinux/hooks.c   |    7 +++----
 security/smack/smack_lsm.c |   10 +++++-----
 6 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 8823e98..18763ea 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -75,7 +75,6 @@ struct dev_state {
 	const struct cred *cred;
 	void __user *disccontext;
 	unsigned long ifclaimed;
-	u32 secid;
 	u32 disabled_bulk_eps;
 };
 
@@ -91,7 +90,6 @@ struct async {
 	struct urb *urb;
 	unsigned int mem_usage;
 	int status;
-	u32 secid;
 	u8 bulk_addr;
 	u8 bulk_status;
 };
@@ -492,7 +490,6 @@ static void async_completed(struct urb *urb)
 	struct dev_state *ps = as->ps;
 	struct siginfo sinfo;
 	struct pid *pid = NULL;
-	u32 secid = 0;
 	const struct cred *cred = NULL;
 	int signr;
 
@@ -507,7 +504,6 @@ static void async_completed(struct urb *urb)
 		sinfo.si_addr = as->userurb;
 		pid = get_pid(as->pid);
 		cred = get_cred(as->cred);
-		secid = as->secid;
 	}
 	snoop(&urb->dev->dev, "urb complete\n");
 	snoop_urb(urb->dev, as->userurb, urb->pipe, urb->actual_length,
@@ -521,7 +517,7 @@ static void async_completed(struct urb *urb)
 	spin_unlock(&ps->lock);
 
 	if (signr) {
-		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);
+		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred);
 		put_pid(pid);
 		put_cred(cred);
 	}
@@ -815,7 +811,6 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	ps->cred = get_current_cred();
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
-	security_task_getsecid(current, &ps->secid);
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
 	file->private_data = ps;
@@ -1430,7 +1425,6 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
 	as->cred = get_current_cred();
-	security_task_getsecid(current, &as->secid);
 	snoop_urb(ps->dev, as->userurb, as->urb->pipe,
 			as->urb->transfer_buffer_length, 0, SUBMIT,
 			NULL, 0);
@@ -2211,7 +2205,7 @@ static void usbdev_remove(struct usb_device *udev)
 			sinfo.si_code = SI_ASYNCIO;
 			sinfo.si_addr = ps->disccontext;
 			kill_pid_info_as_cred(ps->discsignr, &sinfo,
-					ps->disc_pid, ps->cred, ps->secid);
+					ps->disc_pid, ps->cred);
 		}
 	}
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..08a6871 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2164,7 +2164,7 @@ extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
-				const struct cred *, u32);
+				const struct cred *);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
diff --git a/include/linux/security.h b/include/linux/security.h
index 032c366..a1079ab 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -777,7 +777,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@p contains the task_struct for process.
  *	@info contains the signal information.
  *	@sig contains the signal value.
- *	@secid contains the sid of the process where the signal originated
+ *	@cred contains the sid of the process where the signal originated
  *	Return 0 if permission is granted.
  * @task_wait:
  *	Check permission before allowing a process to reap a child process @p
@@ -1546,7 +1546,8 @@ struct security_operations {
 	int (*task_getscheduler) (struct task_struct *p);
 	int (*task_movememory) (struct task_struct *p);
 	int (*task_kill) (struct task_struct *p,
-			  struct siginfo *info, int sig, u32 secid);
+			  struct siginfo *info, int sig,
+			  const struct cred *cred);
 	int (*task_wait) (struct task_struct *p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
@@ -1808,7 +1809,7 @@ int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid);
+			int sig, const struct cred *cred);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
@@ -2377,7 +2378,7 @@ static inline int security_task_movememory(struct task_struct *p)
 
 static inline int security_task_kill(struct task_struct *p,
 				     struct siginfo *info, int sig,
-				     u32 secid)
+				     const struct cred *cred)
 {
 	return 0;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index dd72567..c702648 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -815,7 +815,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 		}
 	}
 
-	return security_task_kill(t, info, sig, 0);
+	return security_task_kill(t, info, sig, NULL);
 }
 
 /**
@@ -1388,7 +1388,7 @@ static int kill_as_cred_perm(const struct cred *cred,
 
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
 int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
-			 const struct cred *cred, u32 secid)
+			 const struct cred *cred)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
@@ -1407,7 +1407,7 @@ int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
 		ret = -EPERM;
 		goto out_unlock;
 	}
-	ret = security_task_kill(p, info, sig, secid);
+	ret = security_task_kill(p, info, sig, cred);
 	if (ret)
 		goto out_unlock;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ddaec58..9ff6d6d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3476,7 +3476,7 @@ static int selinux_task_movememory(struct task_struct *p)
 }
 
 static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
+				int sig, const struct cred *crd)
 {
 	u32 perm;
 	int rc;
@@ -3486,9 +3486,8 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 	else
 		perm = signal_to_av(sig);
 
-	if (secid)
-		rc = avc_has_perm(secid, task_sid(p),
-				  SECCLASS_PROCESS, perm, NULL);
+	if (crd)
+		rc = cred_has_perm(crd, __task_cred(p), perm);
 	else
 		rc = current_has_perm(p, perm);
 	return rc;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 5fef975..223bbdf 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1664,7 +1664,7 @@ static int smack_task_movememory(struct task_struct *p)
  * @p: the task object
  * @info: unused
  * @sig: unused
- * @secid: identifies the smack to use in lieu of current's
+ * @subcred: identifies the smack to use in lieu of current's
  *
  * Return 0 if write access is permitted
  *
@@ -1672,7 +1672,7 @@ static int smack_task_movememory(struct task_struct *p)
  * in the USB code. Someday it may go away.
  */
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
-			   int sig, u32 secid)
+			   int sig, const struct cred *subcred)
 {
 	struct smk_audit_info ad;
 
@@ -1682,15 +1682,15 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * Sending a signal requires that the sender
 	 * can write the receiver.
 	 */
-	if (secid == 0)
+	if (subcred == NULL)
 		return smk_curacc(smk_of_task(task_security(p)), MAY_WRITE,
 				  &ad);
 	/*
-	 * If the secid isn't 0 we're dealing with some USB IO
+	 * If the subcred isn't NULL we're dealing with some USB IO
 	 * specific behavior. This is not clean. For one thing
 	 * we can't take privilege into account.
 	 */
-	return smk_access(smack_from_secid(secid),
+	return smk_access(smk_of_task(lsm_get_cred(subcred, &smack_ops)),
 			  smk_of_task(task_security(p)), MAY_WRITE, &ad);
 }
 

