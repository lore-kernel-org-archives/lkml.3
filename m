Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986Ab3DKOYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964878Ab3DKOYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:24:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 19/26] sh: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, viro@ZenIV.linux.org.uk,
        linux-sh@vger.kernel.org
Date: Thu, 11 Apr 2013 14:30:09 +0100
Message-ID: <20130411133009.32763.71122.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paul Mundt <lethal@linux-sh.org>
cc: linux-sh@vger.kernel.org
---

 arch/sh/drivers/dma/dma-api.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index f46848f..851e510 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/mm.h>
@@ -308,11 +309,9 @@ int dma_extend(unsigned int chan, unsigned long op, void *param)
 }
 EXPORT_SYMBOL(dma_extend);
 
-static int dma_read_proc(char *buf, char **start, off_t off,
-			 int len, int *eof, void *data)
+static int dma_proc_show(struct seq_file *m, void *v)
 {
-	struct dma_info *info;
-	char *p = buf;
+	struct dma_info *info = v;
 
 	if (list_empty(&registered_dmac_list))
 		return 0;
@@ -332,14 +331,26 @@ static int dma_read_proc(char *buf, char **start, off_t off,
 			if (!(channel->flags & DMA_CONFIGURED))
 				continue;
 
-			p += sprintf(p, "%2d: %14s    %s\n", i,
-				     info->name, channel->dev_id);
+			seq_printf(m, "%2d: %14s    %s\n", i,
+				   info->name, channel->dev_id);
 		}
 	}
 
-	return p - buf;
+	return 0;
+}
+
+static int dma_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dma_proc_show, NULL);
 }
 
+static const struct file_operations dma_proc_fops = {
+	.open		= dma_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 int register_dmac(struct dma_info *info)
 {
 	unsigned int total_channels, i;
@@ -412,8 +423,7 @@ EXPORT_SYMBOL(unregister_dmac);
 static int __init dma_api_init(void)
 {
 	printk(KERN_NOTICE "DMA: Registering DMA API.\n");
-	return create_proc_read_entry("dma", 0, 0, dma_read_proc, 0)
-		    ? 0 : -ENOMEM;
+	return proc_create("dma", 0, NULL, &dma_proc_fops) ? 0 : -ENOMEM;
 }
 subsys_initcall(dma_api_init);
 

