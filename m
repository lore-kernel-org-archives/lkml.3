Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBOMqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:46:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:46925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBOMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:46:48 -0500
Date: Sat, 15 Feb 2014 13:46:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 11/27] clocksource: sh_cmt: Add support for multiple
 channels per device
In-Reply-To: <1392339605-20691-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Message-ID: <alpine.DEB.2.02.1402151345450.21991@ionos.tec.linutronix.de>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1392339605-20691-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Laurent Pinchart wrote:
> CMT hardware devices can support multiple channels, with global
> registers and per-channel registers. The sh_cmt driver currently models
> the hardware with one Linux device per channel. This model makes it
> difficult to handle global registers in a clean way.
> 
> Add support for a new model that uses one Linux device per timer with
> multiple channels per device. This requires changes to platform data,
> add new channel configuration fields.
> 
> Support for the legacy model is kept and will be removed after all
> platforms switch to the new model.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/clocksource/sh_cmt.c | 299 +++++++++++++++++++++++++++++++++----------
>  include/linux/sh_timer.h     |   9 ++
>  2 files changed, 239 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
> index 5280231..8390f0f 100644
> --- a/drivers/clocksource/sh_cmt.c
> +++ b/drivers/clocksource/sh_cmt.c
> @@ -53,7 +53,16 @@ struct sh_cmt_device;
>   * channel registers block. All other versions have a shared start/stop register
>   * located in the global space.
>   *
> - * Note that CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
> + * Channels are indexed from 0 to N-1 in the documentation. The channel index
> + * infers the start/stop bit position in the control register and the channel
> + * registers block address. Some CMT instances have a subset of channels
> + * available, in which case the index in the documentation doesn't match the
> + * "real" index as implemented in hardware. This is for instance the case with
> + * CMT0 on r8a7740, which is a 32-bit variant with a single channel numbered 0
> + * in the documentation but using start/stop bit 5 and having its registers
> + * block at 0x60.
> + *
> + * Similarly CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
>   * channels only, is a 48-bit gen2 CMT with the 48-bit channels unavailable.
>   */
>  
> @@ -85,11 +94,15 @@ struct sh_cmt_info {
>  
>  struct sh_cmt_channel {
>  	struct sh_cmt_device *cmt;
> -	unsigned int index;
>  
> -	void __iomem *base;
> +	unsigned int index;	/* Index in the documentation */
> +	unsigned int hwidx;	/* Real hardware index */
> +
> +	void __iomem *iostart;
> +	void __iomem *ioctrl;
>  	struct irqaction irqaction;

While you are at it, can you please get rid of that irqaction and use
request_irq() ?
  
Thanks,

	tglx
