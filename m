Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaIXVJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:09:37 -0400
Received: from mail-bn1bon0098.outbound.protection.outlook.com ([157.56.111.98]:25856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbaIXVJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:09:33 -0400
X-Greylist: delayed 16448 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 17:09:32 EDT
Date: Wed, 24 Sep 2014 14:09:14 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [RFC] pinctrl driver for Zynq
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20972.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(164054003)(229853001)(104016003)(102836001)(50466002)(46102003)(85202003)(15202345003)(76482002)(54356999)(90102001)(50986999)(79102003)(106466001)(81342003)(4396001)(74662003)(10300001)(99396003)(80022003)(74316001)(6806004)(33646002)(120916001)(74502003)(107046002)(83322001)(81542003)(85306004)(110136001)(85852003)(77982003)(83072002)(15975445006)(87936001)(31966008)(83506001)(53416004)(1496007)(20776003)(70736001)(19580405001)(31696002)(92566001)(95666004)(64706001)(85182001)(19580395003)(21056001)(86362001)(44976005)(77096002)(47776003)(23676002)(92726001)(2004002)(107986001)(23106004)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB047;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think I have pinctrl driver that is covering the pinmux options of
Zynq and I also figured out how the DT bindings work.

But there are a couple of things that probably could be done better.

One thing making the DT bindings explode, seems to be all those single
pin functions that can be muxed to every pin.
Next to GPIO, this applies to SD card and write protect - which are even
present twice since Zynq has two SDIO cores. Just these functions
account for a couple of hundred nodes in the DT and a bunch of lines in
the driver. Is there a better way to do this?

In particular for GPIO there seemed to be a better solution with
implementing gpio_request_enable(), but that seemed to allow GPIO in
parallel to request and mux the pin which does not work on Zynq. IOW: I
expected the core would reject a call of gpio_request_enable for a pin
that is already muxed to some other function, but that was not the case
in my testing. Am I missing something here?

And finally, for SD card detect and write protect, we actually have to
disable the muxing. The problem with those functions is, that they have
a dedicated mux for that function which is in parallel to the "normal"
pinmuxes. So, muxing a "normal" function to a pin would not void the
muxing of the SD signals. I thought this would be easily resolved by
implementing the 'disable' op, but after I did that, I noticed that
there is only a stale documentation comment of this member of struct
pinmux_ops left, the actual function pointer is gone.

	Thanks,
	Sören

------------8<-----------------8<-------------------8<--------------8<----------
Date: Mon, 15 Sep 2014 17:24:35 -0700
Subject: [PATCH RFC] pinctrl: Add driver for Zynq

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 3039 +++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/zynq-zc706.dts |   13 +
 arch/arm/mach-zynq/Kconfig       |    1 +
 drivers/pinctrl/Kconfig          |    8 +
 drivers/pinctrl/Makefile         |    1 +
 drivers/pinctrl/pinctrl-zynq.c   |  927 ++++++++++++
 6 files changed, 3988 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pinctrl/pinctrl-zynq.c

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 6cc83d4c6c76..814873da0392 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -229,7 +229,7 @@
 		slcr: slcr@f8000000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
-			compatible = "xlnx,zynq-slcr", "syscon";
+			compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";
 			reg = <0xF8000000 0x1000>;
 			ranges;
 			clkc: clkc@100 {
@@ -250,6 +250,3043 @@
 						"dbg_trc", "dbg_apb";
 				reg = <0x100 0x100>;
 			};
+
+			pinctrl0: pinctrl@700 {
+				compatible = "xlnx,pinctrl-zynq";
+				reg = <0x700 0x200>;
+
+				pinctrl_i2c0_0: pinctrl-i2c0@0 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_0_grp";
+					};
+				};
+
+				pinctrl_i2c0_1: pinctrl-i2c0@1 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_1_grp";
+					};
+				};
+
+				pinctrl_i2c0_2: pinctrl-i2c0@2 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_2_grp";
+					};
+				};
+
+				pinctrl_i2c0_3: pinctrl-i2c0@3 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_3_grp";
+					};
+				};
+
+				pinctrl_i2c0_4: pinctrl-i2c0@4 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_4_grp";
+					};
+				};
+
+				pinctrl_i2c0_5: pinctrl-i2c0@5 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_5_grp";
+					};
+				};
+
+				pinctrl_i2c0_6: pinctrl-i2c0@6 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_6_grp";
+					};
+				};
+
+				pinctrl_i2c0_7: pinctrl-i2c0@7 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_7_grp";
+					};
+				};
+
+				pinctrl_i2c0_8: pinctrl-i2c0@8 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_8_grp";
+					};
+				};
+
+				pinctrl_i2c0_9: pinctrl-i2c0@9 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_9_grp";
+					};
+				};
+
+				pinctrl_i2c0_10: pinctrl-i2c0@10 {
+					i2c0-mux {
+						function = "i2c0";
+						pins = "i2c0_10_grp";
+					};
+				};
+
+				pinctrl_i2c1_0: pinctrl-i2c1@0 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_0_grp";
+					};
+				};
+
+				pinctrl_i2c1_1: pinctrl-i2c1@1 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_1_grp";
+					};
+				};
+
+				pinctrl_i2c1_2: pinctrl-i2c1@2 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_2_grp";
+					};
+				};
+
+				pinctrl_i2c1_3: pinctrl-i2c1@3 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_3_grp";
+					};
+				};
+
+				pinctrl_i2c1_4: pinctrl-i2c1@4 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_4_grp";
+					};
+				};
+
+				pinctrl_i2c1_5: pinctrl-i2c1@5 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_5_grp";
+					};
+				};
+
+				pinctrl_i2c1_6: pinctrl-i2c1@6 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_6_grp";
+					};
+				};
+
+				pinctrl_i2c1_7: pinctrl-i2c1@7 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_7_grp";
+					};
+				};
+
+				pinctrl_i2c1_8: pinctrl-i2c1@8 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_8_grp";
+					};
+				};
+
+				pinctrl_i2c1_9: pinctrl-i2c1@9 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_9_grp";
+					};
+				};
+
+				pinctrl_i2c1_10: pinctrl-i2c1@10 {
+					i2c1-mux {
+						function = "i2c1";
+						pins = "i2c1_10_grp";
+					};
+				};
+
+				pinctrl_gem0_0: pinctrl-gem0@0 {
+					gem0-mux {
+						function = "ethernet0";
+						pins = "ethernet0_0_grp";
+					};
+				};
+
+				pinctrl_gem1_0: pinctrl-gem1@0 {
+					gem1-mux {
+						function = "ethernet1";
+						pins = "ethernet1_0_grp";
+					};
+				};
+
+				pinctrl_mdio0_0: pinctrl-mdio0@0 {
+					mdio0-mux {
+						function = "mdio0";
+						pins = "mdio0_0_grp";
+					};
+				};
+
+				pinctrl_mdio1_0: pinctrl-mdio1@0 {
+					mdio1-mux {
+						function = "mdio1";
+						pins = "mdio1_0_grp";
+					};
+				};
+
+				pinctrl_qspi0_0: pinctrl-qspi0@0 {
+					qspi0-mux {
+						function = "qspi0";
+						pins = "qspi0_0_grp";
+					};
+				};
+
+				pinctrl_qspi1_0: pinctrl-qspi1@0 {
+					qspi0-mux {
+						function = "qspi1";
+						pins = "qspi1_0_grp";
+					};
+				};
+
+				pinctrl_qspi_fbclk: pinctrl-qspi-fbclk@0 {
+					qspi-fbclk-mux {
+						function = "qspi_fbclk";
+						pins = "qspi_fbclk_grp";
+					};
+				};
+
+				pinctrl_qspi_cs1: pinctrl-qspi-cs1@0 {
+					qspi-cs1-mux {
+						function = "qspi_cs1";
+						pins = "qspi_cs1_grp";
+					};
+				};
+
+				pinctrl_spi0_0: pinctrl-spi0@0 {
+					spi0-mux {
+						function = "spi0";
+						pins = "spi0_0_grp";
+					};
+				};
+
+				pinctrl_spi0_1: pinctrl-spi0@1 {
+					spi0-mux {
+						function = "spi0";
+						pins = "spi0_1_grp";
+					};
+				};
+
+				pinctrl_spi0_2: pinctrl-spi0@2 {
+					spi0-mux {
+						function = "spi0";
+						pins = "spi0_2_grp";
+					};
+				};
+
+				pinctrl_spi1_0: pinctrl-spi1@0 {
+					spi1-mux {
+						function = "spi1";
+						pins = "spi1_0_grp";
+					};
+				};
+
+				pinctrl_spi1_1: pinctrl-spi1@1 {
+					spi1-mux {
+						function = "spi1";
+						pins = "spi1_1_grp";
+					};
+				};
+
+				pinctrl_spi1_2: pinctrl-spi1@2 {
+					spi1-mux {
+						function = "spi1";
+						pins = "spi1_2_grp";
+					};
+				};
+
+				pinctrl_spi1_3: pinctrl-spi1@3 {
+					spi1-mux {
+						function = "spi1";
+						pins = "spi1_3_grp";
+					};
+				};
+
+				pinctrl_sdio0_0: pinctrl-sdio0@0 {
+					sdio0-mux {
+						function = "sdio0";
+						pins = "sdio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio0_1: pinctrl-sdio0@1 {
+					sdio0-mux {
+						function = "sdio0";
+						pins = "sdio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio0_2: pinctrl-sdio0@2 {
+					sdio0-mux {
+						function = "sdio0";
+						pins = "sdio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio1_0: pinctrl-sdio1@0 {
+					sdio1-mux {
+						function = "sdio1";
+						pins = "sdio1_0_grp";
+					};
+				};
+
+				pinctrl_sdio1_1: pinctrl-sdio1@1 {
+					sdio1-mux {
+						function = "sdio1";
+						pins = "sdio1_1_grp";
+					};
+				};
+
+				pinctrl_sdio1_2: pinctrl-sdio1@2 {
+					sdio1-mux {
+						function = "sdio1";
+						pins = "sdio1_2_grp";
+					};
+				};
+
+				pinctrl_sdio1_3: pinctrl-sdio1@3 {
+					sdio1-mux {
+						function = "sdio1";
+						pins = "sdio1_3_grp";
+					};
+				};
+
+				pinctrl_smc0_nor: pinctrl-smc0@0 {
+					smc0-mux {
+						function = "smc0_nor";
+						pins = "smc0_nor_grp";
+					};
+				};
+
+				pinctrl_smc0_nor_cs1: pinctrl-smc0_cs1@0 {
+					smc0-cs1-mux {
+						function = "smc0_nor_cs1";
+						pins = "smc0_nor_cs1_grp";
+					};
+				};
+
+				pinctrl_smc0_nor_addr25: pinctrl-smc0_addr25@0 {
+					smc0-addr25-mux {
+						function = "smc0_nor_addr25";
+						pins = "smc0_nor_addr25_grp";
+					};
+				};
+
+				pinctrl_smc0_nand: pinctrl-smc0@1 {
+					smc0-mux {
+						function = "smc0_nand";
+						pins = "smc0_nand_grp";
+					};
+				};
+
+				pinctrl_can0_0: pinctrl-can0@0 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_0_grp";
+					};
+				};
+
+				pinctrl_can0_1: pinctrl-can0@1 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_1_grp";
+					};
+				};
+
+				pinctrl_can0_2: pinctrl-can0@2 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_2_grp";
+					};
+				};
+
+				pinctrl_can0_3: pinctrl-can0@3 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_3_grp";
+					};
+				};
+
+				pinctrl_can0_4: pinctrl-can0@4 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_4_grp";
+					};
+				};
+
+				pinctrl_can0_5: pinctrl-can0@5 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_5_grp";
+					};
+				};
+
+				pinctrl_can0_6: pinctrl-can0@6 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_6_grp";
+					};
+				};
+
+				pinctrl_can0_7: pinctrl-can0@7 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_7_grp";
+					};
+				};
+
+				pinctrl_can0_8: pinctrl-can0@8 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_8_grp";
+					};
+				};
+
+				pinctrl_can0_9: pinctrl-can0@9 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_9_grp";
+					};
+				};
+
+				pinctrl_can0_10: pinctrl-can0@10 {
+					can0-mux {
+						function = "can0";
+						pins = "can0_10_grp";
+					};
+				};
+
+				pinctrl_can1_0: pinctrl-can1@0 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_0_grp";
+					};
+				};
+
+				pinctrl_can1_1: pinctrl-can1@1 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_1_grp";
+					};
+				};
+
+				pinctrl_can1_2: pinctrl-can1@2 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_2_grp";
+					};
+				};
+
+				pinctrl_can1_3: pinctrl-can1@3 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_3_grp";
+					};
+				};
+
+				pinctrl_can1_4: pinctrl-can1@4 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_4_grp";
+					};
+				};
+
+				pinctrl_can1_5: pinctrl-can1@5 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_5_grp";
+					};
+				};
+
+				pinctrl_can1_6: pinctrl-can1@6 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_6_grp";
+					};
+				};
+
+				pinctrl_can1_7: pinctrl-can1@7 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_7_grp";
+					};
+				};
+
+				pinctrl_can1_8: pinctrl-can1@8 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_8_grp";
+					};
+				};
+
+				pinctrl_can1_9: pinctrl-can1@9 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_9_grp";
+					};
+				};
+
+				pinctrl_can1_10: pinctrl-can1@10 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_10_grp";
+					};
+				};
+
+				pinctrl_can1_11: pinctrl-can1@11 {
+					can1-mux {
+						function = "can1";
+						pins = "can1_11_grp";
+					};
+				};
+
+				pinctrl_uart0_0: pinctrl-uart0@0 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_0_grp";
+					};
+				};
+
+				pinctrl_uart0_1: pinctrl-uart0@1 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_1_grp";
+					};
+				};
+
+				pinctrl_uart0_2: pinctrl-uart0@2 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_2_grp";
+					};
+				};
+
+				pinctrl_uart0_3: pinctrl-uart0@3 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_3_grp";
+					};
+				};
+
+				pinctrl_uart0_4: pinctrl-uart0@4 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_4_grp";
+					};
+				};
+
+				pinctrl_uart0_5: pinctrl-uart0@5 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_5_grp";
+					};
+				};
+
+				pinctrl_uart0_6: pinctrl-uart0@6 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_6_grp";
+					};
+				};
+
+				pinctrl_uart0_7: pinctrl-uart0@7 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_7_grp";
+					};
+				};
+
+				pinctrl_uart0_8: pinctrl-uart0@8 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_8_grp";
+					};
+				};
+
+				pinctrl_uart0_9: pinctrl-uart0@9 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_9_grp";
+					};
+				};
+
+				pinctrl_uart0_10: pinctrl-uart0@10 {
+					uart0-mux {
+						function = "uart0";
+						pins = "uart0_10_grp";
+					};
+				};
+
+				pinctrl_uart1_0: pinctrl-uart1@0 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_0_grp";
+					};
+				};
+
+				pinctrl_uart1_1: pinctrl-uart1@1 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_1_grp";
+					};
+				};
+
+				pinctrl_uart1_2: pinctrl-uart1@2 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_2_grp";
+					};
+				};
+
+				pinctrl_uart1_3: pinctrl-uart1@3 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_3_grp";
+					};
+				};
+
+				pinctrl_uart1_4: pinctrl-uart1@4 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_4_grp";
+					};
+				};
+
+				pinctrl_uart1_5: pinctrl-uart1@5 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_5_grp";
+					};
+				};
+
+				pinctrl_uart1_6: pinctrl-uart1@6 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_6_grp";
+					};
+				};
+
+				pinctrl_uart1_7: pinctrl-uart1@7 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_7_grp";
+					};
+				};
+
+				pinctrl_uart1_8: pinctrl-uart1@8 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_8_grp";
+					};
+				};
+
+				pinctrl_uart1_9: pinctrl-uart1@9 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_9_grp";
+					};
+				};
+
+				pinctrl_uart1_10: pinctrl-uart1@10 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_10_grp";
+					};
+				};
+
+				pinctrl_uart1_11: pinctrl-uart1@11 {
+					uart1-mux {
+						function = "uart1";
+						pins = "uart1_11_grp";
+					};
+				};
+
+				pinctrl_ttc0_0: pinctrl-ttc0@0 {
+					ttc0-mux {
+						function = "ttc0";
+						pins = "ttc0_0_grp";
+					};
+				};
+
+				pinctrl_ttc0_1: pinctrl-ttc0@1 {
+					ttc0-mux {
+						function = "ttc0";
+						pins = "ttc0_1_grp";
+					};
+				};
+
+				pinctrl_ttc0_2: pinctrl-ttc0@2 {
+					ttc0-mux {
+						function = "ttc0";
+						pins = "ttc0_2_grp";
+					};
+				};
+
+				pinctrl_ttc1_0: pinctrl-ttc1@0 {
+					ttc1-mux {
+						function = "ttc1";
+						pins = "ttc1_0_grp";
+					};
+				};
+
+				pinctrl_ttc1_1: pinctrl-ttc1@1 {
+					ttc1-mux {
+						function = "ttc1";
+						pins = "ttc1_1_grp";
+					};
+				};
+
+				pinctrl_ttc1_2: pinctrl-ttc1@2 {
+					ttc1-mux {
+						function = "ttc1";
+						pins = "ttc1_2_grp";
+					};
+				};
+
+				pinctrl_swdt0_0: pinctrl-swdt0@0 {
+					swdt0-mux {
+						function = "swdt0";
+						pins = "swdt0_0_grp";
+					};
+				};
+
+				pinctrl_swdt0_1: pinctrl-swdt0@1 {
+					swdt0-mux {
+						function = "swdt0";
+						pins = "swdt0_1_grp";
+					};
+				};
+
+				pinctrl_swdt0_2: pinctrl-swdt0@2 {
+					swdt0-mux {
+						function = "swdt0";
+						pins = "swdt0_2_grp";
+					};
+				};
+
+				pinctrl_swdt0_3: pinctrl-swdt0@3 {
+					swdt0-mux {
+						function = "swdt0";
+						pins = "swdt0_3_grp";
+					};
+				};
+
+				pinctrl_swdt0_4: pinctrl-swdt0@4 {
+					swdt0-mux {
+						function = "swdt0";
+						pins = "swdt0_4_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_0: pinctrl-sdio0_pc@0 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_1: pinctrl-sdio0_pc@1 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_2: pinctrl-sdio0_pc@2 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_3: pinctrl-sdio0_pc@3 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_4: pinctrl-sdio0_pc@4 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_5: pinctrl-sdio0_pc@5 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_6: pinctrl-sdio0_pc@6 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_7: pinctrl-sdio0_pc@7 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_8: pinctrl-sdio0_pc@8 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_9: pinctrl-sdio0_pc@9 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_10: pinctrl-sdio0_pc@10 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_11: pinctrl-sdio0_pc@11 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_12: pinctrl-sdio0_pc@12 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_13: pinctrl-sdio0_pc@13 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_14: pinctrl-sdio0_pc@14 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_15: pinctrl-sdio0_pc@15 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_16: pinctrl-sdio0_pc@16 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_17: pinctrl-sdio0_pc@17 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_18: pinctrl-sdio0_pc@18 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_19: pinctrl-sdio0_pc@19 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_20: pinctrl-sdio0_pc@20 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_21: pinctrl-sdio0_pc@21 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_22: pinctrl-sdio0_pc@22 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_23: pinctrl-sdio0_pc@23 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_24: pinctrl-sdio0_pc@24 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_25: pinctrl-sdio0_pc@25 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_sdio0_pc_26: pinctrl-sdio0_pc@26 {
+					sdio0_pc-mux {
+						function = "sdio0_pc";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+
+				pinctrl_sdio1_pc_0: pinctrl-sdio1_pc@0 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_1: pinctrl-sdio1_pc@1 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_2: pinctrl-sdio1_pc@2 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_3: pinctrl-sdio1_pc@3 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_4: pinctrl-sdio1_pc@4 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_5: pinctrl-sdio1_pc@5 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_6: pinctrl-sdio1_pc@6 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_7: pinctrl-sdio1_pc@7 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_8: pinctrl-sdio1_pc@8 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_9: pinctrl-sdio1_pc@9 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_10: pinctrl-sdio1_pc@10 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_11: pinctrl-sdio1_pc@11 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_12: pinctrl-sdio1_pc@12 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_13: pinctrl-sdio1_pc@13 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_14: pinctrl-sdio1_pc@14 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_15: pinctrl-sdio1_pc@15 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_16: pinctrl-sdio1_pc@16 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_17: pinctrl-sdio1_pc@17 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_18: pinctrl-sdio1_pc@18 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_19: pinctrl-sdio1_pc@19 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_20: pinctrl-sdio1_pc@20 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_21: pinctrl-sdio1_pc@21 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_22: pinctrl-sdio1_pc@22 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_23: pinctrl-sdio1_pc@23 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_24: pinctrl-sdio1_pc@24 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_25: pinctrl-sdio1_pc@25 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_sdio1_pc_26: pinctrl-sdio1_pc@26 {
+					sdio1_pc-mux {
+						function = "sdio1_pc";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_gpio0_0: pinctrl-gpio0@0 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_gpio0_1: pinctrl-gpio0@1 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_gpio0_2: pinctrl-gpio0@2 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_gpio0_3: pinctrl-gpio0@3 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_gpio0_4: pinctrl-gpio0@4 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_gpio0_5: pinctrl-gpio0@5 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_gpio0_6: pinctrl-gpio0@6 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_gpio0_7: pinctrl-gpio0@7 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_gpio0_8: pinctrl-gpio0@8 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_gpio0_9: pinctrl-gpio0@9 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_gpio0_10: pinctrl-gpio0@10 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_gpio0_11: pinctrl-gpio0@11 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_gpio0_12: pinctrl-gpio0@12 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_gpio0_13: pinctrl-gpio0@13 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_gpio0_14: pinctrl-gpio0@14 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_gpio0_15: pinctrl-gpio0@15 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_gpio0_16: pinctrl-gpio0@16 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_gpio0_17: pinctrl-gpio0@17 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_gpio0_18: pinctrl-gpio0@18 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_gpio0_19: pinctrl-gpio0@19 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_gpio0_20: pinctrl-gpio0@20 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_gpio0_21: pinctrl-gpio0@21 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_gpio0_22: pinctrl-gpio0@22 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_gpio0_23: pinctrl-gpio0@23 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_gpio0_24: pinctrl-gpio0@24 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_gpio0_25: pinctrl-gpio0@25 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_gpio0_26: pinctrl-gpio0@26 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_gpio0_27: pinctrl-gpio0@27 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_gpio0_28: pinctrl-gpio0@28 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_gpio0_29: pinctrl-gpio0@29 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_gpio0_30: pinctrl-gpio0@30 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_gpio0_31: pinctrl-gpio0@31 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_gpio0_32: pinctrl-gpio0@32 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_gpio0_33: pinctrl-gpio0@33 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_gpio0_34: pinctrl-gpio0@34 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_gpio0_35: pinctrl-gpio0@35 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_gpio0_36: pinctrl-gpio0@36 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_gpio0_37: pinctrl-gpio0@37 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_gpio0_38: pinctrl-gpio0@38 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_gpio0_39: pinctrl-gpio0@39 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_gpio0_40: pinctrl-gpio0@40 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_gpio0_41: pinctrl-gpio0@41 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_gpio0_42: pinctrl-gpio0@42 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_gpio0_43: pinctrl-gpio0@43 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_gpio0_44: pinctrl-gpio0@44 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_gpio0_45: pinctrl-gpio0@45 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_gpio0_46: pinctrl-gpio0@46 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_gpio0_47: pinctrl-gpio0@47 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_gpio0_48: pinctrl-gpio0@48 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_gpio0_49: pinctrl-gpio0@49 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_gpio0_50: pinctrl-gpio0@50 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_gpio0_51: pinctrl-gpio0@51 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_gpio0_52: pinctrl-gpio0@52 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+				pinctrl_gpio0_53: pinctrl-gpio0@53 {
+					gpio0-mux {
+						function = "gpio0";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_0: pinctrl-sdio0_wp@0 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_1: pinctrl-sdio0_wp@1 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_2: pinctrl-sdio0_wp@2 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_3: pinctrl-sdio0_wp@3 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_4: pinctrl-sdio0_wp@4 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_5: pinctrl-sdio0_wp@5 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_6: pinctrl-sdio0_wp@6 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_7: pinctrl-sdio0_wp@7 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_8: pinctrl-sdio0_wp@8 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_9: pinctrl-sdio0_wp@9 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_10: pinctrl-sdio0_wp@10 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_11: pinctrl-sdio0_wp@11 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_12: pinctrl-sdio0_wp@12 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_13: pinctrl-sdio0_wp@13 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_14: pinctrl-sdio0_wp@14 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_15: pinctrl-sdio0_wp@15 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_16: pinctrl-sdio0_wp@16 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_17: pinctrl-sdio0_wp@17 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_18: pinctrl-sdio0_wp@18 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_19: pinctrl-sdio0_wp@19 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_20: pinctrl-sdio0_wp@20 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_21: pinctrl-sdio0_wp@21 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_22: pinctrl-sdio0_wp@22 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_23: pinctrl-sdio0_wp@23 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_24: pinctrl-sdio0_wp@24 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_25: pinctrl-sdio0_wp@25 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_26: pinctrl-sdio0_wp@26 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_27: pinctrl-sdio0_wp@27 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_28: pinctrl-sdio0_wp@28 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_29: pinctrl-sdio0_wp@29 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_30: pinctrl-sdio0_wp@30 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_31: pinctrl-sdio0_wp@31 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_32: pinctrl-sdio0_wp@32 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_33: pinctrl-sdio0_wp@33 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_34: pinctrl-sdio0_wp@34 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_35: pinctrl-sdio0_wp@35 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_36: pinctrl-sdio0_wp@36 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_37: pinctrl-sdio0_wp@37 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_38: pinctrl-sdio0_wp@38 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_39: pinctrl-sdio0_wp@39 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_40: pinctrl-sdio0_wp@40 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_41: pinctrl-sdio0_wp@41 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_42: pinctrl-sdio0_wp@42 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_43: pinctrl-sdio0_wp@43 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_44: pinctrl-sdio0_wp@44 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_45: pinctrl-sdio0_wp@45 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_46: pinctrl-sdio0_wp@46 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_47: pinctrl-sdio0_wp@47 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_48: pinctrl-sdio0_wp@48 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_49: pinctrl-sdio0_wp@49 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_50: pinctrl-sdio0_wp@50 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_51: pinctrl-sdio0_wp@51 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_52: pinctrl-sdio0_wp@52 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_53: pinctrl-sdio0_wp@53 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_sdio0_wp_54: pinctrl-sdio0_wp@54 {
+					sdio0_wp-mux {
+						function = "sdio0_wp";
+						pins = "sdio0_emio_wp_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_0: pinctrl-sdio0_cd@0 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_1: pinctrl-sdio0_cd@1 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_2: pinctrl-sdio0_cd@2 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_3: pinctrl-sdio0_cd@3 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_4: pinctrl-sdio0_cd@4 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_5: pinctrl-sdio0_cd@5 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_6: pinctrl-sdio0_cd@6 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_7: pinctrl-sdio0_cd@7 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_8: pinctrl-sdio0_cd@8 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_9: pinctrl-sdio0_cd@9 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_10: pinctrl-sdio0_cd@10 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_11: pinctrl-sdio0_cd@11 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_12: pinctrl-sdio0_cd@12 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_13: pinctrl-sdio0_cd@13 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_14: pinctrl-sdio0_cd@14 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_15: pinctrl-sdio0_cd@15 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_16: pinctrl-sdio0_cd@16 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_17: pinctrl-sdio0_cd@17 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_18: pinctrl-sdio0_cd@18 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_19: pinctrl-sdio0_cd@19 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_20: pinctrl-sdio0_cd@20 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_21: pinctrl-sdio0_cd@21 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_22: pinctrl-sdio0_cd@22 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_23: pinctrl-sdio0_cd@23 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_24: pinctrl-sdio0_cd@24 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_25: pinctrl-sdio0_cd@25 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_26: pinctrl-sdio0_cd@26 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_27: pinctrl-sdio0_cd@27 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_28: pinctrl-sdio0_cd@28 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_29: pinctrl-sdio0_cd@29 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_30: pinctrl-sdio0_cd@30 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_31: pinctrl-sdio0_cd@31 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_32: pinctrl-sdio0_cd@32 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_33: pinctrl-sdio0_cd@33 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_34: pinctrl-sdio0_cd@34 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_35: pinctrl-sdio0_cd@35 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_36: pinctrl-sdio0_cd@36 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_37: pinctrl-sdio0_cd@37 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_38: pinctrl-sdio0_cd@38 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_39: pinctrl-sdio0_cd@39 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_40: pinctrl-sdio0_cd@40 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_41: pinctrl-sdio0_cd@41 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_42: pinctrl-sdio0_cd@42 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_43: pinctrl-sdio0_cd@43 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_44: pinctrl-sdio0_cd@44 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_45: pinctrl-sdio0_cd@45 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_46: pinctrl-sdio0_cd@46 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_47: pinctrl-sdio0_cd@47 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_48: pinctrl-sdio0_cd@48 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_49: pinctrl-sdio0_cd@49 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_50: pinctrl-sdio0_cd@50 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_51: pinctrl-sdio0_cd@51 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_52: pinctrl-sdio0_cd@52 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_53: pinctrl-sdio0_cd@53 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_sdio0_cd_54: pinctrl-sdio0_cd@54 {
+					sdio0_cd-mux {
+						function = "sdio0_cd";
+						pins = "sdio0_emio_cd_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_0: pinctrl-sdio1_wp@0 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_1: pinctrl-sdio1_wp@1 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_2: pinctrl-sdio1_wp@2 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_3: pinctrl-sdio1_wp@3 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_4: pinctrl-sdio1_wp@4 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_5: pinctrl-sdio1_wp@5 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_6: pinctrl-sdio1_wp@6 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_7: pinctrl-sdio1_wp@7 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_8: pinctrl-sdio1_wp@8 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_9: pinctrl-sdio1_wp@9 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_10: pinctrl-sdio1_wp@10 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_11: pinctrl-sdio1_wp@11 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_12: pinctrl-sdio1_wp@12 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_13: pinctrl-sdio1_wp@13 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_14: pinctrl-sdio1_wp@14 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_15: pinctrl-sdio1_wp@15 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_16: pinctrl-sdio1_wp@16 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_17: pinctrl-sdio1_wp@17 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_18: pinctrl-sdio1_wp@18 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_19: pinctrl-sdio1_wp@19 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_20: pinctrl-sdio1_wp@20 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_21: pinctrl-sdio1_wp@21 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_22: pinctrl-sdio1_wp@22 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_23: pinctrl-sdio1_wp@23 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_24: pinctrl-sdio1_wp@24 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_25: pinctrl-sdio1_wp@25 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_26: pinctrl-sdio1_wp@26 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_27: pinctrl-sdio1_wp@27 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_28: pinctrl-sdio1_wp@28 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_29: pinctrl-sdio1_wp@29 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_30: pinctrl-sdio1_wp@30 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_31: pinctrl-sdio1_wp@31 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_32: pinctrl-sdio1_wp@32 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_33: pinctrl-sdio1_wp@33 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_34: pinctrl-sdio1_wp@34 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_35: pinctrl-sdio1_wp@35 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_36: pinctrl-sdio1_wp@36 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_37: pinctrl-sdio1_wp@37 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_38: pinctrl-sdio1_wp@38 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_39: pinctrl-sdio1_wp@39 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_40: pinctrl-sdio1_wp@40 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_41: pinctrl-sdio1_wp@41 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_42: pinctrl-sdio1_wp@42 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_43: pinctrl-sdio1_wp@43 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_44: pinctrl-sdio1_wp@44 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_45: pinctrl-sdio1_wp@45 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_46: pinctrl-sdio1_wp@46 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_47: pinctrl-sdio1_wp@47 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_48: pinctrl-sdio1_wp@48 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_49: pinctrl-sdio1_wp@49 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_50: pinctrl-sdio1_wp@50 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_51: pinctrl-sdio1_wp@51 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_52: pinctrl-sdio1_wp@52 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_53: pinctrl-sdio1_wp@53 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_sdio1_wp_54: pinctrl-sdio1_wp@54 {
+					sdio1_wp-mux {
+						function = "sdio1_wp";
+						pins = "sdio1_emio_wp_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_0: pinctrl-sdio1_cd@0 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_0_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_1: pinctrl-sdio1_cd@1 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_1_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_2: pinctrl-sdio1_cd@2 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_2_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_3: pinctrl-sdio1_cd@3 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_3_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_4: pinctrl-sdio1_cd@4 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_4_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_5: pinctrl-sdio1_cd@5 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_5_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_6: pinctrl-sdio1_cd@6 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_6_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_7: pinctrl-sdio1_cd@7 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_7_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_8: pinctrl-sdio1_cd@8 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_8_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_9: pinctrl-sdio1_cd@9 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_9_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_10: pinctrl-sdio1_cd@10 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_10_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_11: pinctrl-sdio1_cd@11 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_11_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_12: pinctrl-sdio1_cd@12 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_12_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_13: pinctrl-sdio1_cd@13 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_13_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_14: pinctrl-sdio1_cd@14 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_14_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_15: pinctrl-sdio1_cd@15 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_15_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_16: pinctrl-sdio1_cd@16 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_16_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_17: pinctrl-sdio1_cd@17 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_17_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_18: pinctrl-sdio1_cd@18 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_18_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_19: pinctrl-sdio1_cd@19 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_19_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_20: pinctrl-sdio1_cd@20 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_20_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_21: pinctrl-sdio1_cd@21 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_21_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_22: pinctrl-sdio1_cd@22 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_22_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_23: pinctrl-sdio1_cd@23 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_23_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_24: pinctrl-sdio1_cd@24 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_24_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_25: pinctrl-sdio1_cd@25 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_25_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_26: pinctrl-sdio1_cd@26 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_26_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_27: pinctrl-sdio1_cd@27 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_27_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_28: pinctrl-sdio1_cd@28 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_28_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_29: pinctrl-sdio1_cd@29 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_29_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_30: pinctrl-sdio1_cd@30 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_30_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_31: pinctrl-sdio1_cd@31 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_31_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_32: pinctrl-sdio1_cd@32 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_32_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_33: pinctrl-sdio1_cd@33 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_33_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_34: pinctrl-sdio1_cd@34 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_34_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_35: pinctrl-sdio1_cd@35 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_35_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_36: pinctrl-sdio1_cd@36 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_36_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_37: pinctrl-sdio1_cd@37 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_37_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_38: pinctrl-sdio1_cd@38 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_38_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_39: pinctrl-sdio1_cd@39 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_39_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_40: pinctrl-sdio1_cd@40 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_40_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_41: pinctrl-sdio1_cd@41 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_41_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_42: pinctrl-sdio1_cd@42 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_42_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_43: pinctrl-sdio1_cd@43 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_43_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_44: pinctrl-sdio1_cd@44 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_44_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_45: pinctrl-sdio1_cd@45 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_45_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_46: pinctrl-sdio1_cd@46 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_46_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_47: pinctrl-sdio1_cd@47 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_47_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_48: pinctrl-sdio1_cd@48 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_48_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_49: pinctrl-sdio1_cd@49 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_49_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_50: pinctrl-sdio1_cd@50 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_50_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_51: pinctrl-sdio1_cd@51 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_51_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_52: pinctrl-sdio1_cd@52 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_52_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_53: pinctrl-sdio1_cd@53 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "gpio0_53_grp";
+					};
+				};
+
+				pinctrl_sdio1_cd_54: pinctrl-sdio1_cd@54 {
+					sdio1_cd-mux {
+						function = "sdio1_cd";
+						pins = "sdio1_emio_cd_grp";
+					};
+				};
+			};
 		};
 
 		dmac_s: dmac@f8003000 {
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 4cc9913078cd..1ae9bcaee252 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -33,11 +33,20 @@
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gem0_0>, <&pinctrl_mdio0_0>;
+};
+
+&gpio0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpio0_7>, <&pinctrl_gpio0_46>, <&pinctrl_gpio0_47>;
 };
 
 &i2c0 {
 	status = "okay";
 	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c0_10>;
 
 	i2cswitch@74 {
 		compatible = "nxp,pca9548";
@@ -105,8 +114,12 @@
 
 &sdhci0 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_sdio0_2>, <&pinctrl_sdio0_wp_15>, <&pinctrl_sdio0_cd_14>;
 };
 
 &uart1 {
 	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_uart1_10>;
 };
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index aaa5162c1509..13b8524354ee 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -9,6 +9,7 @@ config ARCH_ZYNQ
 	select HAVE_ARM_TWD if SMP
 	select ICST
 	select MFD_SYSCON
+	select PINCTRL
 	select SOC_BUS
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index bfd2c2e9f6cd..dd19c03adf9a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -305,6 +305,14 @@ config PINCTRL_PALMAS
 	  open drain configuration for the Palmas series devices like
 	  TPS65913, TPS80036 etc.
 
+config PINCTRL_ZYNQ
+	bool "Pinctrl driver for Xilinx Zynq"
+	depends on ARCH_ZYNQ
+	select PINMUX
+	select GENERIC_PINCONF
+	help
+	  This selectes the pinctrl driver for Xilinx Zynq.
+
 source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
 source "drivers/pinctrl/nomadik/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 05d227508c95..c31f75fd32c9 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
 obj-$(CONFIG_PINCTRL_TB10X)	+= pinctrl-tb10x.o
 obj-$(CONFIG_PINCTRL_ST) 	+= pinctrl-st.o
 obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
+obj-$(CONFIG_PINCTRL_ZYNQ)	+= pinctrl-zynq.o
 
 obj-$(CONFIG_ARCH_BERLIN)	+= berlin/
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
new file mode 100644
index 000000000000..60100812e481
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -0,0 +1,927 @@
+/*
+ * Zynq pin controller
+ *
+ *  Copyright (C) 2014 Xilinx
+ *
+ *  Sören Brinkmann <soren.brinkmann@xilinx.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/spinlock.h>
+#include "pinctrl-utils.h"
+
+#define ZYNQ_PINMUX_MUX_SHIFT	1
+#define ZYNQ_PINMUX_MUX_MASK	(0x7f << ZYNQ_PINMUX_MUX_SHIFT)
+
+struct zynq_pinctrl {
+	struct pinctrl_dev *pctrl;
+	void __iomem *regs;
+	const struct zynq_pctrl_group *groups;
+	unsigned int ngroups;
+	const struct zynq_pinmux_function *funcs;
+	unsigned int nfuncs;
+	spinlock_t lock;
+};
+
+struct zynq_pctrl_group {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned npins;
+};
+
+/**
+ * struct zynq_pinmux_function - a pinmux function
+ * @name:    Name of the pinmux function.
+ * @groups:  List of pingroups for this function.
+ * @ngroups: Number of entries in @groups.
+ */
+struct zynq_pinmux_function {
+	const char *name;
+	const char * const *groups;
+	unsigned int ngroups;
+	unsigned int mux_val;
+	u32 mux;
+	u32 mux_mask;
+	u8 mux_shift;
+};
+
+enum zynq_pinmux_functions {
+	ZYNQ_PMUX_ethernet0,
+	ZYNQ_PMUX_ethernet1,
+	ZYNQ_PMUX_mdio0,
+	ZYNQ_PMUX_mdio1,
+	ZYNQ_PMUX_qspi0,
+	ZYNQ_PMUX_qspi1,
+	ZYNQ_PMUX_qspi_fbclk,
+	ZYNQ_PMUX_qspi_cs1,
+	ZYNQ_PMUX_spi0,
+	ZYNQ_PMUX_spi1,
+	ZYNQ_PMUX_sdio0,
+	ZYNQ_PMUX_sdio0_pc,
+	ZYNQ_PMUX_sdio0_cd,
+	ZYNQ_PMUX_sdio0_wp,
+	ZYNQ_PMUX_sdio1,
+	ZYNQ_PMUX_sdio1_pc,
+	ZYNQ_PMUX_sdio1_cd,
+	ZYNQ_PMUX_sdio1_wp,
+	ZYNQ_PMUX_smc0_nor,
+	ZYNQ_PMUX_smc0_nor_cs1,
+	ZYNQ_PMUX_smc0_nor_addr25,
+	ZYNQ_PMUX_smc0_nand,
+	ZYNQ_PMUX_can0,
+	ZYNQ_PMUX_can1,
+	ZYNQ_PMUX_uart0,
+	ZYNQ_PMUX_uart1,
+	ZYNQ_PMUX_i2c0,
+	ZYNQ_PMUX_i2c1,
+	ZYNQ_PMUX_ttc0,
+	ZYNQ_PMUX_ttc1,
+	ZYNQ_PMUX_swdt0,
+	ZYNQ_PMUX_gpio0,
+	ZYNQ_PMUX_MAX_FUNC
+};
+
+const struct pinctrl_pin_desc zynq_pins[] = {
+      PINCTRL_PIN(0,  "MIO0"),
+      PINCTRL_PIN(1,  "MIO1"),
+      PINCTRL_PIN(2,  "MIO2"),
+      PINCTRL_PIN(3,  "MIO3"),
+      PINCTRL_PIN(4,  "MIO4"),
+      PINCTRL_PIN(5,  "MIO5"),
+      PINCTRL_PIN(6,  "MIO6"),
+      PINCTRL_PIN(7,  "MIO7"),
+      PINCTRL_PIN(8,  "MIO8"),
+      PINCTRL_PIN(9,  "MIO9"),
+      PINCTRL_PIN(10, "MIO10"),
+      PINCTRL_PIN(11, "MIO11"),
+      PINCTRL_PIN(12, "MIO12"),
+      PINCTRL_PIN(13, "MIO13"),
+      PINCTRL_PIN(14, "MIO14"),
+      PINCTRL_PIN(15, "MIO15"),
+      PINCTRL_PIN(16, "MIO16"),
+      PINCTRL_PIN(17, "MIO17"),
+      PINCTRL_PIN(18, "MIO18"),
+      PINCTRL_PIN(19, "MIO19"),
+      PINCTRL_PIN(20, "MIO20"),
+      PINCTRL_PIN(21, "MIO21"),
+      PINCTRL_PIN(22, "MIO22"),
+      PINCTRL_PIN(23, "MIO23"),
+      PINCTRL_PIN(24, "MIO24"),
+      PINCTRL_PIN(25, "MIO25"),
+      PINCTRL_PIN(26, "MIO26"),
+      PINCTRL_PIN(27, "MIO27"),
+      PINCTRL_PIN(28, "MIO28"),
+      PINCTRL_PIN(29, "MIO29"),
+      PINCTRL_PIN(30, "MIO30"),
+      PINCTRL_PIN(31, "MIO31"),
+      PINCTRL_PIN(32, "MIO32"),
+      PINCTRL_PIN(33, "MIO33"),
+      PINCTRL_PIN(34, "MIO34"),
+      PINCTRL_PIN(35, "MIO35"),
+      PINCTRL_PIN(36, "MIO36"),
+      PINCTRL_PIN(37, "MIO37"),
+      PINCTRL_PIN(38, "MIO38"),
+      PINCTRL_PIN(39, "MIO39"),
+      PINCTRL_PIN(40, "MIO40"),
+      PINCTRL_PIN(41, "MIO41"),
+      PINCTRL_PIN(42, "MIO42"),
+      PINCTRL_PIN(43, "MIO43"),
+      PINCTRL_PIN(44, "MIO44"),
+      PINCTRL_PIN(45, "MIO45"),
+      PINCTRL_PIN(46, "MIO46"),
+      PINCTRL_PIN(47, "MIO47"),
+      PINCTRL_PIN(48, "MIO48"),
+      PINCTRL_PIN(49, "MIO49"),
+      PINCTRL_PIN(50, "MIO50"),
+      PINCTRL_PIN(51, "MIO51"),
+      PINCTRL_PIN(52, "MIO52"),
+      PINCTRL_PIN(53, "MIO53"),
+      PINCTRL_PIN(54, "EMIO_SD0_WP"),
+      PINCTRL_PIN(55, "EMIO_SD0_CD"),
+      PINCTRL_PIN(56, "EMIO_SD1_WP"),
+      PINCTRL_PIN(57, "EMIO_SD0_CD"),
+};
+
+/* pin groups */
+static const unsigned int ethernet0_0_pins[] = {16, 17, 18, 19, 20, 21, 22, 23, 24,
+					    25, 26, 27};
+static const unsigned int ethernet1_0_pins[] = {28, 29, 30, 31, 32, 33, 34, 35, 36,
+					        37, 38, 39};
+static const unsigned int mdio0_0_pins[] = {52, 53};
+static const unsigned int mdio1_0_pins[] = {52, 53};
+static const unsigned int qspi0_0_pins[] = {1, 2, 3, 4, 5, 6};
+
+static const unsigned int qspi1_0_pins[] = {9, 10, 11, 12, 13};
+static const unsigned int qspi_cs1_pins[] = {0};
+static const unsigned int qspi_fbclk_pins[] = {8};
+static const unsigned int spi0_0_pins[] = {16, 17, 18, 19, 20, 21};
+static const unsigned int spi0_1_pins[] = {28, 29, 30, 31, 32, 33};
+static const unsigned int spi0_2_pins[] = {40, 41, 42, 43, 44, 45};
+static const unsigned int spi1_0_pins[] = {10, 11, 12, 13, 14, 15};
+static const unsigned int spi1_1_pins[] = {22, 23, 24, 25, 26, 27};
+static const unsigned int spi1_2_pins[] = {34, 35, 36, 37, 38, 39};
+static const unsigned int spi1_3_pins[] = {46, 47, 48, 49, 40, 51};
+static const unsigned int sdio0_0_pins[] = {16, 17, 18, 19, 20, 21};
+static const unsigned int sdio0_1_pins[] = {28, 29, 30, 31, 32, 33};
+static const unsigned int sdio0_2_pins[] = {40, 41, 42, 43, 44, 45};
+static const unsigned int sdio1_0_pins[] = {10, 11, 12, 13, 14, 15};
+static const unsigned int sdio1_1_pins[] = {22, 23, 24, 25, 26, 27};
+static const unsigned int sdio1_2_pins[] = {34, 35, 36, 37, 38, 39};
+static const unsigned int sdio1_3_pins[] = {46, 47, 48, 49, 40, 51};
+static const unsigned int sdio0_emio_wp_pins[] = {54};
+static const unsigned int sdio0_emio_cd_pins[] = {55};
+static const unsigned int sdio1_emio_wp_pins[] = {56};
+static const unsigned int sdio1_emio_cd_pins[] = {57};
+static const unsigned int smc0_nor_pins[] = {0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15,
+					     16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
+					     26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
+					     36, 37, 38, 39};
+static const unsigned int smc0_nor_cs1_pins[] = {1};
+static const unsigned int smc0_nor_addr25_pins[] = {1};
+static const unsigned int smc0_nand_pins[] = {0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
+					      13, 14, 16, 17, 18, 19, 20, 21, 22, 23};
+/* Note: CAN MIO clock inputs are modeled in the clock framework */
+static const unsigned int can0_0_pins[] = {10, 11};
+static const unsigned int can0_1_pins[] = {14, 15};
+static const unsigned int can0_2_pins[] = {18, 19};
+static const unsigned int can0_3_pins[] = {22, 23};
+static const unsigned int can0_4_pins[] = {26, 27};
+static const unsigned int can0_5_pins[] = {30, 31};
+static const unsigned int can0_6_pins[] = {34, 35};
+static const unsigned int can0_7_pins[] = {38, 39};
+static const unsigned int can0_8_pins[] = {42, 43};
+static const unsigned int can0_9_pins[] = {46, 47};
+static const unsigned int can0_10_pins[] = {50, 51};
+static const unsigned int can1_0_pins[] = {8, 9};
+static const unsigned int can1_1_pins[] = {12, 13};
+static const unsigned int can1_2_pins[] = {16, 17};
+static const unsigned int can1_3_pins[] = {20, 21};
+static const unsigned int can1_4_pins[] = {24, 25};
+static const unsigned int can1_5_pins[] = {28, 29};
+static const unsigned int can1_6_pins[] = {32, 33};
+static const unsigned int can1_7_pins[] = {36, 37};
+static const unsigned int can1_8_pins[] = {40, 41};
+static const unsigned int can1_9_pins[] = {44, 45};
+static const unsigned int can1_10_pins[] = {48, 49};
+static const unsigned int can1_11_pins[] = {52, 53};
+static const unsigned int uart0_0_pins[] = {10, 11};
+static const unsigned int uart0_1_pins[] = {14, 15};
+static const unsigned int uart0_2_pins[] = {18, 19};
+static const unsigned int uart0_3_pins[] = {22, 23};
+static const unsigned int uart0_4_pins[] = {26, 27};
+static const unsigned int uart0_5_pins[] = {30, 31};
+static const unsigned int uart0_6_pins[] = {34, 35};
+static const unsigned int uart0_7_pins[] = {38, 39};
+static const unsigned int uart0_8_pins[] = {42, 43};
+static const unsigned int uart0_9_pins[] = {46, 47};
+static const unsigned int uart0_10_pins[] = {50, 51};
+static const unsigned int uart1_0_pins[] = {8, 9};
+static const unsigned int uart1_1_pins[] = {12, 13};
+static const unsigned int uart1_2_pins[] = {16, 17};
+static const unsigned int uart1_3_pins[] = {20, 21};
+static const unsigned int uart1_4_pins[] = {24, 25};
+static const unsigned int uart1_5_pins[] = {28, 29};
+static const unsigned int uart1_6_pins[] = {32, 33};
+static const unsigned int uart1_7_pins[] = {36, 37};
+static const unsigned int uart1_8_pins[] = {40, 41};
+static const unsigned int uart1_9_pins[] = {44, 45};
+static const unsigned int uart1_10_pins[] = {48, 49};
+static const unsigned int uart1_11_pins[] = {52, 53};
+static const unsigned int i2c0_0_pins[] = {10, 11};
+static const unsigned int i2c0_1_pins[] = {14, 15};
+static const unsigned int i2c0_2_pins[] = {18, 19};
+static const unsigned int i2c0_3_pins[] = {22, 23};
+static const unsigned int i2c0_4_pins[] = {26, 27};
+static const unsigned int i2c0_5_pins[] = {30, 31};
+static const unsigned int i2c0_6_pins[] = {34, 35};
+static const unsigned int i2c0_7_pins[] = {38, 39};
+static const unsigned int i2c0_8_pins[] = {42, 43};
+static const unsigned int i2c0_9_pins[] = {46, 47};
+static const unsigned int i2c0_10_pins[] = {50, 51};
+static const unsigned int i2c1_0_pins[] = {12, 13};
+static const unsigned int i2c1_1_pins[] = {16, 17};
+static const unsigned int i2c1_2_pins[] = {20, 21};
+static const unsigned int i2c1_3_pins[] = {24, 25};
+static const unsigned int i2c1_4_pins[] = {28, 29};
+static const unsigned int i2c1_5_pins[] = {32, 33};
+static const unsigned int i2c1_6_pins[] = {36, 37};
+static const unsigned int i2c1_7_pins[] = {40, 41};
+static const unsigned int i2c1_8_pins[] = {44, 45};
+static const unsigned int i2c1_9_pins[] = {48, 49};
+static const unsigned int i2c1_10_pins[] = {52, 53};
+static const unsigned int ttc0_0_pins[] = {18, 19};
+static const unsigned int ttc0_1_pins[] = {30, 31};
+static const unsigned int ttc0_2_pins[] = {42, 43};
+static const unsigned int ttc1_0_pins[] = {16, 17};
+static const unsigned int ttc1_1_pins[] = {28, 29};
+static const unsigned int ttc1_2_pins[] = {40, 41};
+static const unsigned int swdt0_0_pins[] = {14, 15};
+static const unsigned int swdt0_1_pins[] = {26, 27};
+static const unsigned int swdt0_2_pins[] = {38, 39};
+static const unsigned int swdt0_3_pins[] = {50, 51};
+static const unsigned int swdt0_4_pins[] = {52, 53};
+static const unsigned int gpio0_0_pins[] = {0};
+static const unsigned int gpio0_1_pins[] = {1};
+static const unsigned int gpio0_2_pins[] = {2};
+static const unsigned int gpio0_3_pins[] = {3};
+static const unsigned int gpio0_4_pins[] = {4};
+static const unsigned int gpio0_5_pins[] = {5};
+static const unsigned int gpio0_6_pins[] = {6};
+static const unsigned int gpio0_7_pins[] = {7};
+static const unsigned int gpio0_8_pins[] = {8};
+static const unsigned int gpio0_9_pins[] = {9};
+static const unsigned int gpio0_10_pins[] = {10};
+static const unsigned int gpio0_11_pins[] = {11};
+static const unsigned int gpio0_12_pins[] = {12};
+static const unsigned int gpio0_13_pins[] = {13};
+static const unsigned int gpio0_14_pins[] = {14};
+static const unsigned int gpio0_15_pins[] = {15};
+static const unsigned int gpio0_16_pins[] = {16};
+static const unsigned int gpio0_17_pins[] = {17};
+static const unsigned int gpio0_18_pins[] = {18};
+static const unsigned int gpio0_19_pins[] = {19};
+static const unsigned int gpio0_20_pins[] = {20};
+static const unsigned int gpio0_21_pins[] = {21};
+static const unsigned int gpio0_22_pins[] = {22};
+static const unsigned int gpio0_23_pins[] = {23};
+static const unsigned int gpio0_24_pins[] = {24};
+static const unsigned int gpio0_25_pins[] = {25};
+static const unsigned int gpio0_26_pins[] = {26};
+static const unsigned int gpio0_27_pins[] = {27};
+static const unsigned int gpio0_28_pins[] = {28};
+static const unsigned int gpio0_29_pins[] = {29};
+static const unsigned int gpio0_30_pins[] = {30};
+static const unsigned int gpio0_31_pins[] = {31};
+static const unsigned int gpio0_32_pins[] = {32};
+static const unsigned int gpio0_33_pins[] = {33};
+static const unsigned int gpio0_34_pins[] = {34};
+static const unsigned int gpio0_35_pins[] = {35};
+static const unsigned int gpio0_36_pins[] = {36};
+static const unsigned int gpio0_37_pins[] = {37};
+static const unsigned int gpio0_38_pins[] = {38};
+static const unsigned int gpio0_39_pins[] = {39};
+static const unsigned int gpio0_40_pins[] = {40};
+static const unsigned int gpio0_41_pins[] = {41};
+static const unsigned int gpio0_42_pins[] = {42};
+static const unsigned int gpio0_43_pins[] = {43};
+static const unsigned int gpio0_44_pins[] = {44};
+static const unsigned int gpio0_45_pins[] = {45};
+static const unsigned int gpio0_46_pins[] = {46};
+static const unsigned int gpio0_47_pins[] = {47};
+static const unsigned int gpio0_48_pins[] = {48};
+static const unsigned int gpio0_49_pins[] = {49};
+static const unsigned int gpio0_50_pins[] = {50};
+static const unsigned int gpio0_51_pins[] = {51};
+static const unsigned int gpio0_52_pins[] = {52};
+static const unsigned int gpio0_53_pins[] = {53};
+
+#define DEFINE_ZYNQ_PINCTRL_GRP(nm) \
+	{ \
+		.name = #nm "_grp", \
+		.pins = nm ## _pins, \
+		.npins = ARRAY_SIZE(nm ## _pins), \
+	}
+
+struct zynq_pctrl_group zynq_pctrl_groups[] = {
+	DEFINE_ZYNQ_PINCTRL_GRP(ethernet0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(ethernet1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(mdio0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(mdio1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(qspi0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(qspi1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(qspi_fbclk),
+	DEFINE_ZYNQ_PINCTRL_GRP(qspi_cs1),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(spi1_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_emio_wp),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_emio_cd),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_emio_wp),
+	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_emio_cd),
+	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor),
+	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor_cs1),
+	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor_addr25),
+	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nand),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(can0_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(can1_11),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart0_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(uart1_11),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_0),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_1),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_2),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_3),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_4),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_5),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_6),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_7),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_8),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_9),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_10),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_11),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_12),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_13),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_14),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_15),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_16),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_17),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_18),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_19),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_20),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_21),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_22),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_23),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_24),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_25),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_26),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_27),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_28),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_29),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_30),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_31),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_32),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_33),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_34),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_35),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_36),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_37),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_38),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_39),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_40),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_41),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_42),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_43),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_44),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_45),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_46),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_47),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_48),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_49),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_50),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_51),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_52),
+	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_53)
+};
+
+/* function groups */
+static const char * const ethernet0_groups[] = {"ethernet0_0_grp"};
+static const char * const ethernet1_groups[] = {"ethernet1_0_grp"};
+static const char * const mdio0_groups[] = {"mdio0_0_grp"};
+static const char * const mdio1_groups[] = {"mdio1_0_grp"};
+static const char * const qspi0_groups[] = {"qspi0_0_grp"};
+static const char * const qspi1_groups[] = {"qspi0_1_grp"};
+static const char * const qspi_fbclk_groups[] = {"qspi_fbclk_grp"};
+static const char * const qspi_cs1_groups[] = {"qspi_cs1_grp"};
+static const char * const spi0_groups[] =
+				{"spi0_0_grp", "spi0_1_grp", "spi0_2_grp"};
+static const char * const spi1_groups[] =
+		{"spi1_0_grp", "spi1_1_grp", "spi1_2_grp", "spi1_3_grp"};
+static const char * const sdio0_groups[] =
+		{"sdio0_0_grp", "sdio0_1_grp", "sdio0_2_grp"};
+static const char * const sdio1_groups[] =
+	{"sdio1_0_grp", "sdio1_1_grp", "sdio1_2_grp", "sdio1_3_grp"};
+static const char * const sdio0_pc_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_8_grp", "gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp"};
+static const char * const sdio1_pc_groups[] = {"gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp", "gpio0_7_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp"};
+static const char * const sdio0_cd_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp", "sdio0_emio_cd_grp"};
+static const char * const sdio0_wp_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp", "sdio0_emio_wp_grp"};
+static const char * const sdio1_cd_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp", "sdio1_emio_cd_grp"};
+static const char * const sdio1_wp_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp", "sdio1_emio_wp_grp"};
+static const char * const smc0_nor_groups[] = {"smc0_nor"};
+static const char * const smc0_nor_cs1_groups[] = {"smc0_nor_cs1_grp"};
+static const char * const smc0_nor_addr25_groups[] = {"smc0_nor_addr25_grp"};
+static const char * const smc0_nand_groups[] = {"smc0_nand"};
+static const char * const can0_groups[] =
+		{"can0_0_grp", "can0_1_grp", "can0_2_grp", "can0_3_grp",
+		 "can0_4_grp", "can0_5_grp", "can0_6_grp", "can0_7_grp",
+		 "can0_8_grp", "can0_9_grp", "can0_10_grp"};
+static const char * const can1_groups[] =
+		{"can1_0_grp", "can1_1_grp", "can1_2_grp", "can1_3_grp",
+		 "can1_4_grp", "can1_5_grp", "can1_6_grp", "can1_7_grp",
+		 "can1_8_grp", "can1_9_grp", "can1_10_grp", "can1_11_grp"};
+static const char * const uart0_groups[] =
+		{"uart0_0_grp", "uart0_1_grp", "uart0_2_grp", "uart0_3_grp",
+		 "uart0_4_grp", "uart0_5_grp", "uart0_6_grp", "uart0_7_grp",
+		 "uart0_8_grp", "uart0_9_grp", "uart0_10_grp"};
+static const char * const uart1_groups[] =
+		{"uart1_0_grp", "uart1_1_grp", "uart1_2_grp", "uart1_3_grp",
+		 "uart1_4_grp", "uart1_5_grp", "uart1_6_grp", "uart1_7_grp",
+		 "uart1_8_grp", "uart1_9_grp", "uart1_10_grp", "uart1_11_grp"};
+static const char * const i2c0_groups[] =
+		{"i2c0_0_grp", "i2c0_1_grp", "i2c0_2_grp", "i2c0_3_grp",
+		 "i2c0_4_grp", "i2c0_5_grp", "i2c0_6_grp", "i2c0_7_grp",
+		 "i2c0_8_grp", "i2c0_9_grp", "i2c0_10_grp"};
+static const char * const i2c1_groups[] =
+		{"i2c1_0_grp", "i2c1_1_grp", "i2c1_2_grp", "i2c1_3_grp",
+		 "i2c1_4_grp", "i2c1_5_grp", "i2c1_6_grp", "i2c1_7_grp",
+		 "i2c1_8_grp", "i2c1_9_grp", "i2c1_10_grp"};
+static const char * const ttc0_groups[] =
+			{"ttc0_0_grp", "ttc0_1_grp", "ttc0_2_grp"};
+static const char * const ttc1_groups[] =
+			{"ttc1_0_grp", "ttc1_1_grp", "ttc1_2_grp"};
+static const char * const swdt0_groups[] = {"swdt0_0_grp", "swdt0_1_grp",
+			"swdt0_2_grp", "swdt0_3_grp", "swdt0_4_grp"};
+static const char * const gpio0_groups[] = {"gpio0_0_grp",
+		"gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
+		"gpio0_8_grp", "gpio0_10_grp", "gpio0_12_grp",
+		"gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
+		"gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
+		"gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
+		"gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
+		"gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
+		"gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
+		"gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
+		"gpio0_3_grp", "gpio0_5_grp", "gpio0_7_grp",
+		"gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
+		"gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
+		"gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
+		"gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
+		"gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
+		"gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
+		"gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
+		"gpio0_51_grp", "gpio0_53_grp"};
+
+#define DEFINE_ZYNQ_PINMUX_FUNCTION(fname, mval)	\
+	[ZYNQ_PMUX_##fname] = {				\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.mux_val = mval				\
+	}
+
+#define DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(fname, mval, mux, mask, shift)	\
+	[ZYNQ_PMUX_##fname] = {				\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+		.mux_val = mval,			\
+		.mux_mask = mask,			\
+		.mux_shift = shift			\
+	}
+
+#define ZYNQ_SDIO_WP_SHIFT	0
+#define ZYNQ_SDIO_WP_MASK	(0x3f << ZYNQ_SDIO_WP_SHIFT)
+#define ZYNQ_SDIO_CD_SHIFT	16
+#define ZYNQ_SDIO_CD_MASK	(0x3f << ZYNQ_SDIO_CD_SHIFT)
+
+static const struct zynq_pinmux_function zynq_pmux_functions[] = {
+	DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet0, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet1, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(mdio0, 0x40),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(mdio1, 0x50),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi0, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi1, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_fbclk, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_cs1, 1),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(spi0, 0x50),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(spi1, 0x50),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0, 0x40),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0_pc, 0xc),
+	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_wp, 0, 130, ZYNQ_SDIO_WP_MASK,
+					ZYNQ_SDIO_WP_SHIFT),
+	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_cd, 0, 130, ZYNQ_SDIO_CD_MASK,
+					ZYNQ_SDIO_CD_SHIFT),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1, 0x40),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1_pc, 0xc),
+	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_wp, 0, 134, ZYNQ_SDIO_WP_MASK,
+					ZYNQ_SDIO_WP_SHIFT),
+	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_cd, 0, 134, ZYNQ_SDIO_CD_MASK,
+					ZYNQ_SDIO_CD_SHIFT),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor, 4),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_cs1, 8),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_addr25, 4),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nand, 8),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(can0, 0x10),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(can1, 0x10),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(uart0, 0x70),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(uart1, 0x70),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(i2c0, 0x20),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(i2c1, 0x20),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(ttc0, 0x60),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(ttc1, 0x60),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(swdt0, 0x30),
+	DEFINE_ZYNQ_PINMUX_FUNCTION(gpio0, 0)
+};
+
+
+/* pinctrl */
+static int zynq_pctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctrl->ngroups;
+}
+
+static const char *zynq_pctrl_get_group_name(struct pinctrl_dev *pctldev,
+					     unsigned selector)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctrl->groups[selector].name;
+}
+
+static int zynq_pctrl_get_group_pins(struct pinctrl_dev *pctldev,
+				     unsigned selector,
+				     const unsigned **pins,
+				     unsigned *num_pins)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = pctrl->groups[selector].pins;
+	*num_pins = pctrl->groups[selector].npins;
+
+	return 0;
+}
+
+static const struct pinctrl_ops zynq_pctrl_ops = {
+	.get_groups_count = zynq_pctrl_get_groups_count,
+	.get_group_name = zynq_pctrl_get_group_name,
+	.get_group_pins = zynq_pctrl_get_group_pins,
+	.dt_node_to_map = pinconf_generic_dt_node_to_map_group,
+	.dt_free_map = pinctrl_utils_dt_free_map
+};
+
+/* pinmux */
+static int zynq_pmux_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctrl->nfuncs;
+}
+
+static const char *zynq_pmux_get_function_name(struct pinctrl_dev *pctldev,
+					       unsigned selector)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pctrl->funcs[selector].name;;
+}
+
+static int zynq_pmux_get_function_groups(struct pinctrl_dev *pctldev,
+					 unsigned selector,
+					 const char * const **groups,
+					 unsigned * const num_groups)
+{
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = pctrl->funcs[selector].groups;
+	*num_groups = pctrl->funcs[selector].ngroups;
+	return 0;
+}
+
+static int zynq_pinmux_enable(struct pinctrl_dev *pctldev,
+			      unsigned function,
+			      unsigned group)
+{
+	int i;
+	unsigned long flags;
+	struct zynq_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+	const struct zynq_pctrl_group *pgrp = &pctrl->groups[group];
+	const struct zynq_pinmux_function *func = &pctrl->funcs[function];
+
+	spin_lock_irqsave(&pctrl->lock, flags);
+
+	/*
+	 * SD WP & CD are special. They have dedicated registers
+	 * to mux them in
+	 */
+	if (function == ZYNQ_PMUX_sdio0_cd || function == ZYNQ_PMUX_sdio0_wp ||
+			function == ZYNQ_PMUX_sdio1_cd ||
+			function == ZYNQ_PMUX_sdio1_wp) {
+		u32 reg = readl(pctrl->regs + func->mux);
+		reg &= ~func->mux_mask;
+		reg |= pgrp->pins[0] << func->mux_shift;
+		writel(reg, pctrl->regs + func->mux);
+	} else {
+		for (i = 0; i < pgrp->npins; i++) {
+			unsigned int pin = pgrp->pins[i];
+			void __iomem *addr = pctrl->regs + (4 * pin);
+			u32 reg = readl(addr);
+			reg &= ~ZYNQ_PINMUX_MUX_MASK;
+			reg |= func->mux_val << ZYNQ_PINMUX_MUX_SHIFT;
+			writel(reg, addr);
+		}
+	}
+
+	spin_unlock_irqrestore(&pctrl->lock, flags);
+
+	return 0;
+}
+
+static const struct pinmux_ops zynq_pinmux_ops = {
+	.get_functions_count = zynq_pmux_get_functions_count,
+	.get_function_name = zynq_pmux_get_function_name,
+	.get_function_groups = zynq_pmux_get_function_groups,
+	.enable = zynq_pinmux_enable,
+};
+
+static struct pinctrl_desc zynq_desc = {
+	.name = "zynq_pinctrl",
+	.pins = zynq_pins,
+	.npins = ARRAY_SIZE(zynq_pins),
+	.pctlops = &zynq_pctrl_ops,
+	.pmxops = &zynq_pinmux_ops,
+	//const struct pinconf_ops *confops;
+	.owner = THIS_MODULE,
+};
+
+static int zynq_pinctrl_probe(struct platform_device *pdev)
+
+{
+	struct resource *res;
+	struct device_node *slcr;
+	struct zynq_pinctrl *pctrl;
+
+	pctrl = devm_kzalloc(&pdev->dev, sizeof(*pctrl), GFP_KERNEL);
+	if (!pctrl)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	slcr = of_get_parent(pdev->dev.of_node);
+	if (slcr->data) {
+		pctrl->regs = (__force void __iomem *)slcr->data + res->start;
+	} else {
+		dev_err(&pdev->dev, "Unable to get I/O memory\n");
+		of_node_put(slcr);
+		return -ENOMEM;
+	}
+
+	pctrl->groups = zynq_pctrl_groups;
+	pctrl->ngroups = ARRAY_SIZE(zynq_pctrl_groups);
+	pctrl->funcs = zynq_pmux_functions;
+	pctrl->nfuncs = ARRAY_SIZE(zynq_pmux_functions);
+	spin_lock_init(&pctrl->lock);
+
+	pctrl->pctrl = pinctrl_register(&zynq_desc, &pdev->dev, pctrl);
+	if (!pctrl->pctrl)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, pctrl);
+
+	dev_info(&pdev->dev, "zynq pinctrl@%p\n", pctrl->regs);
+
+	return 0;
+}
+
+int zynq_pinctrl_remove(struct platform_device *pdev)
+{
+	struct zynq_pinctrl *pctrl = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(pctrl->pctrl);
+
+	return 0;
+}
+
+static const struct of_device_id zynq_pinctrl_of_match[] = {
+	{ .compatible = "xlnx,pinctrl-zynq" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, zynq_pinctrl_of_match);
+
+static struct platform_driver zynq_pinctrl_driver = {
+	.driver = {
+		.name = "zynq-pinctrl",
+		.of_match_table = zynq_pinctrl_of_match,
+	},
+	.probe = zynq_pinctrl_probe,
+	.remove = zynq_pinctrl_remove,
+};
+
+module_platform_driver(zynq_pinctrl_driver);
+
+MODULE_AUTHOR("Sören Brinkmann <soren.brinkmann@xilinx.com>");
+MODULE_DESCRIPTION("Xilinx Zynq pinctrl driver");
+MODULE_LICENSE("GPL");
-- 
2.1.0.1.g27b9230

