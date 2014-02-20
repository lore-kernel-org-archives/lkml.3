Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaBTXvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:51:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaBTXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [PATCH 3.10 65/66] EDAC: Poll timeout cannot be zero, p2
Date: Thu, 20 Feb 2014 15:52:04 -0800
Message-Id: <20140220234911.349579388@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 9da21b1509d8aa7ab4846722817d16c72d656c91 upstream.

Sanitize code even more to accept unsigned longs only and to not allow
polling intervals below 1 second as this is unnecessary and doesn't make
much sense anyway for polling errors.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1391457913-881-1-git-send-email-prarit@redhat.com
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc.c       |    4 ++--
 drivers/edac/edac_mc_sysfs.c |   10 ++++++----
 drivers/edac/edac_module.h   |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -601,7 +601,7 @@ static void edac_mc_workq_teardown(struc
  *	user space has updated our poll period value, need to
  *	reset our workq delays
  */
-void edac_mc_reset_delay_period(int value)
+void edac_mc_reset_delay_period(unsigned long value)
 {
 	struct mem_ctl_info *mci;
 	struct list_head *item;
@@ -611,7 +611,7 @@ void edac_mc_reset_delay_period(int valu
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, value);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
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
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -52,7 +52,7 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
-extern void edac_mc_reset_delay_period(int value);
+extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
 


