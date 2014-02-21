Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaBUGkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:40:14 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:18007 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbaBUGkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:40:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkEALbyBlOl5H4JgWdsb2JhbABZhklSvUKBJA4BARYmKIImAQUaAQgECwFGEAgdAiYCAlcZiAWreqFDF4EpjG1JBQeCb4FJBIhbhWaJc5VoKA
From: Alistair Popple <alistair@popple.id.au>
To: benh@kernel.crashing.org
Cc: Alistair Popple <alistair@popple.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: =?UTF-8?q?=5BPATCH=206/7=5D=20IBM=20Akebono=3A=20Add=20the=20Akebono=20platform?=
Date: Fri, 21 Feb 2014 17:31:32 +1100
Message-Id: <1392964293-13687-7-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the IBM Akebono board.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 .../devicetree/bindings/powerpc/4xx/akebono.txt    |   54 +++
 arch/powerpc/boot/Makefile                         |    3 +
 arch/powerpc/boot/dcr.h                            |    4 +
 arch/powerpc/boot/dts/akebono.dts                  |  385 ++++++++++++++++++++
 arch/powerpc/boot/treeboot-akebono.c               |  178 +++++++++
 arch/powerpc/boot/wrapper                          |    3 +
 arch/powerpc/configs/44x/akebono_defconfig         |  148 ++++++++
 arch/powerpc/platforms/44x/Kconfig                 |   26 ++
 arch/powerpc/platforms/44x/Makefile                |    1 +
 arch/powerpc/platforms/44x/ppc476.c                |  112 ++++--
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   13 +-
 11 files changed, 901 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/akebono.txt
 create mode 100644 arch/powerpc/boot/dts/akebono.dts
 create mode 100644 arch/powerpc/boot/treeboot-akebono.c
 create mode 100644 arch/powerpc/configs/44x/akebono_defconfig

diff --git a/Documentation/devicetree/bindings/powerpc/4xx/akebono.txt b/Documentation/devicetree/bindings/powerpc/4xx/akebono.txt
new file mode 100644
index 0000000..75adb84
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/akebono.txt
@@ -0,0 +1,54 @@
+
+IBM Akebono board device tree
+=============================
+
+The IBM Akebono board is a development board for the PPC476GTR SoC.
+
+0) The root node
+
+   Required properties:
+
+   - model : "ibm,akebono".
+   - compatible : "ibm,akebono" , "ibm,476gtr".
+
+1.a) The Secure Digital Host Controller Interface (SDHCI) node
+
+  Represent the Secure Digital Host Controller Interfaces.
+
+  Required properties:
+
+   - compatible : should be "ibm,476gtr-sdhci","sdhci".
+   - reg : should contain the SDHCI registers location and length.
+   - interrupt-parent : a phandle for the interrupt controller.
+   - interrupts : should contain the SDHCI interrupt.
+
+1.b) The Advanced Host Controller Interface (AHCI) SATA node
+
+  Represents the advanced host controller SATA interface.
+
+  Required properties:
+
+   - compatible : should be "ibm,476gtr-ahci".
+   - reg : should contain the AHCI registers location and length.
+   - interrupt-parent : a phandle for the interrupt controller.
+   - interrupts : should contain the AHCI interrupt.
+
+1.c) The FPGA node
+
+  The Akebono board stores some board information such as the revision
+  number in an FPGA which is represented by this node.
+
+  Required properties:
+
+   - compatible : should be "ibm,akebono-fpga".
+   - reg : should contain the FPGA registers location and length.
+
+1.d) The AVR node
+
+  The Akebono board has an Atmel AVR microprocessor attached to the I2C
+  bus as a power controller for the board.
+
+  Required properties:
+
+   - compatible : should be "ibm,akebono-avr".
+   - reg : should contain the I2C bus address for the AVR.
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index ca7f08c..dd77cca 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -47,6 +47,7 @@ $(obj)/cuboot-acadia.o: BOOTCFLAGS += -mcpu=405
 $(obj)/treeboot-walnut.o: BOOTCFLAGS += -mcpu=405
 $(obj)/treeboot-iss4xx.o: BOOTCFLAGS += -mcpu=405
 $(obj)/treeboot-currituck.o: BOOTCFLAGS += -mcpu=405
+$(obj)/treeboot-akebono.o: BOOTCFLAGS += -mcpu=405
 $(obj)/virtex405-head.o: BOOTAFLAGS += -mcpu=405
 
 
@@ -86,6 +87,7 @@ src-plat-$(CONFIG_44x) += treeboot-ebony.c cuboot-ebony.c treeboot-bamboo.c \
 				cuboot-taishan.c cuboot-katmai.c \
 				cuboot-warp.c cuboot-yosemite.c \
 				treeboot-iss4xx.c treeboot-currituck.c \
+				treeboot-akebono.c \
 				simpleboot.c fixed-head.S virtex.c
 src-plat-$(CONFIG_8xx) += cuboot-8xx.c fixed-head.S ep88xc.c redboot-8xx.c
 src-plat-$(CONFIG_PPC_MPC52xx) += cuboot-52xx.c
