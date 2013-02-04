Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3BDLwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:52:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3BDLwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:52:00 -0500
Message-ID: <510FA09F.7030604@ti.com>
Date: Mon, 4 Feb 2013 17:20:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <hs@denx.de>
Subject: Re: [PATCH 2/2] ARM: davinci: da850: add wdt OF_DEV_AUXDATA entry
References: <1359016695-10362-1-git-send-email-anilkumar.v@ti.com> <1359016695-10362-3-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1359016695-10362-3-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anil,

On 1/24/2013 2:08 PM, Kumar, Anil wrote:
> Add OF_DEV_AUXDATA for wdt driver in da850 board dt
> file to use wdt clock.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> :100644 100644 37c27af... 1b295d2... M	arch/arm/mach-davinci/da8xx-dt.c
>  arch/arm/mach-davinci/da8xx-dt.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index 37c27af..1b295d2 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -37,11 +37,17 @@ static void __init da8xx_init_irq(void)
>  	of_irq_init(da8xx_irq_match);
>  }
>  
> +struct of_dev_auxdata da850_evm_auxdata_lookup[] __initdata = {

Auxdata is not evm specific. This can instead be called da850_auxdata_lookup[].

Also, I dont think it is necessary to add auxdata in a separate patch 
from dt nodes. So, I fixed these issues and came up with below patch. I 
tested basic wdt reboot. reboot command is still broken (with or 
without this patch). Can you please look at that?

Thanks,
Sekhar

----8<----
From: "Kumar, Anil" <anilkumar.v@ti.com>
Date: Thu, 24 Jan 2013 14:08:14 +0530
Subject: [PATCH 1/1] ARM: davinci: da850: add wdt DT node

Add da850 wdt DT node.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts  |    3 +++
 arch/arm/boot/dts/da850.dtsi     |    5 +++++
 arch/arm/mach-davinci/da8xx-dt.c |    8 +++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index fa04152..cc777dc 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -30,6 +30,9 @@
 		rtc0: rtc@1c23000 {
 			status = "okay";
 		};
+		wdt: wdt@1c21000 {
+			status = "okay";
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 8dd15c0..2800090 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -88,6 +88,11 @@
 				      19>;
 			status = "disabled";
 		};
+		wdt: wdt@1c21000 {
+			compatible = "ti,davinci-wdt";
+			reg = <0x21000 0xfff>;
+			status = "disabled";
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 37c27af..90c3c69 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -37,11 +37,17 @@ static void __init da8xx_init_irq(void)
 	of_irq_init(da8xx_irq_match);
 }
 
+struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
+	{}
+};
+
 #ifdef CONFIG_ARCH_DAVINCI_DA850
 
 static void __init da850_init_machine(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     da850_auxdata_lookup, NULL);
 
 	da8xx_uart_clk_enable();
 }

