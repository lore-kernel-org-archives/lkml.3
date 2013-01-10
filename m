Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3AJXvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:51:48 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:16896 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3AJXvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:51:09 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, lenb@kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH v2 11/12] cpu: Update sysfs cpu/online for hotplug framework
Date: Thu, 10 Jan 2013 16:40:29 -0700
Message-Id: <1357861230-29549-12-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed store_online() to request a cpu online or offline
operation by calling shp_submit_req().  It sets a target cpu
device information with shp_add_dev_info() for the request.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/base/cpu.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 05534ad..cd1cbdc 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -41,27 +41,43 @@ static ssize_t __ref store_online(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
+	struct shp_request *shp_req;
+	struct shp_device *shp_dev;
+	enum shp_operation operation;
+	ssize_t ret = count;
 
-	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
-		ret = cpu_down(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+		operation = SHP_ONLINE_DEL;
 		break;
 	case '1':
-		ret = cpu_up(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+		operation = SHP_ONLINE_ADD;
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
+	}
+
+	shp_req = shp_alloc_request(operation);
+	if (!shp_req)
+		return -ENOMEM;
+
+	shp_dev = kzalloc(sizeof(*shp_dev), GFP_KERNEL);
+	if (!shp_dev) {
+		kfree(shp_req);
+		return -ENOMEM;
+	}
+
+	shp_dev->device = dev;
+	shp_dev->class = SHP_CLS_CPU;
+	shp_dev->info.cpu.cpu_id = cpu->dev.id;
+	shp_add_dev_info(shp_req, shp_dev);
+
+	if (shp_submit_req(shp_req)) {
+		kfree(shp_dev);
+		kfree(shp_req);
+		return -EINVAL;
 	}
-	cpu_hotplug_driver_unlock();
 
-	if (ret >= 0)
-		ret = count;
 	return ret;
 }
 static DEVICE_ATTR(online, 0644, show_online, store_online);