@@ -236,6 +238,7 @@ image-$(CONFIG_YOSEMITE)		+= cuImage.yosemite
 image-$(CONFIG_ISS4xx)			+= treeImage.iss4xx \
 					   treeImage.iss4xx-mpic
 image-$(CONFIG_CURRITUCK)			+= treeImage.currituck
+image-$(CONFIG_AKEBONO)			+= treeImage.akebono
 
 # Board ports in arch/powerpc/platform/8xx/Kconfig
 image-$(CONFIG_MPC86XADS)		+= cuImage.mpc866ads
diff --git a/arch/powerpc/boot/dcr.h b/arch/powerpc/boot/dcr.h
index cc73f7a..bf8f4ed 100644
--- a/arch/powerpc/boot/dcr.h
+++ b/arch/powerpc/boot/dcr.h
@@ -15,6 +15,10 @@
 		asm volatile("mfdcrx %0,%1" : "=r"(rval) : "r"(rn)); \
 		rval; \
 	})
+#define mtdcrx(rn, val) \
+	({	\
+		asm volatile("mtdcrx %0,%1" : : "r"(rn), "r" (val)); \
+	})
 
 /* 440GP/440GX SDRAM controller DCRs */
 #define DCRN_SDRAM0_CFGADDR				0x010
diff --git a/arch/powerpc/boot/dts/akebono.dts b/arch/powerpc/boot/dts/akebono.dts
new file mode 100644
index 0000000..9a21f58
--- /dev/null
+++ b/arch/powerpc/boot/dts/akebono.dts
@@ -0,0 +1,385 @@
+/*
+ * Device Tree Source for IBM Embedded PPC 476 Platform
+ *
+ * Copyright © 2013 Tony Breeds IBM Corporation
+ * Copyright © 2013 Alistair Popple IBM Corporation
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without
+ * any warranty of any kind, whether express or implied.
+ */
+
+/dts-v1/;
+
+/memreserve/ 0x01f00000 0x00100000;	// spin table
+
+/ {
+	#address-cells = <2>;
+	#size-cells = <2>;
+	model = "ibm,akebono";
+	compatible = "ibm,akebono", "ibm,476gtr";
+	dcr-parent = <&{/cpus/cpu@0}>;
+
+	aliases {
+		serial0 = &UART0;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "PowerPC,476";
+			reg = <0>;
+			clock-frequency = <1600000000>; // 1.6 GHz
+			timebase-frequency = <100000000>; // 100Mhz
+			i-cache-line-size = <32>;
+			d-cache-line-size = <32>;
+			i-cache-size = <32768>;
+			d-cache-size = <32768>;
+			dcr-controller;
+			dcr-access-method = "native";
+			status = "ok";
+		};
+		cpu@1 {
+			device_type = "cpu";
+			model = "PowerPC,476";
+			reg = <1>;
+			clock-frequency = <1600000000>; // 1.6 GHz
+			timebase-frequency = <100000000>; // 100Mhz
+			i-cache-line-size = <32>;
+			d-cache-line-size = <32>;
+			i-cache-size = <32768>;
+			d-cache-size = <32768>;
+			dcr-controller;
+			dcr-access-method = "native";
+			status = "disabled";
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x01f00000>;
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x0 0x0 0x0>; // filled in by zImage
+	};
+
+	MPIC: interrupt-controller {
+		compatible = "chrp,open-pic";
+		interrupt-controller;
+		dcr-reg = <0xffc00000 0x00040000>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+		single-cpu-affinity;
+	};
+
+	plb {
+		compatible = "ibm,plb6";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+		clock-frequency = <200000000>; // 200Mhz
+
+		MAL0: mcmal {
+			compatible = "ibm,mcmal-476gtr", "ibm,mcmal2";
+			dcr-reg = <0xc0000000 0x062>;
+			num-tx-chans = <1>;
+			num-rx-chans = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <	/*TXEOB*/ 77 0x4
+					/*RXEOB*/ 78 0x4
+					/*SERR*/  76 0x4
+					/*TXDE*/  79 0x4
+					/*RXDE*/  80 0x4>;
+		};
+
+		SATA0: sata@30000010000 {
+			compatible = "ibm,476gtr-ahci";
+			reg = <0x300 0x00010000 0x0 0x10000>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <93 2>;
+		};
+
+		EHCI0: ehci@30010000000 {
+			compatible = "ibm,476gtr-ehci", "usb-ehci";
+			reg = <0x300 0x10000000 0x0 0x10000>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <85 2>;
+		};
+
+		SD0: sd@30000000000 {
+			compatible = "ibm,476gtr-sdhci", "sdhci";
+			reg = <0x300 0x00000000 0x0 0x10000>;
+			interrupts = <91 2>;
+			interrupt-parent = <&MPIC>;
+		};
+
+		OHCI0: ohci@30010010000 {
+			compatible = "ibm,476gtr-ohci", "usb-ohci";
+			reg = <0x300 0x10010000 0x0 0x10000>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <89 1>;
+			};
+
+		OHCI1: ohci@30010020000 {
+			compatible = "ibm,476gtr-ohci", "usb-ohci";
+			reg = <0x300 0x10020000 0x0 0x10000>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <88 1>;
+			};
+
+		POB0: opb {
+			compatible = "ibm,opb-4xx", "ibm,opb";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			/* Wish there was a nicer way of specifying a full
+			 * 32-bit range
+			 */
+			ranges = <0x00000000 0x0000033f 0x00000000 0x80000000
+				  0x80000000 0x0000033f 0x80000000 0x80000000>;
+			clock-frequency = <100000000>;
+
+			RGMII0: emac-rgmii-wol@50004 {
+				compatible = "ibm,rgmii-wol-476gtr", "ibm,rgmii-wol";
+				reg = <0x50004 0x00000008>;
+				has-mdio;
+			};
+
+			EMAC0: ethernet@30000 {
+				device_type = "network";
+				compatible = "ibm,emac-476gtr", "ibm,emac4sync";
+				interrupt-parent = <&EMAC0>;
+				interrupts = <0x0 0x1>;
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				#size-cells = <0>;
+				interrupt-map = </*Status*/ 0x0 &MPIC 81 0x4
+						 /*Wake*/   0x1 &MPIC 82 0x4>;
+				reg = <0x30000 0x78>;
+
+				/* local-mac-address will normally be added by
+				 * the wrapper. If your device doesn't support
+				 * passing data to the wrapper (in the form
+				 * local-mac-addr=<hwaddr>) then you will need
+				 * to set it manually here. */
+				//local-mac-address = [000000000000];
+
+				mal-device = <&MAL0>;
+				mal-tx-channel = <0>;
+				mal-rx-channel = <0>;
+				cell-index = <0>;
+				max-frame-size = <9000>;
+				rx-fifo-size = <4096>;
+				tx-fifo-size = <2048>;
+				rx-fifo-size-gige = <16384>;
+				phy-mode = "rgmii";
+				phy-map = <0x00000000>;
+				rgmii-wol-device = <&RGMII0>;
+				has-inverted-stacr-oc;
+				has-new-stacr-staopc;
+			};
+
+			UART0: serial@10000 {
+				device_type = "serial";
+				compatible = "ns16750", "ns16550";
+				reg = <0x10000 0x00000008>;
+				virtual-reg = <0xe8010000>;
+				clock-frequency = <1851851>;
+				current-speed = <38400>;
+				interrupt-parent = <&MPIC>;
+				interrupts = <39 2>;
+			};
+
+			IIC0: i2c@00000000 {
+				compatible = "ibm,iic-476gtr", "ibm,iic";
+				reg = <0x0 0x00000020>;
+				interrupt-parent = <&MPIC>;
+				interrupts = <37 2>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				rtc@68 {
+					compatible = "stm,m41t80", "m41st85";
+					reg = <0x68>;
+				};
+			};
+
+			IIC1: i2c@00000100 {
+				compatible = "ibm,iic-476gtr", "ibm,iic";
+				reg = <0x100 0x00000020>;
+				interrupt-parent = <&MPIC>;
+				interrupts = <38 2>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				avr@58 {
+					compatible = "ibm,akebono-avr";
+					reg = <0x58>;
+				};
+			};
+
+			FPGA0: fpga@ebc00000 {
+				compatible = "ibm,akebono-fpga";
+				reg = <0xebc00000 0x8>;
+			};
+		};
+
+		PCIE0: pciex@10100000000 {
+			device_type = "pci";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			compatible = "ibm,plb-pciex-476fpe", "ibm,plb-pciex";
+			primary;
+			port = <0x0>; /* port number */
+			reg = <0x00000101 0x00000000 0x0 0x10000000	       /* Config space access */
+			       0x00000100 0x00000000 0x0 0x00001000>;	/* UTL Registers space access */
+			dcr-reg = <0xc0 0x20>;
+
+//                                pci_space  < pci_addr          > < cpu_addr          > < size       >
+			ranges = <0x02000000 0x00000000 0x80000000 0x00000110 0x80000000 0x0 0x80000000
+			          0x01000000 0x0        0x0        0x00000140 0x0        0x0 0x00010000>;
+
+			/* Inbound starting at 0 to memsize filled in by zImage */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+
+			/* This drives busses 0 to 0xf */
+			bus-range = <0x0 0xf>;
+
+			/* Legacy interrupts (note the weird polarity, the bridge seems
+			 * to invert PCIe legacy interrupts).
+			 * We are de-swizzling here because the numbers are actually for
+			 * port of the root complex virtual P2P bridge. But I want
+			 * to avoid putting a node for it in the tree, so the numbers
+			 * below are basically de-swizzled numbers.
+			 * The real slot is on idsel 0, so the swizzling is 1:1
+			 */
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <
+				0x0 0x0 0x0 0x1 &MPIC 45 0x2 /* int A */
+				0x0 0x0 0x0 0x2 &MPIC 46 0x2 /* int B */
+				0x0 0x0 0x0 0x3 &MPIC 47 0x2 /* int C */
+				0x0 0x0 0x0 0x4 &MPIC 48 0x2 /* int D */>;
+		};
+
+		PCIE1: pciex@20100000000 {
+			device_type = "pci";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			compatible = "ibm,plb-pciex-476fpe", "ibm,plb-pciex";
+			primary;
+			port = <0x1>; /* port number */
+			reg = <0x00000201 0x00000000 0x0 0x10000000	       /* Config space access */
+			       0x00000200 0x00000000 0x0 0x00001000>;	/* UTL Registers space access */
+			dcr-reg = <0x100 0x20>;
+
+//                                pci_space  < pci_addr          > < cpu_addr          > < size       >
+			ranges = <0x02000000 0x00000000 0x80000000 0x00000210 0x80000000 0x0 0x80000000
+			          0x01000000 0x0        0x0        0x00000240 0x0        0x0 0x00010000>;
+
+			/* Inbound starting at 0 to memsize filled in by zImage */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+
+			/* This drives busses 0 to 0xf */
+			bus-range = <0x0 0xf>;
+
+			/* Legacy interrupts (note the weird polarity, the bridge seems
+			 * to invert PCIe legacy interrupts).
+			 * We are de-swizzling here because the numbers are actually for
+			 * port of the root complex virtual P2P bridge. But I want
+			 * to avoid putting a node for it in the tree, so the numbers
+			 * below are basically de-swizzled numbers.
+			 * The real slot is on idsel 0, so the swizzling is 1:1
+			 */
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <
+				0x0 0x0 0x0 0x1 &MPIC 53 0x2 /* int A */
+				0x0 0x0 0x0 0x2 &MPIC 54 0x2 /* int B */
+				0x0 0x0 0x0 0x3 &MPIC 55 0x2 /* int C */
+				0x0 0x0 0x0 0x4 &MPIC 56 0x2 /* int D */>;
+		};
+
+		PCIE2: pciex@18100000000 {
+			device_type = "pci";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			compatible = "ibm,plb-pciex-476fpe", "ibm,plb-pciex";
+			primary;
+			port = <0x2>; /* port number */
+			reg = <0x00000181 0x00000000 0x0 0x10000000	       /* Config space access */
+			       0x00000180 0x00000000 0x0 0x00001000>;	/* UTL Registers space access */
+			dcr-reg = <0xe0 0x20>;
+
+//                                pci_space  < pci_addr          > < cpu_addr          > < size       >
+			ranges = <0x02000000 0x00000000 0x80000000 0x00000190 0x80000000 0x0 0x80000000
+			          0x01000000 0x0        0x0        0x000001c0 0x0        0x0 0x00010000>;
+
+			/* Inbound starting at 0 to memsize filled in by zImage */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+
+			/* This drives busses 0 to 0xf */
+			bus-range = <0x0 0xf>;
+
+			/* Legacy interrupts (note the weird polarity, the bridge seems
+			 * to invert PCIe legacy interrupts).
+			 * We are de-swizzling here because the numbers are actually for
+			 * port of the root complex virtual P2P bridge. But I want
+			 * to avoid putting a node for it in the tree, so the numbers
+			 * below are basically de-swizzled numbers.
+			 * The real slot is on idsel 0, so the swizzling is 1:1
+			 */
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <
+				0x0 0x0 0x0 0x1 &MPIC 61 0x2 /* int A */
+				0x0 0x0 0x0 0x2 &MPIC 62 0x2 /* int B */
+				0x0 0x0 0x0 0x3 &MPIC 63 0x2 /* int C */
+				0x0 0x0 0x0 0x4 &MPIC 64 0x2 /* int D */>;
+		};
+
+		PCIE3: pciex@28100000000 {
+			device_type = "pci";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			compatible = "ibm,plb-pciex-476fpe", "ibm,plb-pciex";
+			primary;
+			port = <0x3>; /* port number */
+			reg = <0x00000281 0x00000000 0x0 0x10000000	       /* Config space access */
+			       0x00000280 0x00000000 0x0 0x00001000>;	/* UTL Registers space access */
+			dcr-reg = <0x120 0x20>;
+
+//                                pci_space  < pci_addr          > < cpu_addr          > < size       >
+			ranges = <0x02000000 0x00000000 0x80000000 0x00000290 0x80000000 0x0 0x80000000
+			          0x01000000 0x0        0x0        0x000002c0 0x0        0x0 0x00010000>;
+
+			/* Inbound starting at 0 to memsize filled in by zImage */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+
+			/* This drives busses 0 to 0xf */
+			bus-range = <0x0 0xf>;
+
+			/* Legacy interrupts (note the weird polarity, the bridge seems
+			 * to invert PCIe legacy interrupts).
+			 * We are de-swizzling here because the numbers are actually for
+			 * port of the root complex virtual P2P bridge. But I want
+			 * to avoid putting a node for it in the tree, so the numbers
+			 * below are basically de-swizzled numbers.
+			 * The real slot is on idsel 0, so the swizzling is 1:1
+			 */
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <
+				0x0 0x0 0x0 0x1 &MPIC 69 0x2 /* int A */
+				0x0 0x0 0x0 0x2 &MPIC 70 0x2 /* int B */
+				0x0 0x0 0x0 0x3 &MPIC 71 0x2 /* int C */
+				0x0 0x0 0x0 0x4 &MPIC 72 0x2 /* int D */>;
+		};
+	};
+
+	chosen {
+		linux,stdout-path = &UART0;
+	};
+};
diff --git a/arch/powerpc/boot/treeboot-akebono.c b/arch/powerpc/boot/treeboot-akebono.c
new file mode 100644
index 0000000..d42ef8a
--- /dev/null
+++ b/arch/powerpc/boot/treeboot-akebono.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright © 2013 Tony Breeds IBM Corporation
+ * Copyright © 2013 Alistair Popple IBM Corporation
+ *
+ * Based on earlier code:
+ *   Copyright (C) Paul Mackerras 1997.
+ *
+ *   Matt Porter <mporter@kernel.crashing.org>
+ *   Copyright 2002-2005 MontaVista Software Inc.
+ *
+ *   Eugene Surovegin <eugene.surovegin@zultys.com> or <ebs@ebshome.net>
+ *   Copyright (c) 2003, 2004 Zultys Technologies
+ *
+ *    Copyright 2007 David Gibson, IBM Corporation.
+ *    Copyright 2010 Ben. Herrenschmidt, IBM Corporation.
+ *    Copyright © 2011 David Kleikamp IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <stdarg.h>
+#include <stddef.h>
+#include "types.h"
+#include "elf.h"
+#include "string.h"
+#include "stdlib.h"
+#include "stdio.h"
+#include "page.h"
+#include "ops.h"
+#include "reg.h"
+#include "io.h"
+#include "dcr.h"
+#include "4xx.h"
+#include "44x.h"
+#include "libfdt.h"
+
+BSS_STACK(4096);
+
+#define SPRN_PIR	0x11E	/* Processor Indentification Register */
+#define USERDATA_LEN	256	/* Length of userdata passed in by PIBS */
+#define MAX_RANKS	0x4
+#define DDR3_MR0CF	0x80010011U
+#define CCTL0_MCO2	0x8000080FU
+#define CCTL0_MCO3	0x80000810U
+#define CCTL0_MCO4	0x80000811U
+#define CCTL0_MCO5	0x80000812U
+#define CCTL0_MCO6	0x80000813U
+
+static unsigned long long ibm_akebono_memsize;
+static long long unsigned mac_addr;
+
+static unsigned long long ibm_akebono_detect_memsize(void)
+{
+	u32 reg;
+	unsigned i;
+	unsigned long long memsize = 0;
+
+	for (i = 0; i < MAX_RANKS; i++) {
+		reg = mfdcrx(DDR3_MR0CF + i);
+
+		if (!(reg & 1))
+			continue;
+
+		reg &= 0x0000f000;
+		reg >>= 12;
+		memsize += (0x800000ULL << reg);
+	}
+
+	return memsize;
+}
+
+static void ibm_akebono_fixups(void)
+{
+	void *emac;
+	u32 reg;
+	void *devp = finddevice("/");
+	u32 dma_ranges[7];
+
+	dt_fixup_memory(0x0ULL,  ibm_akebono_memsize);
+
+	while ((devp = find_node_by_devtype(devp, "pci"))) {
+		if (getprop(devp, "dma-ranges", dma_ranges,
+			    sizeof(dma_ranges)) < 0) {
+			printf("%s: Failed to get dma-ranges\r\n", __func__);
+			continue;
+		}
+
+		dma_ranges[5] = ibm_akebono_memsize >> 32;
+		dma_ranges[6] = ibm_akebono_memsize & 0xffffffffUL;
+
+		setprop(devp, "dma-ranges", dma_ranges, sizeof(dma_ranges));
+	}
+
+	/* Fixup the SD timeout frequency */
+	mtdcrx(CCTL0_MCO4, 0x1);
+
+	/* Disable SD high-speed mode (which seems to be broken) */
+	reg = mfdcrx(CCTL0_MCO2) & ~0x2;
+	mtdcrx(CCTL0_MCO2, reg);
+
+	/* Set the MAC address */
+	emac = finddevice("/plb/opb/ethernet");
+	if (emac > 0) {
+		if (mac_addr)
+			setprop(emac, "local-mac-address",
+				((u8 *) &mac_addr) + 2 , 6);
+	}
+}
+
+void platform_init(char *userdata)
+{
+	unsigned long end_of_ram, avail_ram;
+	u32 pir_reg;
+	int node, size;
+	const u32 *timebase;
+	int len, i, userdata_len;
+	char *end;
+
+	userdata[USERDATA_LEN - 1] = '\0';
+	userdata_len = strlen(userdata);
+	for (i = 0; i < userdata_len; i++) {
+		if (strncmp(&userdata[i], "local-mac-addr=", 15) == 0) {
+			if (i > 0 && userdata[i - 1] != ' ') {
+				/* We've only found a substring ending
+				 * with local-mac-addr so this isn't
+				 * our mac address. */
+				continue;
+			}
+
+			mac_addr = strtoull(&userdata[i + 15], &end, 16);
+
+			/* Remove the "local-mac-addr=<...>" from the kernel
+			 * command line, including the tailing space if
+			 * present. */
+			if (*end == ' ')
+				end++;
+
+			len = ((int) end) - ((int) &userdata[i]);
+			memmove(&userdata[i], end,
+				userdata_len - (len + i) + 1);
+			break;
+		}
+	}
+
+	loader_info.cmdline = userdata;
+	loader_info.cmdline_len = 256;
+
+	ibm_akebono_memsize = ibm_akebono_detect_memsize();
+	if (ibm_akebono_memsize >> 32)
+		end_of_ram = ~0UL;
+	else
+		end_of_ram = ibm_akebono_memsize;
+	avail_ram = end_of_ram - (unsigned long)_end;
+
+	simple_alloc_init(_end, avail_ram, 128, 64);
+	platform_ops.fixups = ibm_akebono_fixups;
+	platform_ops.exit = ibm44x_dbcr_reset;
+	pir_reg = mfspr(SPRN_PIR);
+
+	/* Make sure FDT blob is sane */
+	if (fdt_check_header(_dtb_start) != 0)
+		fatal("Invalid device tree blob\n");
+
+	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
+					     "cpu", sizeof("cpu"));
+	if (!node)
+		fatal("Cannot find cpu node\n");
+	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
+	if (timebase && (size == 4))
+		timebase_period_ns = 1000000000 / *timebase;
+
+	fdt_set_boot_cpuid_phys(_dtb_start, pir_reg);
+	fdt_init(_dtb_start);
+
+	serial_console_init();
+}
diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index 2e1af74..5207498 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -257,6 +257,9 @@ gamecube|wii)
 treeboot-currituck)
     link_address='0x1000000'
     ;;
