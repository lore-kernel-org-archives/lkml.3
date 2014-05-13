Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaEMMVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:21:02 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37961 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbaEMMVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:21:00 -0400
Date: Tue, 13 May 2014 13:20:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 1/2] clk: of: helper for determining flags properties
Message-ID: <20140513122054.GA2419@e106331-lin.cambridge.arm.com>
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
 <1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org>
Thread-Topic: [PATCH 1/2] clk: of: helper for determining flags properties
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:57:32PM +0100, Gabriel FERNANDEZ wrote:
> The patch provides a helper to get flags properties of
> a clock node.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  drivers/clk/clk.c            | 11 +++++++++++
>  include/linux/clk-provider.h |  6 ++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 4d56220..cae8985 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2528,6 +2528,17 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>  }
>  EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>  
> +unsigned long of_clk_get_flags(struct device_node *np)
> +{
> +	unsigned long flags = 0;
> +
> +	if (of_property_read_bool(np, "set-rate-parent"))
> +		flags |= CLK_SET_RATE_PARENT;

NAK.

This is _not_ a hardware property. This flag describes internals of the
Linux clock framework, and is thus not suitable for DT.

You've also failed to document the property.

What are you trying to achieve here, and why do you think this is the
best way of achieving that?

Cheers,
Mark.

> +
> +	return flags;
> +}
> +EXPORT_SYMBOL_GPL(of_clk_get_flags);
> +
>  struct clock_provider {
>  	of_clk_init_cb_t clk_init_cb;
>  	struct device_node *np;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 59e2eb5..650bc10 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -519,6 +519,7 @@ int of_clk_get_parent_count(struct device_node *np);
>  const char *of_clk_get_parent_name(struct device_node *np, int index);
>  
>  void of_clk_init(const struct of_device_id *matches);
> +unsigned long of_clk_get_flags(struct device_node *np);
>  
>  #else /* !CONFIG_OF */
>  
> @@ -546,6 +547,11 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
>  {
>  	return NULL;
>  }
> +static inline unsigned long of_clk_get_flags(struct device_node *np)
> +{
> +	return NULL;
> +}
> +
>  #define of_clk_init(matches) \
>  	{ while (0); }
>  #endif /* CONFIG_OF */
> -- 
> 1.9.1
> 
> 
