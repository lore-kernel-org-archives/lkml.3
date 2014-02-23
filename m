Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaBWU1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:27:23 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:60408 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBWU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
Date: Sun, 23 Feb 2014 12:27:20 -0800
X-Google-Sender-Auth: Vi6mwaqeGBs5lczgUYppqtkEADs
Message-ID: <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 4:19 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Right now when people try to report issues in the kernel they send stack
> dumps to eachother, which looks something like this:
>
> [    6.906437]  [<ffffffff811f0e90>] ? backtrace_test_irq_callback+0x20/0x20
> [    6.907121]  [<ffffffff84388ce8>] dump_stack+0x52/0x7f
> [    6.907640]  [<ffffffff811f0ec8>] backtrace_regression_test+0x38/0x110
> [    6.908281]  [<ffffffff813596a0>] ? proc_create_data+0xa0/0xd0
> [    6.908870]  [<ffffffff870a8040>] ? proc_modules_init+0x22/0x22
> [    6.909480]  [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
> [...]
>
> However, most of the text you get is pure garbage.

I'd like to fix that, but I'd like to fix it in the kernel, and just
stop printing the hex addresses entirely.

However, your kind of script actually makes that worse, in that it
uses the redundant hex addresses for 'addr2line', and that tool is
known to not work with symbolic addresses, only with actual numerical
ones.

So I would *really* want to do this kernel change (possibly
conditional on RANDOMIZE_BASE_ADDRESS or whatever the config variable
is called):

    diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
    index d9c12d3022a7..58039e728f00 100644
    --- a/arch/x86/kernel/dumpstack.c
    +++ b/arch/x86/kernel/dumpstack.c
    @@ -27,13 +27,12 @@ static int die_counter;

     static void printk_stack_address(unsigned long address, int reliable)
     {
    -       pr_cont(" [<%p>] %s%pB\n",
    -               (void *)address, reliable ? "" : "? ", (void *)address);
    +       pr_cont(" %s[<%pB>]\n", reliable ? "" : "? ", (void *)address);
     }

     void printk_address(unsigned long address)
     {
    -       pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
    +       pr_cont(" [<%pS>]\n", (void *)address);
     }

     #ifdef CONFIG_FUNCTION_GRAPH_TRACER

which would make the kernel stack traces much prettier.

But that would require that there be a "resolve symbolic address" (if
CONFIG_KALLSYMS isn't enabled, it would still be hexadecimal) for the
address inside the [<>] thing..

I don't know of any sane tool that does that directly, but it
shouldn't be *that* hard. You can *almost* do it with

  echo "p backtrace_regression_test+0x38" | gdb vmlinux

but you see the problem if you try that ;)

               Linus
