Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaLJItF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:05 -0500
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:3963
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753582AbaLJItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:00 -0500
X-Greylist: delayed 886 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 03:49:00 EST
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 04/15] drm/dsi: Do not add DSI devices for the child nodes with input-port property
Date: Wed, 10 Dec 2014 16:37:17 +0800
Message-ID: <1418200648-32656-5-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(64706001)(47776003)(20776003)(48376002)(46102003)(110136001)(84676001)(21056001)(77096005)(6806004)(68736005)(104016003)(4396001)(50226001)(89996001)(87936001)(2351001)(85426001)(107046002)(229853001)(120916001)(97736003)(105606002)(106466001)(31966008)(76176999)(50986999)(77156002)(62966003)(99396003)(19580395003)(19580405001)(92566001)(50466002)(86362001)(36756003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 0421BF7135
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPI DSI bus driver would try to add a DSI device for a host's every
child node which contains the reg property.  Unfortunately, the existing
i.MX6Q/SDL MIPI DSI host device tree node's child nodes contain the reg
property, but the child nodes are ports pointing to dedicated CRTCs.
So, this patch phases out the child nodes with input-port property before
adding DSI devices for them and updates the MIPI DSI bus OF binding
documentation.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt | 4 ++++
 drivers/gpu/drm/drm_mipi_dsi.c                              | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt b/Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
index 973c272..1a1d3c1 100644
--- a/Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
+++ b/Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
@@ -36,6 +36,10 @@ Peripherals are represented as child nodes of the DSI host's node. Properties
 described here apply to all DSI peripherals, but individual bindings may want
 to define additional, device-specific properties.
 
+Please, do not add the input-port property to the child nodes which represent
+peripherals. Otherwise, the peripherals would be omitted by the MIPI DSI bus
+driver.
+
 Required properties:
 - reg: The virtual channel number of a DSI peripheral. Must be in the range
   from 0 to 3.
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index c0644bb..9adacfe 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -176,8 +176,9 @@ int mipi_dsi_host_register(struct mipi_dsi_host *host)
 	struct device_node *node;
 
 	for_each_available_child_of_node(host->dev->of_node, node) {
-		/* skip nodes without reg property */
-		if (!of_find_property(node, "reg", NULL))
+		/* skip nodes without reg property or with input-port property */
+		if (!of_find_property(node, "reg", NULL) ||
+		     of_find_property(node, "input-port", NULL))
 			continue;
 		of_mipi_dsi_device_add(host, node);
 	}
-- 
2.1.0

