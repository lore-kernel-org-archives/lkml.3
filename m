Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3LCOdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:33:22 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:53440 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3LCOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131025152236.GC10673@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-2-git-send-email-sandeepa.prabhu@linaro.org>
	<20131025152236.GC10673@mudshark.cambridge.arm.com>
Date: Tue, 3 Dec 2013 20:03:17 +0530
Message-ID: <CA+b37P0xNDqKWm-Vdpmwrvqxr01C+bOhas+-nEUxLFe7pzEB7A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 1/6] arm64: support single-step and breakpoint
 handler hooks
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Sorry for responding to this after long-time, I missed this review
during Linaro connect travels.

On 25 October 2013 20:52, Will Deacon <will.deacon@arm.com> wrote:
> Hi Sandeepa,
>
> This is getting there, thanks for persevering with it. I still have a few
> minor comments though.
>
> On Thu, Oct 17, 2013 at 12:17:46PM +0100, Sandeepa Prabhu wrote:
>> AArch64 Single Steping and Breakpoint debug exceptions will be
>> used by multiple debug framworks like kprobes & kgdb.
>>
>> This patch implements the hooks for those frameworks to register
>> their own handlers for handling breakpoint and single step events.
>>
>> Reworked the debug exception handler in entry.S: do_dbg to route
>> software breakpoint (BRK64) exception to do_debug_exception()
>>
>> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
>> ---
>>  arch/arm64/include/asm/debug-monitors.h | 21 ++++++++
>>  arch/arm64/kernel/debug-monitors.c      | 86 ++++++++++++++++++++++++++++++++-
>>  arch/arm64/kernel/entry.S               |  2 +
>>  3 files changed, 108 insertions(+), 1 deletion(-)
>
> [...]
>
>> @@ -215,7 +257,10 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
>>                */
>>               user_rewind_single_step(current);
>>       } else {
>> -             /* TODO: route to KGDB */
>> +             /* call registered single step handlers */
>
> Don't bother with this comment (it's crystal clear from the code).
OK, I will remove this unnecessary print.
>
>> +             if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
>> +                     return 0;
>> +
>>               pr_warning("Unexpected kernel single-step exception at EL1\n");
>>               /*
>>                * Re-enable stepping since we know that we will be
>> @@ -227,11 +272,50 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
>>       return 0;
>>  }
>>
>> +
>> +static LIST_HEAD(break_hook);
>> +DEFINE_RWLOCK(break_hook_lock);
>
> This guy can be a plain old spinlock. That way, the readers have less
> overhead but things still work because we only call a single hook function.
well, kprobes need to support recursive breakpoints (i.e. breakpoint
handler executing BRK once again)
so I converted this lock to rw_lock.  I should put this info in commit
description to be more clearer.
Let me know if you find any issue with re-cursing in breakpoint exception?

Thanks,
Sandeepa
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
