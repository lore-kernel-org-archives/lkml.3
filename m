Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaEEC2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 22:28:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54910 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaEEC2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 22:28:11 -0400
Date: Mon, 5 May 2014 10:28:05 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] drivercore: fix a corner case for deferred probe
Message-ID: <20140505022805.GA15162@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1398045202-5714-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398045202-5714-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050502-7014-0000-0000-000004D52827
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Anyone has some comment on this?

On Mon, Apr 21, 2014 at 09:53:22AM +0800, Wei Yang wrote:
>There is one corner case in deferred probe which will lead a device in
>"dream" in the deferred_probe_pending_list.
>
>Suppose we have three devices, Tom, Jerry and Spike. Tom and Jerry have a
>close relationship, Tom could be up until Jerry is up. Spike is an
>independent device.
>
>Device probe sequence: Tom -> Spike -> Jerry
>
>1. Tom probes, fails for deferred probe
>   adds itself to pending list
>2. Spike probes, succeed
>   move devices in pending list to active list
>   trigger deferred probe
>3. Tom is taken off from active list
>   probes and still fails, scheduled out
>   not added to pending list this time
>   (Tom is not in pending list neither in active list)
>4. Jerry probes, succeed
>   move devices in pending list to active list(but Tom is not there)
>   trigger deferred probe
>   go through the active list
>5. Tom add itself to pending list
>   and wait
>
>Tom will be trapped in the pending list until someone else help it out.
>
>This patch adds a counter of success probe. Every time a driver probe succeeds,
>this is increased by 1. In the deferred_probe_work_func, when probe fails and
>returns EPROBE_DEFER, it checks this counter. If some driver succeed to probe
>during this period, it adds itself to active list again.
>
>Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
>---
> drivers/base/base.h |    2 +-
> drivers/base/bus.c  |    3 ++-
> drivers/base/dd.c   |   14 +++++++++++++-
> 3 files changed, 16 insertions(+), 3 deletions(-)
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
>index 59dc808..a050946 100644
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
>index 0605176..a10526d 100644
>--- a/drivers/base/dd.c
>+++ b/drivers/base/dd.c
>@@ -52,6 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
> static LIST_HEAD(deferred_probe_pending_list);
> static LIST_HEAD(deferred_probe_active_list);
> static struct workqueue_struct *deferred_wq;
>+static u32 success_probe;
>
> /**
>  * deferred_probe_work_func() - Retry probing devices in the active list.
>@@ -60,6 +61,8 @@ static void deferred_probe_work_func(struct work_struct *work)
> {
> 	struct device *dev;
> 	struct device_private *private;
>+	u32 old_success;
>+	int ret = 0;
> 	/*
> 	 * This block processes every device in the deferred 'active' list.
> 	 * Each device is removed from the active list and passed to
>@@ -80,6 +83,7 @@ static void deferred_probe_work_func(struct work_struct *work)
> 		list_del_init(&private->deferred_probe);
>
> 		get_device(dev);
>+		old_success = ACCESS_ONCE(success_probe);
>
> 		/*
> 		 * Drop the mutex while probing each device; the probe path may
>@@ -98,7 +102,14 @@ static void deferred_probe_work_func(struct work_struct *work)
> 		device_pm_unlock();
>
> 		dev_dbg(dev, "Retrying from deferred list\n");
>-		bus_probe_device(dev);
>+		ret = bus_probe_device(dev);
>+		if (ret == -EPROBE_DEFER) {
>+			mutex_lock(&deferred_probe_mutex);
>+			if (old_success != success_probe)
>+				list_move(&private->deferred_probe,
>+					  &deferred_probe_active_list);
>+			mutex_unlock(&deferred_probe_mutex);
>+		}
>
> 		mutex_lock(&deferred_probe_mutex);
>
>@@ -147,6 +158,7 @@ static void driver_deferred_probe_trigger(void)
> 	 * into the active list so they can be retried by the workqueue
> 	 */
> 	mutex_lock(&deferred_probe_mutex);
>+	success_probe++;
> 	list_splice_tail_init(&deferred_probe_pending_list,
> 			      &deferred_probe_active_list);
> 	mutex_unlock(&deferred_probe_mutex);
>-- 
>1.7.9.5

-- 
Richard Yang
Help you, Help me

