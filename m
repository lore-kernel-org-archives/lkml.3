Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaBHLET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 06:04:19 -0500
Received: from [125.89.61.122] ([125.89.61.122]:11988 "EHLO
	mz-mail03.meizu.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbaBHLEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 06:04:12 -0500
From: <falcon@meizu.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] async: Allow to group the asynced device probings
Date: Sat, 8 Feb 2014 19:05:39 +0800
Message-ID: <1391857539-27782-2-git-send-email-falcon@meizu.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391857539-27782-1-git-send-email-falcon@meizu.com>
References: <1391857539-27782-1-git-send-email-falcon@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.179]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <falcon@meizu.com>

[*Note*: NOT applicable, only for comments.]

This allows to schedule a group of probings in order.

Usage:

If the probing of driver2 depends on the probing of driver1, we can put them
into a group, here put them into a group named domain 1, they will be probed in
the linking order.

...

static struct platform_driver first_driver = {
 	.probe = first_driver_probe,
 	.driver		= {
 		.name	= "first driver",
+		.async_probe = 1,
+		.async_domain = 1,
 	},
 };

...

static struct platform_driver second_driver = {
 	.probe = second_driver_probe,
 	.driver		= {
 		.name	= "second_driver",
+		.async_probe = 1,
+		.async_domain = 1,
 	},
 };

...

With this feature, it is possible to async different class of drivers, for
example, put all sound drivers into domain 2, put all display/video drivers
into domain 3, and sensors domain 4, network drivers domain 5 and so forth.

*TODO*:

 o To share the existing wait_for_device_probe(), register all async domains
 with registered=1. But it is too early than our wait_for_async_probe_domain().

 o It may be possible to async the whole kernel initcalls(except the one
 before scheduler available) with more complicated group features, currently,
 this implementation only allows to group the probings linearly, but the real
 dependencies of the probings are more complicated, to solve this issue, group
 the probings in a *tree* architecture may work.

Signed-off-by: Wu Zhangjin <falcon@meizu.com>
---
 drivers/base/dd.c      |  101 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/device.h |    1 +
 init/main.c            |    4 ++
 3 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 357f36e..025d8a9 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -358,11 +358,52 @@ void wait_for_device_probe(void)
 }
 EXPORT_SYMBOL_GPL(wait_for_device_probe);
 
+struct async_domain_structure {
+	/* Data Elements */
+	struct async_domain domain;
+	unsigned int domain_id;
+	unsigned int domain_members;
+	struct completion domain_order;
+	char *last_drv;
+	/* List Link */
+	struct list_head list;
+};
+
 struct stupid_thread_structure {
 	struct device_driver *drv;
 	struct device *dev;
+	struct async_domain_structure *domain;
+	unsigned int wait:1;
 };
 
+static LIST_HEAD(async_domain_list);
+
+/* Create the domain list based on the ids, the same ids share the same domain.  */
+struct async_domain_structure *get_async_domain(unsigned int domain_id)
+{
+	struct async_domain_structure *domain;
+
+	/* Check if our list exist, If exist, return it */
+	if (!list_empty(&async_domain_list)) {
+		list_for_each_entry(domain, &async_domain_list, list)
+			if (domain->domain_id == domain_id) {
+				domain->domain_members++;
+				return domain;
+			}
+	}
+
+	/* If not exist, add a new one  */
+	domain = kzalloc(sizeof(struct async_domain_structure), GFP_KERNEL);
+	domain->domain_id = domain_id;
+	domain->domain_members = 1;
+	init_completion(&domain->domain_order);
+	INIT_LIST_HEAD(&domain->domain.pending);
+	domain->domain.registered = 0;
+	list_add(&domain->list, &async_domain_list);
+
+	return domain;
+}
+
 /**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
@@ -379,12 +420,57 @@ static void __driver_probe_device(void *void_data, async_cookie_t cookie)
 	struct stupid_thread_structure *data = void_data;
 	struct device_driver *drv = data->drv;
 	struct device *dev = data->dev;
+	struct async_domain_structure *domain = data->domain;
+	unsigned int wait = data->wait;
+
+	/* Wait for the previous one */
+	if (wait) {
+		pr_info("%s: %s: wait for %s\n", __func__, drv->name, (char *)domain->last_drv);
+		wait_for_completion_interruptible(&domain->domain_order);
+	}
+
+	if (domain)
+		domain->last_drv = (char *)drv->name;
 
 	pm_runtime_barrier(dev);
 	really_probe(dev, drv);
 	pm_request_idle(dev);
 
 	kfree(data);
