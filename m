Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBPSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:16:57 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56589 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaBPSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:16:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 11/27] clocksource: sh_cmt: Add support for multiple channels per device
Date: Sun, 16 Feb 2014 19:18 +0100
Message-ID: <7782053.5pYg74TXhN@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1402151345450.21991@ionos.tec.linutronix.de>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1392339605-20691-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <alpine.DEB.2.02.1402151345450.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Saturday 15 February 2014 13:46:54 Thomas Gleixner wrote:
> On Fri, 14 Feb 2014, Laurent Pinchart wrote:
> > CMT hardware devices can support multiple channels, with global
> > registers and per-channel registers. The sh_cmt driver currently models
> > the hardware with one Linux device per channel. This model makes it
> > difficult to handle global registers in a clean way.
> > 
> > Add support for a new model that uses one Linux device per timer with
> > multiple channels per device. This requires changes to platform data,
> > add new channel configuration fields.
> > 
> > Support for the legacy model is kept and will be removed after all
> > platforms switch to the new model.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/clocksource/sh_cmt.c | 299 +++++++++++++++++++++++++++++---------
> >  include/linux/sh_timer.h     |   9 ++
> >  2 files changed, 239 insertions(+), 69 deletions(-)
> > 
> > diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
> > index 5280231..8390f0f 100644
> > --- a/drivers/clocksource/sh_cmt.c
> > +++ b/drivers/clocksource/sh_cmt.c
> > @@ -53,7 +53,16 @@ struct sh_cmt_device;
> > 
> >   * channel registers block. All other versions have a shared start/stop
> >   register * located in the global space.
> >   *
> > 
> > - * Note that CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing
> > 32-bit + * Channels are indexed from 0 to N-1 in the documentation. The
> > channel index + * infers the start/stop bit position in the control
> > register and the channel + * registers block address. Some CMT instances
> > have a subset of channels + * available, in which case the index in the
> > documentation doesn't match the + * "real" index as implemented in
> > hardware. This is for instance the case with + * CMT0 on r8a7740, which
> > is a 32-bit variant with a single channel numbered 0 + * in the
> > documentation but using start/stop bit 5 and having its registers + *
> > block at 0x60.
> > + *
> > + * Similarly CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing
> > 32-bit> 
> >   * channels only, is a 48-bit gen2 CMT with the 48-bit channels
> >   unavailable.
> >   */
> > 
> > @@ -85,11 +94,15 @@ struct sh_cmt_info {
> > 
> >  struct sh_cmt_channel {
> >  
> >  	struct sh_cmt_device *cmt;
> > 
> > -	unsigned int index;
> > 
> > -	void __iomem *base;
> > +	unsigned int index;	/* Index in the documentation */
> > +	unsigned int hwidx;	/* Real hardware index */
> > +
> > +	void __iomem *iostart;
> > +	void __iomem *ioctrl;
> > 
> >  	struct irqaction irqaction;
> 
> While you are at it, can you please get rid of that irqaction and use
> request_irq() ?

The driver claims it can't use request_irq() because the function is not 
available for early platform devices. If the situation has changed I'd gladly 
get rid of irqaction.

-- 
Regards,

Laurent Pinchart

