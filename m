Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaEUDVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:21:54 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38317 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaEUDVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:21:52 -0400
Date: Wed, 21 May 2014 11:21:43 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: grant.likely@linaro.org, gregkh@linuxfoundation.org,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivercore: refine commit 58b116b "drivercore: deferral
 race condition fix"
Message-ID: <20140521032143.GA8157@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1399612799-12251-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399612799-12251-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052103-4790-0000-0000-0000018871F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi~

Is this fix reasonable?

On Fri, May 09, 2014 at 01:19:59PM +0800, Wei Yang wrote:
>The commit 58b116b fixs a race condition in which some driver will stuck in the
>deferred list, while introduces another case "probe flood". The root cause is
>in commit 58b116b, deferred_trigger_count will be increased even a probe
>failure happens.
>
>The driver_deferred_probe_trigger() is invoked when a driver is successfully
>bound to a device.(As the comment shows). The commit 58b116b introduce another
>chance to trigger it: when EPROBE_DEFER retun and deferred_trigger_count is
>changed. And unfortunately, deferred_trigger_count is increased in
>driver_deferred_probe_trigger() again.
>
>Suppose there are 10 devices sits in the deferred list and one irrelevant
>driver probe succeeds. In this case, those devices will be triggered to do the
>deferred probe. Since this driver is not the one they want, they will be put
>into the deferred list again. Imagin 5 of them do it first and rest of them do
>it later. Current implementation will increase the deferred_trigger_count when
>the first 5 trigger deferred probe, which lead the rest 5 feel they need to
>trigger the deferred probe again. But the reality is no other driver is probed
>successfully.
>
>This patch fix this problem by making sure the driver_deferred_probe_trigger()
>is only called when a driver is successfully probed. Move the comparison in
>the loop of deferred probe.
>
>Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
>---
> drivers/base/base.h |    2 +-
> drivers/base/bus.c  |    3 ++-
> drivers/base/dd.c   |   44 +++++++++++++++++++++++++++-----------------
> 3 files changed, 30 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/base/base.h b/drivers/base/base.h
>index 24f4242..6315207 100644
>--- a/drivers/base/base.h
>+++ b/drivers/base/base.h
>@@ -105,7 +105,7 @@ extern void container_dev_init(void);
> struct kobject *virtual_device_parent(struct device *dev);
>
> extern int bus_add_device(struct device *dev);
>-extern void bus_probe_device(struct device *dev);
>+extern int bus_probe_device(struct device *dev);
> extern void bus_remove_device(struct device *dev);
>
> extern int bus_add_driver(struct device_driver *drv);
>diff --git a/drivers/base/bus.c b/drivers/base/bus.c
>index 83e910a..9e605b0 100644
>--- a/drivers/base/bus.c
>+++ b/drivers/base/bus.c
>@@ -543,7 +543,7 @@ out_put:
>  *
>  * - Automatically probe for a driver if the bus allows it.
>  */
>-void bus_probe_device(struct device *dev)
>+int bus_probe_device(struct device *dev)
> {
> 	struct bus_type *bus = dev->bus;
> 	struct subsys_interface *sif;
>@@ -562,6 +562,7 @@ void bus_probe_device(struct device *dev)
> 		if (sif->add_dev)
> 			sif->add_dev(dev, sif);
> 	mutex_unlock(&bus->p->mutex);
>+	return ret;
> }
>
> /**
>diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>index 62ec61e..eab7d02 100644
>--- a/drivers/base/dd.c
>+++ b/drivers/base/dd.c
>@@ -52,7 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
> static LIST_HEAD(deferred_probe_pending_list);
> static LIST_HEAD(deferred_probe_active_list);
> static struct workqueue_struct *deferred_wq;
>-static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
>+static u32 success_probe;
>
> /**
>  * deferred_probe_work_func() - Retry probing devices in the active list.
>@@ -61,6 +61,8 @@ static void deferred_probe_work_func(struct work_struct *work)
> {
> 	struct device *dev;
> 	struct device_private *private;
>+	u32 old_success;
>+	int ret = 0;
> 	/*
> 	 * This block processes every device in the deferred 'active' list.
> 	 * Each device is removed from the active list and passed to
>@@ -81,6 +83,7 @@ static void deferred_probe_work_func(struct work_struct *work)
> 		list_del_init(&private->deferred_probe);
>
> 		get_device(dev);
>+		old_success = ACCESS_ONCE(success_probe);
>
> 		/*
> 		 * Drop the mutex while probing each device; the probe path may
>@@ -99,7 +102,28 @@ static void deferred_probe_work_func(struct work_struct *work)
> 		device_pm_unlock();
>
> 		dev_dbg(dev, "Retrying from deferred list\n");
>-		bus_probe_device(dev);
>+		ret = bus_probe_device(dev);
>+		if (ret == -EPROBE_DEFER) {
>+			/*
>+			 * Note, there is a race condition in multi-threaded
>+			 * probe. In the case where more than one device is
>+			 * probing at the same time, it is possible for one
>+			 * probe to complete successfully while another is about
>+			 * to defer. If the second depends on the first, then
>+			 * it will get put on the pending list after the trigger
>+			 * event has already occured and will be stuck there.
>+			 *
>+			 * The 'success_probe' is used to be a counter for a
>+			 * successful probe. When other drivers succeed to
>+			 * probe during our probe, let's move ourself to the
>+			 * active list and do it again.
>+			 */
>+			mutex_lock(&deferred_probe_mutex);
>+			if (old_success != success_probe)
>+				list_move(&private->deferred_probe,
>+					  &deferred_probe_active_list);
>+			mutex_unlock(&deferred_probe_mutex);
>+		}
>
> 		mutex_lock(&deferred_probe_mutex);
>
>@@ -137,16 +161,6 @@ static bool driver_deferred_probe_enable = false;
>  * list and schedules the deferred probe workqueue to process them.  It
>  * should be called anytime a driver is successfully bound to a device.
>  *
>- * Note, there is a race condition in multi-threaded probe. In the case where
>- * more than one device is probing at the same time, it is possible for one
>- * probe to complete successfully while another is about to defer. If the second
>- * depends on the first, then it will get put on the pending list after the
>- * trigger event has already occured and will be stuck there.
>- *
>- * The atomic 'deferred_trigger_count' is used to determine if a successful
>- * trigger has occurred in the midst of probing a driver. If the trigger count
>- * changes in the midst of a probe, then deferred processing should be triggered
>- * again.
>  */
> static void driver_deferred_probe_trigger(void)
> {
>@@ -159,7 +173,7 @@ static void driver_deferred_probe_trigger(void)
> 	 * into the active list so they can be retried by the workqueue
> 	 */
> 	mutex_lock(&deferred_probe_mutex);
>-	atomic_inc(&deferred_trigger_count);
>+	success_probe++;
> 	list_splice_tail_init(&deferred_probe_pending_list,
> 			      &deferred_probe_active_list);
> 	mutex_unlock(&deferred_probe_mutex);
>@@ -278,7 +292,6 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
> static int really_probe(struct device *dev, struct device_driver *drv)
> {
> 	int ret = 0;
>-	int local_trigger_count = atomic_read(&deferred_trigger_count);
>
> 	atomic_inc(&probe_count);
> 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
>@@ -324,9 +337,6 @@ probe_failed:
> 		/* Driver requested deferred probing */
> 		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
> 		driver_deferred_probe_add(dev);
>-		/* Did a trigger occur while probing? Need to re-trigger if yes */
>-		if (local_trigger_count != atomic_read(&deferred_trigger_count))
>-			driver_deferred_probe_trigger();
> 	} else if (ret != -ENODEV && ret != -ENXIO) {
> 		/* driver matched but the probe failed */
> 		printk(KERN_WARNING
>-- 
>1.7.9.5

-- 
Richard Yang
Help you, Help me

