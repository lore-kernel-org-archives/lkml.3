Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaKFW1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:27:14 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40327 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:27:10 -0500
Date: Thu, 6 Nov 2014 14:27:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v5 01/48] kernel: Add support for power-off handler call
 chain
Message-ID: <20141106222703.GA6377@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-2-git-send-email-linux@roeck-us.net>
 <3183593.9HaIZKjCKr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3183593.9HaIZKjCKr@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.545BF5BD.0168,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:30:59PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 06, 2014 08:42:45 AM Guenter Roeck wrote:
> > Various drivers implement architecture and/or device specific means to
> > power off the system.  For the most part, those drivers set the global
> > variable pm_power_off to point to a function within the driver.
> > 
> > This mechanism has a number of drawbacks.  Typically only one scheme
> > to remove power is supported (at least if pm_power_off is used).
> > At least in theory there can be multiple means remove power, some of
> > which may be less desirable. For example, some mechanisms may only
> > power off the CPU or the CPU card, while another may power off the
> > entire system.  Others may really just execute a restart sequence
> > or drop into the ROM monitor. Using pm_power_off can also be racy
> > if the function pointer is set from a driver built as module, as the
> > driver may be in the process of being unloaded when pm_power_off is
> > called. If there are multiple power-off handlers in the system, removing
> > a module with such a handler may inadvertently reset the pointer to
> > pm_power_off to NULL, leaving the system with no means to remove power.
> > 
> > Introduce a system power-off handler call chain to solve the described
> > problems.  This call chain is expected to be executed from the architecture
> > specific machine_power_off() function.  Drivers and architeceture code
> > providing system power-off functionality are expected to register with
> > this call chain.  When registering a power-off handler, callers can
> > provide a priority to control power-off handler execution sequence
> > and thus ensure that the power-off handler with the optimal capabilities
> > to remove power for a given system is called first.
> > 
> > Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> > Cc: Alexander Graf <agraf@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Heiko Stuebner <heiko@sntech.de>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Philippe Rétornaz <philippe.retornaz@gmail.com>
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Romain Perier <romain.perier@gmail.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Acked-by: Heiko Stuebner <heiko@sntech.de>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v5:
> > - Rebase to v3.18-rc3
> > v4:
> > - Do not use notifiers but internal functions and data structures to manage
> >   the list of power-off handlers. Drop unused parameters from callbacks, and
> >   make the power-off function type void.
> >   Code to manage and walk the list of callbacks is derived from notifier.c.
> > v3:
> > - Rename new file to power_off_handler.c
> > - Replace poweroff in all newly introduced variables and in text
> >   with power_off or power-off as appropriate
> > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > - Execute power-off handlers without any locks held
> > v2:
> > - poweroff -> power_off
> > - Add defines for default priorities
> > - Use raw notifiers protected by spinlocks instead of atomic notifiers
> > - Add register_poweroff_handler_simple
> > - Add devm_register_power_off_handler
> > 
> >  include/linux/pm.h               |  28 ++++
> >  kernel/power/Makefile            |   1 +
> >  kernel/power/power_off_handler.c | 293 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 322 insertions(+)
> >  create mode 100644 kernel/power/power_off_handler.c
> > 
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 383fd68..a4d6bf8 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -35,6 +35,34 @@ extern void (*pm_power_off)(void);
> >  extern void (*pm_power_off_prepare)(void);
> >  
> >  struct device; /* we have a circular dep with device.h */
> > +
> > +/*
> > + * Data structures and callbacks to manage power-off handlers
> > + */
> > +
> > +struct power_off_handler_block {
> > +	void (*handler)(struct power_off_handler_block *);
> > +	struct power_off_handler_block __rcu *next;
> > +	int priority;
> > +};
> > +
> > +int register_power_off_handler(struct power_off_handler_block *);
> > +int devm_register_power_off_handler(struct device *,
> > +				    struct power_off_handler_block *);
> > +int register_power_off_handler_simple(void (*function)(void), int priority);
> > +int unregister_power_off_handler(struct power_off_handler_block *);
> > +void do_kernel_power_off(void);
> > +bool have_kernel_power_off(void);
> > +
> > +/*
> > + * Pre-defined power-off handler priorities
> > + */
> > +#define POWER_OFF_PRIORITY_FALLBACK	0
> > +#define POWER_OFF_PRIORITY_LOW		64
> > +#define POWER_OFF_PRIORITY_DEFAULT	128
> > +#define POWER_OFF_PRIORITY_HIGH		192
> > +#define POWER_OFF_PRIORITY_HIGHEST	255
> 
> I'm not sure why we need these gaps in the priority space.
> 
> I guess it might be possible to use
> 
> enum power_off_priority {
> 	POWER_OFF_PRIORITY_FALLBACK = 0,
> 	POWER_OFF_PRIORITY_LOW,
> 	POWER_OFF_PRIORITY_DEFAULT,
> 	POWER_OFF_PRIORITY_HIGH,
> 	POWER_OFF_PRIORITY_HIGHEST,
> 	POWER_OFF_PRIORITY_LIMIT,
> };

I retained the large number space on purpose, specifically to permit in-between
priorities. In other words, I want people to be able to say "priority for this
handler is higher than low but lower than default". After all, the defines were
intended as hints, not as a "Thou shall use those and only those priorities".

Having said that, the important part is to get the series accepted, so I won't
argue if that is what it takes to get an Ack. Let me know.

Thanks,
Guenter

> 
> and then make register_ complain if priority is POWER_OFF_PRIORITY_LIMIT
> or greater.
> 
> But I'm OK with the rest, so if no one else sees a problem here,
> I'm not going to make a fuss about it.
> 
> Rafael
> 
