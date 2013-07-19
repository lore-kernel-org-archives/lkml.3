Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3GSOKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:10:33 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44093 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3GSOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:10:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] mfd: ab8500-debugfs: Apply a check for -ENOMEM after allocating memory for event name
Date: Fri, 19 Jul 2013 15:10:16 +0100
Message-Id: <1374243017-8515-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
References: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 debugfs driver allocates memory to contain the name of a new sysfs
entry, but fails to apply the proper post-allocation checks. If the device
were to run out of memory, the allocation would return NULL. Without the
correct checks the driver will continue to populate address NULL with the
specified device name which would obviously cause a pointer dereference Oops.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index c8298b2..30fcb0c 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2804,6 +2804,9 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 		return -ENOMEM;
 
 	event_name[irq_index] = kmalloc(count, GFP_KERNEL);
+	if (!event_name[irq_index])
+		return -ENOMEM;
+
 	sprintf(event_name[irq_index], "%lu", user_val);
 	dev_attr[irq_index]->show = show_irq;
 	dev_attr[irq_index]->store = NULL;
-- 
1.8.1.2

