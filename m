Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbbANJcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:32:35 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:64351 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbANJcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:32:33 -0500
MIME-Version: 1.0
In-Reply-To: <1420949002-3726-5-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
	<1420949002-3726-5-git-send-email-dave.long@linaro.org>
Date: Wed, 14 Jan 2015 15:02:32 +0530
Message-ID: <CAHM4w1n6wCUSX1QjP8EyA9zkJBZTM=6Vc32Vjm3wPuDv=FXZzw@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] arm64: Kprobes instruction simulation support
From: Pratyush Anand <pratyush.anand@gmail.com>
To: David Long <dave.long@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Pratyush Anand <panand@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 9:33 AM, David Long <dave.long@linaro.org> wrote:
> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>
> Add support for AArch64 instruction simulation in kprobes.
>
> Kprobes needs simulation of instructions that cannot be stepped
> from different memory location, e.g.: those instructions
> that uses PC-relative addressing. In simulation, the behaviour
> of the instruction is implemented using a copy of pt_regs.
>
> Following instruction catagories are simulated:
>  - All branching instructions(conditional, register, and immediate)
>  - Literal access instructions(load-literal, adr/adrp)
>
> Conditional execution is limited to branching instructions in
> ARM v8. If conditions at PSTATE do not match the condition fields
> of opcode, the instruction is effectively NOP. Kprobes considers
> this case as 'miss'.
> changes since v3:
> from David A. Long:
> 1) Fix incorrect simulate_ldrsw_literal() semantics.
> 2) Use instruction test functions instead of private parse table.
> from Will Cohen:
> 3) Remove PC adjustments when simulating an instruction.
> 4) Fix displacement calculations.
>
> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> Signed-off-by: William Cohen <wcohen@redhat.com>
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

[...]

>  static bool aarch64_insn_is_steppable(u32 insn)
>  {
> @@ -60,6 +130,32 @@ arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
>          */
>         if (aarch64_insn_is_steppable(insn))
>                 return INSN_GOOD;
> +
> +       asi->prepare = prepare_none;
> +
> +       if (aarch64_insn_is_bcond(insn)) {
> +               asi->prepare = prepare_bcond;
> +               asi->handler = simulate_b_cond;
> +       } else if (aarch64_insn_is_cb(insn)) {
> +               asi->prepare = prepare_cbz_cbnz;
> +               asi->handler = simulate_cbz_cbnz;
> +       } else if (aarch64_insn_is_tb(insn)) {
> +               asi->prepare = prepare_tbz_tbnz;
> +               asi->handler = simulate_tbz_tbnz;
> +       } else if (aarch64_insn_is_adr(insn))

aarch64_insn_is_adr should be modified to aarch64_insn_is_adr_adrp

> +               asi->handler = simulate_adr_adrp;
> +       else if (aarch64_insn_is_b_bl(insn))
> +               asi->handler = simulate_b_bl;
> +       else if (aarch64_insn_is_ldr_lit(insn))
> +               asi->handler = simulate_ldr_literal;
> +       else if (aarch64_insn_is_ldrsw_lit(insn))
> +               asi->handler = simulate_ldrsw_literal;

also

else if (aarch64_insn_is_br_blr(insn) || aarch64_insn_is_ret(insn))
               asi->handler = simulate_br_blr_ret;


~Pratyush
