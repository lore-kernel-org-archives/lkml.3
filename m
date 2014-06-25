Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaFYBtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:49:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36350 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbaFYBtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:49:06 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
Date: Tue, 24 Jun 2014 20:47:54 -0500
Message-ID: <1403660878-56350-3-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403660878-56350-1-git-send-email-s-anna@ti.com>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logic has been added to the OMAP2+ mailbox code to parse the
mailbox dt nodes and construct the different sub-mailboxes
associated with the instance. The DT representation of the
sub-mailbox devices is different from legacy platform data
representation to allow flexibility of interrupt configuration
between Tx and Rx fifos (to also possibly allow simplex devices
in the future). The DT representation gathers similar information
that was being passed previously through the platform data, except
for the number of fifos, interrupts and interrupt type information,
which are gathered through driver compatible match data.

The non-DT support has to be maintained for now to not break
OMAP3 legacy boot, and the legacy-style code will be cleaned
up once OMAP3 is also converted to DT-boot only.

Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/omap-mailbox.c | 201 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 177 insertions(+), 24 deletions(-)

diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index a27e00e..c61435b 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mailbox-omap.h>
@@ -94,6 +95,24 @@ struct omap_mbox_device {
 	struct list_head elem;
 };
 
+struct omap_mbox_fifo_info {
+	int tx_id;
+	int tx_usr;
+	int tx_irq;
+
+	int rx_id;
+	int rx_usr;
+	int rx_irq;
+
+	const char *name;
+};
+
+struct omap_mbox_device_data {
+	u32 num_users;
+	u32 num_fifos;
+	u32 intr_type;
+};
+
 struct omap_mbox {
 	const char		*name;
 	int			irq;
@@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
 	return 0;
 }
 
+static const struct omap_mbox_device_data omap2_data = {
+	.num_users	= 4,
+	.num_fifos	= 6,
+	.intr_type	= MBOX_INTR_CFG_TYPE1,
+};
+
+static const struct omap_mbox_device_data omap3_data = {
+	.num_users	= 2,
+	.num_fifos	= 2,
+	.intr_type	= MBOX_INTR_CFG_TYPE1,
+};
+
+static const struct omap_mbox_device_data am335x_data = {
+	.num_users	= 4,
+	.num_fifos	= 8,
+	.intr_type	= MBOX_INTR_CFG_TYPE2,
+};
+
+static const struct omap_mbox_device_data omap4_data = {
+	.num_users	= 3,
+	.num_fifos	= 8,
+	.intr_type	= MBOX_INTR_CFG_TYPE2,
+};
+
+static const struct omap_mbox_device_data dra7_data = {
+	.num_users	= 4,
+	.num_fifos	= 12,
+	.intr_type	= MBOX_INTR_CFG_TYPE2,
+};
+
+static const struct of_device_id omap_mailbox_of_match[] = {
+	{
+		.compatible	= "ti,omap2-mailbox",
+		.data		= &omap2_data,
+	},
+	{
+		.compatible     = "ti,omap3-mailbox",
+		.data           = &omap3_data,
+	},
+	{
+		.compatible     = "ti,am3352-mailbox",
+		.data           = &am335x_data,
+	},
+	{
+		.compatible     = "ti,omap4-mailbox",
+		.data           = &omap4_data,
+	},
+	{
+		.compatible     = "ti,am4372-mailbox",
+		.data           = &am335x_data,
+	},
+	{
+		.compatible     = "ti,dra7-mailbox",
+		.data           = &dra7_data,
+	},
+	{
+		/* end */
+	},
+};
+MODULE_DEVICE_TABLE(of, omap_mailbox_of_match);
+
 static int omap_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
 	struct omap_mbox **list, *mbox, *mboxblk;
 	struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
-	struct omap_mbox_dev_info *info;
+	struct omap_mbox_dev_info *info = NULL;
+	struct omap_mbox_device_data *data;
+	struct omap_mbox_fifo_info *finfo, *finfoblk;
 	struct omap_mbox_device *mdev;
 	struct omap_mbox_fifo *fifo;
