Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3EHQhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:37:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54666 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3EHQg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:36:59 -0400
Message-ID: <518A7F26.3030605@wwwdotorg.org>
Date: Wed, 08 May 2013 10:36:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        ldewangan@nvidia.com, bhelgaas@google.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH 1/4] ARM: tegra30: clocks: Fix pciex clock registration
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:57 AM, Jay Agarwal wrote:
> Registering pciex as peripheral clock instead of fixed clock
> as tegra_perih_reset_assert(deassert) api of this clock api 
> gives warning and ultimately does not succeed to assert(deassert).

A few procedural comments: I believe this is at least the second version
of these patches that have been posted. As such, the email subject
should say e.e. "PATCH V2" not just "PATCH". You can pass
--subject-prefix='PATCH V2' to git format-patch to achieve this.

Since this is an updated version of the patches, each patch should
describe what changed in the patch, so that people know what issues
you've fixed in this version. Most people believe that the description
of changes should be below the --- line, so that it doesn't get included
in the commit description when the patch is applied.

> Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
> and should be applied on top of this.

Those two lines should be below the --- line so that they don't get
included in the commit description when the patch is applied. git
metadata will provide clues re: who applied the patch and to which
branch, so there's no need to duplicate this information in the commit
description itself, but rather include it below --- so that it's still
present and people can see it.

Some comments on the patch and series below...

> diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c

> +	/* pciex */
> +	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
> +				    74, &periph_u_regs, periph_clk_enb_refcnt);
> +	clk_register_clkdev(clk, "pciex", NULL);
> +	clks[pciex] = clk;

Hmmm. This change perhaps isn't technically correct, but is the best we
can do for now, so it's fine. It's also consistent with how the Tegra20
clock driver is written.

This clock has a "reset" bit in the CLK_RST_* registers, but not an
"enable" bit in the CLK_ENB_* registers. Hence, representing this as a
gated clock isn't correct, since there is not gate control in HW. The
correct way to handle this would be to implement the new reset
controller API for Tegra, and expose the reset control only, and not
touch the clock registration at all. However, we do this exact same
thing for a number of Tegra clocks right now, hence I think this change
is fine for now; we'll clean this up, along with some other instances of
the same issue, once the reset API is implemented for Tegra. Of course,
if that happens before the PCI code is checked in, then my opinion will
change.

> @@ -1930,7 +1931,6 @@ static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
>  	TEGRA_CLK_DUPLICATE(bsea, "nvavp", "bsea"),
>  	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
>  	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
> -	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),

That seems like an unrelated change, and isn't mentioned in the commit
description. Is the change strictly necessary? Is it cleanup that can
happen as a separate patch later in the series? Aren't you able to
remove the CLK_DUPLICATE() entries for other PCIe-related clocks too?
