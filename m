Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaLROtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:49:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54472 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLROtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:49:20 -0500
Date: Thu, 18 Dec 2014 08:49:15 -0600
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Stop BUGing the system
Message-ID: <20141218144915.GA29004@kahuna>
References: <1418831495-26958-1-git-send-email-nm@ti.com>
 <CAKohponF61J6pWOtfg_722dQDbXtxrmt2dG+rKY7SKbE3xKGZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohponF61J6pWOtfg_722dQDbXtxrmt2dG+rKY7SKbE3xKGZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:38-20141218, Viresh Kumar wrote:
> On 17 December 2014 at 21:21, Nishanth Menon <nm@ti.com> wrote:
> > CPUFRreq subsystem is not a system catastrophic failure point.
> > Failures in these cases DONOT need complete system shutdown with BUG.
> > just refuse to let cpufreq function should be good enough.
> >
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> >  drivers/cpufreq/cpufreq.c |   17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index a09a29c..a5aa2fa 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -281,7 +281,10 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
> >  static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
> >                 struct cpufreq_freqs *freqs, unsigned int state)
> >  {
> > -       BUG_ON(irqs_disabled());
> > +       if (irqs_disabled()) {
> > +               WARN(1, "IRQs disabled!\n");
> > +               return;
> > +       }
> 
> What about:
> 
> > +               if (WARN(irqs_disabled(), "IRQs disabled!\n")
> > +                       return;
> 
> Same for the last change as well..

k.
> 
> >
> >         if (cpufreq_disabled())
> >                 return;
> > @@ -1253,9 +1256,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
> >                         /*
> >                          * Reaching here after boot in a few seconds may not
> >                          * mean that system will remain stable at "unknown"
> > -                        * frequency for longer duration. Hence, a BUG_ON().
> > +                        * frequency for longer duration. Hence, a WARN().
> >                          */
> > -                       BUG_ON(ret);
> > +                       if (ret) {
> > +                               WARN(1, "SYSTEM operating at invalid freq %u", policy->cur);
> > +                               goto err_out_unregister;
> > +                       }
> 
> And I still don't agree for this one. We shouldn't keep on working on a
> potentially unstable frequency.

I can add "could be unstable" -> the point being there can be psuedo
errors reported in the system - example - clock framework bugs. Dont
just stop the boot. example: what if cpufreq was a driver module - it
would not have rescued the system because cpufreq had'nt detected the
logic - if we are going to force this on the system, we should probably
not do this in cpufreq code, instead should be somewhere generic.

While I do empathise (and had infact advocated in the past) of not
favouring system attempting to continue at an invalid configuration and
our attempt to rescue has failed - given that we cannot provide a
consistent behavior (it is not a core system behavior) and potential of
a false-postive (example clk framework or underlying bug), it should be
good enough to "enhance" WARN to be "severe sounding enough" to
flag it for developer and continue while keeping the system alive as
much as possible.


-- 
Regards,
Nishanth Menon
