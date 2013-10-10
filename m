Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3JJJvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:51:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41686 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JJJvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:51:37 -0400
Message-ID: <1381398676.5293.7.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] reset: Add non CONFIG_RESET_CONTROLLER routines
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        Marek Vasut <marex@denx.de>
Date: Thu, 10 Oct 2013 11:51:16 +0200
In-Reply-To: <1381396475-17848-1-git-send-email-iivanov@mm-sol.com>
References: <1381396475-17848-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

Am Donnerstag, den 10.10.2013, 12:14 +0300 schrieb Ivan T. Ivanov:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Make sure client drivers will still build on systems
> without reset control support.

the stubs should at least return errors, but then this turns a compile
time error into a runtime error for devices that don't work without
being properly reset.

Please also refer to this thread:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/174758.html

regards
Philipp

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Marek Vasut <marex@denx.de>
> ---
>  include/linux/reset.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index 6082247..0df3e30 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -4,6 +4,8 @@
>  struct device;
>  struct reset_control;
>  
> +#if defined(CONFIG_RESET_CONTROLLER)
> +
>  int reset_control_reset(struct reset_control *rstc);
>  int reset_control_assert(struct reset_control *rstc);
>  int reset_control_deassert(struct reset_control *rstc);
> @@ -14,4 +16,46 @@ struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
>  
>  int device_reset(struct device *dev);
>  
> +#else /* !CONFIG_RESET_CONTROLLER */
> +
> +/*
> + * Make sure client drivers will still build on systems without
> + * reset control support.
> + */
> +static inline int reset_control_reset(struct reset_control *rstc)
> +{
> +	return 0;
> +}
> +
> +static inline int reset_control_assert(struct reset_control *rstc)
> +{
> +	return 0;
> +}
> +
> +static inline int reset_control_deassert(struct reset_control *rstc)
> +{
> +	return 0;
> +}
> +
> +static inline struct reset_control *
> +reset_control_get(struct device *dev, const char *id)
> +{
> +	return 0;
> +}
> +
> +static inline void reset_control_put(struct reset_control *rstc){}
> +
> +static inline struct reset_control *
> +devm_reset_control_get(struct device *dev, const char *id)
> +{
> +	return NULL;
> +}
> +
> +static inline int device_reset(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
>  #endif


