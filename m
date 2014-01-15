Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaAOO11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:27:27 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34718 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaAOO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:27:24 -0500
MIME-Version: 1.0
In-Reply-To: <1389711141-21090-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
	<1389711141-21090-1-git-send-email-srinivas.kandagatla@st.com>
Date: Wed, 15 Jan 2014 15:27:24 +0100
Message-ID: <CACRpkdbFGOm2xm5H+of_NuJ6DVmBDcEODZbDxVU8nGC-RU64Tw@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] pinctrl: st: Add software edge trigger interrupt support.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 3:52 PM,  <srinivas.kandagatla@st.com> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> ST pin controller does not have hardware support for detecting edge
> triggered interrupts, It only has level triggering support.
> This patch attempts to fake up edge triggers from hw level trigger
> support in software. With this facility now the gpios can be easily used
> for keypads, otherwise it would be difficult for drivers like keypads to
> work with level trigger interrupts.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Clever! Mostly I like the patch as it is but:

>         for_each_set_bit(n, &port_active, BITS_PER_LONG) {
> +               /* check if we are detecting fake edges ... */
> +               pin_edge_cfg = ST_IRQ_EDGE_CONF(bank_edge_mask, n);
> +
> +               if (pin_edge_cfg) {
> +                       /* edge detection. */
> +                       val = st_gpio_get(&bank->gpio_chip, n);
> +                       if (val)
> +                               writel(BIT(n), bank->base + REG_PIO_SET_PCOMP);
> +                       else
> +                               writel(BIT(n), bank->base + REG_PIO_CLR_PCOMP);
> +
> +                       if (pin_edge_cfg != ST_IRQ_EDGE_BOTH &&
> +                               !((pin_edge_cfg & ST_IRQ_EDGE_FALLING) ^ val))
> +                                       continue;
> +               }
> +

Please insert comments here to explain what you are actually doing
because I sure as hell do not understand this code without comments
describing the trick used.

Yours,
Linus Walleij
