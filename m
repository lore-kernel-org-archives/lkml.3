Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaCNSWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:22:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9631 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaCNSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:22:16 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-13-532348d6bb31
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ata: ahci_st: remove deprecated struct ahci_platform_data
 usage
Date: Fri, 14 Mar 2014 19:21:59 +0100
Message-id: <1561239.uqrRD3ZCZp@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd1rHsrBBie+21jc/3qU0WLT42us
	Fsd2PGKyuLxrDpvFr+VHGR1YPTat6mTzuHNtD5vH5iX1Hp83yQWwRHHZpKTmZJalFunbJXBl
	vP7dxFywVaCi/UVGA+NB3i5GTg4JAROJvSefMUHYYhIX7q1n62Lk4hASmM4osWzrAyinhUni
	zd0TLCBVbAJWEhPbVzGC2CICshJXpj1kBCliFmhllJi9Yio7SEJYIEzi+N9FYGNZBFQl1q5+
	yNrFyMHBK6Ap0bozHSQsKuApsWP7SjYQm1dAUOLH5Htg85kF5CX27Z/KCmFrSazfeZxpAiPf
	LCRls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFA+k97BuKrB4hCjAAej
	Eg/vBSXlYCHWxLLiytxDjBIczEoivPuNgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJ
	pCeWpGanphakFsFkmTg4pRoYg/5MucjReviPTUTD7KNF57js9ngzMcaff93wUHSB4LLeXBPz
	5S9ltFO/5kSuZLs+edHkzFd7p7yc/+b5AYHo/X+uFO3x2bFg+avczWu9Yl6F1+plLr1T1z03
	9++RYC2jg4z1FT8dXjidyNWf4VYjy6t5SYR39/IZZR8U7HKuvXwtNefnFFHrnUosxRmJhlrM
	RcWJAIRxsBxGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ahci_platform_data is deprecated (please see comments in
<linux/ahci_platform.h> for details).  Convert ahci_st driver to
use custom ->host_stop method instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/ata/ahci_st.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: b/drivers/ata/ahci_st.c
===================================================================
--- a/drivers/ata/ahci_st.c	2014-03-14 19:17:32.216568395 +0100
+++ b/drivers/ata/ahci_st.c	2014-03-14 19:18:27.912567444 +0100
@@ -87,10 +87,11 @@ static int st_ahci_deassert_resets(struc
 	return 0;
 }
 
-static void st_ahci_exit(struct device *dev)
+static void st_ahci_host_stop(struct ata_host *host)
 {
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct device *dev = host->dev;
 	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
-	struct ahci_host_priv *hpriv = drv_data->hpriv;
 	int err;
 
 	if (drv_data->pwr) {
@@ -127,17 +128,21 @@ static int st_ahci_probe_resets(struct p
 	return st_ahci_deassert_resets(&pdev->dev);
 }
 
+static struct ata_port_operations st_ahci_port_ops = {
+	.inherits	= &ahci_platform_ops,
+	.host_stop	= st_ahci_host_stop,
+};
+
 static const struct ata_port_info st_ahci_port_info = {
 	.flags          = AHCI_FLAG_COMMON,
 	.pio_mask       = ATA_PIO4,
 	.udma_mask      = ATA_UDMA6,
-	.port_ops       = &ahci_platform_ops,
+	.port_ops       = &st_ahci_port_ops,
 };
 
 static int st_ahci_probe(struct platform_device *pdev)
 {
 	struct st_ahci_drv_data *drv_data;
-	struct ahci_platform_data *pdata;
 	struct ahci_host_priv *hpriv;
 	int err;
 
@@ -147,13 +152,6 @@ static int st_ahci_probe(struct platform
 
 	platform_set_drvdata(pdev, drv_data);
 
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
-
-	pdata->exit = st_ahci_exit;
-	pdev->dev.platform_data = pdata;
-
 	hpriv = ahci_platform_get_resources(pdev);
 	if (IS_ERR(hpriv))
 		return PTR_ERR(hpriv);