+treeboot-akebono)
+    link_address='0x1000000'
+    ;;
 treeboot-iss4xx-mpic)
     platformo="$object/treeboot-iss4xx.o"
     ;;
diff --git a/arch/powerpc/configs/44x/akebono_defconfig b/arch/powerpc/configs/44x/akebono_defconfig
new file mode 100644
index 0000000..7e2530c
--- /dev/null
+++ b/arch/powerpc/configs/44x/akebono_defconfig
@@ -0,0 +1,148 @@
+CONFIG_44x=y
+CONFIG_SMP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
+CONFIG_RD_XZ=y
+CONFIG_EXPERT=y
+CONFIG_KALLSYMS_ALL=y
+# CONFIG_SLUB_CPU_PARTIAL is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_POWERNV_MSI is not set
+CONFIG_PPC_47x=y
+# CONFIG_EBONY is not set
+CONFIG_AKEBONO=y
+CONFIG_HIGHMEM=y
+CONFIG_HZ_100=y
+CONFIG_IRQ_ALL_CPUS=y
+# CONFIG_COMPACTION is not set
+CONFIG_CMDLINE_BOOL=y
+CONFIG_CMDLINE=""
+# CONFIG_SUSPEND is not set
+CONFIG_PCI_MSI=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_IPV6 is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+CONFIG_CONNECTOR=y
+CONFIG_MTD=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=35000
+# CONFIG_SCSI_PROC_FS is not set
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+# CONFIG_SATA_PMP is not set
+# CONFIG_ATA_SFF is not set
+# CONFIG_NET_VENDOR_3COM is not set
+# CONFIG_NET_VENDOR_ADAPTEC is not set
+# CONFIG_NET_VENDOR_ALTEON is not set
+# CONFIG_NET_VENDOR_AMD is not set
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_VENDOR_ATHEROS is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_BROCADE is not set
+# CONFIG_NET_VENDOR_CHELSIO is not set
+# CONFIG_NET_VENDOR_CISCO is not set
+# CONFIG_NET_VENDOR_DEC is not set
+# CONFIG_NET_VENDOR_DLINK is not set
+# CONFIG_NET_VENDOR_EMULEX is not set
+# CONFIG_NET_VENDOR_EXAR is not set
+# CONFIG_NET_VENDOR_HP is not set
+CONFIG_IBM_EMAC=y
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MELLANOX is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_MYRI is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_NVIDIA is not set
+# CONFIG_NET_VENDOR_OKI is not set
+# CONFIG_NET_VENDOR_QLOGIC is not set
+# CONFIG_NET_VENDOR_REALTEK is not set
+# CONFIG_NET_VENDOR_RDC is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SILAN is not set
+# CONFIG_NET_VENDOR_SIS is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_SUN is not set
+# CONFIG_NET_VENDOR_TEHUTI is not set
+# CONFIG_NET_VENDOR_TI is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+# CONFIG_NET_VENDOR_XILINX is not set
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_MOUSE_PS2 is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+CONFIG_SERIAL_8250=y
+# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_I2C_CHARDEV=y
+# CONFIG_HWMON is not set
+CONFIG_THERMAL=y
+# CONFIG_USB_DEFAULT_PERSIST is not set
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_OHCI_HCD=y
+# CONFIG_USB_OHCI_HCD_PCI is not set
+CONFIG_USB_STORAGE=y
+CONFIG_MMC=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_M41T80=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY_USER is not set
+CONFIG_VFAT_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_CRAMFS=y
+# CONFIG_NETWORK_FILESYSTEMS is not set
+CONFIG_NLS_DEFAULT="n"
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_FS=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DETECT_HUNG_TASK=y
+CONFIG_XMON=y
+CONFIG_XMON_DEFAULT=y
+CONFIG_PPC_EARLY_DEBUG=y
+CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW=0x00010000
+CONFIG_PPC_EARLY_DEBUG_44x_PHYSHIGH=0x33f
+CONFIG_CRYPTO_PCBC=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_SHA1_PPC=y
+CONFIG_CRYPTO_DES=y
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index d6c7506..b734df0 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -199,6 +199,32 @@ config CURRITUCK
 	help
 	  This option enables support for the IBM Currituck (476fpe) evaluation board
 
