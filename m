Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3JWKO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:14:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49202 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3JWKO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:14:57 -0400
Message-ID: <5267A185.7030607@ti.com>
Date: Wed, 23 Oct 2013 13:14:29 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] Revert "ARM: OMAP2+: Provide alias to USB PHY
 clock"
References: <1381226799-29158-1-git-send-email-rogerq@ti.com> <1381226799-29158-6-git-send-email-rogerq@ti.com> <52550180.1000506@ti.com> <20131009151522.GA8313@atomide.com> <5256703F.1070806@ti.com> <20131022151659.GO15154@atomide.com>
In-Reply-To: <20131022151659.GO15154@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 06:17 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [131010 02:23]:
>> On 10/09/2013 06:15 PM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [131009 00:19]:
>>>> Hi Tony,
>>>>
>>>> On 10/08/2013 01:06 PM, Roger Quadros wrote:
>>>>> This reverts commit 741532c4a995be11815cb72d4d7a48f442a22fea.
>>>>>
>>>>> The proper clock reference is provided in device tree so we
>>>>> no longer need this.
>>>>
>>>> Could you please Ack this one? I think it is best if it goes through Benoit's tree.
>>>
>>> I could queue this into my board removal series that will be
>>> based on Benoit's branch if that works for you. And this
>>> also seems to depend on the omap-for-v3.13/quirk branch
>>> that moves all the legacy pdata handling into pdata-quirks.c.
>>
>> OK Tony. Thanks.
> 
> Actually, can you please update this patch against branch
> omap-for-v3.13/board-removal-take2 and check the
> omap5_uevm_legacy_init() part as well?

Updated patch is below. Note that this must go in only after Benoit has picked
up Tero's clock series and the dts patches in this series.
If needed, you can wait and I can send you a reminder when that happens. Thanks.

>From ab81199d5b9c487c8493e6aa1d8b4bf17c0c5110 Mon Sep 17 00:00:00 2001
From: Roger Quadros <rogerq@ti.com>
Date: Wed, 23 Oct 2013 12:58:59 +0300
Subject: [PATCH] ARM: OMAP2+: Get rid of legacy_init_ehci_clk()

The proper clock reference is provided in device tree so we
no longer need this.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/pdata-quirks.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 10c7145..22537ed 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -26,20 +26,6 @@ struct pdata_init {
 	void (*fn)(void);
 };
 
-/*
- * Create alias for USB host PHY clock.
- * Remove this when clock phandle can be provided via DT
- */
-static void __init __used legacy_init_ehci_clk(char *clkname)
-{
-	int ret;
-
-	ret = clk_add_alias("main_clk", NULL, clkname, NULL);
-	if (ret)
-		pr_err("%s:Failed to add main_clk alias to %s :%d\n",
-		       __func__, clkname, ret);
-}
-
 #if IS_ENABLED(CONFIG_WL12XX)
 
 static struct wl12xx_platform_data wl12xx __initdata;
@@ -105,18 +91,10 @@ static void __init omap4_sdp_legacy_init(void)
 static void __init omap4_panda_legacy_init(void)
 {
 	omap4_panda_display_init_of();
-	legacy_init_ehci_clk("auxclk3_ck");
 	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 53);
 }
 #endif
 
-#ifdef CONFIG_SOC_OMAP5
-static void __init omap5_uevm_legacy_init(void)
-{
-	legacy_init_ehci_clk("auxclk1_ck");
-}
-#endif
-
 static struct pcs_pdata pcs_pdata;
 
 void omap_pcs_legacy_init(int irq, void (*rearm)(void))
@@ -149,9 +127,6 @@ static struct pdata_init pdata_quirks[] __initdata = {
 	{ "ti,omap4-sdp", omap4_sdp_legacy_init, },
 	{ "ti,omap4-panda", omap4_panda_legacy_init, },
 #endif
-#ifdef CONFIG_SOC_OMAP5
-	{ "ti,omap5-uevm", omap5_uevm_legacy_init, },
-#endif
 	{ /* sentinel */ },
 };
 
-- 
1.8.3.2


