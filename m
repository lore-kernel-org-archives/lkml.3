Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaFKI6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbaFKI54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 11/36] mtd: nand: omap: Update DT binding documentation
Date: Wed, 11 Jun 2014 11:56:16 +0300
Message-ID: <1402477001-31132-12-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible id, interrupts and update reg property description.
As the NAND controller needs access to GPMC register space, we need
to pass a second memory resource to the NAND controller node.

Due to the wierd way the reg property has been implemented (i.e.
CS number required in 1st number of reg property) we will need to
use a number outside the possible CS numbers for the GPMC register space.

As a SoC can have fewer than 10 chip selects, 255 seems like a safe
bet for the GPMC register space.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 5e1f31b..8831116 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -13,7 +13,13 @@ Documentation/devicetree/bindings/mtd/nand.txt
 
 Required properties:
 
+ - compatible:	"ti,omap2-nand"
  - reg:		The CS line the peripheral is connected to
+		Should contain 2 resource specifiers
+		- range id (CS number), base offset and length of the
+		  NAND I/O space
+		- range id,  base offset and length of the GPMC register space.
+ - interrupts:	Interrupt resource specifier for GPMC interrupt.
 
 Optional properties:
 
@@ -53,17 +59,21 @@ Example for an AM33xx board:
 	gpmc: gpmc@50000000 {
 		compatible = "ti,am3352-gpmc";
 		ti,hwmods = "gpmc";
-		reg = <0x50000000 0x1000000>;
+		reg = <0x50000000 0x36c>;
 		interrupts = <100>;
 		gpmc,num-cs = <8>;
 		gpmc,num-waitpins = <2>;
 		#address-cells = <2>;
 		#size-cells = <1>;
-		ranges = <0 0 0x08000000 0x2000>;	/* CS0: NAND */
+		ranges = <0 0 0x08000000 0x1000000	/* CS0 space, 16MB */
+			  255 0 0x50000000 0x36c>;	/* GPMC reg space */
 		elm_id = <&elm>;
 
 		nand@0,0 {
-			reg = <0 0 0>; /* CS0, offset 0 */
+			compatible = "ti,omap2-nand";
+			reg = <0 0 4		/* CS0, offset 0, NAND I/O window 4 */
+			       255 0 0x36c>;	/* GPMC reg space */
+			interrupts = <100>;
 			nand-bus-width = <16>;
 			ti,nand-ecc-opt = "bch8";
 			ti,nand-xfer-type = "polled";
-- 
1.8.3.2

