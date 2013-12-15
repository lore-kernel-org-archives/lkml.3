Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3LOMLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:11:13 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41756 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3LOMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:11:09 -0500
Date: Sun, 15 Dec 2013 04:11:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] PNPBIOS: check return value of pnp_add_device()
Message-ID: <20131215121102.GA509@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_device() may fail so we need to handle errors and avoid leaking
memory.

Also, when pnp_alloc_dev fails, return -ENOMEM rather than -1.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/pnp/pnpbios/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 9b86a01..074569e 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -312,18 +312,19 @@ static int __init insert_device(struct pnp_bios_node *node)
 	struct list_head *pos;
 	struct pnp_dev *dev;
 	char id[8];
+	int error;
 
 	/* check if the device is already added */
 	list_for_each(pos, &pnpbios_protocol.devices) {
 		dev = list_entry(pos, struct pnp_dev, protocol_list);
 		if (dev->number == node->handle)
-			return -1;
+			return -EEXIST;
 	}
 
 	pnp_eisa_id_to_string(node->eisa_id & PNP_EISA_ID_MASK, id);
 	dev = pnp_alloc_dev(&pnpbios_protocol, node->handle, id);
 	if (!dev)
-		return -1;
+		return -ENOMEM;
 
 	pnpbios_parse_data_stream(dev, node);
 	dev->active = pnp_is_active(dev);
@@ -342,7 +343,12 @@ static int __init insert_device(struct pnp_bios_node *node)
 	if (!dev->active)
 		pnp_init_resources(dev);
 
-	pnp_add_device(dev);
+	error = pnp_add_device(dev);
+	if (error) {
+		put_device(&dev->dev);
+		return error;
+	}
+
 	pnpbios_interface_attach_device(node);
 
 	return 0;
-- 
1.8.3.1


-- 
Dmitry