+config AKEBONO
+	bool "IBM Akebono (476gtr) Support"
+	depends on PPC_47x
+	default n
+	select SWIOTLB
+	select 476FPE
+	select PPC4xx_PCI_EXPRESS
+	select I2C
+	select I2C_IBM_IIC
+	select NETDEVICES
+	select ETHERNET
+	select NET_VENDOR_IBM
+	select IBM_EMAC_EMAC4
+	select IBM_EMAC_RGMII_WOL
+	select USB
+	select USB_OHCI_HCD_PLATFORM
+	select USB_EHCI_HCD_PLATFORM
+	select MMC_SDHCI
+	select MMC_SDHCI_PLTFM
+	select MMC_SDHCI_OF_476GTR
+	select ATA
+	select SATA_AHCI_PLATFORM
+	help
+	  This option enables support for the IBM Akebono (476gtr) evaluation board
+
+
 config ICON
 	bool "Icon"
 	depends on 44x
diff --git a/arch/powerpc/platforms/44x/Makefile b/arch/powerpc/platforms/44x/Makefile
index f896b89..26d35b5 100644
--- a/arch/powerpc/platforms/44x/Makefile
+++ b/arch/powerpc/platforms/44x/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_XILINX_ML510) += virtex_ml510.o
 obj-$(CONFIG_ISS4xx)	+= iss4xx.o
 obj-$(CONFIG_CANYONLANDS)+= canyonlands.o
 obj-$(CONFIG_CURRITUCK)	+= ppc476.o
