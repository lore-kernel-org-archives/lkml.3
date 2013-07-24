Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3GXNuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:50:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37702 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXNuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:50:14 -0400
Date: Wed, 24 Jul 2013 14:50:11 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130724135011.GE12572@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
 <20130715203922.GD23818@dyad.programming.kicks-ass.net>
 <20130716124248.GB10036@arm.com>
 <51E5655C.7050304@linux.intel.com>
 <20130717141426.GG27948@arm.com>
MIME-Version: 1.0
In-Reply-To: <20130717141426.GG27948@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jul 2013 13:50:11.0309 (UTC) FILETIME=[B74B91D0:01CE8874]
X-MC-Unique: 113072414501202201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 03:14:26PM +0100, Catalin Marinas wrote:
> On Tue, Jul 16, 2013 at 04:23:08PM +0100, Arjan van de Ven wrote:
> > On 7/16/2013 5:42 AM, Catalin Marinas wrote:
> > > Morten's power scheduler tries to address the above and it will grow
> > > into controlling a new model of power driver (and taking into account
> > > Arjan's and others' comments regarding the API). At the same time, we
> > > need some form of task packing. The power scheduler can drive this
> > > (currently via cpu_power) or can simply turn a knob if there are better
> > > options that will be accepted in the scheduler.
> > 
> > how much would you be helped if there was a simple switch
> > 
> > sort left   versus    sort right
> > 
> > (assuming the big cores are all either low or high numbers)
> 
> It helps a bit compared to the current behaviour but there is a lot of
> room for improvement.
> 
> > the sorting is mostly statistical, but that's good enough in practice..
> > each time a task wakes up, you get a bias towards either low or high
> > numbered idle cpus
> 
> If cores within a cluster (socket) are not power-gated individually
> (implementation dependent), it makes more sense to spread the tasks
> among the cores to either get a lower frequency or just get to idle
> quicker. For little cores, even when they are individually power-gated,
> they don't consume much so we would rather spread the tasks equally.
> 
> > very quickly all tasks will be on one side, unless your system is so
> > loaded that all cpus are full.
> 
> It should be more like left socket vs both sockets with the possibility
> of different balancing within a socket. But then we get back to the
> sched_smt/sched_mc power aware scheduling that was removed from the
> kernel.
> 
> It's also important when to make this decision to sort left vs right and
> we want to avoid migrating threads unnecessarily. There could be small
> threads (e.g. an mp3 decoding thread) that should stay on the little
> core.

Given that the power topology is taken into account, a sort
left/right-like mechanism would only help performance insensitive tasks
on big.LITTLE. Performance sensitive tasks that each can use more than
a little cpu should move in the opposite direction. Well, directly to a
big cpu, even if some little cpus are idle.

It can be discussed whether smaller performance sensitive tasks that
would fit on a little cpu should be put on a little or big cpu. That
would depend on the nature of the task and if other tasks depend on it.


