Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3KALhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab3KALhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:37:06 -0400
Message-ID: <52739244.3060209@redhat.com>
Date: Fri, 01 Nov 2013 07:36:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: peterz@infradead.org, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
References: <20131031163144.0fd27457@annuminas.surriel.com> <20131101110825.GX2400@suse.de>
In-Reply-To: <20131101110825.GX2400@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 07:08 AM, Mel Gorman wrote:
> On Thu, Oct 31, 2013 at 04:31:44PM -0400, Rik van Riel wrote:
>> There is a race between stop_two_cpus, and the global stop_cpus.
>>
> 
> What was the trigger for this? I want to see what was missing from my own
> testing. I'm going to go out on a limb and guess that CPU hotplug was also
> running in the background to specifically stress this sort of rare condition.
> Something like running a standard test with the monitors/watch-cpuoffline.sh
> from mmtests running in parallel.

AFAIK the trigger was a test that continuously loads and
unloads kernel modules, while doing other stuff.

>> It is possible for two CPUs to get their stopper functions queued
>> "backwards" from one another, resulting in the stopper threads
>> getting stuck, and the system hanging. This can happen because
>> queuing up stoppers is not synchronized.
>>
>> This patch adds synchronization between stop_cpus (a rare operation),
>> and stop_two_cpus.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>> Prarit is running a test with this patch. By now the kernel would have
>> crashed already, yet it is still going. I expect Prarit will add his
>> Tested-by: some time tomorrow morning.
>>
>>  kernel/stop_machine.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
>> index 32a6c44..46cb4c2 100644
>> --- a/kernel/stop_machine.c
>> +++ b/kernel/stop_machine.c
>> @@ -40,8 +40,10 @@ struct cpu_stopper {
>>  };
>>  
>>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
>> +static DEFINE_PER_CPU(bool, stop_two_cpus_queueing);
>>  static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
>>  static bool stop_machine_initialized = false;
>> +static bool stop_cpus_queueing = false;
>>  
>>  static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
>>  {
>> @@ -261,16 +263,37 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
>>  	cpu_stop_init_done(&done, 2);
>>  	set_state(&msdata, MULTI_STOP_PREPARE);
>>  
>> + wait_for_global:
>> +	/* If a global stop_cpus is queuing up stoppers, wait. */
>> +	while (unlikely(stop_cpus_queueing))
>> +		cpu_relax();
>> +
> 
> This partially serialises callers to migrate_swap() while it is checked
> if the pair of CPUs are being affected at the moment. It's two-stage

Not really. This only serializes migrate_swap if there is a global
stop_cpus underway.

If there is no global stop_cpus, migrate_swap will continue the way
it did before, without locking.

> locking. The global lock is short-lived while the per-cpu data is updated
> and the per-cpu values allow a degree of parallelisation on call_cpu which
> could not be done with a spinlock held anyway.  Why not make protection
> of the initial update a normal spinlock? i.e.
> 
> spin_lock(&stop_cpus_queue_lock);
> this_cpu_write(stop_two_cpus_queueing, true);
> spin_unlock(&stop_cpus_queue_lock);

Because that would result in all migrate_swap instances serializing
with each other.

-- 
All rights reversed
