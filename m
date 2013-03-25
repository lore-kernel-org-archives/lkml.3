Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab3CYNBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:01:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58669 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab3CYNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:01:32 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 25 Mar 2013 06:01:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] watchdog:improve w83627hf_wdt to timeout in minutes
Message-ID: <20130325130135.GB28652@roeck-us.net>
References: <1364184957-32386-1-git-send-email-tonychung00@gmail.com>
 <20130325051914.GB17618@roeck-us.net>
 <CAHyaeP0aTBcqpb0uUcwKCfzi-gJfrEoX6vQK08kN5Vh7sOqVBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHyaeP0aTBcqpb0uUcwKCfzi-gJfrEoX6vQK08kN5Vh7sOqVBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 11:57:51PM -0700, Tony Chung wrote:
> Thanks Guenter.
> 
> So will the new watchdog infrastructure for this driver back-ported to
> older LTS releases?
> 
I don't think so.

Guenter

> On Sun, Mar 24, 2013 at 10:19 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > On Sun, Mar 24, 2013 at 09:15:57PM -0700, Tony Chung wrote:
> > > The current maximum of 255 seconds is insufficient.
> > > For example, crash dump could take 5+ minutes.
> > >
> > > Signed-off-by: Tony Chung <tonychung00@gmail.com>
> >
> > I would suggest to use the port to the watchdog infrastructure for any
> > changes on this driver.
> >
> > > ---
> > >  drivers/watchdog/w83627hf_wdt.c |   73
> > ++++++++++++++++++++++++++++++--------
> > >  1 files changed, 57 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/watchdog/w83627hf_wdt.c
> > b/drivers/watchdog/w83627hf_wdt.c
> > > index 92f1326..d26adfb 100644
> > > --- a/drivers/watchdog/w83627hf_wdt.c
> > > +++ b/drivers/watchdog/w83627hf_wdt.c
> > > @@ -58,7 +58,7 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port
> > (default 0x2E)");
> > >  static int timeout = WATCHDOG_TIMEOUT;       /* in seconds */
> > >  module_param(timeout, int, 0);
> > >  MODULE_PARM_DESC(timeout,
> > > -             "Watchdog timeout in seconds. 1 <= timeout <= 255,
> > default="
> > > +             "Watchdog timeout in seconds. 1 <= timeout <= 15300,
> > default="
> > >                               __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
> > >
> > >  static bool nowayout = WATCHDOG_NOWAYOUT;
> > > @@ -67,6 +67,29 @@ MODULE_PARM_DESC(nowayout,
> > >               "Watchdog cannot be stopped once started (default="
> > >                               __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > >
> > > +/* timeout unit in minute */
> > > +static bool use_minute;
> > > +static char *unit;
> > > +static int max_timeout = 15300; /* 255*60 seconds */
> > > +
> > > +static inline int wdt_round_secs_to_minute(int t)
> > > +{
> > > +     return (t + 59) / 60;
> > > +}
> >
> > Use DIV_ROUND_UP().
> >
> > > +
> > > +static inline int wdt_use_minute(int t)
> > > +{
> > > +     if (t > 255) {
> > > +             t = wdt_round_secs_to_minute(t);
> > > +             use_minute = 1;
> >
> > bool has true / false.
> >
> > > +             unit = "minutes";
> > > +     } else {
> > > +             use_minute = 0;
> > > +             unit = "secs";
> > > +     }
> > > +     return t;
> > > +}
> > > +
> > >  /*
> > >   *   Kernel methods.
> > >   */
> > > @@ -107,6 +130,23 @@ static void w83627hf_unselect_wd_register(void)
> > >       outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
> > >  }
> > >
> > > +/* set CRF5 register */
> > > +static void w83627hf_set_crf5(void)
> > > +{
> > > +     unsigned char t;
> > > +
> > > +     outb_p(0xF5, WDT_EFER); /* Select CRF5 */
> > > +     t = inb_p(WDT_EFDR);      /* read CRF5 */
> > > +     t &= ~0x0C;               /* set second mode & disable keyboard
> > > +                                 turning off watchdog */
> > > +     t |= 0x02;                /* enable the WDTO# output low pulse
> > > +                                 to the KBRST# pin (PIN60) */
> > > +     if (use_minute)
> > > +             t |= 0x80;        /* set timeout in minute */
> > > +
> > > +     outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
> > > +}
> > > +
> > >  /* tyan motherboards seem to set F5 to 0x4C ?
> > >   * So explicitly init to appropriate value. */
> > >
> > > @@ -116,21 +156,16 @@ static void w83627hf_init(void)
> > >
> > >       w83627hf_select_wd_register();
> > >
> > > +     w83627hf_set_crf5();
> > > +
> > >       outb_p(0xF6, WDT_EFER); /* Select CRF6 */
> > >       t = inb_p(WDT_EFDR);      /* read CRF6 */
> > >       if (t != 0) {
> > > -             pr_info("Watchdog already running. Resetting timeout to %d
> > sec\n",
> > > -                     timeout);
> > > +             pr_info("Watchdog already running.  Reset timeout to %d
> > %s\n",
> > > +                     timeout, unit);
> > >               outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
> > >       }
> > >
> > > -     outb_p(0xF5, WDT_EFER); /* Select CRF5 */
> > > -     t = inb_p(WDT_EFDR);      /* read CRF5 */
> > > -     t &= ~0x0C;               /* set second mode & disable keyboard
> > > -                                 turning off watchdog */
> > > -     t |= 0x02;                /* enable the WDTO# output low pulse
> > > -                                 to the KBRST# pin (PIN60) */
> > > -     outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
> > >
> > >       outb_p(0xF7, WDT_EFER); /* Select CRF7 */
> > >       t = inb_p(WDT_EFDR);      /* read CRF7 */
> > > @@ -147,6 +182,9 @@ static void wdt_set_time(int timeout)
> > >
> > >       w83627hf_select_wd_register();
> > >
> > > +     if (use_minute)
> > > +             w83627hf_set_crf5();
> >
> > What if the new timeout is less than 256 seconds ?
> >
> > > +
> > >       outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
> > >       outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF6 */
> > >
> > > @@ -169,9 +207,9 @@ static int wdt_disable(void)
> > >
> > >  static int wdt_set_heartbeat(int t)
> > >  {
> > > -     if (t < 1 || t > 255)
> > > +     if (t < 1 || t > max_timeout)
> > >               return -EINVAL;
> > > -     timeout = t;
> > > +     timeout = wdt_use_minute(t);
> >
> > This should probably also update the watchdog timer register.
> >
> > >       return 0;
> > >  }
> > >
> > > @@ -262,9 +300,11 @@ static long wdt_ioctl(struct file *file, unsigned
> > int cmd, unsigned long arg)
> > >               wdt_ping();
> > >               /* Fall */
> > >       case WDIOC_GETTIMEOUT:
> > > -             return put_user(timeout, p);
> > > +             timeval = (use_minute) ? timeout * 60 : timeout;
> >
> > Isn't timeout always in seconds ?
> >
> > > +             return put_user(timeval, p);
> > >       case WDIOC_GETTIMELEFT:
> > >               timeval = wdt_get_time();
> > > +             timeval = (use_minute) ? timeval * 60 : timeval;
> > >               return put_user(timeval, p);
> > >       default:
> > >               return -ENOTTY;
> > > @@ -346,7 +386,8 @@ static int __init wdt_init(void)
> > >
> > >       if (wdt_set_heartbeat(timeout)) {
> > >               wdt_set_heartbeat(WATCHDOG_TIMEOUT);
> > > -             pr_info("timeout value must be 1 <= timeout <= 255, using
> > %d\n",
> > > +             pr_info("timeout value must be 1 <= timeout <= %d, using
> > %d\n",
> > > +                     max_timeout,
> >
> > That is still a constant, isn't it ? Why use a variable ?
> >
> > >                       WATCHDOG_TIMEOUT);
> > >       }
> > >
> > > @@ -371,8 +412,8 @@ static int __init wdt_init(void)
> > >               goto unreg_reboot;
> > >       }
> > >
> > > -     pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
> > > -             timeout, nowayout);
> > > +     pr_info("initialized. timeout=%d %s (nowayout=%d)\n",
> > > +             timeout, unit, nowayout);
> > >
> > >  out:
> > >       return ret;
> > > --
> > > 1.7.0.4
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > linux-watchdog" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> 
> 
> 
> -- 
> - Tony Chung
