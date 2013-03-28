Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3C1Rsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:48:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49835 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3C1Rsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:48:46 -0400
Message-ID: <5154827B.8010701@wwwdotorg.org>
Date: Thu, 28 Mar 2013 11:48:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bibek Basu <bbasu@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Pritesh Raithatha <praithatha@nvidia.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
In-Reply-To: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 11:11 AM, Bibek Basu wrote:
> From: Pritesh Raithatha <praithatha@nvidia.com>
> 
> This patch adds suspend and resume callbacks to the pinctrl-tegra driver.
> 
> Based on work by:
> Pritesh Raithatha <praithatha@nvidia.com>

Those two lines are somewhat implied by the fact the commit's git author
field is Pritesh, and his s-o-b line is included below.

> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> Signed-off-by: Bibek Basu <bbasu@nvidia.com>

> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c

> +static struct tegra_pmx *pmx;

Isn't there any way to pass data into the suspend/resume functions so
that this global isn't needed?

Why can't we just use the device suspend/resume functions rather than
global (syscore) suspend/resume functions? Presumably this is to ensure
that all other drivers suspend first, then the pinctrl driver does, and
the reverse for resume. Can't we rely on deferred probe to ensure that
instead?

To make that work, we might need every affected driver to define a dummy
pinmux state in DT that references the pinctrl driver, to make sure they
all get probed after the pinctrl driver.

> +#ifdef CONFIG_PM_SLEEP

Perhaps we can remove the ifdefs, and always compile this code. The
compiler should remove any unused functions from the final linked image.

>  int tegra_pinctrl_probe(struct platform_device *pdev,
>  			const struct tegra_pinctrl_soc_data *soc_data)
> -{
> -	struct tegra_pmx *pmx;
> +	{

The indentation of the { is wrong there.

> +#ifdef CONFIG_PM_SLEEP

I think you can use if (IS_ENABLED(CONFIG_PM_SLEEP)) here instead of an
ifdef. This will allow the code to be compiled in all cases (to allow
better compile coverage), but it will be optimized out if
CONFIG_PM_SLEEP isn't enabled. Can you please make that change, and
verify that it works?

The same comment applies to the other ifdefs below.
