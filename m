Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaCXIrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:47:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34658 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaCXIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:47:15 -0400
Message-ID: <532FF10A.8010502@hitachi.com>
Date: Mon, 24 Mar 2014 17:47:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip v8 08/26] kprobes/x86: Call exception handlers directly
 from do_int3/do_debug
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305115939.22766.21199.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140321210508.358c30ee@gandalf.local.home>
In-Reply-To: <20140321210508.358c30ee@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/22 10:05), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 20:59:39 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> To avoid a kernel crash by probing on lockdep code, call
>> kprobe_int3_handler and kprobe_debug_handler directly
>> from do_int3 and do_debug. Since there is a locking code
>> in notify_die, lockdep code can be invoked. And because
>> the lockdep involves printk() related things, theoretically,
>> we need to prohibit probing on much more code...
>>
>> Anyway, most of the int3 handlers in the kernel are already
>> called from do_int3 directly, e.g. ftrace_int3_handler,
>> poke_int3_handler, kgdb_ll_trap. Actually only
>> kprobe_exceptions_notify is on the notifier_call_chain.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  arch/x86/include/asm/kprobes.h |    2 ++
>>  arch/x86/kernel/kprobes/core.c |   24 +++---------------------
>>  arch/x86/kernel/traps.c        |   10 ++++++++++
>>  3 files changed, 15 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
>> index 9454c16..53cdfb2 100644
>> --- a/arch/x86/include/asm/kprobes.h
>> +++ b/arch/x86/include/asm/kprobes.h
>> @@ -116,4 +116,6 @@ struct kprobe_ctlblk {
>>  extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
>>  extern int kprobe_exceptions_notify(struct notifier_block *self,
>>  				    unsigned long val, void *data);
>> +extern int kprobe_int3_handler(struct pt_regs *regs);
>> +extern int kprobe_debug_handler(struct pt_regs *regs);
>>  #endif /* _ASM_X86_KPROBES_H */
>> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
>> index 4708d6e..566958e 100644
>> --- a/arch/x86/kernel/kprobes/core.c
>> +++ b/arch/x86/kernel/kprobes/core.c
>> @@ -559,7 +559,7 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
>>   * Interrupts are disabled on entry as trap3 is an interrupt gate and they
>>   * remain disabled throughout this function.
>>   */
>> -static int __kprobes kprobe_handler(struct pt_regs *regs)
>> +int __kprobes kprobe_int3_handler(struct pt_regs *regs)
>>  {
>>  	kprobe_opcode_t *addr;
>>  	struct kprobe *p;
>> @@ -857,7 +857,7 @@ no_change:
>>   * Interrupts are disabled on entry as trap1 is an interrupt gate and they
>>   * remain disabled throughout this function.
>>   */
>> -static int __kprobes post_kprobe_handler(struct pt_regs *regs)
>> +int __kprobes kprobe_debug_handler(struct pt_regs *regs)
>>  {
>>  	struct kprobe *cur = kprobe_running();
>>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
>> @@ -960,22 +960,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
>>  	if (args->regs && user_mode_vm(args->regs))
>>  		return ret;
>>  
>> -	switch (val) {
>> -	case DIE_INT3:
>> -		if (kprobe_handler(args->regs))
>> -			ret = NOTIFY_STOP;
>> -		break;
>> -	case DIE_DEBUG:
>> -		if (post_kprobe_handler(args->regs)) {
>> -			/*
>> -			 * Reset the BS bit in dr6 (pointed by args->err) to
>> -			 * denote completion of processing
>> -			 */
>> -			(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
>> -			ret = NOTIFY_STOP;
>> -		}
> 
> The DIE_DEBUG case is removed but not added anyplace else. The change
> log doesn't say why this was removed.

As you can see the above hunk, post_kprobe_handler() is now renamed
as kprobe_debug_handler() which is called from do_debug() directly.

What I meant in the patch comment;

>> To avoid a kernel crash by probing on lockdep code, call
>> kprobe_int3_handler and kprobe_debug_handler directly
>> from do_int3 and do_debug.

was actually pointing that change...

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


