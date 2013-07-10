Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3GJNFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:05:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:32087 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3GJNFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:05:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="363120055"
Message-ID: <51DD5BFC.8000102@linux.intel.com>
Date: Wed, 10 Jul 2013 06:05:00 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com> <20130710111627.GC15989@e103687>
In-Reply-To: <20130710111627.GC15989@e103687>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>>
>> also, it almost looks like there is a fundamental assumption in the code
>> that you can get the current effective P state to make scheduler decisions on;
>> on Intel at least that is basically impossible... and getting more so with every generation
>> (likewise for AMD afaics)
>>
>> (you can get what you ran at on average over some time in the past, but not
>> what you're at now or going forward)
>>
>
> As described above, it is not a strict assumption. From a scheduler
> point of view we somehow need to know if the cpus are truly fully
> utilized (at their highest P-state)

unfortunately we can't provide this on Intel ;-(
we can provide you what you ran at average, we cannot provide you if that is the max or not

(first of all, because we outright don't know what the max would have been, and second,
because we may be running slower than max because the workload was memory bound or
any of the other conditions that makes the HW P state "governor" decide to reduce
frequency for efficiency reasons)

> so we need to throw more cpus at the
> problem (assuming that we have more than one task per cpu) or if we can
> just go to a higher P-state. We don't need a strict guarantee that we
> get exactly the P-state that we request for each cpu. The power
> scheduler generates hints and the power driver gives us feedback on what
> we can roughly expect to get.


>
>> I'm rather nervous about calculating how many cores you want active as a core scheduler feature.
>> I understand that for your big.LITTLE architecture you need this due to the asymmetry,
>> but as a general rule for more symmetric systems it's known to be suboptimal by quite a
>> real percentage. For a normal Intel single CPU system it's sort of the worst case you can do
>> in that it leads to serializing tasks that could have run in parallel over multiple cores/threads.
>> So at minimum this kind of logic must be enabled/disabled based on architecture decisions.
>
> Packing clearly has to take power topology into account and do the right
> thing for the particular platform. It is not in place yet, but will be
> addressed. I believe it would make sense for dual cpu Intel systems to
> pack at socket level?

a little bit. if you have 2 quad core systems, it will make sense to pack 2 tasks
onto a single core, assuming they are not cache or memory bandwidth bound (remember this is numa!)
but if you have 4 tasks, it's not likely to be worth it to pack, unless you get an enormous
economy of scale due to cache sharing
(this is far more about getting numa balancing right than about power; you're not very likely
to win back the power you loose from inefficiency if you get the numa side wrong by being
too smart about power placement)


