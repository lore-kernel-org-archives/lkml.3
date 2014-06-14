Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaFNFo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 01:44:29 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57955 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaFNFo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 01:44:27 -0400
Message-ID: <539BE132.2080008@hitachi.com>
Date: Sat, 14 Jun 2014 14:44:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, seiji.aguchi@hds.com,
        Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: Re: [tip:perf/kprobes] kprobes, x86: Call exception_enter
 after kprobes handled
References: <20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp> <tip-ecd50f714c421c759354632dd00f70c718c95b10@git.kernel.org> <CAFTL4hyYa7=h3DE+kkpNpWxp4VtaJ07tkkj96W+ZAmKtZD+pkA@mail.gmail.com>
In-Reply-To: <CAFTL4hyYa7=h3DE+kkpNpWxp4VtaJ07tkkj96W+ZAmKtZD+pkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

(2014/06/14 2:14), Frederic Weisbecker wrote:
> Hi Masami,
> 
> 2014-04-24 12:59 GMT+02:00 tip-bot for Masami Hiramatsu <tipbot@zytor.com>:
>> Commit-ID:  ecd50f714c421c759354632dd00f70c718c95b10
>> Gitweb:     http://git.kernel.org/tip/ecd50f714c421c759354632dd00f70c718c95b10
>> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> AuthorDate: Thu, 17 Apr 2014 17:17:40 +0900
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Thu, 24 Apr 2014 10:03:00 +0200
>>
>> kprobes, x86: Call exception_enter after kprobes handled
>>
>> Move exception_enter() call after kprobes handler
>> is done. Since the exception_enter() involves
>> many other functions (like printk), it can cause
>> recursive int3/break loop when kprobes probe such
>> functions.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Jiri Kosina <jkosina@suse.cz>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
>> Link: http://lkml.kernel.org/r/20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> This patch results in exception_enter/exception_exit imbalances:
> 
> arch/x86/kernel/traps.c: In function ‘do_debug’:
> include/linux/context_tracking.h:46:6: warning: ‘prev_state’ may be
> used uninitialized in this function [-Wmaybe-uninitialized]
>    if (prev_ctx == IN_USER)
>       ^
> arch/x86/kernel/traps.c:431:17: note: ‘prev_state’ was declared here
>   enum ctx_state prev_state;

Oops, obviously there are bugs...

> An obvious solution would be to change all the goto exit before
> exception_enter() to return from do_debug(). But if there are any user
> of RCU before exception_enter() this won't work. Does
> kprobe_debug_andle() use RCU read side critical sections? I'm also
> worried about kmemcheck...

As far as I can check the code again, it is enough to remove this patch and
to add context_track_user_*() to kprobe blacklist, since those checks
in_interrupt() at the entry and returns immediately. It seems
we have no problem on it. I think that was my fault. :(

I'll send a bugfix, thank you!

> 
>> ---
>>  arch/x86/kernel/traps.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> index e5d4a70..ba9abe9 100644
>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -327,7 +327,6 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>>         if (poke_int3_handler(regs))
>>                 return;
>>
>> -       prev_state = exception_enter();
>>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>>         if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>>                                 SIGTRAP) == NOTIFY_STOP)
>> @@ -338,6 +337,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>>         if (kprobe_int3_handler(regs))
>>                 return;
>>  #endif
>> +       prev_state = exception_enter();
>>
>>         if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>>                         SIGTRAP) == NOTIFY_STOP)
>> @@ -415,8 +415,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>>         unsigned long dr6;
>>         int si_code;
>>
>> -       prev_state = exception_enter();
>> -
>>         get_debugreg(dr6, 6);
>>
>>         /* Filter out all the reserved bits which are preset to 1 */
>> @@ -449,6 +447,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>>         if (kprobe_debug_handler(regs))
>>                 goto exit;
>>  #endif
>> +       prev_state = exception_enter();
>>
>>         if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
>>                                                         SIGTRAP) == NOTIFY_STOP)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


