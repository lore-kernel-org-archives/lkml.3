Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaEZCpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 22:45:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47044 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEZCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 22:45:32 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: [PATCH 1/9] perf, tools: Support handling complete branch stacks as histograms v6
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
	<1400259938-3436-2-git-send-email-andi@firstfloor.org>
	<87fvk6ji10.fsf@sejong.aot.lge.com>
	<20140523213503.GD29957@tassilo.jf.intel.com>
Date: Mon, 26 May 2014 11:45:30 +0900
In-Reply-To: <20140523213503.GD29957@tassilo.jf.intel.com> (Andi Kleen's
	message of "Fri, 23 May 2014 14:35:03 -0700")
Message-ID: <8738fxjm0l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 23 May 2014 14:35:03 -0700, Andi Kleen wrote:
> On Mon, May 19, 2014 at 05:21:15PM +0900, Namhyung Kim wrote:
>> This is gone with 540476de74c9 ("perf tools: Remove
>> symbol_conf.use_callchain check").
>
> The patchkit applies to tip/perf/core.

The commit 540476de74c9 is also in the tip/perf/core.  Please check
machine_resolve_callchain_sample().

>
>> > +				 * Check for overlap into the callchain.
>> > +				 * The return address is one off compared to
>> > +				 * the branch entry. To adjust for this
>> > +				 * assume the calling instruction is not longer
>> > +				 * than 8 bytes.
>> > +				 */
>> > +				if (be[i].from < chain->ips[first_call] &&
>> > +				    be[i].from >= chain->ips[first_call] - 8)
>> > +					first_call++;
>> 
>> It seems that you need to check chain->ips[first_call] is greater than
>> PERF_CONTEXT_MAX and use such value as the cpumode...
>
> I don't understand the comment. The only IP that gets resolved is the from/to.
> And add_callchain_ip does it own resolution.
>
> Wouldn't make any sense to get it from first_call

Okay, let me explain it this way..

You're checking the branch stack with normal callchain to find overlap
by comparing the 'from' address and the address in chain->ips[].  But
chain->ips[0] doesn't contain a valid address but a PERF_CONTEXT_XXX for
cpumode of subsequent callchains.  So the first_call of 0 won't do
anything meaningful for you and it'd still contain overlapped
callchains.

  $ perf --version
  perf version 3.15.rc4.g816bf8
  
  $ perf record -b -g ./tcall
  
  $ perf report -D | grep -A35 SAMPLE
  4748858059190923 0x3608 [0x240]: PERF_RECORD_SAMPLE(IP, 0x1): 31914/31914: 0xffffffff81043ffa period: 1 addr: 0
  ... chain: nr:17
  .....  0: ffffffffffffff80
  .....  1: ffffffff81043ffa
  .....  2: ffffffff81029d40
  .....  3: ffffffff81025554
  .....  4: ffffffff811246c7
  .....  5: ffffffff81125d69
  .....  6: ffffffff811280dc
  .....  7: ffffffff811a4266
  .....  8: ffffffff811a4bb1
  .....  9: ffffffff811f1a4f
  ..... 10: ffffffff811a344c
  ..... 11: ffffffff811a49bb
  ..... 12: ffffffff811a4ac8
  ..... 13: ffffffff811a4d3d
  ..... 14: ffffffff81664689
  ..... 15: fffffffffffffe00
  ..... 16: 0000003153ebca47
  ... branch stack: nr:16
  .....  0: ffffffff81029d3b -> ffffffff81043ff0
  .....  1: ffffffff810280c9 -> ffffffff81029d18
  .....  2: ffffffff81043ffd -> ffffffff810280be
  .....  3: 0000000000000000 -> 0000000000000000
  .....  4: 0000000000000000 -> 0000000000000000
  .....  5: 0000000000000000 -> 0000000000000000
  .....  6: 0000000000000000 -> 0000000000000000
  .....  7: 0000000000000000 -> 0000000000000000
  .....  8: 0000000000000000 -> 0000000000000000
  .....  9: 0000000000000000 -> 0000000000000000
  ..... 10: 0000000000000000 -> 0000000000000000
  ..... 11: 0000000000000000 -> 0000000000000000
  ..... 12: 0000000000000000 -> 0000000000000000
  ..... 13: 0000000000000000 -> 0000000000000000
  ..... 14: 0000000000000000 -> 0000000000000000
  ..... 15: 0000000000000000 -> 0000000000000000

As you can see, chain->ips[0] is ffffffffffffff80 (= -128) that is
defined as PERF_CONTEXT_KERNEL.  And in this case nr of branch stack is
16 but it's actually 3.  I guess you need to ignore 0 entries..

Also perf report seems to fail to resolve symbols/srclines in branch
stack (possibly due to missing cpumode) and find loops.

  $ perf report --branch-history --stdio
  ...
       0.00%  native_writ  [k] native_write_msr_safe  [kernel.kallsyms]
              |
              ---0xffffffff81043ff0
                 0xffffffff81029d3b
                 0xffffffff81029d18
                 0xffffffff810280c9
                 0xffffffff810280be
                 0xffffffff81043ffd
                 |          
                 |--99.77%-- 0xffffffff81043ff0
                 |          0xffffffff81029d3b
                 |          0xffffffff81029d18
                 |          0xffffffff810280c9
                 |          0xffffffff810280be
                 |          0xffffffff81043ffd
                 |          0
                 |          0
                 |          |          
                 |          |--91.43%-- native_write_msr_safe +10
                 |          |          intel_pmu_enable_all +80
                 |          |          x86_pmu_enable +628
                 |          |          perf_pmu_enable +39
                 |          |          perf_event_context_sched_in +121
                 |          |          perf_event_comm +364
                 |          |          set_task_comm +102
                 |          |          setup_new_exec +129
                 |          |          load_elf_binary +1007
                 |          |          
                 |           --8.57%-- 0
                 |                     0
                 |                     |          
                 |                     |--91.78%-- native_write_msr_safe +10
                 |                     |          intel_pmu_enable_all +80
                 |                     |          x86_pmu_enable +628
                 |                     |          perf_pmu_enable +39
                 |                     |          perf_event_context_sched_in +121
                 |                     |          perf_event_comm +364
                 |                     |          set_task_comm +102
                 |                     |          setup_new_exec +129
                 |                     |          
                 |                      --8.22%-- 0
                 |                                0
                 |                                native_write_msr_safe +10
                 |                                intel_pmu_enable_all +80
                 |                                x86_pmu_enable +628
                 |                                perf_pmu_enable +39
                 |                                perf_event_context_sched_in +121
                 |                                perf_event_comm +364
                 |                                set_task_comm +102
                  --0.23%-- [...]



>
>> 
>> 
>> > +			} else
>> > +				be[i] = branch->entries[branch->nr - i - 1];
>> > +		}
>> > +
>> > +		nr = remove_loops(be, nr);
>> > +
>> > +		for (i = 0; i < nr; i++) {
>> > +			err = add_callchain_ip(machine, thread, parent,
>> > +					       root_al,
>> > +					       -1, be[i].to);
>> > +			if (!err)
>> > +				err = add_callchain_ip(machine, thread,
>> > +						       parent, root_al,
>> > +						       -1, be[i].from);
>> 
>> ... for here.
>> 
>> 
>> > +			if (err == -EINVAL)
>> > +				break;
>> > +			if (err)
>> > +				return err;
>> > +		}
>> > +		chain_nr -= nr;
>> 
>> It seems it could make some callchain nodes being ignored.  What if a
>> case like small callchains with matches to only 2 nodes in the LBR?
>> 
>>   nr = 16, chain_nr = 10 and first_call = 2
>
> The chain_nr variable is just to handle it when the user
> specified a max_stack value. nr is always capped to max_stack too.
> If lbr size is >= max_stack it will end up being 0 or negative and the 
> following loop to add normal call stack entries will do nothing.
>
> I think that's the correct behavior.

Hmm.. I assumed user didn't specify a max_stack but failed to understand
how the code prevents from ignoring remaining 8 callchain nodes.

Thanks,
Namhyung
