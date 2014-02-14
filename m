Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBNK1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:27:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaBNK1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:27:19 -0500
Date: Fri, 14 Feb 2014 11:27:08 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.14
Message-ID: <20140214102708.GA26356@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the below tag to receive fixes for setting the EDAC core
polling timeout through sysfs.

You're surely wondering why the patches are not based on an rc. Well,
Andrew sent you 79040cad3f82 ("drivers/edac/edac_mc_sysfs.c: poll
timeout cannot be zero sent you") already (it got in in -rc2) but it is
not enough as a fix because for one, setting too low polling intervals
(< 1sec) don't make any sense and cause unnecessary polling load on the
system.

Then, even if we set some interval, we explode with

[ 4143.094342] WARNING: CPU: 1 PID: 0 at kernel/workqueue.c:1393 __queue_work+0x1d7/0x340()

because the workqueue setup path is used also for the timeout period
resetting and we're doing INIT_DELAYED_WORK() on an already active
workqueue. Which is total bollocks. So this is taken care of by the
second patch, whole diff below.

I've CCed stable for those two.

@Greg: Greg, can you please take 79040cad3f82 before you apply those two
below?

Thanks!


The following changes since commit 4675348e78fab420e70f9144b320d9c063c7cee8:

  Merge tag 'stable/for-linus-3.14-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip (2014-02-12 12:28:05 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.14

for you to fetch changes up to cb6ef42e516cb8948f15e4b70dc03af8020050a2:

  EDAC: Correct workqueue setup path (2014-02-14 10:40:47 +0100)

----------------------------------------------------------------
Fix polling timeout setting through sysfs.

----------------------------------------------------------------
Borislav Petkov (2):
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

 drivers/edac/edac_mc.c       | 13 ++++++++-----
 drivers/edac/edac_mc_sysfs.c | 10 ++++++----
 drivers/edac/edac_module.h   |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e8c9ef03495b..33edd6766344 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -559,7 +559,8 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  *
  *		called with the mem_ctls_mutex held
  */
-static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec,
+				bool init)
 {
 	edac_dbg(0, "\n");
 
@@ -567,7 +568,9 @@ static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 	if (mci->op_state != OP_RUNNING_POLL)
 		return;
 
-	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+	if (init)
+		INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+
 	mod_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
 
@@ -601,7 +604,7 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
  *	user space has updated our poll period value, need to
  *	reset our workq delays
  */
-void edac_mc_reset_delay_period(int value)
+void edac_mc_reset_delay_period(unsigned long value)
 {
 	struct mem_ctl_info *mci;
 	struct list_head *item;
@@ -611,7 +614,7 @@ void edac_mc_reset_delay_period(int value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, value, false);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
@@ -782,7 +785,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		/* This instance is NOW RUNNING */
 		mci->op_state = OP_RUNNING_POLL;
 
-		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
+		edac_mc_workq_setup(mci, edac_mc_get_poll_msec(), true);
 	} else {
 		mci->op_state = OP_RUNNING_INTERRUPT;
 	}
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 8ec1747b1c39..b335c6ab5efe 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -52,18 +52,20 @@ int edac_mc_get_poll_msec(void)
 
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	long l;
+	unsigned long l;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = kstrtol(val, 0, &l);
+	ret = kstrtoul(val, 0, &l);
 	if (ret)
 		return ret;
-	if (!l || ((int)l != l))
+
+	if (l < 1000)
 		return -EINVAL;
-	*((int *)kp->arg) = l;
+
+	*((unsigned long *)kp->arg) = l;
 
 	/* notify edac_mc engine to reset the poll period */
 	edac_mc_reset_delay_period(l);
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 3d139c6e7fe3..f2118bfcf8df 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -52,7 +52,7 @@ extern void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
-extern void edac_mc_reset_delay_period(int value);
+extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
