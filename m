Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3EIFTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:19:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47201 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3EIFSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:18:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="45617294"
From: Saravana Kannan <skannan@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 1/3] driver core: Add API to wait for deferred probe to complete during init
Date: Wed,  8 May 2013 22:18:44 -0700
Message-Id: <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel framework (Eg: regulator, clock, etc) might want to do some clean up
work (Eg: turn off unclaimed resources) after all devices are done probing
during kernel init. Before deferred probing was introduced, this was
typically done using a late_initcall(). That approach still makes the
assumption that all drivers that are compiled in, register in one of the
earlier initcall levels.

With the introduction of deferred probing, even if the
assumption that all compiled in drivers register in one of the earlier
initcalls is ture, there is no longer a guarantee that all their matching
devices would have completed probing by late_initcall(). This is because
deferred probing loginc starts attempting the deferred probes only in a
late_initcall() function.

The most obvious fallback of using late_initcall_sync() also doesn't work
since the deferred probing work initated during late_initcall() is done in
a workqueue. So, frameworks that want to wait for all devices to finish
probing during init will now have to wait for the deferred workqueue to
finish it's work. This patch adds a wait_for_init_deferred_probe_done() API
that can by called from late_initcall_sync() or a workqueue started from
late_initcall_sync()

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/base/dd.c      |    8 ++++++++
 include/linux/device.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index bb5645e..bb2b9c6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -52,6 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
 static LIST_HEAD(deferred_probe_pending_list);
 static LIST_HEAD(deferred_probe_active_list);
 static struct workqueue_struct *deferred_wq;
+DECLARE_COMPLETION(init_def_probe_done);
 
 /**
  * deferred_probe_work_func() - Retry probing devices in the active list.
@@ -105,6 +106,7 @@ static void deferred_probe_work_func(struct work_struct *work)
 		put_device(dev);
 	}
 	mutex_unlock(&deferred_probe_mutex);
+	complete_all(&init_def_probe_done);
 }
 static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
@@ -179,6 +181,12 @@ static int deferred_probe_initcall(void)
 }
 late_initcall(deferred_probe_initcall);
 
+void wait_for_init_deferred_probe_done(void)
+{
+	wait_for_completion(&init_def_probe_done);
+}
+EXPORT_SYMBOL_GPL(wait_for_init_deferred_probe_done);
+
 static void driver_bound(struct device *dev)
 {
 	if (klist_node_attached(&dev->p->knode_driver)) {
diff --git a/include/linux/device.h b/include/linux/device.h
index 9d6464e..5c557f7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -247,6 +247,7 @@ extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
 extern void wait_for_device_probe(void);
+extern void wait_for_init_deferred_probe_done(void);
 
 
 /* sysfs interface for exporting driver attributes */
-- 
1.7.8.3

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
