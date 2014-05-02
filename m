Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaEBI41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:56:27 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39332 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaEBI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <1398334403-26181-4-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
Date: Fri, 2 May 2014 10:56:23 +0200
Message-ID: <CAPDyKFpTwPDu9afhOjhhQ2PKGFB+hWsp=mcaYTq8OvuGF7yT3Q@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Geert,

Some more review comments.

> +
> +
> +#ifdef CONFIG_PM_RUNTIME
> +
> +static int of_clk_pm_runtime_suspend(struct device *dev)
> +{
> +       int ret;
> +
> +       ret = pm_generic_runtime_suspend(dev);
> +       if (ret)
> +               return ret;
> +
> +       ret = pm_clk_suspend(dev);

What about slow clocks? Those aren't handled with pm_clk_suspend().

> +       if (ret) {
> +               pm_generic_runtime_resume(dev);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int of_clk_pm_runtime_resume(struct device *dev)
> +{
> +       pm_clk_resume(dev);

What about slow clocks? Those aren't handled with pm_clk_resume().

> +       return pm_generic_runtime_resume(dev);
> +}
> +
> +static struct dev_pm_domain of_clk_pm_domain = {
> +       .ops = {
> +               .runtime_suspend = of_clk_pm_runtime_suspend,
> +               .runtime_resume = of_clk_pm_runtime_resume,

Drivers/subsystems may invoke pm_runtime_force_suspend|resume() from
some of their system PM callbacks, which requires the runtime PM
callbacks to be defined for CONFIG_PM instead of CONFIG_PM_RUNTIME, I
believe that should be changed here as well.

> +               USE_PLATFORM_PM_SLEEP_OPS

What about other buses beside the platfrom bus. Certainly we need to
handle devices attached to any other subsystem type as well.

Kind regards
Ulf Hansson
