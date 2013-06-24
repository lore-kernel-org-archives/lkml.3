Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3FXUhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:37:03 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49670 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845Ab3FXUhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:37:00 -0400
Date: Mon, 24 Jun 2013 15:36:57 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130624203657.GA107621@asylum.americas.sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130623092840.GB13445@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
> 
> That's 4.5 GB/sec initialization speed - that feels a bit slow and the 
> boot time effect should be felt on smaller 'a couple of gigabytes' desktop 
> boxes as well. Do we know exactly where the 2 hours of boot time on a 32 
> TB system is spent?
> 
There are other several spots that could be improved on a large system but 
memory initialization is by far the biggest.

> While you cannot profile the boot process (yet), you could try your 
> delayed patch and run a "perf record -g" call-graph profiling of the 
> late-time initialization routines. What does 'perf report' show?
> 

I have some data from earlier runs.
memmap_init_zone was the function that was the biggest hitter by far.
Parts of it could certianly are low hanging fruit, set_pageblock_migratetype
for example.
However it seems for a larger system SetPageReserved will be the largest
consumer of cycles.  On a 1TB system I just booted it was around 50% of time
spent in memmap_init_zone.


perf seems to struggle with 512 cpus, but I did get some data.
It seems to indicate similar data to what I found in earlier experiments.
Lots of time in memmap_init_zone,
Some are waiting on locks, this guy seems to be representative of that.

-      0.14%    kworker/160:1  [kernel.kallsyms]        [k] mspin_lock                               ▒
   + mspin_lock                                                                                      ▒
   + __mutex_lock_slowpath                                                                           ▒
   - mutex_lock                                                                                      ▒
      - 99.69% online_pages             

> Delayed initialization makes sense I guess because 32 TB is a lot of 
> memory - I'm just wondering whether there's some low hanging fruits left 
> in the mem init code, that code is certainly not optimized for 
> performance.
>
> Plus with a struct page size of around 64 bytes (?) 32 TB of RAM has 512 
> GB of struct page arrays alone. Initializing those will take quite some 
> time as well - and I suspect they are allocated via zeroing them first. If 
> that memset() exists then getting rid of it might be a good move as well.
> 
> Yet another thing to consider would be to implement an initialization 
> speedup of 3 orders of magnitude: initialize on the large page (2MB) 
> grandularity and on-demand delay the initialization of the 4K granular 
> struct pages [but still allocating them] - which I suspect are a good 
> chunk of the overhead? That way we could initialize in 2MB steps and speed 
> up the 2 hours bootup of 32 TB of RAM to 14 seconds...
> 
> [ The cost would be one more branch in the buddy allocator, to detect
>   not-yet-initialized 2 MB chunks as we encounter them. Acceptable I 
>   think. ]
> 
> Thanks,
> 
> 	Ingo
