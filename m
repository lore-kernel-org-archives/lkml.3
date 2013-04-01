Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3DAEen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:34:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18225 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3DAEel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:34:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 31 Mar 2013 21:34:03 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Date: Mon, 1 Apr 2013 10:04:37 +0530
Subject: RE: [PATCH] pinctrl: tegra: add suspend-resume support
Thread-Topic: [PATCH] pinctrl: tegra: add suspend-resume support
Thread-Index: Ac4r3IefXW53D4edRWq5o4SEpCLe/wCsp2Gw
Message-ID: <77F7DB30C698A44DA22FB222C89DE941A668585708@BGMAIL01.nvidia.com>
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
 <5154827B.8010701@wwwdotorg.org>
In-Reply-To: <5154827B.8010701@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

My response inline.

Regards
Bibek


-----Original Message-----
From: Stephen Warren [mailto:swarren@wwwdotorg.org] 
Sent: Thursday, March 28, 2013 11:19 PM
To: Bibek Basu
Cc: Linus Walleij; linux-kernel@vger.kernel.org; Pritesh Raithatha
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support

On 03/28/2013 11:11 AM, Bibek Basu wrote:
> From: Pritesh Raithatha <praithatha@nvidia.com>
> 
> This patch adds suspend and resume callbacks to the pinctrl-tegra driver.
> 
> Based on work by:
> Pritesh Raithatha <praithatha@nvidia.com>

Those two lines are somewhat implied by the fact the commit's git author field is Pritesh, and his s-o-b line is included below.
[BB]: Will get rid of the above lines.

> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> Signed-off-by: Bibek Basu <bbasu@nvidia.com>

> diff --git a/drivers/pinctrl/pinctrl-tegra.c 
> b/drivers/pinctrl/pinctrl-tegra.c

> +static struct tegra_pmx *pmx;

Isn't there any way to pass data into the suspend/resume functions so that this global isn't needed?

Why can't we just use the device suspend/resume functions rather than global (syscore) suspend/resume functions? Presumably this is to ensure that all other drivers suspend first, then the pinctrl driver does, and the reverse for resume. Can't we rely on deferred probe to ensure that instead?

To make that work, we might need every affected driver to define a dummy pinmux state in DT that references the pinctrl driver, to make sure they all get probed after the pinctrl driver.
[BB]: Before I add dummy pinmux state in DT of affected driver, I would like to know the following:
    1> The usage of syscore api needs  global data. So, are you suggesting that syscore APIs are not appropriate to be used or syscore implementation is not proper?
    2> Adding dummy DT states may give scope for BUGS. Reason being there must be someone checking that every time some new driver refrences pinmux driver, should put a dummy entry in device tree. Isnt it more time costing   then having "static struct tegra_pmx *pmx;"?

> +#ifdef CONFIG_PM_SLEEP

Perhaps we can remove the ifdefs, and always compile this code. The compiler should remove any unused functions from the final linked image.
[BB]: Will do

>  int tegra_pinctrl_probe(struct platform_device *pdev,
>  			const struct tegra_pinctrl_soc_data *soc_data) -{
> -	struct tegra_pmx *pmx;
> +	{

The indentation of the { is wrong there.
[BB]: Will fix

> +#ifdef CONFIG_PM_SLEEP

I think you can use if (IS_ENABLED(CONFIG_PM_SLEEP)) here instead of an ifdef. This will allow the code to be compiled in all cases (to allow better compile coverage), but it will be optimized out if CONFIG_PM_SLEEP isn't enabled. Can you please make that change, and verify that it works?
[BB]: Will do.

The same comment applies to the other ifdefs below.
