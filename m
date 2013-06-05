Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3FEU0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:26:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58455 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab3FEU0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:26:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Wed, 05 Jun 2013 22:35:05 +0200
Message-ID: <105446113.ZumbZWCbSi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51AF71B6.6030408@semaphore.gr>
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic> <51AF71B6.6030408@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
> Hi Borislav,
> 
> On 06/05/2013 07:17 PM, Borislav Petkov wrote:
> > On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
> >> Ondemand calculates load in terms of frequency and increases it only
> >> if the load_freq is greater than up_threshold multiplied by current
> >> or average frequency. This seems to produce oscillations of frequency
> >> between min and max because, for example, a relatively small load can
> >> easily saturate minimum frequency and lead the CPU to max. Then, the
> >> CPU will decrease back to min due to a small load_freq.
> >
> > Right, and I think this is how we want it, no?
> >
> > The thing is, the faster you finish your work, the faster you can become
> > idle and save power.
> 
> This is exactly the goal of this patch. To use more efficiently middle
> frequencies to finish faster the work.
> 
> > If you switch frequencies in a staircase-like manner, you're going to
> > take longer to finish, in certain cases, and burn more power while doing
> > so.
> 
> This is not true with this patch. It switches to middle frequencies
> when the load < up_threshold.
> Now, ondemand does not increase freq. CPU runs in lowest freq till the
> load is greater than up_threshold.
> 
> > Btw, racing to idle is also a good example for why you want boosting:
> > you want to go max out the core but stay within power limits so that you
> > can finish sooner.
> >
> >> This patch changes the calculation method of load and target frequency
> >> considering 2 points:
> >> - Load computation should be independent from current or average
> >> measured frequency. For example an absolute load 80% at 100MHz is not
> >> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
> >> - Target frequency should be increased to any value of frequency table
> >> proportional to absolute load, instead to only the max. Thus:
> >>
> >> Target frequency = C * load
> >>
> >> where C = policy->cpuinfo.max_freq / 100
> >>
> >> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
> >> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
> >> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
> >> that middle frequencies are used more, with this patch. Highest
> >> and lowest frequencies were used less by ~9%

Can you also use powertop to measure the percentage of time spent in idle
states for the same workload with and without your patchset?  Also, it would
be good to measure the total energy consumption somehow ...

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
