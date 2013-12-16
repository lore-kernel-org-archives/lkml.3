Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3LPNBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:01:32 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:45392 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3LPNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:01:31 -0500
Message-ID: <1387198885.13062.154.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Mon, 16 Dec 2013 17:01:25 +0400
In-Reply-To: <201312150355.27755.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312150153.54044.arnd@arndb.de>
	 <1387073571.13062.102.camel@host5.omatika.ru>
	 <201312150355.27755.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-15 at 03:55 +0100, Arnd Bergmann wrote:
> On Sunday 15 December 2013, Sergei Ianovich wrote:
> ...
> I think the way you have structured your code is good, and an MFD would
> not help. Please just restructure the DT representation to contain the
> external-bus and/or the fpga connected to it. You probably don't need both,
> but it doesn't hurt to show them as different device-nodes either.
> Your choice.

PXA27x memory bus can have up to 10 devices: up to 6 slower
flash/SRAM/variable-latency-IO selected by nCS<0> to <5>, and up to 4
partions of SDRAM selected by nSDCS<0> to <3>.

It appears that the FPGA is directly connected to the memory bus and is
selected by nCS<5>. According to MSC2 configuration (already in the
mainstream U-Boot), the FPGA is configured as a synchronous SRAM with
access cycle of 30x memory bus cycles. So I made it a top-level bus like
pxabus.

Ethernet devices are also connected to the memory bus via some kind of
gate array. This one is a bit faster -- 15x memory cycles, which is
still a lot. It explains why network transfers are never faster than 15
Mbit/s.

The final tree looks like this:

diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
new file mode 100644
index 0000000..cb2a31d
--- /dev/null
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -0,0 +1,208 @@
+/* Device tree for ICP DAS LP-8x4x */
+/dts-v1/;
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include "pxa27x.dtsi"
+
+/ {
+	model = "ICP DAS LP-8x4x programmable automation controller";
+	compatible = "marvell,lp8x4x", "marvell,pxa270";
+
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+	};
+
+	memory {
+		/*
+		 * SDRAM
+		 * connected to CPU via nSDCS<0>
+		 */
+		reg = <0xa0000000 0x08000000>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vmmc: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "vmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+
+	flash@00000000 {
+		/*
+		 * Boot memory
+		 * connected to CPU via nCS<0>
+		 */
+		compatible = "cfi-flash";
+		reg = <0x0 0x02000000>;
+		bank-width = <4>;
+		device-width = <2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		fs@0 {
+			label = "u-boot";
+			reg = <0 0x40000>;
+		};
+		fs@40000 {
+			label = "settings";
+			reg = <0x40000 0x40000>;
+		};
+		fs@80000 {
+			label = "kernel";
+			reg = <0x80000 0x280000>;
+		};
+		fs@300000 {
+			label = "root_fs";
+			reg = <0x300000 0x1d00000>;
+		};
+	};
+
+	flash@04000000 {
+		/*
+		 * connected to CPU via nCS<1>
+		 */
+		compatible = "cfi-flash";
+		reg = <0x04000000 0x02000000>;
+		bank-width = <2>;
+		device-width = <1>;
+	};
+
+	pxabus {
+		pxairq: interrupt-controller@40d00000 {
+			marvell,intc-priority;
+			marvell,intc-nr-irqs = <34>;
+		};
+
+		uart@40100000 {
+			status = "okay";
+		};
+
+		uart@40200000 {
+			status = "okay";
+		};
+
+		uart@40700000 {
+			status = "okay";
+		};
+
+		mmc@41100000 {
+			status = "okay";
+			vmmc-supply = <&vmmc>;
+		};
+
+		ohci@4c000000 {
+			status = "okay";
+			marvell,port-mode = <3>;
+			marvell,oc-mode-perport;
+			marvell,enable-port1;
+		};
+	};
+
+	extbus {
+		/*
+		 * Transparent bus, 2 byte-wide access
+		 * connected to CPU via nCS<3>
+		 */
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		interrupt-parent = <&gpio>;
+
+		eth0: eth@0c000000 {
+			compatible = "davicom,dm9000";
+			reg = <0x0c000000 0x2
+			       0x0c004000 0x2>;
+			interrupts = <9 IRQ_TYPE_EDGE_RISING>;
+			status = "okay";
+		};
+
+		eth1: eth@0d000000 {
+			compatible = "davicom,dm9000";
+			reg = <0x0d000000 0x2
+			       0x0d004000 0x2>;
+			interrupts = <82 IRQ_TYPE_EDGE_RISING>;
+			status = "okay";
+		};
+	};
+
+	fpgabus {
+		/*
+		 * Transparent bus, 1 byte-wide access, even addresses only
+		 * connected to CPU via nCS<5>
+		 */
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x17000000 0x10000>;
+		interrupt-parent = <&fpga>;
+
+		rtc@901c {
+			compatible = "ds,rtc-ds1302";
+			reg = <0x901c 0x1>;
+			status = "okay";
+		};
+
+		sram@a000 {
+			compatible = "icpdas,sram-lp8x4x";
+			reg = <0xa000 0x1000
+			       0x901e 0x1>;
+		};
+
+		fpga: irq@9006 {
+			compatible = "icpdas,irq-lp8x4x";
+			reg = <0x9006 0x16>;
+			interrupt-parent = <&gpio>;
+			interrupts = <3 IRQ_TYPE_EDGE_FALLING>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
+			status = "okay";
+		};
+
+		uart@9050 {
+			compatible = "icpdas,uart-lp8x4x";
+			reg = <0x9050 0x10
+			       0x9030 0x02>;
+			interrupts = <13>;
+			status = "okay";
+		};
+
+		uart@9060 {
+			compatible = "icpdas,uart-lp8x4x";
+			reg = <0x9060 0x10
+			       0x9032 0x02>;
+			interrupts = <14>;
+			status = "okay";
+		};
+
+		uart@9070 {
+			compatible = "icpdas,uart-lp8x4x";
+			reg = <0x9070 0x10
+			       0x9034 0x02>;
+			interrupts = <15>;
+			status = "okay";
+		};
+
+		backplane@9046 {
+			compatible = "icpdas,backplane-lp8x4x";
+			reg = <0x9046 0x2
+			       0x9004 0x2
+			       0x1000 0x10
+			       0x2000 0x10
+			       0x3000 0x10
+			       0x4000 0x10
+			       0x5000 0x10
+			       0x6000 0x10
+			       0x7000 0x10
+			       0x8000 0x10>;
+		};
+	};
+};



