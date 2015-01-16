Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbbAPTkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:40:06 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48817 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbAPTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:40:04 -0500
Message-ID: <54B96911.7000905@linaro.org>
Date: Fri, 16 Jan 2015 19:40:01 +0000
From: Zoltan Kiss <zoltan.kiss@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: William Cohen <wcohen@redhat.com>, oprofile-list@lists.sf.net,
        linux-kernel@vger.kernel.org
Subject: Re: Thread scheduler misbehaviour OR Oprofile bug?
References: <54B919B5.4020300@linaro.org> <54B9305F.5020800@redhat.com>
In-Reply-To: <54B9305F.5020800@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Another fun fact I forgot to mention: if I profile only this thread, and 
then run opreport with cpu filtering, it only shows results on the right 
cpu. So the wrong accounting only happens when I do system wide 
profiling. But not just with this thread and function, other functions 
appear at the wrong place as well.

Regards,

Zoltan

On 16/01/15 15:38, William Cohen wrote:
> On 01/16/2015 09:01 AM, Zoltan Kiss wrote:
>> Hi,
>>
>> I'm using OProfile to check some suspicious behaviour of dpdk-pktgen,
>> and I can see something which troubles me. Either the scheduler lies
>> about core affinity or Oprofile accounts some samples wrongly.
>> This userspace app runs in threads, which are assigned explicitly to one
>> single core with pthread_setaffinity_np (I've added some debug lines
>> which checks the affinity with pthread_getaffinity_np to make sure that
>> the affinity was correctly set indeed)
>> These threads run infinite loops, calling different functions. In my
>> example one of these functions (pktgen_main_rxtx_loop) should only be
>> called by the thread on core #1, but in the oprofile results I can see
>> samples from all other cores as well. I've added a sched_getcpu() call
>> to every iteration of that infinite loop to check if it runs anywhere
>> else than core #1, but it seems to be fine.
>> So my conclusion is that either the scheduler doesn't care about thread
>> affinity and even sched_getcpu() can't see that, OR, Oprofile falsely
>> accounts samples to the wrong CPU. Or to the wrong symbol, although I've
>> added "__attribute__ ((noinline))" to every called function to make sure
>> that inlineing doesn't screw up anything.
>> I'm running my tests on Ubuntu Servers with 14.04 with 3.13.0-32 kernel,
>> the CPU is a desktop kind, i5-4570 @ 3.20GHz (no-HT!) with oprofile 0.9.9.
>> Anyone have a suggestion about what happens?
>>
>> Regards,
>>
>> Zoltan
>
> Hi Zoltan,
>
> Are you using operf or opcontrol to set up the data measurements?  It would be good to provide the command lines that you are using to do the data collection with oprofile.
>
> "perf stat <command>" or "perf stat -p <list_of_pids>" can show task migration.  Look for the non-zero "cpu-migrations" in the output like in the output below.
>
> $ perf stat -p 29600
> ^C
>   Performance counter stats for process id '29600':
>
>         4303.761019      task-clock (msec)         #    0.305 CPUs utilized           [100.00%]
>              17,980      context-switches          #    0.004 M/sec                   [100.00%]
>                 595      cpu-migrations            #    0.138 K/sec                   [100.00%]
>              44,212      page-faults               #    0.010 M/sec
>      10,585,868,260      cycles                    #    2.460 GHz                     [100.00%]
>       6,463,554,435      stalled-cycles-frontend   #   61.06% frontend cycles idle    [100.00%]
>     <not supported>      stalled-cycles-backend
>      10,400,529,789      instructions              #    0.98  insns per cycle
>                                                    #    0.62  stalled cycles per insn [100.00%]
>       2,049,813,299      branches                  #  476.284 M/sec                   [100.00%]
>          48,441,881      branch-misses             #    2.36% of all branches
>
>        14.112614437 seconds time elapsed
>
>
>
> As a check you might try using "perf record <command>" or "perf record -p <list_of_pids>".  Once data collection is done use "perf report --sort=cpu" to see whether samples were recorded on other processors.  That would determine how much the monitored process is beoing scheduled on other cpus.
>
> There is also a systemtap (https://sourceware.org/systemtap/) script cycle_thief (https://sourceware.org/systemtap/examples/#process/cycle_thief.stp) that shows how often tasks are migrated and what other tasks are competing with the pid for time.
>
> These suggestions should help determine whether oprofile is getting the attribution of samples wrong or the scheduler is migrating the tasks.
>
> -Will
>
