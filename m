Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaBBVe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:34:27 -0500
Received: from mail.eperm.de ([89.247.134.16]:41683 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaBBVe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:34:26 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 16:34:25 EST
From: Stephan Mueller <smueller@chronox.de>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Date: Sun, 02 Feb 2014 22:25:31 +0100
Message-ID: <16782692.5vMS7Bhbvf@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140202203617.GA9499@logfs.org>
References: <20140202203617.GA9499@logfs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. Februar 2014, 15:36:17 schrieb Jörn Engel:

Hi Jörn,

> Collects entropy from random behaviour all modern cpus exhibit.  The
> scheduler and slab allocator are instrumented for this purpose.  How
> much randomness can be gathered is clearly hardware-dependent and hard
> to estimate.  Therefore the entropy estimate is zero, but random bits
> still get mixed into the pools.

May I ask what the purpose of the patches is when no entropy is implied? I see 
that the pool is stirred more. But is that really a problem that needs 
addressing?

Please, do not get me wrong with the presented critisism here -- the approach 
in general looks interesting.

However, the following patches makes me wonder big time.

>  extern void get_random_bytes(void *buf, int nbytes);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index a88f4a485c5e..7af6389f9b9e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2511,6 +2511,7 @@ need_resched:
>  	rq = cpu_rq(cpu);
>  	rcu_note_context_switch(cpu);
>  	prev = rq->curr;
> +	__add_cpu_randomness(__builtin_return_address(1), prev);
> 
>  	schedule_debug(prev);
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index eb043bf05f4c..ea5a30d44ad1 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3587,6 +3587,7 @@ static __always_inline void *__do_kmalloc(size_t size,
> gfp_t flags, trace_kmalloc(caller, ret,
>  		      size, cachep->size, flags);
> 
> +	add_cpu_randomness(__builtin_return_address(2), ret);
>  	return ret;
>  }

First, the noise source you add is constantly triggered throughout the 
execution of the kernel. Entropy is very important, we (who are interested in 
crypto) know that. But how often is entropy needed? Other folks wonder about 
the speed of the kernel. And with these two patches, every kmalloc and every 
scheduling invocation now dives into the random.c code to do something. I 
would think this is a bit expensive, especially to stir the pool without 
increasing the entropy estimator. I think entropy collection should be 
performed when it is needed and not throughout the lifetime of the system.

Second, when I offered my initial patch which independently collects some 
entropy on the CPU execution timing, I got shot down with one concern raised 
by Ted, and that was about whether a user can influence the entropy collection 
process. When I am trying to measure CPU execution timing in the RNG, the 
concern was raised that the measured timing variations was due to CPU states 
that were influenced by users. Your patch here clearly hooks into code paths 
which are definitely affected by user actions. So, this patch therefore would 
be subject to the same concerns. I personally think that this is not so much 
an issue, yet it was raised previously.

It seems I have a bad timing, because just two days ago I released a new 
attempt on the CPU jitter RNG [1] with a new noise source, and I was just 
about to prepare a release email. With that attempt, both issues raised above 
are addressed, including a theoretical foundation of the noise source.

[1] http://www.chronox.de/

Ciao
Stephan
-- 
| Cui bono? |
