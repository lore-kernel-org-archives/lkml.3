Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaEISVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:21:42 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63184 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084AbaEISVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:21:40 -0400
MIME-Version: 1.0
Date: Fri, 9 May 2014 20:21:40 +0200
X-Google-Sender-Auth: Aae99nw1dX-tJIyioFwyddehP38
Message-ID: <CAMuHMdV5yA8yyhao8SLCTWmo8bjof-BMQRK_UW+GUGE8pvAdUA@mail.gmail.com>
Subject: Re: I'll queue a patch for 3.11 which removes the #ifdef... (was: Re:
 idle: Add the stack canary init to cpu_startup_entry())
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 8:31 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=d7880812b3594d3c6dcbe3cfd71dabb17347d082
> Commit:     d7880812b3594d3c6dcbe3cfd71dabb17347d082
> Parent:     c7788792a5e7b0d5d7f96d0766b4cb6112d47d75
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon Jun 10 16:52:03 2013 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue Jun 11 22:04:47 2013 +0200
>
>     idle: Add the stack canary init to cpu_startup_entry()
>
>     Moving x86 to the generic idle implementation (commit 7d1a9417 "x86:
>     Use generic idle loop") wreckaged the stack protector.
>
>     I stupidly missed that boot_init_stack_canary() must be inlined from a
>     function which never returns, but I put that call into
>     arch_cpu_idle_prepare() which of course returns.
>
>     I pondered to play tricks with arch_cpu_idle_prepare() first, but then
>     I noticed, that the other archs which have implemented the
>     stackprotector (ARM and SH) do not initialize the canary for the
>     non-boot cpus.
>
>     So I decided to move the boot_init_stack_canary() call into
>     cpu_startup_entry() ifdeffed with an CONFIG_X86 for now. This #ifdef
>     is just a temporary measure as I don't want to inflict the
>     boot_init_stack_canary() call on ARM and SH that late in the cycle.
>
>     I'll queue a patch for 3.11 which removes the #ifdef if the ARM/SH
>     maintainers have no objection.

Any progress here?

>     Reported-by: Wouter van Kesteren <woutershep@gmail.com>
>     Cc: x86@kernel.org
>     Cc: Russell King <linux@arm.linux.org.uk>
>     Cc: Paul Mundt <lethal@linux-sh.org>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index d5585f5..bf2ee1a 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c

> @@ -112,6 +113,21 @@ static void cpu_idle_loop(void)
>
>  void cpu_startup_entry(enum cpuhp_state state)
>  {
> +       /*
> +        * This #ifdef needs to die, but it's too late in the cycle to
> +        * make this generic (arm and sh have never invoked the canary
> +        * init for the non boot cpus!). Will be fixed in 3.11
> +        */
> +#ifdef CONFIG_X86
> +       /*
> +        * If we're the non-boot CPU, nothing set the stack canary up
> +        * for us. The boot CPU already has it initialized but no harm
> +        * in doing it again. This is a good place for updating it, as
> +        * we wont ever return from this function (so the invalid
> +        * canaries already on the stack wont ever trigger).
> +        */
> +       boot_init_stack_canary();
> +#endif
>         current_set_polling();
>         arch_cpu_idle_prepare();
>         cpu_idle_loop();

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
