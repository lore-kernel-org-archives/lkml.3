Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaDCSfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:35:12 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53934 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaDCSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:35:08 -0400
Date: Thu, 3 Apr 2014 21:30:54 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS/loongson2_cpufreq: fix CPU clock rate setting
Message-ID: <20140403183053.GA9247@drone.musicnaut.iki.fi>
References: <1396465624-21661-1-git-send-email-aaro.koskinen@iki.fi>
 <CAKohpokxg=UsiXyq1kJAqgVyj6qYoiQfryfpXGebPtB4f253FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokxg=UsiXyq1kJAqgVyj6qYoiQfryfpXGebPtB4f253FQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 03, 2014 at 09:51:41AM +0530, Viresh Kumar wrote:
> On 3 April 2014 00:37, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > Loongson2 has been using (incorrectly) kHz for cpu_clk rate. This has
> > been unnoticed, as loongson2_cpufreq was the only place where the rate
> > was set/get. After commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
> > (cpufreq: introduce cpufreq_generic_get() routine) things however broke,
> > and now loops_per_jiffy adjustments are incorrect (1000 times too long).
> > The patch fixes this by changing cpu_clk rate to Hz.
> >
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/mips/loongson/lemote-2f/clock.c | 7 +++++--
> >  drivers/cpufreq/loongson2_cpufreq.c  | 4 ++--
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
> > index aed32b8..699f388 100644
> > --- a/arch/mips/loongson/lemote-2f/clock.c
> > +++ b/arch/mips/loongson/lemote-2f/clock.c
> > @@ -91,6 +91,7 @@ EXPORT_SYMBOL(clk_put);
> >
> >  int clk_set_rate(struct clk *clk, unsigned long rate)
> >  {
> > +       unsigned int rate_khz;
> 
> Initialize rate_khz here only instead of doing it separately..

Ok.

> From here:
> 
> >         for (i = 0; loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END;
> >              i++) {
> >                 if (loongson2_clockmod_table[i].frequency ==
> >                     CPUFREQ_ENTRY_INVALID)
> >                         continue;
> > -               if (rate == loongson2_clockmod_table[i].frequency)
> > +               if (rate_khz == loongson2_clockmod_table[i].frequency)
> >                         break;
> >         }
> > -       if (rate != loongson2_clockmod_table[i].frequency)
> > +       if (rate_khz != loongson2_clockmod_table[i].frequency)
> >                 return -ENOTSUPP;
> 
> To here:
> 
> All this code is junk and not required anymore as rate is guaranteed
> to be in loongson2_clockmod_table[].. Probably you need value of
> 'i' here and you can pass that directly from loongson2_cpufreq_target().

But then we couldn't use clk_set_rate()? Anyway I think that should
be done with separate patch(es), which probably would not qualify
for 3.14-stable or 3.15-rc.

A.
