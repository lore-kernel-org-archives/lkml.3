Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaEAKKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:10:41 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34304 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaEAJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 02/47] mtd: nand: stm_nand_bch: provide Device Tree documentation
Date: Thu,  1 May 2014 10:56:09 +0100
Message-Id: <1398938214-17847-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we describe the different new and generic options used by
the ST BCH driver.

Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/stm-nand.txt | 123 +++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
new file mode 100644
index 0000000..9f9325f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
@@ -0,0 +1,123 @@
+STM BCH NAND Support
+--------------------
+
+Required properties:
+
+- compatible		: Should be "st,nand-bch"
+- reg			: Should contain register's location and length
+- reg-names		: "nand_mem" - NAND Controller register map
+			  "nand_dma" - BCH Controller DMA configuration map
+- interrupts		: Interrupt number
+- interrupt-names	: "nand_irq" - NAND Controller IRQ
+- st,nand-banks		: Subnode representing one or more "banks" of NAND
+                          Flash, connected to an STM NAND Controller (see
+                          description below).
+- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
+- st,bch-bitflip-threshold
+			: The threshold at which the number of corrected bit-
+			  flips per sector is deemed to have reached an
+			  excessive level (triggers '-EUCLEAN' to be returned
+			  to the caller).  The value should be in the range 1
+			  to <ecc-strength> where <ecc-strength> is 18 or 30,
+			  depending on the BCH ECC mode in operation.  A value
+			  of 0, or if left unspecified, is interpreted by the
+			  driver as <ecc-strength>.
+
+Properties describing Bank of NAND Flash ("st,nand-banks"):
+
+- st,nand-csn		: Chip select associated with the Bank.
+- st,nand-timing-spec	: [Optional] NAND Device Timing Data.  All times
+                          expressed in ns, except where stated otherwise:
+
+                            tR           : Max Page Read delay [us]
+                            tCLS         : Min CLE setup time
+                            tCS          : Min CE setup time
+                            tALS         : Min ALE setup time
+                            tDS          : Min Data setup time
+                            tWP          : Min WE pulse width
+                            tCLH         : Min CLE hold time
+                            tCH          : Min CE hold time
+                            tALH         : Min ALE hold time
+                            tDH          : Min Data hold time
+                            tWB          : Max WE high to busy
+                            tWH          : Min WE hold time
+                            tWC          : Min Write cycle time
+                            tRP          : Min RE pulse width
+                            tREH         : Min RE high hold time
+                            tRC          : Min Read cycle time
+                            tREA         : Max Read access time
+                            tRHOH        : Min RE high to output hold
+                            tCEA         : Max CE access time
+                            tCOH         : Min CE high to output hold
+                            tCHZ         : Max CE high to output high Z
+                            tCSD         : Min CE high to ALE/CLE don't care
+
+- st,nand-timing-relax	: [Optional] Number of IP clock cycles by which to
+			  "relax" timing configuration.  Required on some boards
+			  to accommodate board-level limitations. Applies to
+			  'st,nand-timing-spec' and ONFI timing mode
+			  configuration.
+
+- nand-on-flash-bbt	: Generic NAND property (See mtd/nand.txt)
+
+- partitions		: [Optional] Subnode describing MTD partition map
+                          (see mtd/partition.txt)
+
+Note, during initialisation, the NAND Controller timing registers are configured
+according to one of the following methods, in order of precedence:
+
+           1. Configuration based on "st,nand_timing_spec" if supplied.
+
+           2. Configuration based on ONFI timing mode, as advertised by the
+              device during ONFI-probing (ONFI-compliant NAND only).
+
+           3. Use reset/safe timing values
+
+Example:
+
+	nandbch: nand-bch {
+	        compatible = "st,nand-bch";
+	        reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
+	        reg-names = "nand_mem", "nand_dma";
+	        interrupts = <0 139 0x0>;
+	        interrupt-names = "nand_irq";
+		nand-ecc-strength = <30>;
+	        st,nand-banks = <&nand_banks>;
+
+	        status = "okay";
+	};
+
+	nand_banks: nand-banks {
+		bank0 {
+			/* NAND_BBT_USE_FLASH */
+			nand-on-flash-bbt;
+			st,nand-csn		= <0>;
+			st,nand-timing-data	= <&nand_timing0>;
+
+			partitions {
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				partition@0{
+					label = "NAND Flash 1";
+					reg = <0x00000000 0x00800000>;
+				};
+				partition@800000{
+					label = "NAND Flash 2";
+					reg = <0x00800000 0x0F800000>;
+				};
+			};
+		};
+	};
+
+	nand_timing0: nand-timing {
+		sig-setup	= <10>;
+		sig-hold	= <10>;
+		CE-deassert	= <0>;
+		WE-to-RBn	= <100>;
+		wr-on		= <10>;
+		wr-off		= <30>;
+		rd-on		= <10>;
+		rd-off		= <30>;
+		chip-delay	= <30>;		/* delay in us */
+	};
-- 
1.8.3.2

