Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaEPJ2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:28:20 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15712 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbaEPJ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:28:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 16 May 2014 02:23:28 -0700
Date: Fri, 16 May 2014 12:28:12 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Doug Anderson <dianders@chromium.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC] cpufreq: send notifications for intermediate (stable)
 frequencies
Message-ID: <20140516092812.GN15168@tbergstrom-lnx.Nvidia.com>
References: <25738681139c04272b6d2ebeff244c6d36c893f7.1400133090.git.viresh.kumar@linaro.org>
 <537512E0.7000102@wwwdotorg.org>
 <CAD=FV=X_tVnMBz3yOf6QBYf4+-AK79_sF=asX4mD2mptxhM2CQ@mail.gmail.com>
 <537528B9.9070708@wwwdotorg.org>
 <CAD=FV=V4dBRubAKUOUFc=yAWRPNhmSvULg4Pjtx9rD+ou-sMZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAD=FV=V4dBRubAKUOUFc=yAWRPNhmSvULg4Pjtx9rD+ou-sMZg@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:58:26PM +0200, Doug Anderson wrote:
> Stephen,
> 
> On Thu, May 15, 2014 at 1:51 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 05/15/2014 02:39 PM, Doug Anderson wrote:
> >> Hi,
> >>
> >> On Thu, May 15, 2014 at 12:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >>> On 05/14/2014 11:56 PM, Viresh Kumar wrote:
> >>>> Douglas Anderson, recently pointed out an interesting problem due to which his
> >>>> udelay() was expiring earlier than it should:
> >>>> https://lkml.org/lkml/2014/5/13/766
> >>>>
> >>>> While transitioning between frequencies few platforms may temporarily switch to
> >>>> a stable frequency, waiting for the main PLL to stabilize.
> >>>>
> >>>> For example: When we transition between very low frequencies on exynos, like
> >>>> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> >>>> No CPUFREQ notification is sent for that. That means there's a period of time
> >>>> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> >>>> and 300MHz. And so udelay behaves badly.
> >>>>
> >>>> To get this fixed in a generic way, lets introduce another callback safe_freq()
> >>>> for the cpufreq drivers.
> >>>>
> >>>> safe_freq() should return a stable intermediate frequency a platform might want
> >>>> to switch to, before jumping to the frequency corresponding to 'index'. Core
> >>>> will send the 'PRE' notification for this 'stable' frequency and 'POST' for the
> >>>> 'target' frequency. Though if ->target_index() fails, it will handle POST for
> >>>> 'stable' frequency only.
> >>>>
> >>>> Drivers must send 'POST' notification for 'stable' freq and 'PRE' for 'target'
> >>>> freq. If they can't switch to target frequency, they don't need to send any
> >>>> notification.
> >>>
> >>> This seems rather complex. Can't either the driver or the cpufreq core
> >>> be responsible for all of the notifications? Otherwise, the logic gets
> >>> rather complex, and spread between the core and the driver.
> >>>
> >>> Perhaps the core should make separate calls into the driver to switch to
> >>> the temporary frequency and the final frequency, so it can manage all
> >>> the notifications. Probably best to use a separate function pointer for
> >>> the temporary change so the driver can easily know what it's doing.
> >>
> >> In the discussion about the exynos cpufreq redesign (atop
> >> cpufreq-cpu0), it turns out that they've come up with a pretty
> >> reasonable solution that also happens to solve our problem.  They
> >> utilize an extra divider to make sure that the temporary PLL gets
> >> divided down so that it's low enough.
> >>
> >> It might mean that going between 300 MHz and 500 MHz that you will
> >> transition through 400 MHz, but I'm quite OK with not sending out a
> >> notification for that.
> >>
> >> If something like that could work for tegra, then maybe we can drop
> >> this whole thing and it will all just fix itself.  ;)
> >
> > At least in the case of Tegra20 cpufreq, I don't think that will be
> > possible at least without changing the temporary clock source we use
> > (pll_p). The PLL that's use temporarily is also the root of all the
> > peripheral clocks, and hence can't be changed. We also only characterize
> > that PLL at the one specific frequency it was designed to run at.
> 
> It's interesting, in the exynos case they didn't change the PLL itself
> but found an extra divider that I wasn't actually aware existed.  It
> was located after the mux and before the cpu.
> 
> 

We do have a divider between the mux and clocksource as well, but we never use
it except from Tegra114 onwards for hw controlled thermal throttling (more as
an emergency measure in case sw fails to react in time). Tegra also has a
microsecond counter which could be used for udelay() on parts which don't have
the arch counter (Tegra20 and Tegra30). For Tegra114 and Tegra124 we use the
arch counter, so there shouldn't be a problem.

Cheers,

Peter.
