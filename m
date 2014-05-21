Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaEULWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44875 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaEULWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:32 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 14/16] ARM: OMAP: gpmc: Update DT binding documentation
Date: Wed, 21 May 2014 14:21:02 +0300
Message-ID: <1400671264-10702-15-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The meaning of ranges and how address mapping is done has changed.
Ranges should now contain 2 ranges
  - GPMC I/O map. ~1GB. This map will be partitioned among the
    chip select (CS) nodes
  - GPMC register map. This is common for all the CS nodes
    and is shared only by the NAND controller.

Chip select (CS) number is no longer specified via reg property. Instead
it is specified via the gpmc,cs property in the CS node.

gpmc,nand boolean property added to specify whether a NAND device is
interfaced to the CS.
gpmc,device-width property is made mandatory.

The CS node must have a child device node for each device attached to
that chip select. Properties for that child are GPMC agnostic.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/bus/ti-gpmc.txt | 109 ++++++++++++++++------
 1 file changed, 81 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/bus/ti-gpmc.txt b/Documentation/devicetree/bindings/bus/ti-gpmc.txt
index 704be93..ca92efb 100644
--- a/Documentation/devicetree/bindings/bus/ti-gpmc.txt
+++ b/Documentation/devicetree/bindings/bus/ti-gpmc.txt
@@ -1,8 +1,6 @@
 Device tree bindings for OMAP general purpose memory controllers (GPMC)
 
-The actual devices are instantiated from the child nodes of a GPMC node.
-
-Required properties:
+GPMC node - Required properties:
 
  - compatible:		Should be set to one of the following:
 
@@ -16,22 +14,39 @@ Required properties:
 			(see the example below)
  - ti,hwmods:		Should be set to "ti,gpmc" until the DT transition is
 			completed.
- - #address-cells:	Must be set to 2 to allow memory address translation
- - #size-cells:		Must be set to 1 to allow CS address passing
+ - interrupts:		Interrupt resource specifier for GPMC interrupt.
+ - #address-cells:	Must be set to 2 to allow memory address translation.
+			1 for range selection and 1 for child's resource address.
+ - #size-cells:		Must be set to 1 to allow child's resource size.
  - gpmc,num-cs:		The maximum number of chip-select lines that controller
 			can support.
  - gpmc,num-waitpins:	The maximum number of wait pins that controller can
 			support.
- - ranges:		Must be set up to reflect the memory layout with four
-			integer values for each chip-select line in use:
-
-			   <cs-number> 0 <physical address of mapping> <size>
-
-			Currently, calculated values derived from the contents
-			of the per-CS register GPMC_CONFIG7 (as set up by the
-			bootloader) are used for the physical address decoding.
-			As this will change in the future, filling correct
-			values here is a requirement.
+ - ranges:		Should contain 2 ranges
+			- GPMC I/O map. ~1GB. This map will be partitioned among
+			the chip select (CS) nodes
+			- GPMC register map. This is common for all the CS nodes
+			and is shared only by the NAND controller.
+
+The GPMC node must contain Chip Select (CS) child nodes representing the
+chip selects in use.
+
+CS node - Required properties:
+
+ - reg:			Resource specifier specifying the CS partition start address
+			and size. Start address must be 16MB aligned. Size has to be
+			one of 16MB, 32MB, 64MB, 128MB and 256MB.
+ - #address-cells:	Must be set to 2 to allow memory address translation.
+			1 for range selection and 1 for child's resource address.
+ - #size-cells:		Must be set to 1 to allow child's resource size.
+ - ranges:		Must be present for 1:1 address translation of child nodes.
+
+ - gpmc,cs:		Chip select number. 0 to (gpmc,num-cs - 1)
+ - gpmc,device-width:	Total width of device(s) connected to a GPMC
+			chip-select in bytes. The GPMC supports 8-bit
+			and 16-bit devices and so this property must be
+			1 or 2.
+ - gpmc,nand:		Boolean. Must be present if CS contains NAND device child.
 
 Timing properties for child nodes. All are optional and default to 0.
 
@@ -95,10 +110,6 @@ GPMC chip-select settings properties for child nodes. All are optional.
 - gpmc,burst-wrap	Enables wrap bursting
 - gpmc,burst-read	Enables read page/burst mode
 - gpmc,burst-write	Enables write page/burst mode
-- gpmc,device-width	Total width of device(s) connected to a GPMC
-			chip-select in bytes. The GPMC supports 8-bit
-			and 16-bit devices and so this property must be
-			1 or 2.
 - gpmc,mux-add-data	Address and data multiplexing configuration.
 			Valid values are 1 for address-address-data
 			multiplexing mode and 2 for address-data
@@ -114,17 +125,59 @@ GPMC chip-select settings properties for child nodes. All are optional.
 
 Example for an AM33xx board:
 
-	gpmc: gpmc@50000000 {
-		compatible = "ti,am3352-gpmc";
-		ti,hwmods = "gpmc";
-		reg = <0x50000000 0x2000>;
-		interrupts = <100>;
+gpmc@50000000 {
+	compatible = "ti,am3352-gpmc";
+	ti,hwmods = "gpmc";
+	reg = <0x50000000 0x36b>;
+	interrupts = <100>;
 
-		gpmc,num-cs = <8>;
-		gpmc,num-waitpins = <2>;
+	gpmc,num-cs = <8>;
+	gpmc,num-waitpins = <2>;
+	#address-cells = <2>;
+	#size-cells = <1>;
+
+	ranges = <0 0 0x00000000 0x1FFFFFFF	/* GPMC I/O space 512MB */
+		  1 0 0x50000000 0x36b>;	/* register space */
+
+	cs0 {
 		#address-cells = <2>;
 		#size-cells = <1>;
-		ranges = <0 0 0x08000000 0x10000000>; /* CS0 @addr 0x8000000, size 0x10000000 */
+		reg = <0 0 0x1000000>;  /* CS0 partition, 16 MB */
+		ranges;
+
+		gpmc,cs = <0>;
+		gpmc,device-width = <2>;	/* 16-bit */
+		gpmc,nand;
+
+		gpmc,cs-on-ns = <0>;
+		gpmc,cs-rd-off-ns = <36>;
+		gpmc,cs-wr-off-ns = <36>;
+		gpmc,adv-on-ns = <6>;
+		gpmc,adv-rd-off-ns = <24>;
+		gpmc,adv-wr-off-ns = <36>;
+		gpmc,oe-on-ns = <6>;
+		gpmc,oe-off-ns = <48>;
+		gpmc,we-on-ns = <6>;
+		gpmc,we-off-ns = <30>;
+		gpmc,rd-cycle-ns = <72>;
+		gpmc,wr-cycle-ns = <72>;
+		gpmc,access-ns = <54>;
+		gpmc,wr-access-ns = <30>;
+
+		nand@0,0 {
+			compatible = "ti,omap2-nand";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0 0 4		/* Nand I/O */
+			       1 0 0x36b>;	/* GPMC registers */
+			interrupts = <20>;
+
+			ti,nand-cs = <0>;
+			nand-bus-width = <16>;
+			...
+		};
 
-		/* child nodes go here */
 	};
+
+	/* Other CS nodes and their children if present */
+};
-- 
1.8.3.2

