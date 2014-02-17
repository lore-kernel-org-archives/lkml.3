Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBQBri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:47:38 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBQBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:47:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 11/27] clocksource: sh_cmt: Add support for multiple channels per device
Date: Mon, 17 Feb 2014 02:48:42 +0100
Message-ID: <2041255.QOGrHiKJmD@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANqRtoSQ53E-xbe0PM_-=NY0ouVkhW8tac-5ZuLYYwAO072aTg@mail.gmail.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <7782053.5pYg74TXhN@avalon> <CANqRtoSQ53E-xbe0PM_-=NY0ouVkhW8tac-5ZuLYYwAO072aTg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Monday 17 February 2014 10:41:31 Magnus Damm wrote:
> On Mon, Feb 17, 2014 at 3:18 AM, Laurent Pinchart wrote:
> > On Saturday 15 February 2014 13:46:54 Thomas Gleixner wrote:
> >> On Fri, 14 Feb 2014, Laurent Pinchart wrote:
> >> > CMT hardware devices can support multiple channels, with global
> >> > registers and per-channel registers. The sh_cmt driver currently models
> >> > the hardware with one Linux device per channel. This model makes it
> >> > difficult to handle global registers in a clean way.
> >> > 
> >> > Add support for a new model that uses one Linux device per timer with
> >> > multiple channels per device. This requires changes to platform data,
> >> > add new channel configuration fields.
> >> > 
> >> > Support for the legacy model is kept and will be removed after all
> >> > platforms switch to the new model.
> >> > 
> >> > Signed-off-by: Laurent Pinchart
> >> > <laurent.pinchart+renesas@ideasonboard.com>
> >> > ---
> >> > 
> >> >  drivers/clocksource/sh_cmt.c | 299 ++++++++++++++++++++++++++---------
> >> >  include/linux/sh_timer.h     |   9 ++
> >> >  2 files changed, 239 insertions(+), 69 deletions(-)
> >> > 
> >> > diff --git a/drivers/clocksource/sh_cmt.c
> >> > b/drivers/clocksource/sh_cmt.c
> >> > index 5280231..8390f0f 100644
> >> > --- a/drivers/clocksource/sh_cmt.c
> >> > +++ b/drivers/clocksource/sh_cmt.c

[snip]

> >> > @@ -85,11 +94,15 @@ struct sh_cmt_info {
> >> > 
> >> >  struct sh_cmt_channel {
> >> >     struct sh_cmt_device *cmt;
> >> > -   unsigned int index;
> >> > -   void __iomem *base;
> >> > +   unsigned int index;     /* Index in the documentation */
> >> > +   unsigned int hwidx;     /* Real hardware index */
> >> > +
> >> > +   void __iomem *iostart;
> >> > +   void __iomem *ioctrl;
> >> > 
> >> >     struct irqaction irqaction;
> >> 
> >> While you are at it, can you please get rid of that irqaction and use
> >> request_irq() ?
> > 
> > The driver claims it can't use request_irq() because the function is not
> > available for early platform devices. If the situation has changed I'd
> > gladly get rid of irqaction.
> 
> With the risk of stating the obvious, this depends on how early the
> early platform device stuff is being run. The actual location may not
> be the same on SH and ARM for instance.
> 
> On ARM we are doing all we can to initialize these devices as late as
> ever possible in the MULTIPLAFORM (DT reference) case. Once we manage
> to remove the legacy ARM case then there is one less user of early
> platform timers.
> 
> One perhaps reasonable way forward could be to use request_irq() in
> case of DT and leave the legacy platform data case to rely on
> irqaction.

The whole point of switching from setup_irq() to request_irq() is to simplify 
the code. Adding request_irq() as an option would go in the opposite 
direction.

-- 
Regards,

Laurent Pinchart

