Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3CKQj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:39:29 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44999 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CKQj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:39:27 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn, mporter@ti.com,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] parport: use kmemdup instead of kmalloc + memcpy
Date: Mon, 11 Mar 2013 18:39:22 +0200
Message-Id: <1363019962-3519-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces calls to kmalloc followed by memcpy with a single call to
kmemdup. This was found via make coccicheck.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/parport/parport_gsc.c    |    4 ++--
 drivers/parport/parport_sunbpp.c |    5 ++---
 drivers/parport/procfs.c         |    6 ++----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 050773c..6778676 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -246,14 +246,14 @@ struct parport *parport_gsc_probe_port(unsigned long base,
 		printk (KERN_DEBUG "parport (0x%lx): no memory!\n", base);
 		return NULL;
 	}
-	ops = kmalloc (sizeof (struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_gsc_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
 	if (!ops) {
 		printk (KERN_DEBUG "parport (0x%lx): no memory for ops!\n",
 			base);
 		kfree (priv);
 		return NULL;
 	}
-	memcpy (ops, &parport_gsc_ops, sizeof (struct parport_operations));
 	priv->ctr = 0xc;
 	priv->ctr_writable = 0xff;
 	priv->dma_buf = 0;
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 5c4b6a1..dffd6d0 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -284,12 +284,11 @@ static int bpp_probe(struct platform_device *op)
 	size = resource_size(&op->resource[0]);
 	dma = PARPORT_DMA_NONE;
 
-	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_sunbpp_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
         if (!ops)
 		goto out_unmap;
 
-        memcpy (ops, &parport_sunbpp_ops, sizeof(struct parport_operations));
-
 	dprintk(("register_port\n"));
 	if (!(p = parport_register_port((unsigned long)base, irq, dma, ops)))
 		goto out_free_ops;
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 3f56bc0..92ed045 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -476,10 +476,9 @@ int parport_proc_register(struct parport *port)
 	struct parport_sysctl_table *t;
 	int i;
 
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_sysctl_template, sizeof(*t));
 
 	t->device_dir[0].extra1 = port;
 
@@ -523,10 +522,9 @@ int parport_device_proc_register(struct pardevice *device)
 	struct parport_device_sysctl_table *t;
 	struct parport * port = device->port;
 	
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_device_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_device_sysctl_template, sizeof(*t));
 
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
-- 
1.7.9.5

