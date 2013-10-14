Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3JNRPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:15:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48772 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3JNRPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:15:37 -0400
Date: Mon, 14 Oct 2013 18:15:41 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/7] Power-aware scheduling v2
Message-ID: <20131014171541.GP31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <20131014133234.GM3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20131014133234.GM3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Oct 2013 17:15:33.0346 (UTC) FILETIME=[FDACB420:01CEC900]
X-MC-Unique: 113101418153405101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:32:34PM +0100, Peter Zijlstra wrote:
> On Fri, Oct 11, 2013 at 06:19:10PM +0100, Morten Rasmussen wrote:
> > Hi,
> > 
> > I have revised the previous power scheduler proposal[1] trying to address as
> > many of the comments as possible. The overall idea was discussed at LPC[2,3].
> > The revised design has removed the power scheduler and replaced it with a high
> > level power driver interface. An interface that allows the scheduler to query
> > the power driver for information and provide hints to guide power management
> > decisions in the power driver.
> > 
> > The power driver is going to be a unified platform power driver that can
> > replace cpufreq and cpuidle drivers. Generic power policies will be optional
> > helper functions called from the power driver. Platforms may choose to
> > implement their own policies as part of their power driver.
> > 
> > This RFC series prototypes a part of the power driver interface (cpu capacity
> > hints) and shows how they can be used from the scheduler. More extensive use of
> > the power driver hints and queries is left for later. The focus for now is the
> > power driver interface. The patch series includes a power driver/cpufreq
> > governor that can use existing cpufreq drivers as backend. It has been tested
> > (not thoroughly) on ARM TC2. The cpufreq governor power driver implementation
> > is rather horrible, but it illustrates how the power driver interface can be
> > used. Native power drivers is on the todo list.
> > 
> > The power driver interface is still missing quite a few calls to handle: Idle,
> > adding extra information to the sched_domain hierarchy to guide scheduling
> > decisions (packing), and possibly scaling of tracked load to compensate for
> > frequency changes and asymmetric systems (big.LITTLE).
> > 
> > This set is based on 3.11. I have done ARM TC2 testing based on linux-linaro
> > 2013.08[4] to get cpufreq support for TC2.
> 
> What I'm missing is a general overview of why what and how.
> 
> In particular; how does this proposal lead to power savings. Is there a
> mathematical model that supports this framework? Something where if you
> give it a task set with global utilisation < 1 (ie. there's idle time),
> it results in less power used.

It is not there yet. What I'm proposing here is just the interface with
some very simple examples of how they can be used. It is not the
complete set of hooks, but a starting point. In the first round of
discussions it was clear that it is quite important to find an interface
that can work for everyone. To find a good power optimization model we
first need to know what information the platform (represented by the
power driver) can provide.

With guidance from the power driver about what level performance we can
expect from a cpu, and possibly also the power cost, we can make better
load-balancing decisions. We can add task packing support and let the
platform decide the degree of packing that meets the power/performance
target.

> 
> Also, how does this proposal deal with cpufreq's fundamental broken
> approach to SMP? Afaict nothing considers the effect of one cpu upon
> another -- something which isn't true at all.

If you are referring to not doing anything clever with the affected cpus
in the power driver then yes. I doesn't do anything clever at the
moment. However, the go_faster/slower() interface would allow the power
driver to refuse increasing the frequency if the power cost can't be
justified for some reason. Using the power driver interface the
scheduler will know this and be able to try a different balance. Spread
load to other cpus in the same frequency domain that are less loaded, if
possible.

> 
> In fact, I don't see anything except a random bunch of hooks without an
> over-all picture of how to get less power used.

I will follow up with a better description of the overall picture. The
slides I linked to are not really self-explaining.

Thanks,
Morten

