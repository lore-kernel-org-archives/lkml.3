Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaCCS5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:57:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaCCS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Borislav Petkov <bp@suse.de>, Doug Thompson <dougthompson@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 65/67] EDAC: Poll timeout cannot be zero, p2
Date: Mon,  3 Mar 2014 10:55:53 -0800
Message-Id: <1393872955-28810-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 9da21b1509d8aa7ab4846722817d16c72d656c91 upstream.

Sanitize code even more to accept unsigned longs only and to not allow
polling intervals below 1 second as this is unnecessary and doesn't make
much sense anyway for polling errors.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1391457913-881-1-git-send-email-prarit@redhat.com
Cc: Doug Thompson <dougthompson@xmission.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/edac/edac_mc.c       |  4 ++--
 drivers/edac/edac_mc_sysfs.c | 12 ++++++++----
 drivers/edac/edac_module.h   |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d1e9eb1..ab5341c 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -600,7 +600,7 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
  *	user space has updated our poll period value, need to
  *	reset our workq delays
  */
-void edac_mc_reset_delay_period(int value)
+void edac_mc_reset_delay_period(unsigned long value)
 {
 	struct mem_ctl_info *mci;
 	struct list_head *item;
@@ -610,7 +610,7 @@ void edac_mc_reset_delay_period(int value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, value);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index c9303ed..c2b9b7f 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -52,16 +52,20 @@ int edac_mc_get_poll_msec(void)
 
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	long l;
+	unsigned long l;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
+	ret = kstrtoul(val, 0, &l);
+	if (ret)
+		return ret;
+
+	if (l < 1000)
 		return -EINVAL;
-	*((int *)kp->arg) = l;
+
+	*((unsigned long *)kp->arg) = l;
 
 	/* notify edac_mc engine to reset the poll period */
 	edac_mc_reset_delay_period(l);
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 3d139c6..f2118bf 100644
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
1.8.3.2

