Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3G2OlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:41:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48424 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751074Ab3G2OlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:41:20 -0400
Date: Mon, 29 Jul 2013 11:41:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 4/5] ARM: dove: relocate internal registers device nodes
Message-ID: <20130729144124.GC2417@localhost>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1375101114-28858-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375101114-28858-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Mon, Jul 29, 2013 at 02:31:53PM +0200, Sebastian Hesselbarth wrote:
> With mbus node in place, now relocate all internal device nodes
> to internal-regs node with proper address ranges.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove.dtsi |  955 +++++++++++++++++++++----------------------
>  1 file changed, 474 insertions(+), 481 deletions(-)
> 

I think you might do this in a slightly different way, and achieve a
less intrusive patch (fwiw, i personally try to avoid intrusive changes).

Maybe it's just a matter of taste, so it's up to you to decide
Anyway, here's my proposal:

----------------------------8<----------------------------------------
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index db9ae00..0fbc30e 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -5,6 +5,7 @@
 / {
 	compatible = "marvell,dove";
 	model = "Marvell Armada 88AP510 SoC";
+	interrupt-parent = <&intc>;
 
 	aliases {
 		gpio0 = &gpio0;
@@ -41,22 +42,17 @@
 			  MBUS_ID(0x01, 0xfd) 0 0xf8000000 0x8000000   /* BootROM  128M */
 			  MBUS_ID(0x03, 0x01) 0 0xc8000000 0x0100000   /* CESA SRAM  1M */
 			  MBUS_ID(0x0d, 0x00) 0 0xf0000000 0x0100000>; /* PMU  SRAM  1M */
-	};
+};
 
-	soc@f1000000 {
+mbus {
+	internal-regs {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		interrupt-parent = <&intc>;
-
-		ranges = <0xc8000000 0xc8000000 0x0100000   /* CESA SRAM   1M */
-		          0xe0000000 0xe0000000 0x8000000   /* PCIe0 Mem 128M */
-		          0xe8000000 0xe8000000 0x8000000   /* PCIe1 Mem 128M */
-		          0xf0000000 0xf0000000 0x0100000   /* ScratchPad  1M */
-		          0x00000000 0xf1000000 0x1000000   /* SB/NB regs 16M */
-		          0xf2000000 0xf2000000 0x0100000   /* PCIe0 I/O   1M */
-		          0xf2100000 0xf2100000 0x0100000   /* PCIe0 I/O   1M */
-		          0xf8000000 0xf8000000 0x8000000>; /* BootROM   128M */
+		ranges = <0x00000000 MBUS_ID(0xf0, 0x01) 0 0x0100000   /* MBUS regs  1M */
+			  0x00800000 MBUS_ID(0xf0, 0x02) 0 0x1000000   /* AXI  regs 16M */
+			  0xffffe000 MBUS_ID(0x03, 0x01) 0 0x0000800   /* CESA SRAM  2k */
+			  0xfffff000 MBUS_ID(0x0d, 0x00) 0 0x0000800>; /* PMU  SRAM  2k */
 
 		mbusc: mbus-ctrl@20000 {
 			compatible = "marvell,mbus-controller";
@@ -443,7 +439,7 @@
 		crypto: crypto-engine@30000 {
 			compatible = "marvell,orion-crypto";
 			reg = <0x30000 0x10000>,
-			      <0xc8000000 0x800>;
+			      <0xffffe000 0x800>;
 			reg-names = "regs", "sram";
 			interrupts = <31>;
 			clocks = <&gate_clk 15>;
@@ -465,7 +461,6 @@
 
 			channel1 {
 				interrupts = <40>;
-				dmacap,memset;
 				dmacap,memcpy;
 				dmacap,xor;
 			};
@@ -486,7 +481,6 @@
 
 			channel1 {
 				interrupts = <43>;
-				dmacap,memset;
 				dmacap,memcpy;
 				dmacap,xor;
 			};
----------------------------------->8-----------------------------------

It has a much nicer diffstat:

 arch/arm/boot/dts/dove.dtsi | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

And in addition, it allows to see some (maybe unrelated?) changes
other than the node-relocation.

I've seen these kind of things in (e.g.) omap3-igep0020.dts, and it
seems to me it could be a cleaner way of doing this relocation.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
