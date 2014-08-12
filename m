Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaHLJFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:05:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45777 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbaHLJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:05:20 -0400
Date: Tue, 12 Aug 2014 10:04:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: Re: [PATCH v3] kprobes: arm: enable OPTPROBES for ARM 32
Message-ID: <20140812090423.GC29013@arm.com>
References: <1407550339-34805-1-git-send-email-wangnan0@huawei.com>
 <20140811134832.GD15853@arm.com>
 <53E96FFF.8030101@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E96FFF.8030101@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:38:07AM +0100, Masami Hiramatsu wrote:
> (2014/08/11 22:48), Will Deacon wrote:
> > On Sat, Aug 09, 2014 at 03:12:19AM +0100, Wang Nan wrote:
> >> This patch introduce kprobeopt for ARM 32.
> >>
> >> Limitations:
> >>  - Currently only kernel compiled with ARM ISA is supported.
> >>
> >>  - Offset between probe point and optinsn slot must not larger than
> >>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
> >>    things complex. Futher patch can make such optimization.
> >>
> >> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
> >> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
> >> replace probed instruction by a 'b', branch to trampoline code and then
> >> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
> >> to execute kprobe handler. It also emulate/simulate replaced instruction.
> > 
> > Could you briefly describe the optimisation please?
> 
> On arm32, optimization means "replacing a breakpoint with a branch".

What do you mean by breakpoint in this case?
KPROBE_ARM_BREAKPOINT_INSTRUCTION an friends are actually undefined
instructions, and the architecture doesn't provide atomicity guarantees
when overwriting those in a live instruction stream.

That means that if you overwrite one of these `breakpoint' instructions with
a branch, you can't guarantee that another core will see either the
breakpoint of the branch -- it could see a combination of both.

> Of course simple branch instruction doesn't memorize the source(probe)
> address, optprobe makes a trampoline code for each probe point and
> each trampoline stores "struct kprobe" of that probe point.
> 
> At first, the kprobe puts a breakpoint into the probe site, and builds
> a trampoline. After a while, it starts optimizing the probe site by
> replacing the breakpoint with a branch.
> 
> > I'm not familiar with
> > kprobes internals, but if you're trying to patch an arbitrary instruction
> > with a branch then that's not guaranteed to be atomic by the ARM
> > architecture.
> 
> Hmm, I'm not sure about arm32 too. Would you mean patch_text() can't
> replace an instruction atomically? Or only the breakpoint is special?
> (for cache?)
> optprobe always swaps branch and breakpoint, isn't that safe?

No, it's not safe. The ARM ARM is pretty clear about this (see section
3.5.4. "Concurrent modification and execution of instructions"). Note that
there is a special-purpose BKPT instruction designed for this case, but I
think this tends to get used by hardware debuggers and having the
instruction in the kernel can hamper debugging efforts.

> > We can, however, patch branches with other branches.
> > 
> > Anyway, minor comments in-line:
> > 
> >> +/* Caller must ensure addr & 3 == 0 */
> >> +static int can_optimize(unsigned long paddr)
> >> +{
> >> +	return 1;
> >> +}
> > 
> > Why not check the paddr alignment here, rather than have a comment?
> 
> Actually, we don't need to care about that. The alignment is already
> checked before calling this function (at arch_prepare_kprobe() in
> arch/arm/kernel/kprobes.c).
> 
> > 
> >> +/* Free optimized instruction slot */
> >> +static void
> >> +__arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
> >> +{
> >> +	if (op->optinsn.insn) {
> >> +		free_optinsn_slot(op->optinsn.insn, dirty);
> >> +		op->optinsn.insn = NULL;
> >> +	}
> >> +}
> >> +
> >> +extern void kprobe_handler(struct pt_regs *regs);
> >> +
> >> +static void
> >> +optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
> >> +{
> >> +	unsigned long flags;
> >> +	struct kprobe *p = &op->kp;
> >> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> >> +
> >> +	/* Save skipped registers */
> >> +	regs->ARM_pc = (unsigned long)op->kp.addr;
> >> +	regs->ARM_ORIG_r0 = ~0UL;
> > 
> > Why are you writing ORIG_r0?
> 
> In x86, optimization(breakpoint to jump) is transparently done, thus
> we have to mimic all registers as the breakpoint exception. And in x86
> int3(which is the breakpoint) exception sets -1 to orig_ax.

Ok, we do the same thing on ARM when we take an exception.

> >> +	/* Copy arch-dep-instance from template */
> >> +	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
> >> +
> >> +	/* Set probe information */
> >> +	val = (unsigned long)op;
> >> +	memcpy(buf + TMPL_VAL_IDX, &val, sizeof(val));
> >> +
> >> +	/* Set probe function call */
> >> +	val = (unsigned long)optimized_callback;
> >> +	memcpy(buf + TMPL_CALL_IDX, &val, sizeof(val));
> > 
> > Ok, so this is updating the `offset' portion of a b instruction, right? What
> > if memcpy does that byte-by-byte?
> 
> No, as you can see a indirect call "blx r2" in optprobe_template_entry(
> inline asm), this sets .data bytes at optprobe_template_call which is loaded
> to r2 register. :-)
> So all the 4bytes are used for storing the address.

Ah, ok, that makes sense. So we copy the offset into the .data word,
synchronise the caches and only then run the new code. I was wondering
about concurrent execution by another core, but it doesn't look like that
can happen.

Will
