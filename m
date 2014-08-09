Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaHIK5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 06:57:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51524 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaHIK5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 06:57:50 -0400
Date: Sat, 9 Aug 2014 12:57:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] Flipped jump labels
Message-ID: <20140809105742.GA5910@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dudes,

with the current impl. of jump labels, people can't really do the
following:

---
JMP unlikely_code
likely_code

unlikely_code:
unlikely code
---

and after some initialization queries overwrite the JMP with a NOP so
that the likely code gets executed at 0 cost.

The issue is that jump labels unconditionally add NOPs by default
(see arch_static_branch). For example, native_sched_clock() gets the
following code layout here:

--
NOP
unlikely code (which computes time in ns from jiffies)
likely code (which does RDTSC)
--

Yes, unlikely code comes first.

when the jump labels get initialized and all checks done, at runtime we
have this:

	   0xffffffff8100ce40 <sched_clock>:    push   %rbp
	   0xffffffff8100ce41 <sched_clock+1>:  mov    %rsp,%rbp
	   0xffffffff8100ce44 <sched_clock+4>:  and    $0xfffffffffffffff0,%rsp

unconditional JMP!!!

	   0xffffffff8100ce48 <sched_clock+8>:  jmpq   0xffffffff8100ce70 <sched_clock+48>

unlikely code using jiffies

	   0xffffffff8100ce4d <sched_clock+13>: mov    0x9a71ac(%rip),%r8        # 0xffffffff819b4000 <jiffies_64>
	   0xffffffff8100ce54 <sched_clock+20>: movabs $0xffc2f745d964b800,%rax
	   0xffffffff8100ce5e <sched_clock+30>: leaveq 
	   0xffffffff8100ce5f <sched_clock+31>: imul   $0x3d0900,%r8,%rdx
	   0xffffffff8100ce66 <sched_clock+38>: add    %rdx,%rax
	   0xffffffff8100ce69 <sched_clock+41>: retq   
	   0xffffffff8100ce6a <sched_clock+42>: nopw   0x0(%rax,%rax,1)

likely code using RDTSC, see JMP target address.

	   0xffffffff8100ce70 <sched_clock+48>: rdtsc


so what we end up getting is not really helping because we always get to
pay for that JMP on all modern systems which sport RDTSC even though we
shouldn't really.

And remember this is not something cheap: sched_clock uses the TSC
even if it is unstable so we're always jumping like insane and
unconditionally.

So, long story short, we want this, instead:

	   0xffffffff8100cf10 <sched_clock>:    push   %rbp
	   0xffffffff8100cf11 <sched_clock+1>:  mov    %rsp,%rbp
	   0xffffffff8100cf14 <sched_clock+4>:  and    $0xfffffffffffffff0,%rsp

unconditional JMP is nopped out

	   0xffffffff8100cf18 <sched_clock+8>:  data32 data32 data32 xchg %ax,%ax

likely code which comes first in the function so all the advantages from
it to front end, branch pred, yadda yadda, get to be enjoyed :)

	   0xffffffff8100cf1d <sched_clock+13>: rdtsc  
	   0xffffffff8100cf1f <sched_clock+15>: mov    %eax,%esi
	   0xffffffff8100cf21 <sched_clock+17>: mov    %rdx,%rax
	   0xffffffff8100cf24 <sched_clock+20>: shl    $0x20,%rax
	   0xffffffff8100cf28 <sched_clock+24>: or     %rsi,%rax
	   0xffffffff8100cf2b <sched_clock+27>: mov    %rax,%rcx
	   0xffffffff8100cf2e <sched_clock+30>: incl   %gs:0xb8e0
	   0xffffffff8100cf36 <sched_clock+38>: mov    %gs:0x1d0c30,%rsi
	   0xffffffff8100cf3f <sched_clock+47>: mov    %gs:0x1d0c38,%rax
	   0xffffffff8100cf48 <sched_clock+56>: cmp    %rax,%rsi
	   0xffffffff8100cf4b <sched_clock+59>: jne    0xffffffff8100cf90 <sched_clock+128>
	   0xffffffff8100cf4d <sched_clock+61>: mov    (%rsi),%eax
	   0xffffffff8100cf4f <sched_clock+63>: mul    %rcx
	   0xffffffff8100cf52 <sched_clock+66>: shrd   $0xa,%rdx,%rax
	   0xffffffff8100cf57 <sched_clock+71>: add    0x8(%rsi),%rax
	   0xffffffff8100cf5b <sched_clock+75>: decl   %gs:0xb8e0
	   0xffffffff8100cf63 <sched_clock+83>: je     0xffffffff8100cf88 <sched_clock+120>
	   0xffffffff8100cf65 <sched_clock+85>: leaveq 
	   0xffffffff8100cf66 <sched_clock+86>: retq   

Done, we return here.

	   0xffffffff8100cf67 <sched_clock+87>: nop

unlikely code which does the jiffies math.

	   0xffffffff8100cf68 <sched_clock+88>: mov    0x9a7091(%rip),%rax        # 0xffffffff819b4000 <jiffies_64>
	   0xffffffff8100cf6f <sched_clock+95>: leaveq 
	   0xffffffff8100cf70 <sched_clock+96>: imul   $0x3d0900,%rax,%rdx
	   ...


So basically what I'm proposing is a jump label type which is
initialized by default to jump to the unlikely code and once
initialization has happened, JMP gets overwritten.

The things to pay attention here is

* this label should be used in places where it is very likely for the
jump to get overwritten. Basically the opposite to tracepoints for which
the jump labels were created initially, to be mostly off.

* It must be used in places where JMP gets overwritten only after some
initialization done first.

Anyway, below is a concept patch for myself to try the idea first - it
seems to work here. Constructive ideas and suggestions are welcome, as
always.

---
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 6a2cefb4395a..2d963c6489a8 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -30,6 +30,22 @@ l_yes:
 	return true;
 }
 
+static __always_inline bool arch_static_branch_active(struct static_key *key)
+{
+	asm_volatile_goto("1:"
+		"jmp %l[l_yes]\n\t"
+		".byte " __stringify(GENERIC_NOP3) "\n\t"
+		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		".popsection \n\t"
+		: :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
+
+
 #endif /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4ca327e900ae..81bc2c4a7eab 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(tsc_khz);
  */
 static int __read_mostly tsc_unstable;
 
-static struct static_key __use_tsc = STATIC_KEY_INIT;
+static struct static_key __use_tsc = STATIC_KEY_INIT_FALSE;
 
 int tsc_clocksource_reliable;
 
@@ -280,7 +280,7 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (!static_key_false(&__use_tsc)) {
+	if (arch_static_branch_active(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
