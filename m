Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaEGE5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:57:01 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:35507 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaEGE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:56:58 -0400
Message-ID: <5369BD06.5020503@synopsys.com>
Date: Wed, 7 May 2014 10:26:38 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch,gmane.linux.kernel.next
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, <mingo@kernel.org>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        anton Kolesov <Anton.Kolesov@synopsys.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: kprobes broken in linux-next (was Re: [tip:perf/kprobes] kprobes:
 Introduce NOKPROBE_SYMBOL()  macro to maintain kprobes blacklist)
References: <20140417081705.26341.96719.stgit@ltc230.yrl.intra.hitachi.co.jp> <tip-376e242429bf8539ef39a080ac113c8799840b13@git.kernel.org> <5361DB14.7010406@synopsys.com> <5362F147.6030901@hitachi.com>
In-Reply-To: <5362F147.6030901@hitachi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 02 May 2014 06:43 AM, Masami Hiramatsu wrote:
> (2014/05/01 14:26), Vineet Gupta wrote:
>> On Thursday 24 April 2014 04:28 PM, tip-bot for Masami Hiramatsu wrote:
>>> Commit-ID:  376e242429bf8539ef39a080ac113c8799840b13
>>> Gitweb:     http://git.kernel.org/tip/376e242429bf8539ef39a080ac113c8799840b13
>>> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>> AuthorDate: Thu, 17 Apr 2014 17:17:05 +0900
>>> Committer:  Ingo Molnar <mingo@kernel.org>
>>> CommitDate: Thu, 24 Apr 2014 10:02:56 +0200
>>>
>>> kprobes: Introduce NOKPROBE_SYMBOL() macro to maintain kprobes blacklist
>>>
>>> Introduce NOKPROBE_SYMBOL() macro which builds a kprobes
>>> blacklist at kernel build time.
>>>
>> ....
>>
>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>> index 146e4ff..40ceb3c 100644
>>> --- a/include/asm-generic/vmlinux.lds.h
>>> +++ b/include/asm-generic/vmlinux.lds.h
>>> @@ -109,6 +109,14 @@
>>>  #define BRANCH_PROFILE()
>>>  #endif
>>>  
>>> +#ifdef CONFIG_KPROBES
>>> +#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
>>> +				*(_kprobe_blacklist)			      \
>>> +				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
>>> +#else
>>> +#define KPROBE_BLACKLIST()
>>> +#endif
>>> +
>>>  #ifdef CONFIG_EVENT_TRACING
>>>  #define FTRACE_EVENTS()	. = ALIGN(8);					\
>>>  			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
>>> @@ -507,6 +515,7 @@
>>>  	*(.init.rodata)							\
>>>  	FTRACE_EVENTS()							\
>>>  	TRACE_SYSCALLS()						\
>>> +	KPROBE_BLACKLIST()						\
>>>  	MEM_DISCARD(init.rodata)					\
>>>  	CLK_OF_TABLES()							\
>>>  	RESERVEDMEM_OF_TABLES()						\
>>
>> Linux-next fails to boot on ARC due to misaligned __start_kprobe_blacklist. Patch
>> below fixes it.
>>
>> ------------------------>
>> >From c5afc4ebf9c1c094a260e2aaff6c5b3106063039 Mon Sep 17 00:00:00 2001
>> From: Vineet Gupta <vgupta@synopsys.com>
>> Date: Thu, 1 May 2014 10:47:29 +0530
>> Subject: [PATCH] kprobes: Ensure blacklist data is aligned
>>
>> ARC Linux (not supporting native unaligned access) was failing to boot
>> because __start_kprobe_blacklist was not aligned.
>>
>> This was because per generated vmlinux.lds it was emitted right next
>> to .rodata with strings etc hence could be randomly unaligned.
>>
>> Fix that by ensuring a word alignment. While 4 would suffice for 32bit
>> arches and problem at hand, it is probably better to put 8.
>>
>> | Path: (null) CPU: 0 PID: 1 Comm: swapper Not tainted
>> | 3.15.0-rc3-next-20140430 #2
>> | task: 8f044000 ti: 8f01e000 task.ti: 8f01e000
>> |
>> | [ECR   ]: 0x00230400 => Misaligned r/w from 0x800fb0d3
>> | [EFA   ]: 0x800fb0d3
>> | [BLINK ]: do_one_initcall+0x86/0x1bc
>> | [ERET  ]: init_kprobes+0x52/0x120
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thanks!

Hi Ingo/Andrew,

Can one of you please pick this up - it doesn't show up in linux-next yet.

Thx,
-Vineet


