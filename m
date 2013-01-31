Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3AaIj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:39:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52610 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3AaIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:39:22 -0500
Date: Thu, 31 Jan 2013 09:39:09 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/4] cpufreq: ondemand: call dbs_check_cpu only when
 necessary
Message-ID: <20130131083825.GA30667@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-3-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
 <20130130164614.GC30559@balto.lan>
 <CAKohponMezzus0tRW+CdC7wLq1U1pRio5q=g6F845x7iveFCAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponMezzus0tRW+CdC7wLq1U1pRio5q=g6F845x7iveFCAA@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Viresh,

On Wed, Jan 30, 2013 at 10:41:08PM +0530, Viresh Kumar wrote:
> On 30 January 2013 22:16, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Isn't that how it works now?  The current cpu ktime is not checked
> > against its own, but against the "leader" cpu (dbs_info_local->cdbs.cpu),
> > that's why it's initialized only for the first.
> >
> > Maybe I should have used dbs_info_leader/dbs_info instead of
> > dbs_info_local/dbs_info.
> 
> This routine is called as wq handler. Which will recover dbs_info from work
> using container_of. Which would give dbs_info_local for the cpu j.
> 
> Then we will execute below code.
> 
> +       /* use leader CPU's dbs_info */
> +       dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cdbs.cpu);
> 
> dbs_info_local->cdbs.cpu was uninitialized for all cpus except policy->cpu.

Ok, now I see the problem: cdbs->cpu is initialized only on the leader
cpu and this is working by coincidence on my system, while
cdbs->time_stamp is initialized only on the leader cpu, and that should
be correct even when cpu hotplugging as that's reinitialized every time.

That's a fix so I'll send a patch just to set ->cpu into the
for_each_cpu cycle.

Thanks,
Fabio

> And so, might be initialized with 0 as its a global variable... But if you
> offline cpu 0 and online it back, then policy->cpu would be 1 and this logic,
> which worked by mistake will fail.
> 
> +       mutex_lock(&dbs_info->cdbs.timer_mutex);
> +
> +       time_now = ktime_get();
> +       delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);
> 
> and so as this.
> 
> Correct?
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Fabio Baltieri
