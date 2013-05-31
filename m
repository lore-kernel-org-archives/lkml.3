Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3EaMd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:33:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55500 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3EaMdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:33:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
Date: Fri, 31 May 2013 14:42:09 +0200
Message-ID: <2135481.eCRs7DzAb6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=yFV05ON3Dth=6gLMHEVRNVb2J5+8OeLNv2G8VmSXkkQ@mail.gmail.com>
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpo=yFV05ON3Dth=6gLMHEVRNVb2J5+8OeLNv2G8VmSXkkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 31, 2013 02:24:59 PM Viresh Kumar wrote:
> On 31 May 2013 02:37, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> 
> Ahh.. earlier mail got sent without me doing complete review :(
> 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > +static void od_check_cpu(int cpu, unsigned int load)
> >  {
> >         struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
> >         struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
> > @@ -176,29 +170,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
> >         dbs_info->freq_lo = 0;
> >
> >         /* Check for frequency increase */
> > -       if (load_freq > od_tuners->up_threshold * policy->cur) {
> > +       if (load > od_tuners->up_threshold) {
> 
> Chances of this getting hit are minimal now.. I don't know if keeping
> this will change anything now :)
> 
> >                 /* If switching to max speed, apply sampling_down_factor */
> >                 if (policy->cur < policy->max)
> >                         dbs_info->rate_mult =
> >                                 od_tuners->sampling_down_factor;
> >                 dbs_freq_increase(policy, policy->max);
> >                 return;
> > -       }
> > -
> > -       /* Check for frequency decrease */
> > -       /* if we cannot reduce the frequency anymore, break out early */
> > -       if (policy->cur == policy->min)
> > -               return;
> > -
> > -       /*
> > -        * The optimal frequency is the frequency that is the lowest that can
> > -        * support the current CPU usage without triggering the up policy. To be
> > -        * safe, we focus 10 points under the threshold.
> > -        */
> > -       if (load_freq < od_tuners->adj_up_threshold
> > -                       * policy->cur) {
> > +       } else {
> > +               /* Calculate the next frequency proportional to load */
> >                 unsigned int freq_next;
> > -               freq_next = load_freq / od_tuners->adj_up_threshold;
> > +               freq_next = load * policy->max / 100;
> 
> Rafael asked why you believe this is the right formula and I really couldn't
> find an appropriate answer to that, sorry :(

Right, it would be good to explain that.

"Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