-	u32 intr_type;
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *child;
+	const struct of_device_id *match;
+	u32 intr_type, info_count;
+	u32 num_users, num_fifos;
+	u32 tmp[3];
 	u32 l;
 	int i;
 
-	if (!pdata || !pdata->info_cnt || !pdata->info) {
+	if (!node && (!pdata || !pdata->info_cnt || !pdata->info)) {
 		pr_err("%s: platform not supported\n", __func__);
 		return -ENODEV;
 	}
 
+	if (node) {
+		match = of_match_device(omap_mailbox_of_match, &pdev->dev);
+		if (!match)
+			return -ENODEV;
+		data = (struct omap_mbox_device_data *)match->data;
+
+		info_count = of_get_available_child_count(node);
+		if (!info_count) {
+			dev_err(&pdev->dev, "no available mbox devices found\n");
+			return -ENODEV;
+		}
+
+		intr_type = data->intr_type;
+		num_users = data->num_users;
+		num_fifos = data->num_fifos;
+	} else { /* non-DT device creation */
+		info_count = pdata->info_cnt;
+		info = pdata->info;
+		intr_type = pdata->intr_type;
+		num_users = pdata->num_users;
+		num_fifos = pdata->num_fifos;
+	}
+
+	finfoblk = devm_kzalloc(&pdev->dev, info_count * sizeof(*finfoblk),
+				GFP_KERNEL);
+	if (!finfoblk)
+		return -ENOMEM;
+
+	finfo = finfoblk;
+	child = NULL;
+	for (i = 0; i < info_count; i++, finfo++) {
+		if (!node) {
+			finfo->tx_id = info->tx_id;
+			finfo->rx_id = info->rx_id;
+			finfo->tx_usr = info->usr_id;
+			finfo->tx_irq = info->irq_id;
+			finfo->rx_usr = info->usr_id;
+			finfo->rx_irq = info->irq_id;
+			finfo->name = info->name;
+			info++;
+		} else {
+			child = of_get_next_available_child(node, child);
+			ret = of_property_read_u32_array(child, "ti,mbox-tx",
+							 tmp, ARRAY_SIZE(tmp));
+			if (ret)
+				return ret;
+			finfo->tx_id = tmp[0];
+			finfo->tx_irq = tmp[1];
+			finfo->tx_usr = tmp[2];
+
+			ret = of_property_read_u32_array(child, "ti,mbox-rx",
+							 tmp, ARRAY_SIZE(tmp));
+			if (ret)
+				return ret;
+			finfo->rx_id = tmp[0];
+			finfo->rx_irq = tmp[1];
+			finfo->rx_usr = tmp[2];
+
+			finfo->name = child->name;
+		}
+		if (finfo->tx_id >= num_fifos || finfo->rx_id >= num_fifos ||
+		    finfo->tx_usr >= num_users || finfo->rx_usr >= num_users)
+			return -EINVAL;
+	}
+
 	mdev = devm_kzalloc(&pdev->dev, sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
@@ -615,41 +767,40 @@ static int omap_mbox_probe(struct platform_device *pdev)
 		return PTR_ERR(mdev->mbox_base);
 
 	/* allocate one extra for marking end of list */
-	list = devm_kzalloc(&pdev->dev, (pdata->info_cnt + 1) * sizeof(*list),
+	list = devm_kzalloc(&pdev->dev, (info_count + 1) * sizeof(*list),
 			    GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 
-	mboxblk = devm_kzalloc(&pdev->dev, pdata->info_cnt * sizeof(*mbox),
+	mboxblk = devm_kzalloc(&pdev->dev, info_count * sizeof(*mbox),
 			       GFP_KERNEL);
 	if (!mboxblk)
 		return -ENOMEM;
 
-	info = pdata->info;
-	intr_type = pdata->intr_type;
 	mbox = mboxblk;
-	for (i = 0; i < pdata->info_cnt; i++, info++) {
+	finfo = finfoblk;
+	for (i = 0; i < info_count; i++, finfo++) {
 		fifo = &mbox->tx_fifo;
-		fifo->msg = MAILBOX_MESSAGE(info->tx_id);
-		fifo->fifo_stat = MAILBOX_FIFOSTATUS(info->tx_id);
-		fifo->intr_bit = MAILBOX_IRQ_NOTFULL(info->tx_id);
-		fifo->irqenable = MAILBOX_IRQENABLE(intr_type, info->usr_id);
-		fifo->irqstatus = MAILBOX_IRQSTATUS(intr_type, info->usr_id);
-		fifo->irqdisable = MAILBOX_IRQDISABLE(intr_type, info->usr_id);
+		fifo->msg = MAILBOX_MESSAGE(finfo->tx_id);
+		fifo->fifo_stat = MAILBOX_FIFOSTATUS(finfo->tx_id);
+		fifo->intr_bit = MAILBOX_IRQ_NOTFULL(finfo->tx_id);
+		fifo->irqenable = MAILBOX_IRQENABLE(intr_type, finfo->tx_usr);
+		fifo->irqstatus = MAILBOX_IRQSTATUS(intr_type, finfo->tx_usr);
+		fifo->irqdisable = MAILBOX_IRQDISABLE(intr_type, finfo->tx_usr);
 
 		fifo = &mbox->rx_fifo;
-		fifo->msg =  MAILBOX_MESSAGE(info->rx_id);
-		fifo->msg_stat =  MAILBOX_MSGSTATUS(info->rx_id);
-		fifo->intr_bit = MAILBOX_IRQ_NEWMSG(info->rx_id);
-		fifo->irqenable = MAILBOX_IRQENABLE(intr_type, info->usr_id);
-		fifo->irqstatus = MAILBOX_IRQSTATUS(intr_type, info->usr_id);
-		fifo->irqdisable = MAILBOX_IRQDISABLE(intr_type, info->usr_id);
+		fifo->msg = MAILBOX_MESSAGE(finfo->rx_id);
+		fifo->msg_stat =  MAILBOX_MSGSTATUS(finfo->rx_id);
+		fifo->intr_bit = MAILBOX_IRQ_NEWMSG(finfo->rx_id);
+		fifo->irqenable = MAILBOX_IRQENABLE(intr_type, finfo->rx_usr);
+		fifo->irqstatus = MAILBOX_IRQSTATUS(intr_type, finfo->rx_usr);
+		fifo->irqdisable = MAILBOX_IRQDISABLE(intr_type, finfo->rx_usr);
 
 		mbox->intr_type = intr_type;
 
 		mbox->parent = mdev;
-		mbox->name = info->name;
-		mbox->irq = platform_get_irq(pdev, info->irq_id);
+		mbox->name = finfo->name;
+		mbox->irq = platform_get_irq(pdev, finfo->tx_irq);
 		if (mbox->irq < 0)
 			return mbox->irq;
 		list[i] = mbox++;
@@ -657,8 +808,8 @@ static int omap_mbox_probe(struct platform_device *pdev)
 
 	mutex_init(&mdev->cfg_lock);
 	mdev->dev = &pdev->dev;
-	mdev->num_users = pdata->num_users;
-	mdev->num_fifos = pdata->num_fifos;
+	mdev->num_users = num_users;
+	mdev->num_fifos = num_fifos;
 	mdev->mboxes = list;
 	ret = omap_mbox_register(mdev);
 	if (ret)
@@ -684,6 +835,7 @@ static int omap_mbox_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto unregister;
 
+	devm_kfree(&pdev->dev, finfoblk);
 	return 0;
 
 unregister:
@@ -708,6 +860,7 @@ static struct platform_driver omap_mbox_driver = {
 	.driver	= {
 		.name = "omap-mailbox",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_mailbox_of_match),
 	},
 };
 
-- 
2.0.0

