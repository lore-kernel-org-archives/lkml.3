Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3GSOK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:10:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59508 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3GSOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:10:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] mfd: ab8500-debugfs: Apply a check for -ENOMEM after allocating memory for sysfs
Date: Fri, 19 Jul 2013 15:10:15 +0100
Message-Id: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 debugfs driver allocates memory for a new sysfs entry, but
fails to apply the proper post-allocation checks. If the device were to
run out of memory, the allocation would return NULL. Without the correct
checks the driver will continue to populate NULL->[show|store|...],
which would obviously cause a pointer dereference Oops.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 7d1f1b0..c8298b2 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2800,6 +2800,9 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	 */
 	dev_attr[irq_index] = kmalloc(sizeof(struct device_attribute),
 		GFP_KERNEL);
+	if (!dev_attr[irq_index])
+		return -ENOMEM;
+
 	event_name[irq_index] = kmalloc(count, GFP_KERNEL);
 	sprintf(event_name[irq_index], "%lu", user_val);
 	dev_attr[irq_index]->show = show_irq;
-- 
1.8.1.2

