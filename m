Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3BBUoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:44:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49063 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab3BBUoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:44:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM: make VT switching to the suspend console optional v2
Date: Sat, 02 Feb 2013 21:50:35 +0100
Message-ID: <2424360.s1UolC1PMO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1933562.n2GhljaZKo@vostro.rjw.lan>
References: <1359819248-3714-1-git-send-email-jbarnes@virtuousgeek.org> <1359819248-3714-2-git-send-email-jbarnes@virtuousgeek.org> <1933562.n2GhljaZKo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 02, 2013 08:39:21 PM Rafael J. Wysocki wrote:
> On Saturday, February 02, 2013 04:34:08 PM Jesse Barnes wrote:
> > KMS drivers can potentially restore the display configuration without
> > userspace help.  Such drivers can can call a new funciton,
> > pm_vt_switch_required(false) if they support this feature.  In that
> > case, the PM layer won't VT switch to the suspend console at suspend
> > time and then back to the original VT on resume, but rather leave things
> > alone for a nicer looking suspend and resume sequence.
> > 
> > v2: make a function so we can handle multiple drivers (Alan)
> > 
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > ---
> >  include/linux/pm.h     |    2 ++
> >  kernel/power/console.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 61 insertions(+)
> > 
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 03d7bb1..5c2b131 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -35,6 +35,8 @@ extern void (*pm_idle)(void);
> >  extern void (*pm_power_off)(void);
> >  extern void (*pm_power_off_prepare)(void);
> >  
> > +extern void pm_vt_switch_required(bool required);
> > +
> >  /*
> >   * Device power management
> >   */
> > diff --git a/kernel/power/console.c b/kernel/power/console.c
> > index b1dc456..67c4de3 100644
> > --- a/kernel/power/console.c
> > +++ b/kernel/power/console.c
> > @@ -4,6 +4,7 @@
> >   * Originally from swsusp.
> >   */
> >  
> > +#include <linux/console.h>
> >  #include <linux/vt_kern.h>
> >  #include <linux/kbd_kern.h>
> >  #include <linux/vt.h>
> > @@ -14,8 +15,63 @@
> >  
> >  static int orig_fgconsole, orig_kmsg;
> >  
> > +DEFINE_SPINLOCK(vt_switch_lock);
> > +static int vt_switch_required = -1;
> > +
> > +/**
> > + * pm_vt_switch_required - indicate VT switch at suspend requirements
> > + * @required: if true, caller needs VT switch at suspend/resume time
> > + *
> > + * The different console drivers may or may not require VT switches across
> > + * suspend/resume, depending on how they handle restoring video state and
> > + * what may be running.
> > + *
> > + * Drivers can indicate support for switchless suspend/resume, which can
> > + * save time and flicker, by using this routine and passing 'false' as
> > + * the argument.  If any loaded driver needs VT switching, or the
> > + * no_console_suspend argument has been passed on the command line, VT
> > + * switches will occur.
> > + */
> 
> It seems to me that we'll need a separate counter for the number of registered
> drivers and do the switch if that number is equal to the number of drivers that
> have passed false to this thing.
> 
> In which case we can simplify this slightly and introduce
> pm_vt_swtich_not_required(void)

Sorry, that won't be sufficient.  Rather something like pm_vt_switch_get()
(indicating "I'll do the switch, thanks") and pm_vt_switch_put() (indicating
"now you need to do the switch yourself").

> and then the only drivers that need to bother
> will be the ones known to not require the switch.
> 
> Otherwise it will be kind of error prone I'm afraid.

Thanks,
Rafael


> > +void pm_vt_switch_required(bool required)
> > +{
> > +	spin_lock(&vt_switch_lock);
> > +	if (vt_switch_required == -1) {
> > +		/* First call, set up real value */
> > +		if (!required)
> > +			vt_switch_required = 0;
> > +		if (required)
> > +			vt_switch_required = 1;
> > +	} else {
> > +		/*
> > +		 * Subsequent caller, make sure we handle the case
> > +		 * where a driver binds, needs VT switch, but then unbinds
> > +		 * later and a switchless driver is present.
> > +		 */
> > +		if (!required && vt_switch_required > 0)
> > +			vt_switch_required--;
> > +		else if (required)
> > +			vt_switch_required++;
> > +	}
> > +	spin_unlock(&vt_switch_lock);
> > +}
> > +EXPORT_SYMBOL(pm_vt_switch_required);
> > +
> > +static bool pm_vt_switch(void)
> > +{
> > +	bool ret = true;
> > +
> > +	spin_lock(&vt_switch_lock);
> > +	if (!vt_switch_required && console_suspend_enabled)
> > +		ret = false;
> > +	spin_unlock(&vt_switch_lock);
> > +	return ret;
> > +}
> > +
> >  int pm_prepare_console(void)
> >  {
> > +	if (!pm_vt_switch())
> > +		return 0;
> > +
> >  	orig_fgconsole = vt_move_to_console(SUSPEND_CONSOLE, 1);
> >  	if (orig_fgconsole < 0)
> >  		return 1;
> > @@ -26,6 +82,9 @@ int pm_prepare_console(void)
> >  
> >  void pm_restore_console(void)
> >  {
> > +	if (!pm_vt_switch())
> > +		return;
> > +
> >  	if (orig_fgconsole >= 0) {
> >  		vt_move_to_console(orig_fgconsole, 0);
> >  		vt_kmsg_redirect(orig_kmsg);
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