+obj-$(CONFIG_AKEBONO)	+= ppc476.o
diff --git a/arch/powerpc/platforms/44x/ppc476.c b/arch/powerpc/platforms/44x/ppc476.c
index c6c5a6f..33986c1 100644
--- a/arch/powerpc/platforms/44x/ppc476.c
+++ b/arch/powerpc/platforms/44x/ppc476.c
@@ -1,7 +1,8 @@
 /*
  * PowerPC 476FPE board specific routines
  *
- * Copyright © 2011 Tony Breeds IBM Corporation
+ * Copyright © 2013 Tony Breeds IBM Corporation
+ * Copyright © 2013 Alistair Popple IBM Corporation
  *
  * Based on earlier code:
  *    Matt Porter <mporter@kernel.crashing.org>
@@ -35,6 +36,7 @@
 #include <asm/mmu.h>
 
 #include <linux/pci.h>
+#include <linux/i2c.h>
 
 static struct of_device_id ppc47x_of_bus[] __initdata = {
 	{ .compatible = "ibm,plb4", },
@@ -55,15 +57,69 @@ static void quirk_ppc_currituck_usb_fixup(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(0x1033, 0x0035, quirk_ppc_currituck_usb_fixup);
 
+/* Akebono has an AVR microcontroller attached to the I2C bus
+ * which is used to power off/reset the system. */
+
+/* AVR I2C Commands */
+#define AVR_PWRCTL_CMD (0x26)
+
+/* Flags for the power control I2C commands */
+#define AVR_PWRCTL_PWROFF (0x01)
+#define AVR_PWRCTL_RESET (0x02)
+
+static struct i2c_client *avr_i2c_client;
+static void avr_halt_system(int pwrctl_flags)
+{
+	/* Request the AVR to reset the system */
+	i2c_smbus_write_byte_data(avr_i2c_client,
+				  AVR_PWRCTL_CMD, pwrctl_flags);
+
+	/* Wait for system to be reset */
+	while (1)
+		;
+}
+
+static void avr_power_off_system(void)
+{
+	avr_halt_system(AVR_PWRCTL_PWROFF);
+}
+
+static void avr_reset_system(char *cmd)
+{
+	avr_halt_system(AVR_PWRCTL_RESET);
+}
+
+static int avr_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
+{
+	avr_i2c_client = client;
+	ppc_md.restart = avr_reset_system;
+	ppc_md.power_off = avr_power_off_system;
+	return 0;
+}
+
+static const struct i2c_device_id avr_id[] = {
+	{ "akebono-avr", 0 },
+	{ }
+};
+
+static struct i2c_driver avr_driver = {
+	.driver = {
+		.name = "akebono-avr",
+	},
+	.probe = avr_probe,
+	.id_table = avr_id,
+};
+
 static int __init ppc47x_device_probe(void)
 {
+	i2c_add_driver(&avr_driver);
 	of_platform_bus_probe(NULL, ppc47x_of_bus, NULL);
 
 	return 0;
 }
 machine_device_initcall(ppc47x, ppc47x_device_probe);
 
