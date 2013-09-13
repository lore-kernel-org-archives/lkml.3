Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3IMXhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:37:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55562 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab3IMXha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:37:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Sat, 14 Sep 2013 01:48:35 +0200
Message-ID: <9715082.jFAchu7UKu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <5197493.kSPF7VUWqc@vostro.rjw.lan> <CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 13, 2013 05:14:26 PM Viresh Kumar wrote:
> On 4 September 2013 01:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, September 03, 2013 06:50:05 PM Srivatsa S. Bhat wrote:
> 
> >> This doesn't solve the problem completely: it prevents the store_*() task
> >> from continuing *only* when it concurrently executes the __cpufreq_governor()
> >> function along with the CPU offline task. But if the two calls don't overlap,
> >> we will still have the possibility where the store_*() task tries to acquire
> >> the timer mutex after the CPU offline task has just finished destroying it.
> >
> > Yeah, I overlooked that.
> 
> As a background, I had a IRC chat with Srivatsa on this mail.. (I have marked
> this unread as there were other important topics to close)..
> 
> And he had some other code in mind and these synchronization problems
> aren't there with my patch at all (as per him too)..
> 
> Rafael, probably both me and Srivatsa are missing something that you
> understood, can you please share what problem you see here with my patch?
> 
> And yes, even with Srivatsa's patchset I found a problem:
> Two threads, one changing governor from ondemand->conservative and other
> one changing min/max freq..
> 
> First one will try to STOP governor and other one will try to change
> limits of gov.
> Suppose 2nd one gets to ->governor() and after this first one stops
> the governor.
> Now the first one tries to access lock and crashes..
> 
> On IRC, Srivatsa agreed about the problem..
> 
> So, probably the first thing to do is to get this patch back, i.e.
> revert of Srivatsa's
> patch:
> 
> commit 56d07db274b7b15ca38b60ea4a762d40de093000
> Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Date:   Sat Sep 7 01:23:55 2013 +0530
> 
>     cpufreq: Remove temporary fix for race between CPU hotplug and sysfs-writes
> 
> 
> Srivatsa also asked if we can get a big lock around call to ->governor()
> which would create recursive locks on a call to EXIT event (as we have seen it
> earlier..)..
> 
> But he believes he can pull it off and will try this later.. So, for
> now we can revert
> the above patch :)

OK, I'll think about that, but not today and probably not within the next
few days, because I'm heading to New Orleans in several hours and really
have other stuff to take care of now.  Sorry about that.

Thanks,
Rafael

