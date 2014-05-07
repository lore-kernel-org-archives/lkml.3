Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaEGHgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:36:03 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41011 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaEGHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:36:00 -0400
Date: Wed, 7 May 2014 09:35:36 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression in v3.14
Message-ID: <20140507073536.GA1973@localhost>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:10:34AM +0530, Viresh Kumar wrote:
> Cc'ing Dirk who is taking care of intel-pstate driver.
> 
> On 6 May 2014 22:05, Johan Hovold <jhovold@gmail.com> wrote:
> > After updating my main system from v3.13 to v3.14.2, I found that the
> > git bash-completion was extremely sluggish. Completing a file name would
> > take roughly six rather than one second on this Haswell machine
> > (i7-4770). (Other things, such as git rebase, also felt slower, but
> > the completion issue was much more obvious and easy to measure).
> >
> > I managed to reproduce the problem using the following minimal construct
> >
> >         cat dmesg.repeat | while read x; do true; done
> >
> > where dmesg.repeat is simply dmesg concatenated together to an
> > equivalent number of lines as produced by git ls-files in the
> > kernel-source tree root (45k), and where the actual processing of each
> > line has been removed.
> >
> > Most of the time I get:
> >
> >         $ time cat dmesg.repeat | while read x; do true; done
> >
> >         real    0m6.091s
> >         user    0m3.674s
> >         sys     0m2.447s
> >
> > but sometimes it only takes one second.
> >
> >         $ time cat dmesg.repeat | while read x; do true; done
> >
> >         real    0m1.100s
> >         user    0m0.544s
> >         sys     0m0.570s
> >
> > I don't seem to be able to reproduce the problem on 3.13 where the pipe
> > always takes about one second to finish.
> >
> > Taking all but one core offline seems to make the problem go away, and so
> > does using the performance rather than powersave governor of the
> > intel_pstate cpufreq driver (on at least one of two online cores).
> >
> > Moving the mouse cursor makes to loop finish faster, and so does
> > switching to a another terminal to print cpufreq/cpuinfo_cur_freq which
> > was around cpuinfo_min_freq several times (when tracing, see below).

<snip>

> I tried to take a look at the diff for cpufreq between 3.13 and 3.14.2 and
> couldn't pin point on any change which might cause it. Don't have a clue
> of what's going on. I don't know how to help you on this.
> 
> Normally I test my stuff on a ARM board and I don't remember facing
> any such behavior there. There might be something wrong with intel-pstate
> as well..
> 
> Also, can you try to use acpi-cpufreq instead? And see how that is behaving?

Using acpi-cpufreq and the ondemand governor (with all 8 cores
online) on 3.14.3 improves the situation somewhat:

	$ time cat dmesg.repeat | while read x; do true; done
	
	real    0m1.989s
	user    0m1.257s
	sys     0m0.747s

when the system is idle, and

	$ time cat dmesg.repeat | while read x; do true; done
	
	real    0m1.191s
	user    0m0.753s
	sys     0m0.449s
	
when run a second time in immediate succession.

When running the same tests on 3.13.11, the figures are roughly the same

	$ time cat dmesg.repeat | while read x; do true; done
	
	real    0m2.075s
	user    0m1.276s
	sys     0m0.816s

	$ time cat dmesg.repeat | while read x; do true; done
	
	real    0m1.291s
	user    0m0.800s
	sys     0m0.504s

So I guess that idle-active difference is normal for acpi-cpufreq and
that the problem only arises in or with the intel_pstate driver.

Thanks,
Johan
