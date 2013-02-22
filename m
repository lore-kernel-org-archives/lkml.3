Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3BVF0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:26:53 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60415 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3BVF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:26:50 -0500
Message-ID: <5127018E.9040200@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 13:26:38 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361427108.5861.41.camel@marge.simpson.net> <5125C607.8090909@linux.vnet.ibm.com> <1361434231.5861.61.camel@marge.simpson.net> <5125E40D.6050006@linux.vnet.ibm.com> <1361439789.5861.70.camel@marge.simpson.net> <5126D9A2.8090404@linux.vnet.ibm.com> <1361509372.5817.60.camel@marge.simpson.net>
In-Reply-To: <1361509372.5817.60.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022205-5140-0000-0000-000002CBAD4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 01:02 PM, Mike Galbraith wrote:
> On Fri, 2013-02-22 at 10:36 +0800, Michael Wang wrote: 
>> On 02/21/2013 05:43 PM, Mike Galbraith wrote:
>>> On Thu, 2013-02-21 at 17:08 +0800, Michael Wang wrote:
>>>
>>>> But is this patch set really cause regression on your Q6600? It may
>>>> sacrificed some thing, but I still think it will benefit far more,
>>>> especially on huge systems.
>>>
>>> We spread on FORK/EXEC, and will no longer will pull communicating tasks
>>> back to a shared cache with the new logic preferring to leave wakee
>>> remote, so while no, I haven't tested (will try to find round tuit) it
>>> seems  it _must_ hurt.  Dragging data from one llc to the other on Q6600
>>> hurts a LOT.  Every time a client and server are cross llc, it's a huge
>>> hit.  The previous logic pulled communicating tasks together right when
>>> it matters the most, intermittent load... or interactive use.
>>
>> I agree that this is a problem need to be solved, but don't agree that
>> wake_affine() is the solution.
> 
> It's not perfect, but it's better than no countering force at all.  It's
> a relic of the dark ages, when affine meant L2, ie this cpu.  Now days,
> affine has a whole new meaning, L3, so it could be done differently, but
> _some_ kind of opposing force is required.
> 
>> According to my understanding, in the old world, wake_affine() will only
>> be used if curr_cpu and prev_cpu share cache, which means they are in
>> one package, whatever search in llc sd of curr_cpu or prev_cpu, we won't
>> have the chance to spread the task out of that package.
> 
> ? affine_sd is the first domain spanning both cpus, that may be NODE.
> True we won't ever spread in the wakeup path unless SD_WAKE_BALANCE is
> set that is.  Would be nice to be able to do that without shredding
> performance.
> 
> Off the top of my pointy head, I can think of a way to _maybe_ improve
> the "affine" wakeup criteria:  Add a small (package size? and very fast)
> FIFO queue to task struct, record waker/wakee relationship.  If
> relationship exists in that queue (rbtree), try to wake local, if not,
> wake remote.  The thought is to identify situations ala 1:N pgbench
> where you really need to keep the load spread.  That need arises when
> the sum wakees + waker won't fit in one cache.  True buddies would
> always hit (hm, hit rate), always try to become affine where they
> thrive.  1:N stuff starts missing when client count exceeds package
> size, starts expanding it's horizons. 'Course you would still need to
> NAK if imbalanced too badly, and let NUMA stuff NAK touching lard-balls
> and whatnot.  With a little more smarts, we could have happy 1:N, and
> buddies don't have to chat through 2m thick walls to make 1:N scale as
> well as it can before it dies of stupidity.

Just confirm that I'm not on the wrong way, did the 1:N mode here means
1 task forked N threads, and child always talk with father?

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

