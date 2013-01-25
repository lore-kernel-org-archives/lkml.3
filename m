Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3AYIQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:16:30 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:47499 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3AYIQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:16:27 -0500
MIME-Version: 1.0
In-Reply-To: <1358889025-8530-3-git-send-email-gregory.clement@free-electrons.com>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
	<1358889025-8530-3-git-send-email-gregory.clement@free-electrons.com>
Date: Fri, 25 Jan 2013 09:16:27 +0100
Message-ID: <CACRpkda-N0GrKOeaz4Hji0ef9pSRNPCxW_jLGR28iX-sk0-=tg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] gpio: pca953x: add support for pca9505
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:10 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> Now that pca953x driver can handle GPIO expanders with more than 32
> bits this patch adds the support for the pca9505 which cam with 40
> GPIOs.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Patch applied, thanks.

But guys, this driver contains some horrific stuff, look at this:

static int pxa_gpio_nums(void)
{
        int count = 0;

#ifdef CONFIG_ARCH_PXA
        if (cpu_is_pxa25x()) {
#ifdef CONFIG_CPU_PXA26x
                count = 89;
                gpio_type = PXA26X_GPIO;
#elif defined(CONFIG_PXA25x)
                count = 84;
                gpio_type = PXA26X_GPIO;
#endif /* CONFIG_CPU_PXA26x */
        } else if (cpu_is_pxa27x()) {
                count = 120;
                gpio_type = PXA27X_GPIO;
        } else if (cpu_is_pxa93x()) {
                count = 191;
                gpio_type = PXA93X_GPIO;
        } else if (cpu_is_pxa3xx()) {
                count = 127;
                gpio_type = PXA3XX_GPIO;
        }
#endif /* CONFIG_ARCH_PXA */

#ifdef CONFIG_ARCH_MMP
        if (cpu_is_pxa168() || cpu_is_pxa910()) {
                count = 127;
                gpio_type = MMP_GPIO;
        } else if (cpu_is_mmp2()) {
                count = 191;
                gpio_type = MMP_GPIO;
        }
#endif /* CONFIG_ARCH_MMP */
        return count;
}

This is totally killing all attempts at a single kernel for multiple
machines in this family. The above should not be #ifdef's but instead
use either platform data or the compatible property to figure out which
one to use.

It's fine to introduce new compatible= strings or device names to
distinguish between these.

As an example, in pinctrl-nomadik.c we have this:

static const struct of_device_id nmk_pinctrl_match[] = {
        {
                .compatible = "stericsson,nmk_pinctrl",
                .data = (void *)PINCTRL_NMK_DB8500,
        },
        {},
};

static const struct platform_device_id nmk_pinctrl_id[] = {
        { "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
        { "pinctrl-db8500", PINCTRL_NMK_DB8500 },
        { "pinctrl-db8540", PINCTRL_NMK_DB8540 },
        { }
};

static struct platform_driver nmk_pinctrl_driver = {
        .driver = {
                .owner = THIS_MODULE,
                .name = "pinctrl-nomadik",
                .of_match_table = nmk_pinctrl_match,
        },
        .probe = nmk_pinctrl_probe,
        .id_table = nmk_pinctrl_id,
};


The first match is for DT boot the latter for using the platform
device name directly.

Then in the probefunction we do:

static int nmk_pinctrl_probe(struct platform_device *pdev)
{
        const struct platform_device_id *platid = platform_get_device_id(pdev);
(...)
        if (platid)
                version = platid->driver_data;
        else if (np) {
                const struct of_device_id *match;

                match = of_match_device(nmk_pinctrl_match, &pdev->dev);
                if (!match)
                        return -ENODEV;
                version = (unsigned int) match->data;
        }
(...)
        if (version == PINCTRL_NMK_STN8815)
                nmk_pinctrl_stn8815_init(&npct->soc);
        if (version == PINCTRL_NMK_DB8500)
                nmk_pinctrl_db8500_init(&npct->soc);
        if (version == PINCTRL_NMK_DB8540)
                nmk_pinctrl_db8540_init(&npct->soc);
}

Surely a scheme like this must be possible to use to distinguish between
the different versions at runtime rather than using these #ifdefs?

Yours,
Linus Walleij
