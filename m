Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3JQRSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:18:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:59839 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab3JQRSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:18:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,515,1378882800"; 
   d="scan'208";a="418511992"
Message-ID: <52601BEE.5090500@linux.intel.com>
Date: Thu, 17 Oct 2013 10:18:38 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
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
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com> <20131014133356.GN3081@twins.programming.kicks-ass.net> <525C0A51.2080407@linux.intel.com> <20131017164038.GV31039@e103034-lin> <20131017165416.GW10651@twins.programming.kicks-ass.net>
In-Reply-To: <20131017165416.GW10651@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> cpufreq has pre- and post-change notifiers so the current TC2 clock driver

yeah those are EVIL ;-)

>> waits (yields) in its clk_set_rate() implementation until the change has
>> happened to ensure that the post-change notifier happens at the right
>> time. Since clk_set_rate() is allowed to sleep other tasks may be
>> running while waiting for the change to complete. This may be true for
>> other clock drivers as well.
>>
>> AFAICT, there is no way to reuse the existing cpufreq drivers in a
>> sensible way for scheduler driven frequency scaling.

that's the conclusion we came to as well about a year ago (and is also
why we're no longer using cpufreq core for the Intel pstate driver.
the locking/sleeping/callback/cpuhotplug/sysfs/etc stuff is just a MESS
for something that ends up being extremely simple if you just code the
sequence... for us it's just one register write to change... which shows this as an
extreme obviously)


>
> Note that you still have preemption disabled in your late callback from
> finish_task_switch(). There's no way you can wait/yield/whatever from
> there. Nor is that really sane.

the other fun one with this could be that if you have a series of scheduleable tasks
for changing stuff.... somehow you want to keep ordering in the requests, and only do
the last one/etc.
Not Fun(tm)



