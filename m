Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3H3Sdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:33:32 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:47923 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3H3Sda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:33:30 -0400
Message-ID: <5220E56A.80603@hp.com>
Date: Fri, 30 Aug 2013 14:33:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com> <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com> <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
In-Reply-To: <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:54 PM, Linus Torvalds wrote:
> On Thu, Aug 29, 2013 at 8:12 PM, Waiman Long<waiman.long@hp.com>  wrote:
>> On 08/29/2013 07:42 PM, Linus Torvalds wrote:
>>> Waiman? Mind looking at this and testing? Linus
>> Sure, I will try out the patch tomorrow morning and see how it works out for
>> my test case.
> Ok, thanks, please use this slightly updated pCMPXCHG_LOOPatch attached here.
>
>

I tested your patch on a 2-socket (12 cores, 24 threads) DL380 with 
2.9GHz Westmere-EX CPUs, the test results of your test program (max 
threads increased to 24 to match the thread count) were:

with patch = 68M
w/o patch = 12M

So it was an almost 6X improvement. I think that is really good. A 
dual-socket machine, these days, shouldn't be considered as a "BIG" 
machine. They are pretty common in different organizations.

I have reviewed the patch, and it looks good to me with the exception 
that I added a cpu_relax() call at the end of while loop in the 
CMPXCHG_LOOP macro.

I also got the perf data of the test runs with and without the patch.

With patch:

  29.24%    a.out  [kernel.kallsyms]    [k] lockref_get_or_lock
  19.65%    a.out  [kernel.kallsyms]    [k] lockref_put_or_lock
  14.11%    a.out  [kernel.kallsyms]    [k] dput
   5.37%    a.out  [kernel.kallsyms]    [k] __d_lookup_rcu
   5.29%    a.out  [kernel.kallsyms]    [k] lg_local_lock
   4.59%    a.out  [kernel.kallsyms]    [k] d_rcu_to_refcount
     :
   0.13%    a.out  [kernel.kallsyms]    [k] complete_walk
     :
   0.01%    a.out  [kernel.kallsyms]    [k] _raw_spin_lock

Without patch:

  93.50%    a.out  [kernel.kallsyms]    [k] _raw_spin_lock
   0.96%    a.out  [kernel.kallsyms]    [k] dput
   0.80%    a.out  [kernel.kallsyms]    [k] kmem_cache_free
   0.75%    a.out  [kernel.kallsyms]    [k] lg_local_lock
   0.48%    a.out  [kernel.kallsyms]    [k] complete_walk
   0.45%    a.out  [kernel.kallsyms]    [k] __d_lookup_rcu

For the other test cases that I am interested in, like the AIM7 
benchmark, your patch may not be as good as my original one. I got 1-3M 
JPM (varied quite a lot in different runs) in the short workloads on a 
80-core system. My original one got 6M JPM. However, the test was done 
on 3.10 based kernel. So I need to do more test to see if that has an 
effect on the JPM results.

Anyway, I think this patch is good performance-wise. I remembered that 
awhile ago that an internal reported a lock contention problem in dentry 
involving probably complete_walk(). This patch will certainly help for 
that case.

I will do more investigation to see how to make this patch work better 
for my test cases.

Thank for taking the effort in optimizing the complete_walk() and 
unlazy_walk() function that are not in my original patch. That will make 
the patch work even better under more circumstances. I really appreciate 
that.

Best regards,
Longman



