Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3H3Wsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:48:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49959 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3H3Wse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:48:34 -0400
Message-ID: <52212128.3000100@infradead.org>
Date: Fri, 30 Aug 2013 15:48:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        bernie@develer.com
Subject: Re: do_div() silently truncates "base" to 32bit
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com> <52210D34.5030807@infradead.org> <CAOMFOmUav+3UqR9s5LF6n4c4oXZ-K5oBJrmLtz-PMY053vH8Rg@mail.gmail.com>
In-Reply-To: <CAOMFOmUav+3UqR9s5LF6n4c4oXZ-K5oBJrmLtz-PMY053vH8Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/13 15:14, Anatol Pomozov wrote:
> Hi
> 
> On Fri, Aug 30, 2013 at 2:23 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 08/30/13 10:21, Anatol Pomozov wrote:
>>> Hi,
>>>
>>>
>>> I was debugging weird "zero divide" problem in CFQ code below
>>>
>>>
>>> static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
>>>       struct blkg_policy_data *pd, int off)
>>> {
>>>     struct cfq_group *cfqg = pd_to_cfqg(pd);
>>>     u64 samples = blkg_stat_read(&cfqg->stats.avg_queue_size_samples);
>>>     u64 v = 0;
>>>
>>>     if (samples) {
>>>         v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
>>>         do_div(v, samples);
>>>     }
>>>     __blkg_prfill_u64(sf, pd, v);
>>>     return 0;
>>> }
>>>
>>>
>>> do_div() crashes says "zero divide". It is weird because just a few
>>> lines above we check divider for zero.
>>>
>>>
>>> The problem comes from include/asm-generic/div64.h file that
>>> implements do_div() as macros:
>>>
>>> # define do_div(n,base) ({ \
>>>     uint32_t __base = (base); \
>>>     uint32_t __rem; \
>>>     __rem = ((uint64_t)(n)) % __base; \
>>>     (n) = ((uint64_t)(n)) / __base; \
>>>     __rem; \
>>>  })
>>>
>>>
>>> Do you see the problem?
>>>
>>> The problem here is that "base" argument is truncated to 32bit, but in
>>> the function above "sample" is 64bit variable. If sample's 32 low bits
>>> are zero - we have a crash. in fact we have incorrect behavior any
>>> time when high 32bits are non-zero.
>>>
>>>
>>> My question is why the base is 32bit? Why not to use 64bit arguments?
>>
>> Maybe performance related?
>>
>> If you want 64-bit values, don't use do_div() from asm-generic/div64.h.
>>
>> Instead look at linux/math64.h and use div_u64_rem() et al
>> or the recently posted div64_u64_rem().
>> [posted by Mike Snitzer on Aug. 21 2013]
>>
>> I.e., use exactly the function(s) that you need to use.
>>
>> Does that fix the problem?
> 
> It definitely fixes the crash. I've already sent a patch to CFQ
> maillist http://news.gmane.org/gmane.linux.kernel.cgroups
> 
> But another question still remains: why compiler does not warn that
> size truncation happens? How to prevent bugs like CFQ one in the
> future? Should we add a compile-time assert to do_div() to prevent
> passing 64 numbers in "base" macro parameter?


That sounds like a fine idea to me.

-- 
~Randy