-/* We can have either UICs or MPICs */
 static void __init ppc47x_init_irq(void)
 {
 	struct device_node *np;
@@ -163,37 +219,30 @@ static void __init ppc47x_setup_arch(void)
 	ppc47x_smp_init();
 }
 
-/*
- * Called very early, MMU is off, device-tree isn't unflattened
- */
-static int __init ppc47x_probe(void)
-{
-	unsigned long root = of_get_flat_dt_root();
-
-	if (!of_flat_dt_is_compatible(root, "ibm,currituck"))
-		return 0;
-
-	return 1;
-}
-
 static int board_rev = -1;
 static int __init ppc47x_get_board_rev(void)
 {
-	u8 fpga_reg0;
-	void *fpga;
-	struct device_node *np;
+	int reg;
+	u8 *fpga;
+	struct device_node *np = NULL;
+
+	if (of_machine_is_compatible("ibm,currituck")) {
+		np = of_find_compatible_node(NULL, NULL, "ibm,currituck-fpga");
+		reg = 0;
+	} else if (of_machine_is_compatible("ibm,akebono")) {
+		np = of_find_compatible_node(NULL, NULL, "ibm,akebono-fpga");
+		reg = 2;
+	}
 
-	np = of_find_compatible_node(NULL, NULL, "ibm,currituck-fpga");
 	if (!np)
 		goto fail;
 
-	fpga = of_iomap(np, 0);
+	fpga = (u8 *) of_iomap(np, 0);
 	of_node_put(np);
 	if (!fpga)
 		goto fail;
 
-	fpga_reg0 = ioread8(fpga);
-	board_rev = fpga_reg0 & 0x03;
+	board_rev = ioread8(fpga + reg) & 0x03;
 	pr_info("%s: Found board revision %d\n", __func__, board_rev);
 	iounmap(fpga);
 	return 0;
@@ -221,13 +270,30 @@ static void ppc47x_pci_irq_fixup(struct pci_dev *dev)
 	}
 }
 
