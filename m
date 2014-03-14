Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaCNRW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:22:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaCNRW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:22:27 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-cf-53233ad15d1a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci_platform: fix devm_ioremap_resource() return value
 checking
Date: Fri, 14 Mar 2014 18:22:09 +0100
Message-id: <2139783.QvectlX5nq@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2LVsrBBqv+qlm8OT6dyWLT42us
	Fsd2PGKyuLxrDpvFr+VHGR1YPTat6mTz2Lyk3uP9vqtsHp83yQWwRHHZpKTmZJalFunbJXBl
	/N3eylzwnqvi+JNLbA2MEzm7GDk5JARMJDb072KBsMUkLtxbz9bFyMUhJLCIUWLT/IvMEE4L
	k8Sl+TsYQarYBKwkJravArNFBGQlrkx7yAhSxCzQwSjRPb+THSQhLBAh8evnX7CxLAKqEsuW
	bgdr4BXQlJh0eCsbiC0q4CmxY/tKNoi4oMSPyffA6pkF5CX27Z/KCmFrSazfeZxpAiPfLCRl
	s5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGA+k9rBuLLB4hCjAAejEg/v
	BSXlYCHWxLLiytxDjBIczEoivPuNgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeW
	pGanphakFsFkmTg4pRoYrapqeKUSkjq3K4f/m/KVT/89m/jNkhpxlV3GpzTuxtsn7ZAN7SoW
	/709/Ou9Dfc09iu0mesfa/wobdL7TfyA78Ns1/2rHrM47/974XJZ4PIo10Y13y9s0zccU3n+
	5+ctlsbFKtozVS5O+P32yTSrdwu6z216ZlRQ4rddUf7Kh7Wbr0yq4M0zUmIpzkg01GIuKk4E
	AOQbcNxIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() returns a pointer to the remapped memory or
an ERR_PTR() encoded error code on failure.  Fix the check inside
ahci_platform_get_resources() accordingly.

Also while at it remove a needless line break.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/ata/ahci_platform.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ata/ahci_platform.c
===================================================================
--- a/drivers/ata/ahci_platform.c	2014-03-14 16:45:04.056724383 +0100
+++ b/drivers/ata/ahci_platform.c	2014-03-14 17:54:12.504653647 +0100
@@ -199,8 +199,7 @@ static void ahci_platform_put_resources(
  * RETURNS:
  * The allocated ahci_host_priv on success, otherwise an ERR_PTR value
  */
-struct ahci_host_priv *ahci_platform_get_resources(
-	struct platform_device *pdev)
+struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
@@ -219,8 +218,9 @@ struct ahci_host_priv *ahci_platform_get
 
 	hpriv->mmio = devm_ioremap_resource(dev,
 			      platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (!hpriv->mmio) {
+	if (IS_ERR(hpriv->mmio)) {
 		dev_err(dev, "no mmio space\n");
+		rc = PTR_ERR(hpriv->mmio);
 		goto err_out;
 	}
 

