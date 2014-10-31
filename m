Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbaJaU1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:27:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaJaU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:27:19 -0400
Message-ID: <5453F0A4.4090708@suse.cz>
Date: Fri, 31 Oct 2014 21:27:16 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Alex Thorlton <athorlton@sgi.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert khugepaged to a task_work function
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com> <87lho0pf4l.fsf@tassilo.jf.intel.com> <544F9302.4010001@redhat.com> <544FB8A8.1090402@redhat.com>
In-Reply-To: <544FB8A8.1090402@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2014 16:39, Rik van Riel wrote:
> On 10/28/2014 08:58 AM, Rik van Riel wrote:
>> On 10/28/2014 08:12 AM, Andi Kleen wrote:
>>> Alex Thorlton <athorlton@sgi.com> writes:
>>>
>>>> Last week, while discussing possible fixes for some 
>>>> unexpected/unwanted behavior
>>>> from khugepaged (see: https://lkml.org/lkml/2014/10/8/515) several 
>>>> people
>>>> mentioned possibly changing changing khugepaged to work as a 
>>>> task_work function
>>>> instead of a kernel thread.  This will give us finer grained 
>>>> control over the
>>>> page collapse scans, eliminate some unnecessary scans since tasks 
>>>> that are
>>>> relatively inactive will not be scanned often, and eliminate the 
>>>> unwanted
>>>> behavior described in the email thread I mentioned.
>>>
>>> With your change, what would happen in a single threaded case?
>>>
>>> Previously one core would scan and another would run the workload.
>>> With your change both scanning and running would be on the same
>>> core.
>>>
>>> Would seem like a step backwards to me.
>>
>> It's not just scanning, either.
>>
>> Memory compaction can spend a lot of time waiting on
>> locks. Not consuming CPU or anything, but just waiting.
>>
>> I am not convinced that moving all that waiting to task
>> context is a good idea.
>
> It may be worth investigating how the hugepage code calls
> the memory allocation & compaction code.

It's actually quite stupid, AFAIK. it will scan for collapse candidates, 
and only then
try to allocate THP, which may involve compaction. If that fails, the 
scanning time was
wasted.

What could help would be to cache one or few free huge pages per zone 
with cache
re-fill done asynchronously, e.g. via work queues. The cache could 
benefit fault-THP
allocations as well. And adding some logic that if nobody uses the 
cached pages and
memory is low, then free them. And importantly, if it's not possible to 
allocate huge
pages for the cache, then prevent scanning for collapse candidates as 
there's no point.
(well this is probably more complex if some nodes can allocate huge 
pages and others
not).

For the scanning itself, I think NUMA balancing does similar thing in 
task_work context
already, no?

> Doing only async compaction from task_work context should
> probably be ok.

I'm afraid that if we give up sync compaction here, then there will be 
no more left to
defragment MIGRATE_UNMOVABLE pageblocks.

>
> -- 
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

