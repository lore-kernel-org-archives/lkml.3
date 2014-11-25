Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaKYNhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:37:07 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39711 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaKYNhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:37:05 -0500
Message-ID: <547485F5.50600@collabora.co.uk>
Date: Tue, 25 Nov 2014 14:36:53 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com> <54736AD0.4070909@collabora.co.uk> <1416907375.5023.54.camel@AMDC1943>
In-Reply-To: <1416907375.5023.54.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/25/2014 10:22 AM, Krzysztof Kozlowski wrote:
> 
> Hmmm, that's strange. I've looked again at your dmesg and it is little
> different than mine (when system fails).
> 1. Does your PMIC come up? In your dmesg:
> [    2.687297] max77802-pmic max77802-pmic: regulator init failed for 0
> [    2.693539] platform max77802-pmic: Driver max77802-pmic requests probe deferral
>

The Peach Pit/Pi DTS define the parent input supplies for the max77802 PMIC
regulators and these are regulators from the tps65090 PMU but the max77802
is probed before. When the system does not fail, the probe is deferred and
succeed later but I don't know when the system fails (more on that below).
 
> 2. In my case booting fails just after disabling unused clocks which is
> quite early, my dmesg:
> [   11.700074] input: gpio_keys as /devices/platform/gpio_keys/input/input0
> [   11.704282] s3c-rtc 101e0000.rtc: setting system clock to 2029-01-11 19:19:17 UTC (1862853557)
> [   11.770602] mmcblk0: mmc0:0001 M8G1WA 7.28 GiB
> [   11.776201] mmcblk0boot0: mmc0:0001 M8G1WA partition 1 2.00 MiB
> [   11.780968] mmcblk0boot1: mmc0:0001 M8G1WA partition 2 2.00 MiB
> [   11.786823] mmcblk0rpmb: mmc0:0001 M8G1WA partition 3 128 KiB
> [   11.793815]  mmcblk0: p1 p2 p3 p4
> [   11.824165] PVDD_G3D_1V0: disabling
> [   11.830833] PVDD_G3DS_1V0: disabling
> [   11.837771] PVDD_HSIC_1V8: disabling
> [   11.841172] PVDD_ABB_1V8: disabling
> [   11.844866] PVDD_ANAIP_1V8: disabling
> [   11.847157] usb 5-1.4: new high-speed USB device number 3 using exynos-ehci
> [   11.848778] PVDD
> 
> In your case you have a gap here:
> [    3.624142] platform 12d10000.adc: Driver exynos-adc requests probe deferral
> [   24.188722] random: nonblocking pool is initialized
>
> Could you try my patches once again but this time with enabled:
> DEBUG_EXYNOS_UART
> EARLY_PRINTK
> DEBUG_S3C_UART3
> DEBUG_LL
>

Yes, there is a gap and I don't know why. Even after enabling all those
config options, nothing is printed on the serial console after the exynos-adc
probe deferral. Only that message in drivers/char/random.c is printed but
nothing else is printed after all...

> and with following change:
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 4896ae9e23da..316856e55784 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -478,7 +478,9 @@ static void clk_disable_unused_subtree(struct clk *clk)
>          * sequence.  call .disable_unused if available, otherwise fall
>          * back to .disable
>          */
> +       pr_err("clk: checking %s\n", clk->name);
>         if (__clk_is_enabled(clk)) {
> +               pr_err("clk: enabled %s, disabling\n", clk->name);
>                 if (clk->ops->disable_unused)
>                         clk->ops->disable_unused(clk->hw);
>                 else if (clk->ops->disable)
> 
> Without my patch the boot hangs:
> [   12.230666] clk: checking dout_unipro
> [   12.234304] clk: checking mout_unipro
> [   12.237913] clk: checking sclk_usbd300
> [   12.241638] clk: enabled sclk_usbd300, disabling
> [   12.246264] clk: checking dout_usbd300
> [   12.249992] clk: checking sclk_usbd301
> [   12.253683] clk: enabled sclk_usbd301, disabling
> [   12.258309] clk: checking dout_usbd301
> [   12.262007] clk: checking sclk_maudio0
> [   12.265728] clk: enabled sclk_maudio0, disabling
> [   12.270355] clk: checking pcm_bus
> 
> because audss seems to be gated so kernel cannot access status of
> pcm_bus clock.
>

I added those printk's but clk_disable_unused() is executed after the
exynos-adc probe function so the logs are not shown on the serial console.

As mentioned previously in the thread, Tushar's fix [0] works for me and with
that patch I see the clocks disabled by clk_disable_unused_subtree() and the
kernel is able to access pcm_bus and other audio clocks:

[    5.007368] clk: checking mout_spdif
[    5.010908] clk: checking dout_audio0
[    5.014566] clk: checking mout_audio0
[    5.018208] clk: checking sclk_maudio0
[    5.021926] clk: enabled sclk_maudio0, disabling
[    5.026541] clk: checking pcm_bus
[    5.029820] clk: enabled pcm_bus, disabling
[    5.034001] clk: checking sclk_pcm
[    5.037367] clk: enabled sclk_pcm, disabling

Any ideas?

Best regards,
Javier

[0]: http://www.spinics.net/lists/arm-kernel/msg337970.html
