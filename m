Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbbAYN6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:58:00 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46083 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbbAYN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501231223470.5526@nanos>
References: <1418162614-19182-1-git-send-email-khilman@kernel.org>
	<1418162614-19182-2-git-send-email-khilman@kernel.org>
	<alpine.DEB.2.11.1501231223470.5526@nanos>
Date: Sun, 25 Jan 2015 19:27:57 +0530
Message-ID: <CAKohpomZJAymPHVNR9LkHM8V2tkmM=H+btYEiAJ9hq0mAoOzYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] clockevents: introduce ->set_dev_mode() which can
 return error
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@kernel.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 23 January 2015 at 17:27, Thomas Gleixner <tglx@linutronix.de> wrote:
> static int __clockevents_set_mode(dev, mode)
> {
>         /* Transition mode */
>         if (dev->set_mode) {
>            if (mode > CLOCK_EVT_MODE_RESUME)
>                  return -ENOSYS;
>            dev->set_mode(mode, dev);
>            return 0;
>         }
>
>         if (dev->features & CLOCK_EVT_FEAT_DUMMY)
>            return 0;
>
>         switch (mode) {
>         /*
>          * This is an internal state, which is guaranteed to
>          * go from SHUTDOWN to UNUSED. No driver interaction
>          * required.
>          */
>         case CLOCK_EVT_MODE_UNUSED:
>              return 0;
>
>         case CLOCK_EVT_MODE_SHUTDOWN:
>              return dev->shutdown(dev);
>
>         case CLOCK_EVT_MODE_PERIODIC:
>              /* Core internal bug */
>              if (!(dev->features & CLOCK_EVT_FEAT_PERIODIC))
>                    return -ENOSYS;
>              return dev->setup_periodic(dev);
>
>         case CLOCK_EVT_MODE_ONESHOT:
>              /* Core internal bug */
>              if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
>                    return -ENOSYS;
>              return dev->setup_oneshot(dev);
>
>         case CLOCK_EVT_MODE_RESUME:
>              return dev->setup_resume(dev);

Because setting to all these existing modes isn't allowed
to fail currently, shouldn't we make return type of all the new
callbacks as 'void' and return 0 from this routine ? That way, these
callbacks would stay consistent with the set_mode() callback..

>
>         default:
>              return -ENOSYS;
> }
>
> And do sanity checking on registration time:
>
> static int ce_check(dev)
> {
>        if (dev->set_mode)
>            return 0;
>
>        if (dev->features & CLOCK_EVT_FEAT_DUMMY)
>            return 0;
>
>        if (!dev->shutdown)
>            return -EMORON;
>
>        if ((dev->features & CLOCK_EVT_FEAT_PERIODIC) &&
>            !dev->setup_periodic)
>            return -EMORON;
>
>        if ((dev->features & CLOCK_EVT_FEAT_ONESHOT) &&
>            !dev->setup_oneshot)
>            return -EMORON;
>
>        /* Optional callbacks */
>        if (!dev->setup_resume)
>           dev->setup_resume = setup_noop();
>
>        return 0;
> }
>
> That gives us a clear distinction of required and optional callbacks,
> which will make error handling and recovery simpler as well.

Now that we are looking forward to providing individual callbacks
per feature, I wanted to propose few more solutions to it, though I am
quite sure you would have already considered and rejected them.

I remember from your earlier mail that you didn't wanted to add
ONESHOT_STOPPED as a feature (as it isn't a feature really)
and that restricts us from doing this:

static int __clockevents_set_mode(dev, mode)
{
        if ((mode == CLOCK_EVT_MODE_ONESHOT_STOPPED) &&
            !(dev->features & CLOCK_EVT_FEAT_ONESHOT_STOPPED))
                return -ENOSYS;

        dev->set_mode(mode, dev);
        return 0;
}

But what about providing a separate callback only for ONESHOT_STOPPED
mode and use set_mode() for everything else ?

static int __clockevents_set_mode(dev, mode)
{
        if (mode == CLOCK_EVT_MODE_ONESHOT_STOPPED) {
                if (dev->stop_onshot)
                        return dev->stop_onshot(dev);
                else
                        return -ENOSYS;
        }

        dev->set_mode(mode, dev);
        return 0;
}

Thanks for looking into this thread again..

--
viresh
