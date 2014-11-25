Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaKYLQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:16:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbaKYKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Horman <horms+renesas@verge.net.au>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 151/254] ata: sata_rcar: Disable DIPM mode for r8a7790 ES1
Date: Tue, 25 Nov 2014 10:38:21 +0000
Message-Id: <1416912004-5928-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms+renesas@verge.net.au>

commit aa1cf25887099bba68f1f3879c0d394e08b8779f upstream.

Unlike other SATA R-Car r8a7790 controllers the r8a7790 ES1 SATA R-Car
controller needs to be run with DIPM disabled.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/devicetree/bindings/ata/sata_rcar.txt |  3 ++-
 drivers/ata/sata_rcar.c                             | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ata/sata_rcar.txt b/Documentation/devicetree/bindings/ata/sata_rcar.txt
index 1e6111333fa8..7dd32d321a34 100644
--- a/Documentation/devicetree/bindings/ata/sata_rcar.txt
+++ b/Documentation/devicetree/bindings/ata/sata_rcar.txt
@@ -3,7 +3,8 @@
 Required properties:
 - compatible		: should contain one of the following:
 			  - "renesas,sata-r8a7779" for R-Car H1
-			  - "renesas,sata-r8a7790" for R-Car H2
+			  - "renesas,sata-r8a7790-es1" for R-Car H2 ES1
+			  - "renesas,sata-r8a7790" for R-Car H2 other than ES1
 			  - "renesas,sata-r8a7791" for R-Car M2
 - reg			: address and length of the SATA registers;
 - interrupts		: must consist of one interrupt specifier.
diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 61eb6d77dac7..8732e42db3a9 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -146,6 +146,7 @@
 enum sata_rcar_type {
 	RCAR_GEN1_SATA,
 	RCAR_GEN2_SATA,
+	RCAR_R8A7790_ES1_SATA,
 };
 
 struct sata_rcar_priv {
@@ -763,6 +764,9 @@ static void sata_rcar_setup_port(struct ata_host *host)
 	ap->udma_mask	= ATA_UDMA6;
 	ap->flags	|= ATA_FLAG_SATA;
 
+	if (priv->type == RCAR_R8A7790_ES1_SATA)
+		ap->flags	|= ATA_FLAG_NO_DIPM;
+
 	ioaddr->cmd_addr = base + SDATA_REG;
 	ioaddr->ctl_addr = base + SSDEVCON_REG;
 	ioaddr->scr_addr = base + SCRSSTS_REG;
@@ -792,6 +796,7 @@ static void sata_rcar_init_controller(struct ata_host *host)
 		sata_rcar_gen1_phy_init(priv);
 		break;
 	case RCAR_GEN2_SATA:
+	case RCAR_R8A7790_ES1_SATA:
 		sata_rcar_gen2_phy_init(priv);
 		break;
 	default:
@@ -838,6 +843,10 @@ static struct of_device_id sata_rcar_match[] = {
 		.data = (void *)RCAR_GEN2_SATA
 	},
 	{
+		.compatible = "renesas,sata-r8a7790-es1",
+		.data = (void *)RCAR_R8A7790_ES1_SATA
+	},
+	{
 		.compatible = "renesas,sata-r8a7791",
 		.data = (void *)RCAR_GEN2_SATA
 	},
@@ -849,6 +858,7 @@ static const struct platform_device_id sata_rcar_id_table[] = {
 	{ "sata_rcar", RCAR_GEN1_SATA }, /* Deprecated by "sata-r8a7779" */
 	{ "sata-r8a7779", RCAR_GEN1_SATA },
 	{ "sata-r8a7790", RCAR_GEN2_SATA },
+	{ "sata-r8a7790-es1", RCAR_R8A7790_ES1_SATA },
 	{ "sata-r8a7791", RCAR_GEN2_SATA },
 	{ },
 };
-- 
2.1.0

