Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3BVChc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:37:32 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52288 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3BVCha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:37:30 -0500
Message-ID: <5126D9E0.7040108@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 10:37:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop>
In-Reply-To: <1361442055.26780.3.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022202-3568-0000-0000-00000331AB4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 06:20 PM, Peter Zijlstra wrote:
> On Thu, 2013-02-21 at 12:51 +0800, Michael Wang wrote:
>> The old logical when locate affine_sd is:
>>
>>         if prev_cpu != curr_cpu
>>                 if wake_affine()
>>                         prev_cpu = curr_cpu
>>         new_cpu = select_idle_sibling(prev_cpu)
>>         return new_cpu
>>
>> The new logical is same to the old one if prev_cpu == curr_cpu, so
>> let's
>> simplify the old logical like:
>>
>>         if wake_affine()
>>                 new_cpu = select_idle_sibling(curr_cpu)
>>         else
>>                 new_cpu = select_idle_sibling(prev_cpu)
>>
>>         return new_cpu
>>
>> Actually that doesn't make sense.
> 
> It does :-)
> 
>> I think wake_affine() is trying to check whether move a task from
>> prev_cpu to curr_cpu will break the balance in affine_sd or not, but
>> why
>> won't break balance means curr_cpu is better than prev_cpu for
>> searching
>> the idle cpu?
> 
> It doesn't, the whole affine wakeup stuff is meant to pull waking tasks
> towards the cpu that does the wakeup, we limit this by putting bounds on
> the imbalance this is may create.
> 
> The reason we want to run tasks on the cpu that does the wakeup is
> because that cpu 'obviously' is running something related and it seems
> like a good idea to run related tasks close together.
> 
> So look at affine wakeups as a force that groups related tasks.

That's right, and it's one point I've missed when judging the
wake_affine()...

But that's really some benefit hardly to be estimate, especially when
the workload is heavy, the cost of wake_affine() is very high to
calculated se one by one, is that worth for some benefit we could not
promise?

According to the testing result, I could not agree this purpose of
wake_affine() benefit us, but I'm sure that wake_affine() is a terrible
performance killer when system is busy.

> 
>> So the new logical in this patch set is:
>>
>>         new_cpu = select_idle_sibling(prev_cpu)
>>         if idle_cpu(new_cpu)
>>                 return new_cpu
>>
>>         new_cpu = select_idle_sibling(curr_cpu)
>>         if idle_cpu(new_cpu) {
>>                 if wake_affine()
>>                         return new_cpu
>>         }
>>
>>         return prev_cpu
>>
>> And now, unless we are really going to move load from prev_cpu to
>> curr_cpu, we won't use wake_affine() any more.
> 
> That's completely breaks stuff, not cool.

Could you please give more details on what's the point you think is bad?

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

