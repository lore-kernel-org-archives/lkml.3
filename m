Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3FQJtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:49:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:47610 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3FQJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <51B2948A.60309@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
 <1370590169-24804-2-git-send-email-alex.shi@intel.com> <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com>
 <51B2948A.60309@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 02:49:03 -0700
Message-ID: <CAPM31RK6+kdEcD3xqdvu0dsvL1THkgGnJoU3f7SLx_+9uqym-Q@mail.gmail.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
To: Alex Shi <alex.shi@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 7:18 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 06/07/2013 05:07 PM, Vincent Guittot wrote:
>> On 7 June 2013 09:29, Alex Shi <alex.shi@intel.com> wrote:
>>> > Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
>>> > smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
>>> > vaiables to describe them. unsigned long is more efficient and convenience.
>>> >
>> Hi Alex,
>>
>> I just want to point out that we can't have more than 48388 tasks with
>> highest priority on a runqueue with an unsigned long on a 32 bits
>> system.  I don't know if we can reach such kind of limit on a 32bits
>> machine ? For sure, not on an embedded system.

This should be ok.

Note that:
  runnable_load_avg = \Sum se->load_avg_contrib <= \Sum
se->load.weight = cfs_rq->load.weight

And load_weight uses unsigned longs also.

blocked_load_avg must be also safe since anything appearing in blocked
load could have appeared in runnable load and we've said that was ok
above.

Reviewed-By: Paul Turner <pjt@google.com>

>
> Thanks question!
> It should be a talked problem. I just remember the conclusion is when
> you get the up bound task number, you already run out the memory space
> on 32 bit.
>
> Just for kernel resource for a process, it need 2 pages stack.
> mm_struct, task_struct, task_stats, vm_area_struct, page table etc.
> these are already beyond 4 pages. so 4 * 4k * 48388 = 774MB. plus user
> level resources.
>
> So, usually the limited task number in Linux is often far lower this
> number: $ulimit -u.
>
> Anyway, at least, the runnable_load_avg is smaller then load.weight. if
> load.weight can use long type, runablle_load_avg is no reason can't.
>
> --
> Thanks
>     Alex
