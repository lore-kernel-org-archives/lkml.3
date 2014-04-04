Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaDDPaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:30:20 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53101 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaDDPaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <1396577891-2713-3-git-send-email-elder@linaro.org>
References: <1396577891-2713-1-git-send-email-elder@linaro.org>
	<1396577891-2713-3-git-send-email-elder@linaro.org>
Date: Fri, 4 Apr 2014 08:30:16 -0700
Message-ID: <CAAYSxhqOh4F=vSDJYUwFE85og-Tgc9Hi8c79biEZYYjb8z1Qkg@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: add SMP support for Broadcom mobile SoCs
From: Tim Kryger <tim.kryger@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, sboyd@codeaurora.org,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 7:18 PM, Alex Elder <elder@linaro.org> wrote:

> diff --git a/arch/arm/mach-bcm/platsmp.c b/arch/arm/mach-bcm/platsmp.c
> new file mode 100644
> index 0000000..46a64f2
> --- /dev/null
> +++ b/arch/arm/mach-bcm/platsmp.c

> +/* Size of mapped Cortex A9 SCU address space */
> +#define SCU_SIZE               0x58

> +/*
> + * Enable the Cortex A9 Snoop Control Unit
> + *
> + * By the time this is called we already know there are multiple
> + * cores present.  We assume we're running on a Cortex A9 processor,
> + * so any trouble getting the base address register or getting the
> + * SCU base is a problem.
> + *
> + * Return 0 if successful or an error code otherwise.
> + */
> +static int __init scu_a9_enable(void)
> +{
> +       unsigned long config_base;
> +       void __iomem *scu_base;
> +
> +       if (!scu_a9_has_base()) {
> +               pr_err("no configuration base address register!\n");
> +               return -ENXIO;
> +       }
> +
> +       /* Config base address register value is zero for uniprocessor */
> +       config_base = scu_a9_get_base();
> +       if (!config_base) {
> +               pr_err("hardware reports only one core; disabling SMP\n");
> +               return -ENOENT;
> +       }
> +
> +       scu_base = ioremap((phys_addr_t)config_base, SCU_SIZE);
> +       if (!scu_base) {
> +               pr_err("failed to remap config base (%lu/%u) for SCU\n",
> +                       config_base, SCU_SIZE);
> +               return -ENOMEM;
> +       }
> +
> +       scu_enable(scu_base);
> +
> +       iounmap(scu_base);      /* That's the last we'll need of this */
> +
> +       return 0;
> +}

This function seems useful for Cortex A9 MPCore in general.

While you gave it a generic name, you put it in a Broadcom file.

Is there a better location for this code?