+/*
+ * Called very early, MMU is off, device-tree isn't unflattened
+ */
+static int __init ppc47x_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+
+	if (of_flat_dt_is_compatible(root, "ibm,akebono"))
+		return 1;
+
+	if (of_flat_dt_is_compatible(root, "ibm,currituck")) {
+		ppc_md.pci_irq_fixup = ppc47x_pci_irq_fixup;
+		return 1;
+	}
+
+	return 0;
+}
+
 define_machine(ppc47x) {
 	.name			= "PowerPC 47x",
 	.probe			= ppc47x_probe,
 	.progress		= udbg_progress,
 	.init_IRQ		= ppc47x_init_irq,
 	.setup_arch		= ppc47x_setup_arch,
-	.pci_irq_fixup		= ppc47x_pci_irq_fixup,
 	.restart		= ppc4xx_reset_system,
 	.calibrate_decr		= generic_calibrate_decr,
 };
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 64603a1..54ec1d5 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1440,7 +1440,8 @@ static int __init ppc4xx_pciex_check_core_init(struct device_node *np)
 		ppc4xx_pciex_hwops = &ppc405ex_pcie_hwops;
 #endif
 #ifdef CONFIG_476FPE
-	if (of_device_is_compatible(np, "ibm,plb-pciex-476fpe"))
+	if (of_device_is_compatible(np, "ibm,plb-pciex-476fpe")
+		|| of_device_is_compatible(np, "ibm,plb-pciex-476gtr"))
 		ppc4xx_pciex_hwops = &ppc_476fpe_pcie_hwops;
 #endif
 	if (ppc4xx_pciex_hwops == NULL) {
@@ -1751,7 +1752,10 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
 			dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL,
 				sa | DCRO_PEGPL_460SX_OMR1MSKL_UOT
 					| DCRO_PEGPL_OMRxMSKL_VAL);
-		else if (of_device_is_compatible(port->node, "ibm,plb-pciex-476fpe"))
+		else if (of_device_is_compatible(
+				port->node, "ibm,plb-pciex-476fpe") ||
+			of_device_is_compatible(
+				port->node, "ibm,plb-pciex-476gtr"))
 			dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL,
 				sa | DCRO_PEGPL_476FPE_OMR1MSKL_UOT
 					| DCRO_PEGPL_OMRxMSKL_VAL);
@@ -1881,7 +1885,10 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 			sa |= PCI_BASE_ADDRESS_MEM_PREFETCH;
 
 		if (of_device_is_compatible(port->node, "ibm,plb-pciex-460sx") ||
-		    of_device_is_compatible(port->node, "ibm,plb-pciex-476fpe"))
+		    of_device_is_compatible(
+			    port->node, "ibm,plb-pciex-476fpe") ||
+		    of_device_is_compatible(
+			    port->node, "ibm,plb-pciex-476gtr"))
 			sa |= PCI_BASE_ADDRESS_MEM_TYPE_64;
 
 		out_le32(mbase + PECFG_BAR0HMPA, RES_TO_U32_HIGH(sa));
-- 
1.7.10.4

