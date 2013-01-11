Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AKXKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:10:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44148 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3AKXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:10:04 -0500
Message-ID: <50F09BC7.90607@wwwdotorg.org>
Date: Fri, 11 Jan 2013 16:09:59 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357911185-11048-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
> Enable tegra based keyboard controller and populate the key matrix for
> seaboard. The key matrix was originally on driver code which is removed
> to have clean driver. The key mapping is now passed through dts file.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Requesting for testing on seaboard.
> I generated this patch as Stephen suggested to have one patch for dt file
> entry for keys on seaboard.

To some extent this works; at least this patch series is probably almost
OK, but there are a bunch of issues in the KBC driver obviously:

This series won't work on its own with the current Tegra for-next
content, because:

a) The clock driver doesn't provide any KBC clock for Tegra20, either in
the old Tegra clock driver, or the first conversion to the common clock
framework, nor the most recent complete conversion to the common clock
framework. Was the driver tested at all on the upstream kernel? I
suppose it's just possible it was tested on Tegra30, although see below...

This brings up the point that the clk_get() call in the KBC driver is
probably wrong. At least with Prashant's latest common clock framework
patches applied, clk_get() returns NULL, not an error pointer for a
non-existent clock. As such, the following driver code succeeds:

> 	kbc->clk = clk_get(&pdev->dev, NULL);
> 	if (IS_ERR(kbc->clk)) {
> 		dev_err(&pdev->dev, "failed to get keyboard clock\n");
> 		err = PTR_ERR(kbc->clk);
> 		goto err_iounmap;
> 	}

Should that check be if (!kbc-clk) instead? Or does the common clock
framework require if (IS_ERR_OR_NULL(kbc->clk)); hopefully not since
IS_ERR_OR_NULL shouldn't be used any more.

This then causes the later call to tegra_periph_reset_{de,}assert() to
crash since it generates a bogus pointer from the NULL pointer and
dereferences it. I assume similar things happen before Prashant's latest
clock patches.

Oh, and the KBC clock is marked TEGRA_PERIPH_NO_RESET for Tegra30, and
also for Tegra20 in the ChromeOS kernel; why is the driver trying to
assert reset on a clock that doesn't support it?

I hacked around this by adding the following to clk-tegra20.c on top of
Prashant's latest patches:

> 	/* kbc */
> 	clk = tegra_clk_periph_gate("kbc", "clk_32k", TEGRA_PERIPH_NO_RESET |
> 				    TEGRA_PERIPH_ON_APB, clk_base, 0,
> 				    36, &periph_h_regs, periph_clk_enb_refcnt);
> 	clk_register_clkdev(clk, NULL, "tegra-kbc");
> 	clks[kbc] = clk;
> 

b) There is no AUXDATA in the board file, nor clocks properties in the
.dts files, in this series to actually hook the KBC driver up to be able
to get the correct clock. This leads me to suspect the driver was never
tested upstream on either Tegra20 /or/ Tegra30.

I hacked around this by applying the following:

> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 8e97825..9ca5e94 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -400,6 +400,7 @@
>                 reg = <0x7000e200 0x100>;
>                 interrupts = <0 85 0x04>;
>                 status = "disabled";
> +               clocks = <&tegra_car 36>;
>         };
>  
>         pmc {
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> index 9dca3e4..e580045 100644
> --- a/arch/arm/boot/dts/tegra30.dtsi
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -417,6 +417,7 @@
>                 reg = <0x7000e200 0x100>;
>                 interrupts = <0 85 0x04>;
>                 status = "disabled";
> +               clocks = <&tegra_car 36>;
>         };
>  
>         pmc {

I guess I can fold that fix into this series when I apply it, after
Prashant's clock patches are merged.

Once I hacked around the above issues, the driver doesn't work very well
at all. There is a *long* delay between when I press a key and when it
shows up (e.g. echo'd to the HDMI console). When I release the key the
same keypress is generated twice. Or perhaps it's a repeat, but since
it's *always* 2 extra keypresses and I doubt I always hold my finger on
the key the exact same amount of time, I think it's key release that
does this not repeat. I assume this would repro on any board, so you
won't need Seaboard to debug it. Harmony is able to read the keyboard
using the KBC.

Even with the above, I was able to validate that the keymap in the
Seaboard .dts file looks reasonable.

However, please fix the KBC driver...
