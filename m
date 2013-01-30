Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3A3LEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:04:47 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37670 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3A3LEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:04:44 -0500
Date: Wed, 30 Jan 2013 12:04:29 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Message-ID: <20130130110429.GC32315@balto.lan>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
 <1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
 <CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
 <20130130091453.GA32315@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130091453.GA32315@balto.lan>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:14:53AM +0100, Fabio Baltieri wrote:
> Hello Viresh,
> 
> On Wed, Jan 30, 2013 at 12:33:40PM +0530, Viresh Kumar wrote:
> > I am starting to follow cpufreq patches religiously now and so have to come
> > back to this old thread due to some crash we got :)
> > 
> > Its still not pushed upstream, so better to get it resolved before 3.9.
> 
> Definitely, that's what we have -next for!
> 
> > On Thu, Dec 27, 2012 at 8:25 PM, Fabio Baltieri
> > <fabio.baltieri@linaro.org> wrote:
> > 
> > > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > 
> > >  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> > > -               struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> > > +                                 struct cpu_dbs_common_info *cdbs,
> > > +                                 unsigned int sampling_rate,
> > > +                                 int cpu)
> > >  {
> > >         int delay = delay_for_sampling_rate(sampling_rate);
> > > +       struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
> > 
> > I couldn't understand the real need for this, as it should really give
> > back the same
> > pointer pointed out by: cdbs and hence no need of cpu in params too..

Small sidenote, actually what I'm going to drop here i *cdbs, as I need
cpu for schedule_delayed_work_on and can't use cdbs->cpu for that as
it's the master's one.

Fabio

> > 
> > I may be wrong here :)
> 
> You are actually right.  This comes from the first version of the patch
> (I basically rewrote it after the common code rafactoring), and cdbs was
> meant to be always the one for the master CPU while cpu should indicate
> the one being initialized.  Then the thing turned out as:
> 
> A - I dropped the code specific for master cdbs here as it was already
> there on another code path following the rafactoring.
> B - I passed j_cdbs = dbs_data->get_cpu_cdbs(j) in the init cycle while
> it was really meant to be get_cpu_cdbs(cpu).
> 
> > >
> > > -       INIT_DEFERRABLE_WORK(&cdbs->work, dbs_data->gov_dbs_timer);
> > > -       schedule_delayed_work_on(cdbs->cpu, &cdbs->work, delay);
> > > +       schedule_delayed_work_on(cpu, &cdbs_local->work, delay);
> > >  }

-- 
Fabio Baltieri
