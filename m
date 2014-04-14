Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaDNVp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:45:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34160 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755627AbaDNVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:45:52 -0400
Date: Mon, 14 Apr 2014 22:45:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 4/7] imx-drm: ipu-dc: Wait for DC_FC_1 / DP_SF_END
	interrupt
Message-ID: <20140414214507.GO24070@n2100.arm.linux.org.uk>
References: <1397488895-17930-1-git-send-email-p.zabel@pengutronix.de> <1397488895-17930-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397488895-17930-5-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:21:32PM +0200, Philipp Zabel wrote:
> Wait for the DC Frame Complete or DP Sync Flow End interrupts
> before disabling DC channels.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-dc.c | 71 +++++++++++++++++++++++----------
>  1 file changed, 50 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> index d5de8bb..13b7538 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> @@ -18,6 +18,7 @@
>  #include <linux/types.h>
>  #include <linux/errno.h>
>  #include <linux/delay.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  
>  #include "../imx-drm.h"
> @@ -110,6 +111,9 @@ struct ipu_dc_priv {
>  	struct device		*dev;
>  	struct ipu_dc		channels[IPU_DC_NUM_CHANNELS];
>  	struct mutex		mutex;
> +	struct completion	comp;
> +	int			dc_irq;
> +	int			dp_irq;
>  };
>  
>  static void dc_link_event(struct ipu_dc *dc, int event, int addr, int priority)
> @@ -239,38 +243,46 @@ void ipu_dc_enable_channel(struct ipu_dc *dc)
>  }
>  EXPORT_SYMBOL_GPL(ipu_dc_enable_channel);
>  
> +static irqreturn_t dc_irq_handler(int irq, void *dev_id)
> +{
> +	struct ipu_dc *dc = dev_id;
> +	u32 reg;
> +
> +	reg = readl(dc->base + DC_WR_CH_CONF);
> +	reg &= ~DC_WR_CH_CONF_PROG_TYPE_MASK;
> +	writel(reg, dc->base + DC_WR_CH_CONF);
> +
> +	/* The Freescale BSP kernel clears DIx_COUNTER_RELEASE here */
> +
> +	disable_irq(irq);

Shouldn't this be disable_irq_nosync() ?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
