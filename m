Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3IERyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:54:47 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16592 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IERyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:54:46 -0400
Message-ID: <5228C559.1090509@hp.com>
Date: Thu, 05 Sep 2013 13:54:33 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockref: remove cpu_relax() again
References: <20130905131814.GA24274@osiris> <CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
In-Reply-To: <CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 11:31 AM, Linus Torvalds wrote:
> On Thu, Sep 5, 2013 at 6:18 AM, Heiko Carstens
> <heiko.carstens@de.ibm.com>  wrote:
>> *If* however the cpu_relax() makes sense on other platforms maybe we could
>> add something like we have already with "arch_mutex_cpu_relax()":
> I actually think it won't.
>
> The lockref cmpxchg isn't waiting for something to change - it only
> loops _if_ something has changed, and rather than cpu_relax(), we most
> likely want to try to take advantage of the fact that we have the
> changed data in our exclusive cacheline, and try to get our ref update
> out as soon as possible.
>
> IOW, the lockref loop is not an idle loop like a spinlock "wait for
> lock to be released", it's very much an active loop of "oops,
> something changed".
>
> And there can't be any livelock, since by definition somebody else
> _did_ make progress. In fact, adding the cpu_relax() probably just
> makes things much less fair - once somebody else raced on you, the
> cpu_relax() now makes it more likely that _another_ cpu does so too.
>
> That said, let's see Tony's numbers are. On x86, it doesn't seem to
> matter, but as Tony noticed, the variability can be quite high (for
> me, the numbers tend to be quite stable when running the test program
> multiple times in a loop, but then variation between boots or after
> having done something else can be quite big - I suspect the cache
> access patterns end up varying wildly with different dentry layout and
> hash chain depth).
>
>                Linus
I have found that having a cpu_relax() at the bottom of the while
loop in CMPXCHG_LOOP() macro does help performance in some case on
x86-64 processors. I saw no noticeable difference for the AIM7's
short workload. On the high_systime workload, however, I saw about 5%
better performance with cpu_relax(). Below were the perf profile of
the 2 high_systime runs at 1500 users on a 80-core DL980 with HT off.

Without cpu_relax():

      4.60%     ls  [kernel.kallsyms]     [k] _raw_spin_lock
                   |--48.50%-- lockref_put_or_lock
                   |--46.97%-- lockref_get_or_lock
                   |--1.04%-- lockref_get

      2.95%     reaim  [kernel.kallsyms]     [k] _raw_spin_lock
                   |--29.70%-- lockref_put_or_lock
                   |--28.87%-- lockref_get_or_lock
                   |--0.63%-- lockref_get


With cpu_relax():

      1.67%     reaim  [kernel.kallsyms]     [k] _raw_spin_lock
                   |--14.80%-- lockref_put_or_lock
                   |--14.04%-- lockref_get_or_lock

      1.36%     ls  [kernel.kallsyms]     [k] _raw_spin_lock
                   |--44.94%-- lockref_put_or_lock
                   |--43.12%-- lockref_get_or_lock

So I would suggest having some kind of conditional cpu_relax() in
the loop.

-Longman



