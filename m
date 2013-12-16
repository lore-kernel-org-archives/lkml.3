Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3LPJsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:48:09 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50106 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3LPJsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:48:06 -0500
MIME-Version: 1.0
In-Reply-To: <1387150085-23173-7-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
	<1387150085-23173-7-git-send-email-sre@debian.org>
Date: Mon, 16 Dec 2013 10:48:06 +0100
Message-ID: <CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com>
Subject: Re: [RFCv4 06/11] misc: Introduce Nokia CMT driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 12:27 AM, Sebastian Reichel <sre@debian.org> wrote:

> Add driver handling GPIO pins of Nokia modems. The
> driver provides reset notifications, so that SSI
> clients can subscribe to them easily.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>

If the driver provides reset notifications, should it rather be
in drivers/reset?

I'm thinking of a generic GPIO reset driver with a generic
notification mechanism, which seems to be what this is.

I.e. it doesn't look device-specific at all, just like some
generic glue code that could be useful to many such
scenarios.

> +config NOKIA_CMT
> +       tristate "Enable CMT support"
> +       help
> +       If you say Y here, you will enable CMT support.
> +
> +       If unsure, say Y, or else you will not be able to use the CMT.

None of this explains what this driver actually does and what
CMT means, so please rewrite this a bit to be more helpful.
The way it is written it could as well say "enable FOO support".

> +++ b/drivers/misc/nokia-cmt.c
> @@ -0,0 +1,298 @@
> +/*
> + * CMT support.

So CMT = ...?

> +/**
> + * struct cmt_device - CMT device data
> + * @cmt_rst_ind_tasklet: Bottom half for CMT reset line events
> + * @cmt_rst_ind_irq: IRQ number of the CMT reset line
> + * @n_head: List of notifiers registered to get CMT events
> + * @node: Link on the list of available CMTs
> + * @device: Reference to the CMT platform device
> + */
> +struct cmt_device {
> +       struct tasklet_struct           cmt_rst_ind_tasklet;
> +       unsigned int                    cmt_rst_ind_irq;
> +       struct atomic_notifier_head     n_head;
> +       struct list_head                node;
> +       struct device                   *device;
> +       struct cmt_gpio                 *gpios;
> +       int                             gpio_amount;
> +};

The kerneldoc and and the struct are not in sync. Look
this over.

> +static LIST_HEAD(cmt_list);    /* List of CMT devices */
(...)
> +struct cmt_device *cmt_get(const char *name)
> +{
> +       struct cmt_device *p, *cmt = ERR_PTR(-ENODEV);
> +
> +       list_for_each_entry(p, &cmt_list, node)
> +               if (strcmp(name, dev_name(p->device)) == 0) {
> +                       cmt = p;
> +                       break;
> +               }
> +
> +       return cmt;
> +}
> +EXPORT_SYMBOL_GPL(cmt_get);

Is this driver used on non-DT platforms, or can we skip this
struct device * referencing altogether?

I would feel better if this driver looked more like
drivers/mfd/syscon.c

> +static irqreturn_t cmt_rst_ind_isr(int irq, void *cmtdev)
> +{
> +       struct cmt_device *cmt = (struct cmt_device *)cmtdev;
> +
> +       tasklet_schedule(&cmt->cmt_rst_ind_tasklet);
> +
> +       return IRQ_HANDLED;
> +}

Why are you using a tasklet rather than a work
for this?

Yours,
Linus Walleij
