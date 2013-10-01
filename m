Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3JACle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:41:34 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28972 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3JACld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:41:33 -0400
Message-ID: <524A364D.3040606@hp.com>
Date: Mon, 30 Sep 2013 22:41:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>  <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>  <20130928074144.GA17773@gmail.com>  <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>  <20130928192123.GA8228@gmail.com> <20130928193739.GA8642@gmail.com>  <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>  <20130928195207.GA31245@gmail.com> <1380561027.3467.196.camel@schen9-DESK>  <20130930181411.GO15690@laptop.programming.kicks-ass.net>  <1380568987.3467.198.camel@schen9-DESK>  <5249D26C.8020208@hp.com> <1380570436.3467.199.camel@schen9-DESK>
In-Reply-To: <1380570436.3467.199.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 03:47 PM, Tim Chen wrote:
>> My qrwlock doesn't enable qrwlock by default. You have to use menuconfig
>> to explicitly enable it. Have you done that when you build the test
>> kernel? I am thinking of explicitly enabling it for x86 if the anon-vma
>> lock is converted back to a rwlock.
>>
> Yes, I have explicitly enabled it during my testing.
>
> Thanks.
> Tim
>
Thank for the info.

I had tested Ingo's 2nd patch myself with the qrwlock patch on a 8-node
machine with a 3.12.0-rc2 kernel. The results of AIM7's high_systime
(at 1500 users) were:

Anon-vmas lock          JPM        %Change
--------------          ---        -------
     rwsem        148265           -
     rwlock        238715          +61%
     qrwlock        242048          +63%

So the queue rwlock was only slightly faster in this case. Below were
the perf profile with rwlock:

  18.20%   reaim  [kernel.kallsyms]  [k] __write_lock_failed
   9.36%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   2.91%   reaim  [kernel.kallsyms]  [k] mspin_lock
   2.73%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
   2.23%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.29%   reaim  [kernel.kallsyms]  [k] __read_lock_failed
   1.21%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.14%   reaim  [kernel.kallsyms]  [k] zap_pte_range
   1.13%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock
   1.04%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner

The perf profile with qrwlock:

  10.57%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   7.98%   reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
   5.83%   reaim  [kernel.kallsyms]  [k] mspin_lock
   2.86%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   2.71%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
   1.52%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.51%   reaim  [kernel.kallsyms]  [k] queue_read_lock_slowpath
   1.35%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
   1.12%   reaim  [kernel.kallsyms]  [k] zap_pte_range
   1.06%   reaim  [kernel.kallsyms]  [k] perf_event_aux_ctx
   1.01%   reaim  [kernel.kallsyms]  [k] perf_event_aux

In the qrwlock kernel, less time were spent in the rwlock slowpath
path (about half). However, more time were now spent in the spinlock
and mutex spinning. Another observation is that no noticeable idle
time was reported whereas the system could be half idle with rwsem.
There was also a lot less idle balancing activities.

The qrwlock is fair wrt the writers. So its performance may not be
as good as the fully unfair rwlock. However, queuing reduces a lot
of cache contention traffic, thus improving performance. It is the
interplay of these 2 factors that determine how much performance
benefit we can see. Another factor to consider is that when we have
less contention in anon-vmas, other areas of contentions will show up.

With qrwlock, the spinlock contention was:

  10.57%   reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
              |--58.70%-- release_pages
              |--38.42%-- pagevec_lru_move_fn
              |--0.64%-- get_page_from_freelist
              |--0.64%-- __page_cache_release
               --1.60%-- [...]

   2.86%      ls  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
                 |--52.73%-- pagevec_lru_move_fn
                 |--46.25%-- release_pages
                  --1.02%-- [...]

   1.52%    true  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
               |--53.76%-- pagevec_lru_move_fn
               |--43.95%-- release_pages
               |--1.02%-- __page_cache_release

-Longman

