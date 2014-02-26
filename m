Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaBZTJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:09:20 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62964 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaBZTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:16 -0500
Subject: [PATCH 2/4] i2o: Fix I/O space alignment requirement
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:09:12 -0700
Message-ID: <20140226190912.9616.50210.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i2o_iop_systab_set() allocates I/O port space, it specifies 1Mb
alignment required.  This seems unlikely, since most platforms have only
64Kb of I/O space total.  I think 4Kb is a more reasonable choice, since
that's the minimum alignment of a PCI-PCI bridge I/O window.

My guess is that this is a copy/paste error from the memory allocation
code, which specifies 1Mb alignment (which is the minimum alignment of a
PCI-PCI bridge memory window).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/message/i2o/iop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index a8373d7aaef7..68aef58bf89c 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -700,7 +700,7 @@ static int i2o_iop_systab_set(struct i2o_controller *c)
 		root = pci_find_parent_resource(c->pdev, res);
 		if (root == NULL)
 			osm_warn("%s: Can't find parent resource!\n", c->name);
-		if (root && allocate_resource(root, res, sb->desired_io_size, sb->desired_io_size, sb->desired_io_size, 1 << 20,	/* Unspecified, so use 1Mb and play safe */
+		if (root && allocate_resource(root, res, sb->desired_io_size, sb->desired_io_size, sb->desired_io_size, 1 << 12,	/* Unspecified, so use 4Kb and play safe */
 					      NULL, NULL) >= 0) {
 			c->io_alloc = 1;
 			sb->current_io_size = resource_size(res);

