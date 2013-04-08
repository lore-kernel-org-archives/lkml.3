Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936243Ab3DHPPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:15:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54849 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936113Ab3DHPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:15:05 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 8 Apr 2013 08:15:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Don Zickus <dzickus@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130408151509.GA20919@roeck-us.net>
References: <1365192994-94850-1-git-send-email-dzickus@redhat.com>
 <516259D2.7000805@redhat.com>
 <20130408124858.GC79013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408124858.GC79013@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 08:48:58AM -0400, Don Zickus wrote:
> On Mon, Apr 08, 2013 at 01:46:58PM +0800, Dave Young wrote:
> > On 04/06/2013 04:16 AM, Don Zickus wrote:
> > > A common problem with kdump is that during the boot up of the
> > > second kernel, the hardware watchdog times out and reboots the
> > > machine before a vmcore can be captured.
> > > 
> > > Instead of tellling customers to disable their hardware watchdog
> > > timers, I hacked up a hook to put in the kdump path that provides
> > > one last kick before jumping into the second kernel.
> > > 
> > > The assumption is the watchdog timeout is at least 10-30 seconds
> > > long, enough to get the second kernel to userspace to kick the watchdog
> > > again, if needed.
> > 
> > For kdump kernel some devices need to reset, this might increase the
> > boot time, it's not so reliable for the 10-30s for us to kicking the
> > watchdog.
> > 
> > Could we have another option to disable/stop the watchdog while panic
> > happens? Ie. add a kernel cmdline panic_stop_wd=<0|1> for 1st kernel, if
> > it's set to 1, then just stop the watchdog or we can kick the watchdog
> > like what you do in this patch. Of course stopping watchdog should be
> > lockless as well..
> 
> Hmm, I can look into that.  But I am not sure all watchdogs have the
> ability to stop once started.  I was also worried about the case where

Correct.

> kdump hangs for some reason.  Having the watchdog there to 'reboot' would
> be a nice safety net.
> 
Absolutely agree. After all, the reason for the kdump is most likely that
something went really wrong, meaning there is some likelyhood for the hang
to occur. Turning off the watchdog in this condition does not seem to be
a good idea.

> Perhaps adjusting the watchdog 'timeout' to something like 3 minutes would
> be easier?
> 
Not all watchdogs support such large timeouts, unfortunately. Maybe it would
make sense to implement infrastructure support for a softdog on top of the
hardware watchdog. Several drivers implement that outside the infrastructure
already.

Guenter

> I'll wait on feedback from the watchdog community to help point me in a
> good direction.
> 
> Cheers,
> Don
> 
> > 
> > > 
> > > Of course kdump is usually executed on a panic path, so grabbing the
> > > watchdog mutexes to communicate with the hardware won't work.  For now,
> > > I do everything locklessly.
> > > 
> > > I can attempt a 'mutex_trylock' but not sure what to do in the failure
> > > case?  spin up to a second?
> > > 
> > > This patch is more of a proof of concept right now.  Hopefully feedback
> > > will help solve this problem better.
> > > 
> > > I have tested this with a machine using iTCO_wdt and the 'watchdog' app.
> > > The extra kicked happened as expected.
> > > 
> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > ---
> > >  drivers/watchdog/watchdog_dev.c |   35 +++++++++++++++++++++++++++++++++++
> > >  include/linux/watchdog.h        |    7 +++++++
> > >  kernel/kexec.c                  |    6 ++++++
> > >  3 files changed, 48 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> > > index 08b48bb..6393572 100644
> > > --- a/drivers/watchdog/watchdog_dev.c
> > > +++ b/drivers/watchdog/watchdog_dev.c
> > > @@ -84,6 +84,41 @@ out_ping:
> > >  }
> > >  
> > >  /*
> > > + *	watchdog_kick_for_kdump: kick the watchdog in the kdump path
> > > + *
> > > + * 	The kdump path needs time to reboot the kernel back into
> > > + * 	userspace.  This window is big enough the hardware watchdog
> > > + * 	may come in and reboot the box.  This hook gives the watchdog
> > > + * 	one final kick to get kdump over the hump.
> > > + *
> > > + * 	We don't know what devices are open, so just use the legacy
> > > + * 	interface for now.  We have to do this locklessly as we can
> > > + * 	not wait.
> > > + */
> > > +
> > > +void watchdog_kick_for_kdump(void)
> > > +{
> > > +	struct watchdog_device *wddev = old_wdd;
> > > +
> > > +	/* FIXME - Perhaps use a mutex_trylock? */
> > > +
> > > +	if (!wddev)
> > > +		return;
> > > +
> > > +	if (test_bit(WDOG_UNREGISTERED, &wddev->status))
> > > +		return;
> > > +
> > > +	if (!watchdog_active(wddev))
> > > +		return;
> > > +
> > > +	if (wddev->ops->ping)
> > > +		wddev->ops->ping(wddev);  /* ping the watchdog */
> > > +	else
> > > +		wddev->ops->start(wddev); /* restart watchdog */
> > > +}
> > > +EXPORT_SYMBOL_GPL(watchdog_kick_for_kdump);
> > > +
> > > +/*
> > >   *	watchdog_start: wrapper to start the watchdog.
> > >   *	@wddev: the watchdog device to start
> > >   *
> > > diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> > > index 2a3038e..5dff975 100644
> > > --- a/include/linux/watchdog.h
> > > +++ b/include/linux/watchdog.h
> > > @@ -142,4 +142,11 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
> > >  extern int watchdog_register_device(struct watchdog_device *);
> > >  extern void watchdog_unregister_device(struct watchdog_device *);
> > >  
> > > +#ifdef CONFIG_WATCHDOG_CORE
> > > +/* drivers/watchdog/watchdog_dev.c */
> > > +extern void watchdog_kick_for_kdump(void);
> > > +#else
> > > +static inline void watchdog_kick_for_kdump(void) { };
> > > +#endif
> > > +
> > >  #endif  /* ifndef _LINUX_WATCHDOG_H */
> > > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > > index bddd3d7..ced7ccd 100644
> > > --- a/kernel/kexec.c
> > > +++ b/kernel/kexec.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/swap.h>
> > >  #include <linux/syscore_ops.h>
> > > +#include <linux/watchdog.h>
> > >  
> > >  #include <asm/page.h>
> > >  #include <asm/uaccess.h>
> > > @@ -1094,6 +1095,11 @@ void crash_kexec(struct pt_regs *regs)
> > >  		if (kexec_crash_image) {
> > >  			struct pt_regs fixed_regs;
> > >  
> > > +			/*
> > > +			 * Give panic path a chance to do its post processing
> > > +			 */
> > > +			watchdog_kick_for_kdump();
> > > +
> > >  			crash_setup_regs(&fixed_regs, regs);
> > >  			crash_save_vmcoreinfo();
> > >  			machine_crash_shutdown(&fixed_regs);
> > > 
> > 
> > 
> > -- 
> > Thanks
> > Dave
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
