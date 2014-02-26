Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaBZTJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:09:32 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38643 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaBZTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:29 -0500
Subject: [PATCH 4/4] i2o: Use pci_bus_alloc_resource(),
 not allocate_resource() directly
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:09:27 -0700
Message-ID: <20140226190927.9616.43043.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert i2o_res_alloc() to use pci_bus_alloc_resource() rather than
pci_find_parent_resource() and allocate_resource().  We don't have a
resource to start with, so pci_find_parent_resource() can't do anything
useful: a bus may have several memory resources available, so there might
be several possible parents.  This is more likely on root buses because
host bridges may have any number of apertures.

I'm pretty sure this didn't work in the first place because it passed
size == min == max to allocate_resource().  The min and max parameters are
constraints on the *addresses* of the resource, not on its size, so I think
it was impossible for allocate_resource() to succeed.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/message/i2o/iop.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index c334ba7224a1..5e7b1b75f999 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -655,8 +655,8 @@ static int i2o_iop_activate(struct i2o_controller *c)
 static void i2o_res_alloc(struct i2o_controller *c, unsigned long flags)
 {
 	i2o_status_block *sb = c->status_block.virt;
-	struct resource *root, *res = &c->mem_resource;
-	resource_size_t size, min, max, align;
+	struct resource *res = &c->mem_resource;
+	resource_size_t size, align;
 	int err;
 
 	res->name = c->pdev->bus->name;
@@ -664,21 +664,17 @@ static void i2o_res_alloc(struct i2o_controller *c, unsigned long flags)
 	res->start = 0;
 	res->end = 0;
 	osm_info("%s: requires private memory resources.\n", c->name);
-	root = pci_find_parent_resource(c->pdev, res);
-	if (root == NULL) {
-		osm_warn("%s: Can't find parent resource!\n", c->name);
-		return;
-	}
 
 	if (flags & IORESOURCE_MEM) {
-		size = min = max = sb->desired_mem_size;
+		size = sb->desired_mem_size;
 		align = 1 << 20;	/* unspecified, use 1Mb and play safe */
 	} else if (flags & IORESOURCE_IO) {
-		size = min = max = sb->desired_io_size;
+		size = sb->desired_io_size;
 		align = 1 << 12;	/* unspecified, use 4Kb and play safe */
 	}
 
-	err = allocate_resource(root, res, size, min, max, align, NULL, NULL);
+	err = pci_bus_alloc_resource(c->pdev->bus, res, size, align, 0, 0,
+				     NULL, NULL);
 	if (err < 0)
 		return;
 

