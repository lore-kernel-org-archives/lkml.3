Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaEUJBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:01:23 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62681 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEUJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:01:18 -0400
Date: Wed, 21 May 2014 11:00:51 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Johan Hovold <jhovold@gmail.com>,
        dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression in v3.14
Message-ID: <20140521090051.GO21412@localhost>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
 <536A3EE9.5050409@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A3EE9.5050409@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:10:49AM -0700, Dirk Brandewie wrote:
> On 05/06/2014 10:40 PM, Viresh Kumar wrote:
> > Cc'ing Dirk who is taking care of intel-pstate driver.
> >
> 
> Thanks Viresh I had seen this thread.
> 
> I am looking into it

Any updates on this, Dirk? 3.14 is still basically unusable with the
intel_pstate driver.

Any fixes or workarounds posted elsewhere that I can apply in the
meantime?

Thanks,
Johan

> > On 6 May 2014 22:05, Johan Hovold <jhovold@gmail.com> wrote:
> >> After updating my main system from v3.13 to v3.14.2, I found that the
> >> git bash-completion was extremely sluggish. Completing a file name would
> >> take roughly six rather than one second on this Haswell machine
> >> (i7-4770). (Other things, such as git rebase, also felt slower, but
> >> the completion issue was much more obvious and easy to measure).
> >>
> >> I managed to reproduce the problem using the following minimal construct
> >>
> >>          cat dmesg.repeat | while read x; do true; done
> >>
> >> where dmesg.repeat is simply dmesg concatenated together to an
> >> equivalent number of lines as produced by git ls-files in the
> >> kernel-source tree root (45k), and where the actual processing of each
> >> line has been removed.
> >>
> >> Most of the time I get:
> >>
> >>          $ time cat dmesg.repeat | while read x; do true; done
> >>
> >>          real    0m6.091s
> >>          user    0m3.674s
> >>          sys     0m2.447s
> >>
> >> but sometimes it only takes one second.
> >>
> >>          $ time cat dmesg.repeat | while read x; do true; done
> >>
> >>          real    0m1.100s
> >>          user    0m0.544s
> >>          sys     0m0.570s
> >>
> >> I don't seem to be able to reproduce the problem on 3.13 where the pipe
> >> always takes about one second to finish.
> >>
> >> Taking all but one core offline seems to make the problem go away, and so
> >> does using the performance rather than powersave governor of the
> >> intel_pstate cpufreq driver (on at least one of two online cores).
> >>
> >> Moving the mouse cursor makes to loop finish faster, and so does
> >> switching to a another terminal to print cpufreq/cpuinfo_cur_freq which
> >> was around cpuinfo_min_freq several times (when tracing, see below).
> >>
> >> I could not reproduce the problem when using perf record, but I can get
> >> function-profile traces using ftrace (in which case the loop takes about
> >> 60 seconds instead of six seconds to finish).
> >>
> >> Comparing the traces I see a lot of functions taking ten times longer to
> >> finish, but I guess that's expected if this is indeed a cpufreq issue.
> >>
> >> Since this is my main machine (and only multi-core machine at the
> >> moment) I'm not able to bisect this myself. And for the same reason I
> >> have not verified that the problem persists in v3.15-rc.
> >>
> >> I don't see any cpufreq patches in the v3.14.3 stable queue nor anything
> >> obviously related and marked for stable in v3.15-rc.
> >>
> >> Any ideas about what might be going on?
> >
> > I tried to take a look at the diff for cpufreq between 3.13 and 3.14.2 and
> > couldn't pin point on any change which might cause it. Don't have a clue
> > of what's going on. I don't know how to help you on this.
> >
> > Normally I test my stuff on a ARM board and I don't remember facing
> > any such behavior there. There might be something wrong with intel-pstate
> > as well..
> >
> > Also, can you try to use acpi-cpufreq instead? And see how that is behaving?
> >
> > --
> > viresh
