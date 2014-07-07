Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaGGMik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:38:40 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40972 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaGGMii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
Date: Mon, 7 Jul 2014 14:38:37 +0200
Message-ID: <CACRpkdYkbdbkO7Jff-mQy1ybiq=HV9fJfgGG8QezvX2iJXoUcQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
From: Linus Walleij <linus.walleij@linaro.org>
To: Houcheng Lin <houcheng@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 3:37 PM, Houcheng Lin <houcheng@gmail.com> wrote:

(...)
> +static DEFINE_MUTEX(deferred_reset_mutex);
> +static LIST_HEAD(deferred_reset_list);
> +
> +struct defer_reset_private {
> +       struct list_head lnode;
> +       struct device_node *node;  /* defer_reset device */

Isn't it better if you get the gpio descriptor(s) in probe() and store that
inside defer_reset_private instead of storing the device_node?

struct gpio_desc *gpiod;

(Then you need not include <linux/of_gpio.h>)

> +};


> +static int gdr_issue_reset_line(
> +       struct device_node *of_node, int index, int val)
> +{
> +       enum of_gpio_flags flags = 0;
> +       struct gpio_desc *gpiod;
> +       gpiod = of_get_named_gpiod_flags(of_node, "reset-gpios", index, &flags);
> +       if (IS_ERR(gpiod))
> +               return -PTR_ERR(gpiod);
> +       gdr_issue_reset_gpio(gpiod, val, flags);

So here just use the gpiod from the private struct instead
of looking it up in the last minute.

> +static int gdr_probe(struct platform_device *pdev_gdr)
> +{
> +       struct list_head *pos, *n;
> +
> +       pr_debug("gpio defer reset probe\n");
> +
> +       mutex_lock(&deferred_reset_mutex);
> +       list_for_each_safe(pos, n, &deferred_reset_list) {
> +               struct defer_reset_private *pdata;
> +               struct platform_device *pdev;
> +               pdata = list_entry(pos, struct defer_reset_private, lnode);
> +               pdev = of_find_device_by_node(pdata->node->parent);

So in this iteration I would get the gpio descriptor for each one using
something like:

pdata->gpiod = gpiod_get_index(&pdev->dev, ...);

Yours,
Linus Walleij
