Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaHKNtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:49:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33021 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbaHKNtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:49:15 -0400
Date: Mon, 11 Aug 2014 14:48:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
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
Message-ID: <20140811134832.GD15853@arm.com>
References: <1407550339-34805-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407550339-34805-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 09, 2014 at 03:12:19AM +0100, Wang Nan wrote:
> This patch introduce kprobeopt for ARM 32.
> 
> Limitations:
>  - Currently only kernel compiled with ARM ISA is supported.
> 
>  - Offset between probe point and optinsn slot must not larger than
>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
>    things complex. Futher patch can make such optimization.
> 
> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
> replace probed instruction by a 'b', branch to trampoline code and then
> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
> to execute kprobe handler. It also emulate/simulate replaced instruction.

Could you briefly describe the optimisation please? I'm not familiar with
kprobes internals, but if you're trying to patch an arbitrary instruction
with a branch then that's not guaranteed to be atomic by the ARM
architecture.

We can, however, patch branches with other branches.

Anyway, minor comments in-line:

> +/* Caller must ensure addr & 3 == 0 */
> +static int can_optimize(unsigned long paddr)
> +{
> +	return 1;
> +}

Why not check the paddr alignment here, rather than have a comment?

> +/* Free optimized instruction slot */
> +static void
> +__arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
> +{
> +	if (op->optinsn.insn) {
> +		free_optinsn_slot(op->optinsn.insn, dirty);
> +		op->optinsn.insn = NULL;
> +	}
> +}
> +
> +extern void kprobe_handler(struct pt_regs *regs);
> +
> +static void
> +optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
> +{
> +	unsigned long flags;
> +	struct kprobe *p = &op->kp;
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	/* Save skipped registers */
> +	regs->ARM_pc = (unsigned long)op->kp.addr;
> +	regs->ARM_ORIG_r0 = ~0UL;

Why are you writing ORIG_r0?

> +	local_irq_save(flags);
> +
> +	if (kprobe_running()) {
> +		kprobes_inc_nmissed_count(&op->kp);
> +	} else {
> +		__this_cpu_write(current_kprobe, &op->kp);
> +		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +		opt_pre_handler(&op->kp, regs);
> +		__this_cpu_write(current_kprobe, NULL);
> +	}
> +
> +	/* In each case, we must singlestep the replaced instruction. */
> +	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
> +
> +	local_irq_restore(flags);
> +}
> +
> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
> +{
> +	u8 *buf;
> +	unsigned long rel_chk;
> +	unsigned long val;
> +
> +	if (!can_optimize((unsigned long)op->kp.addr))
> +		return -EILSEQ;
> +
> +	op->optinsn.insn = get_optinsn_slot();
> +	if (!op->optinsn.insn)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Verify if the address gap is in 32MiB range, because this uses
> +	 * a relative jump.
> +	 *
> +	 * kprobe opt use a 'b' instruction to branch to optinsn.insn.
> +	 * According to ARM manual, branch instruction is:
> +	 *
> +	 *   31  28 27           24 23             0
> +	 *  +------+---+---+---+---+----------------+
> +	 *  | cond | 1 | 0 | 1 | 0 |      imm24     |
> +	 *  +------+---+---+---+---+----------------+
> +	 *
> +	 * imm24 is a signed 24 bits integer. The real branch offset is computed
> +	 * by: imm32 = SignExtend(imm24:'00', 32);
> +	 *
> +	 * So the maximum forward branch should be:
> +	 *   (0x007fffff << 2) = 0x01fffffc =  0x1fffffc
> +	 * The maximum backword branch should be:
> +	 *   (0xff800000 << 2) = 0xfe000000 = -0x2000000
> +	 *
> +	 * We can simply check (rel & 0xfe000003):
> +	 *  if rel is positive, (rel & 0xfe000000) shoule be 0
> +	 *  if rel is negitive, (rel & 0xfe000000) should be 0xfe000000
> +	 *  the last '3' is used for alignment checking.
> +	 */
> +	rel_chk = (unsigned long)((long)op->optinsn.insn -
> +			(long)op->kp.addr + 8) & 0xfe000003;
> +
> +	if ((rel_chk != 0) && (rel_chk != 0xfe000000)) {
> +		__arch_remove_optimized_kprobe(op, 0);
> +		return -ERANGE;
> +	}
> +
> +	buf = (u8 *)op->optinsn.insn;
> +
> +	/* Copy arch-dep-instance from template */
> +	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
> +
> +	/* Set probe information */
> +	val = (unsigned long)op;
> +	memcpy(buf + TMPL_VAL_IDX, &val, sizeof(val));
> +
> +	/* Set probe function call */
> +	val = (unsigned long)optimized_callback;
> +	memcpy(buf + TMPL_CALL_IDX, &val, sizeof(val));

Ok, so this is updating the `offset' portion of a b instruction, right? What
if memcpy does that byte-by-byte?

Will
