Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178AbaCSO70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:59:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:49306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878AbaCSO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:59:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Dinh Nguyen <dinguyen@altera.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, arm@kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: stmmac-socfpga breakage in arm-soc
Date: Wed, 19 Mar 2014 15:58:47 +0100
Message-ID: <29079107.ja9Hu9mMY0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5329AAE1.7030705@gmail.com>
References: <201403191333.01095.arnd@arndb.de> <4337501.shzGE38xmF@wuerfel> <5329AAE1.7030705@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bb+YYmA82bNwFCuQJwuL2DP41XNkup2W12aF8EfUX6p
 hMjdQQvIH6BB+c0T8x+7B82K1ExaDuI73x47/zlVYIZn8fhId8
 NwdeMRw2OLoQLdpyJ8+eZcLA1fpyJRrlBapgmnHJPb6JJkRRwN
 GchQV0HPPMLD3oHiKUY2GnTdSUs7RfIlDoxJY5u4ZJlBBeuN4N
 XFZ1FhWEAjezmlG4zvwNTqUtQRjC7ALQVsw2z1fE9pMI8hBAZC
 pg3BDIiZ1IjdSN5Vqm48b3Tt4qAxiMpl2CKVEkb8VBaUJs5iMU
 Qn7xqHB7LfMzZ/QxM86NRetDpLVCpQUv9LQeklTiHmCZPqZ/X5
 iM/csdqaprCSBU+v4dm0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2014 09:34:09 Dinh Nguyen wrote:
> 
> diff --git a/arch/arm/boot/dts/socfpga.dtsi 
> b/arch/arm/boot/dts/socfpga.dtsi
> index 5f1e256..953801c 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -456,8 +456,10 @@
>                          altr,sysmgr-syscon = <&sysmgr 0x60>;
>                          reg = <0xff700000 0x2000>;
>                          interrupts = <0 115 4>;
> +                       interrupt-names = "macirq";
>                          mac-address = [00 00 00 00 00 00];/* Filled in 
> by U-Boot */
>                          clocks = <&emac0_clk>;
> +                       clock-names = "stmmaceth";
>                  };

Ah, I see. I missed the "macirq" name in the binding, but the clock name
must be documented in the binding first. I see that it is present in
Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt, but
not in any of the other bindings. The driver however prints out a warning
if it's not present.

I've added this part to my patch now.


	Arnd

diff --git a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
index ec216e0..f7aa231 100644
--- a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
@@ -20,6 +20,8 @@ gmac0: ethernet@ff700000 {
 	status = "disabled";
 	reg = <0xff700000 0x2000>;
 	interrupts = <0 115 4>;
+	interrupt-names = "macirq";
 	mac-address = [00 00 00 00 00 00];/* Filled in by U-Boot */
 	clocks = <&emac0_clk>;
+	clocks-names = ""stmmaceth";
 };
diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
index 5748351..19d5648 100644
--- a/Documentation/devicetree/bindings/net/stmmac.txt
+++ b/Documentation/devicetree/bindings/net/stmmac.txt
@@ -31,6 +31,10 @@ Optional properties:
 - reset-names: Should contain the reset signal name "stmmaceth", if a
 	reset phandle is given
 - max-frame-size: See ethernet.txt file in the same directory
+- clocks: If present, the first clock should be the GMAC main clock,
+  further clocks may be specified in derived bindings
+- clock-names: One name for each entry in the clocks property, the
+  first one should be "stmmaceth".
 
 Examples:
 
@@ -43,4 +47,6 @@ Examples:
 		mac-address = [000000000000]; /* Filled in by U-Boot */
 		max-frame-size = <3800>;
 		phy-mode = "gmii";
+		clocks = <&clock>;
+		clock-names = "stmmaceth">
 	};
diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 1595712..982649e 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -457,8 +457,10 @@
 			altr,sysmgr-syscon = <&sysmgr 0x60>;
 			reg = <0xff700000 0x2000>;
 			interrupts = <0 115 4>;
+			interrupt-names = "macirq";
 			mac-address = [00 00 00 00 00 00];/* Filled in by U-Boot */
 			clocks = <&emac0_clk>;
+			clock-names = "stmmaceth";
 		};
 
 		gmac1: ethernet@ff702000 {
@@ -467,8 +469,10 @@
 			altr,sysmgr-syscon = <&sysmgr 0x60>;
 			reg = <0xff702000 0x2000>;
 			interrupts = <0 120 4>;
+			interrupt-names = "macirq";
 			mac-address = [00 00 00 00 00 00];/* Filled in by U-Boot */
 			clocks = <&emac1_clk>;
+			clock-names = "stmmaceth";
 		};
 
 		L2: l2-cache@fffef000 {

