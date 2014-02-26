Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaBZTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:09:27 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36348 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaBZTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:23 -0500
Subject: [PATCH 3/4] i2o: Refactor i2o_iop_systab_set() PCI space allocation
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:09:20 -0700
Message-ID: <20140226190920.9616.82654.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the PCI space allocation in i2o_iop_systab_set().  This might
improve readability slightly, but mainly it is to make the next patch
simpler.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/message/i2o/iop.c |   89 +++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 43 deletions(-)

diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 68aef58bf89c..c334ba7224a1 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -652,6 +652,48 @@ static int i2o_iop_activate(struct i2o_controller *c)
 	return i2o_hrt_get(c);
 };
 
+static void i2o_res_alloc(struct i2o_controller *c, unsigned long flags)
+{
+	i2o_status_block *sb = c->status_block.virt;
+	struct resource *root, *res = &c->mem_resource;
+	resource_size_t size, min, max, align;
+	int err;
+
+	res->name = c->pdev->bus->name;
+	res->flags = flags;
+	res->start = 0;
+	res->end = 0;
+	osm_info("%s: requires private memory resources.\n", c->name);
+	root = pci_find_parent_resource(c->pdev, res);
+	if (root == NULL) {
+		osm_warn("%s: Can't find parent resource!\n", c->name);
+		return;
+	}
+
+	if (flags & IORESOURCE_MEM) {
+		size = min = max = sb->desired_mem_size;
+		align = 1 << 20;	/* unspecified, use 1Mb and play safe */
+	} else if (flags & IORESOURCE_IO) {
+		size = min = max = sb->desired_io_size;
+		align = 1 << 12;	/* unspecified, use 4Kb and play safe */
+	}
+
+	err = allocate_resource(root, res, size, min, max, align, NULL, NULL);
+	if (err < 0)
+		return;
+
+	if (flags & IORESOURCE_MEM) {
+		c->mem_alloc = 1;
+		sb->current_mem_size = resource_size(res);
+		sb->current_mem_base = res->start;
+	} else if (flags & IORESOURCE_IO) {
+		c->io_alloc = 1;
+		sb->current_io_size = resource_size(res);
+		sb->current_io_base = res->start;
+	}
+	osm_info("%s: allocated PCI space %pR\n", c->name, res);
+}
+
 /**
  *	i2o_iop_systab_set - Set the I2O System Table of the specified IOP
  *	@c: I2O controller to which the system table should be send
@@ -665,52 +707,13 @@ static int i2o_iop_systab_set(struct i2o_controller *c)
 	struct i2o_message *msg;
 	i2o_status_block *sb = c->status_block.virt;
 	struct device *dev = &c->pdev->dev;
-	struct resource *root;
 	int rc;
 
-	if (sb->current_mem_size < sb->desired_mem_size) {
-		struct resource *res = &c->mem_resource;
-		res->name = c->pdev->bus->name;
-		res->flags = IORESOURCE_MEM;
-		res->start = 0;
-		res->end = 0;
-		osm_info("%s: requires private memory resources.\n", c->name);
-		root = pci_find_parent_resource(c->pdev, res);
-		if (root == NULL)
-			osm_warn("%s: Can't find parent resource!\n", c->name);
-		if (root && allocate_resource(root, res, sb->desired_mem_size, sb->desired_mem_size, sb->desired_mem_size, 1 << 20,	/* Unspecified, so use 1Mb and play safe */
-					      NULL, NULL) >= 0) {
-			c->mem_alloc = 1;
-			sb->current_mem_size = resource_size(res);
-			sb->current_mem_base = res->start;
-			osm_info("%s: allocated %llu bytes of PCI memory at "
-				"0x%016llX.\n", c->name,
-				(unsigned long long)resource_size(res),
-				(unsigned long long)res->start);
-		}
-	}
+	if (sb->current_mem_size < sb->desired_mem_size)
+		i2o_res_alloc(c, IORESOURCE_MEM);
 
-	if (sb->current_io_size < sb->desired_io_size) {
-		struct resource *res = &c->io_resource;
-		res->name = c->pdev->bus->name;
-		res->flags = IORESOURCE_IO;
-		res->start = 0;
-		res->end = 0;
-		osm_info("%s: requires private memory resources.\n", c->name);
-		root = pci_find_parent_resource(c->pdev, res);
-		if (root == NULL)
-			osm_warn("%s: Can't find parent resource!\n", c->name);
-		if (root && allocate_resource(root, res, sb->desired_io_size, sb->desired_io_size, sb->desired_io_size, 1 << 12,	/* Unspecified, so use 4Kb and play safe */
-					      NULL, NULL) >= 0) {
-			c->io_alloc = 1;
-			sb->current_io_size = resource_size(res);
-			sb->current_io_base = res->start;
-			osm_info("%s: allocated %llu bytes of PCI I/O at "
-				"0x%016llX.\n", c->name,
-				(unsigned long long)resource_size(res),
-				(unsigned long long)res->start);
-		}
-	}
+	if (sb->current_io_size < sb->desired_io_size)
+		i2o_res_alloc(c, IORESOURCE_IO);
 
 	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
 	if (IS_ERR(msg))