+
+	/* Finish */
+	if (domain) {
+		pr_info("%s: %s: complete device probing\n", __func__, drv->name);
+		complete(&domain->domain_order);
+	}
+}
+
+void wait_for_async_probe_in_domain(void)
+{
+	struct async_domain_structure *domain;
+
+	pr_info("%s: Wait for all asynced probe devices\n", __func__);
+	list_for_each_entry(domain, &async_domain_list, list) {
+		pr_debug("%s: Wait for domain %d\n", __func__, domain->domain_id);
+		async_synchronize_full_domain(&domain->domain);
+		pr_debug("%s: Release the data struct for domain %d\n", __func__, domain->domain_id);
+		kfree(domain);
+	}
+}
+
+static inline void async_probe_in_domain(void *void_data)
+{
+	struct stupid_thread_structure *data = void_data;
+	struct device_driver *drv = data->drv;
+	async_cookie_t cookie;
+	struct async_domain_structure *domain;
+
+	/* Schedule the device in the specified domain */
+	domain = data->domain;
+	data->wait = (domain->domain_members > 1) ? 1 : 0;
+	pr_debug("%s: %s: members = %d, wait = %d\n", __func__, drv->name, domain->domain_members, data->wait);
+	cookie = async_schedule_domain(__driver_probe_device, data, &domain->domain);
+	pr_info("%s: async call %s driver, cookie is %llu, domain is %d\n", __func__, drv->name, cookie, drv->async_domain);
 }
 
 int driver_probe_device(struct device_driver *drv, struct device *dev)
@@ -400,13 +486,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
 	if (drv->async_probe) {
-		data = kmalloc(sizeof(*data), GFP_KERNEL);
+		data = kzalloc(sizeof(struct stupid_thread_structure), GFP_KERNEL);
 		data->drv = drv;
 		data->dev = dev;
 
-		cookie = async_schedule(__driver_probe_device, data);
-		pr_info("%s: async call %s driver, cookie is %llu\n", __func__, drv->name, cookie);
+		if (!drv->async_domain) {
+			data->domain = NULL;
+			cookie = async_schedule(__driver_probe_device, data);
+			pr_info("%s: async call %s driver, cookie is %llu\n", __func__, drv->name, cookie);
+		} else {
+			/* Probe the device with domain specified */
+			pr_info("%s: async_probe_in_domain() %s\n", __func__, drv->name);
+			data->domain = get_async_domain(drv->async_domain);
+			async_probe_in_domain(data);
+		}
 	} else {
+		pr_debug("%s: Probe %s\n", __func__, drv->name);
 		pm_runtime_barrier(dev);
 		ret = really_probe(dev, drv);
 		pm_request_idle(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index f39ee48..3806947 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -248,6 +248,7 @@ struct device_driver {
 
 	struct driver_private *p;
 
+	unsigned int async_domain;
 	unsigned int async_probe:1;
 };
 
diff --git a/init/main.c b/init/main.c
index febc511..4271b7b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -836,6 +836,8 @@ static int try_to_run_init_process(const char *init_filename)
 
 static noinline void __init kernel_init_freeable(void);
 
+extern void wait_for_async_probe_in_domain(void);
+
 static int __ref kernel_init(void *unused)
 {
 	int ret;
@@ -843,6 +845,8 @@ static int __ref kernel_init(void *unused)
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+	wait_for_async_probe_in_domain();
+
 	free_initmem();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
-- 
1.7.10.4

