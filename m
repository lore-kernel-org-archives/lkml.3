Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaFYBtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:49:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45583 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbaFYBtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:49:19 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6/6] mailbox/omap: add a custom of_xlate function
Date: Tue, 24 Jun 2014 20:47:58 -0500
Message-ID: <1403660878-56350-7-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403660878-56350-1-git-send-email-s-anna@ti.com>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox framework currently does not support using the
channel phandles directly in the mbox property of client nodes,
and also expects a minimum value of 1 for the #mbox-cells in the
mailbox controller device node. Implement a custom of_xlate function
for the OMAP mailbox driver that allows phandles for the pargs
specifier instead of indexing to avoid any channel registration
order dependencies.

Cc: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/omap-mailbox.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index d71e84f..4847466 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -676,6 +676,28 @@ static const struct of_device_id omap_mailbox_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_mailbox_of_match);
 
+static struct mbox_chan *omap_mbox_of_xlate(struct mbox_controller *controller,
+					    const struct of_phandle_args *sp)
+{
+	phandle phandle = sp->args[0];
+	struct device_node *node;
+	struct omap_mbox_device *mdev;
+	struct omap_mbox *mbox;
+
+	node = of_find_node_by_phandle(phandle);
+	if (!node) {
+		pr_err("could not find node phandle 0x%x\n", phandle);
+		return NULL;
+	}
+
+	mdev = container_of(controller, struct omap_mbox_device, controller);
+	if (WARN_ON(!mdev))
+		return NULL;
+
+	mbox = omap_mbox_device_find(mdev, node->name);
+	return mbox ? mbox->chan : NULL;
+}
+
 static int omap_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
@@ -835,6 +857,7 @@ static int omap_mbox_probe(struct platform_device *pdev)
 	mdev->controller.ops = &omap_mbox_chan_ops;
 	mdev->controller.chans = chnls;
 	mdev->controller.num_chans = info_count;
+	mdev->controller.of_xlate = omap_mbox_of_xlate;
 	ret = omap_mbox_register(mdev);
 	if (ret)
 		return ret;
-- 
2.0.0

