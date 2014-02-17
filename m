Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaBQJ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:57:01 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:33066 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBQJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:56:59 -0500
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
Date: Mon, 17 Feb 2014 10:58:06 +0100
Message-ID: <3050110.8B4nKkQ5Sd@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANqRtoQ=QJ0YVjp+8y+H9OTk=iRf6Jdeg_J9PMyYa-9WbgfXyA@mail.gmail.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2041255.QOGrHiKJmD@avalon> <CANqRtoQ=QJ0YVjp+8y+H9OTk=iRf6Jdeg_J9PMyYa-9WbgfXyA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Monday 17 February 2014 11:07:06 Magnus Damm wrote:
> On Mon, Feb 17, 2014 at 10:48 AM, Laurent Pinchart wrote:
> > On Monday 17 February 2014 10:41:31 Magnus Damm wrote:
> >> On Mon, Feb 17, 2014 at 3:18 AM, Laurent Pinchart wrote:
> >> > On Saturday 15 February 2014 13:46:54 Thomas Gleixner wrote:
> >> >> On Fri, 14 Feb 2014, Laurent Pinchart wrote:
> >> >> > CMT hardware devices can support multiple channels, with global
> >> >> > registers and per-channel registers. The sh_cmt driver currently
> >> >> > models the hardware with one Linux device per channel. This model
> >> >> > makes it difficult to handle global registers in a clean way.
> >> >> > 
> >> >> > Add support for a new model that uses one Linux device per timer
> >> >> > with multiple channels per device. This requires changes to platform
> >> >> > data, add new channel configuration fields.
> >> >> > 
> >> >> > Support for the legacy model is kept and will be removed after all
> >> >> > platforms switch to the new model.
> >> >> > 
> >> >> > Signed-off-by: Laurent Pinchart
> >> >> > <laurent.pinchart+renesas@ideasonboard.com>
> >> >> > ---
> >> >> > 
> >> >> >  drivers/clocksource/sh_cmt.c | 299 ++++++++++++++++++++++++--------
> >> >> >  include/linux/sh_timer.h     |   9 ++
> >> >> >  2 files changed, 239 insertions(+), 69 deletions(-)
> >> >> > 
> >> >> > diff --git a/drivers/clocksource/sh_cmt.c
> >> >> > b/drivers/clocksource/sh_cmt.c
> >> >> > index 5280231..8390f0f 100644
> >> >> > --- a/drivers/clocksource/sh_cmt.c
> >> >> > +++ b/drivers/clocksource/sh_cmt.c
> > 
> > [snip]
> > 
> >> >> > @@ -85,11 +94,15 @@ struct sh_cmt_info {
> >> >> > 
> >> >> >  struct sh_cmt_channel {
> >> >> >     struct sh_cmt_device *cmt;
> >> >> > 
> >> >> > -   unsigned int index;
> >> >> > -   void __iomem *base;
> >> >> > +   unsigned int index;     /* Index in the documentation */
> >> >> > +   unsigned int hwidx;     /* Real hardware index */
> >> >> > +
> >> >> > +   void __iomem *iostart;
> >> >> > +   void __iomem *ioctrl;
> >> >> > 
> >> >> >     struct irqaction irqaction;
> >> >> 
> >> >> While you are at it, can you please get rid of that irqaction and use
> >> >> request_irq() ?
> >> > 
> >> > The driver claims it can't use request_irq() because the function is
> >> > not available for early platform devices. If the situation has changed
> >> > I'd gladly get rid of irqaction.
> >> 
> >> With the risk of stating the obvious, this depends on how early the
> >> early platform device stuff is being run. The actual location may not
> >> be the same on SH and ARM for instance.
> >> 
> >> On ARM we are doing all we can to initialize these devices as late as
> >> ever possible in the MULTIPLAFORM (DT reference) case. Once we manage
> >> to remove the legacy ARM case then there is one less user of early
> >> platform timers.
> >> 
> >> One perhaps reasonable way forward could be to use request_irq() in
> >> case of DT and leave the legacy platform data case to rely on
> >> irqaction.
> > 
> > The whole point of switching from setup_irq() to request_irq() is to
> > simplify the code. Adding request_irq() as an option would go in the
> > opposite direction.
> 
> The point of switching to setup_irq() was not very clear to me. I
> think it is fine to switch to using it over time, and I'm open to any
> alternative ways forward. Usually moving in incremental steps means
> more crap in the short term, but if someone could come up with a way
> that involves little crap then I'm all for that! =)

I've had a quick look at request_irq(). The function is defined as a static 
inline in include/linux/interrupt.h:

static inline int __must_check
request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
            const char *name, void *dev)
{
        return request_threaded_irq(irq, handler, NULL, flags, name, dev);
}

request_threaded_irq() is implemented in kernel/irq/manage.c. I've removed the 
code paths that would never be taken when called by the sh_cmt driver, due to

- handler not being NULL
- thread_fn being NULL
- CONFIG_DEBUG_SHIRQ_FIXME not being set
- IRQF_SHARED not being set

int request_threaded_irq(unsigned int irq, irq_handler_t handler,
                         irq_handler_t thread_fn, unsigned long irqflags,
                         const char *devname, void *dev_id)
{
        struct irqaction *action;
        struct irq_desc *desc;
        int retval;

        desc = irq_to_desc(irq);
        if (!desc)
                return -EINVAL;

        if (!irq_settings_can_request(desc) ||
            WARN_ON(irq_settings_is_per_cpu_devid(desc)))
                return -EINVAL;

        action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
        if (!action)
                return -ENOMEM;

        action->handler = handler;
        action->thread_fn = thread_fn;
        action->flags = irqflags;
        action->name = devname;
        action->dev_id = dev_id;

        chip_bus_lock(desc);
        retval = __setup_irq(irq, desc, action);
        chip_bus_sync_unlock(desc);

        if (retval)
                kfree(action);

        return retval;
}

setup_irq() is implemented in the same file as

int setup_irq(unsigned int irq, struct irqaction *act)
{
        int retval;
        struct irq_desc *desc = irq_to_desc(irq);

        if (WARN_ON(irq_settings_is_per_cpu_devid(desc)))
                return -EINVAL;
        chip_bus_lock(desc);
        retval = __setup_irq(irq, desc, act);
        chip_bus_sync_unlock(desc);

        return retval;
}

The only two differences between request_irq() and setup_irq() would thus be

- the extra !irq_settings_can_request(desc) check
- the extra kzalloc() call

The former should only be true for chained IRQ handlers, which isn't the case 
here. The latter is just a kmalloc + kmap_atomic + memset as far as I can 
tell.

It thus seems safe to replace setup_irq() with request_irq().

-- 
Regards,

Laurent Pinchart

