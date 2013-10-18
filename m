Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3JRIrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:47:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57906 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3JRIra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:47:30 -0400
Date: Fri, 18 Oct 2013 09:47:37 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
Message-ID: <20131018084737.GX31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
 <20131014133356.GN3081@twins.programming.kicks-ass.net>
 <525C0A51.2080407@linux.intel.com>
 <20131017164038.GV31039@e103034-lin>
 <20131017165416.GW10651@twins.programming.kicks-ass.net>
 <52601BEE.5090500@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <52601BEE.5090500@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Oct 2013 08:47:27.0185 (UTC) FILETIME=[AC28B410:01CECBDE]
X-MC-Unique: 113101809472803801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 06:18:38PM +0100, Arjan van de Ven wrote:
> >>
> >> cpufreq has pre- and post-change notifiers so the current TC2 clock driver
> 
> yeah those are EVIL ;-)
> 
> >> waits (yields) in its clk_set_rate() implementation until the change has
> >> happened to ensure that the post-change notifier happens at the right
> >> time. Since clk_set_rate() is allowed to sleep other tasks may be
> >> running while waiting for the change to complete. This may be true for
> >> other clock drivers as well.
> >>
> >> AFAICT, there is no way to reuse the existing cpufreq drivers in a
> >> sensible way for scheduler driven frequency scaling.
> 
> that's the conclusion we came to as well about a year ago (and is also
> why we're no longer using cpufreq core for the Intel pstate driver.
> the locking/sleeping/callback/cpuhotplug/sysfs/etc stuff is just a MESS
> for something that ends up being extremely simple if you just code the
> sequence... for us it's just one register write to change... which shows this as an
> extreme obviously)

We should be able to boil it down to a sequence on ARM as well. But it
means dropping cpufreq and looking at the clock framework.

Are you still using the pre- and post-change notifiers on Intel, or can
they be ignored safely?

> 
> 
> >
> > Note that you still have preemption disabled in your late callback from
> > finish_task_switch(). There's no way you can wait/yield/whatever from
> > there. Nor is that really sane.
> 
> the other fun one with this could be that if you have a series of scheduleable tasks
> for changing stuff.... somehow you want to keep ordering in the requests, and only do
> the last one/etc.
> Not Fun(tm)

Agreed, I don't want to go there. Also, the overhead will probably kill any
benefit that there might be.

