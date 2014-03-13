Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaCMPQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:16:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26773 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaCMPQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:16:47 -0400
Message-ID: <5321CBDA.1060705@oracle.com>
Date: Thu, 13 Mar 2014 11:16:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com> <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
In-Reply-To: <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 03:27 PM, Linus Torvalds wrote:
> On Sat, Feb 22, 2014 at 4:19 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Right now when people try to report issues in the kernel they send stack
>> dumps to eachother, which looks something like this:
>>
>> [    6.906437]  [<ffffffff811f0e90>] ? backtrace_test_irq_callback+0x20/0x20
>> [    6.907121]  [<ffffffff84388ce8>] dump_stack+0x52/0x7f
>> [    6.907640]  [<ffffffff811f0ec8>] backtrace_regression_test+0x38/0x110
>> [    6.908281]  [<ffffffff813596a0>] ? proc_create_data+0xa0/0xd0
>> [    6.908870]  [<ffffffff870a8040>] ? proc_modules_init+0x22/0x22
>> [    6.909480]  [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
>> [...]
>>
>> However, most of the text you get is pure garbage.
>
> I'd like to fix that, but I'd like to fix it in the kernel, and just
> stop printing the hex addresses entirely.
>
> However, your kind of script actually makes that worse, in that it
> uses the redundant hex addresses for 'addr2line', and that tool is
> known to not work with symbolic addresses, only with actual numerical
> ones.
>
> So I would *really* want to do this kernel change (possibly
> conditional on RANDOMIZE_BASE_ADDRESS or whatever the config variable
> is called):
>
>      diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
>      index d9c12d3022a7..58039e728f00 100644
>      --- a/arch/x86/kernel/dumpstack.c
>      +++ b/arch/x86/kernel/dumpstack.c
>      @@ -27,13 +27,12 @@ static int die_counter;
>
>       static void printk_stack_address(unsigned long address, int reliable)
>       {
>      -       pr_cont(" [<%p>] %s%pB\n",
>      -               (void *)address, reliable ? "" : "? ", (void *)address);
>      +       pr_cont(" %s[<%pB>]\n", reliable ? "" : "? ", (void *)address);
>       }
>
>       void printk_address(unsigned long address)
>       {
>      -       pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
>      +       pr_cont(" [<%pS>]\n", (void *)address);
>       }
>
>       #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>
> which would make the kernel stack traces much prettier.
>
> But that would require that there be a "resolve symbolic address" (if
> CONFIG_KALLSYMS isn't enabled, it would still be hexadecimal) for the
> address inside the [<>] thing..
>
> I don't know of any sane tool that does that directly, but it
> shouldn't be *that* hard. You can *almost* do it with
>
>    echo "p backtrace_regression_test+0x38" | gdb vmlinux
>
> but you see the problem if you try that ;)

I've looked into doing it in the kernel, but it seems that it would require a rather
large code addition just to deal with getting pretty line numbers.

Unless I'm missing something big, is it really worth it?


Thanks,
Sasha

