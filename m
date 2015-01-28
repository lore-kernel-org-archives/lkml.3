Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbbA1WYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:24:25 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63451 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbA1ULm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:42 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3.4 081/177] KVM: x86: Emulator fixes for eip canonical checks on near branches
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1422418236-12852-161-git-send-email-lizf@kernel.org>
Date: Wed, 28 Jan 2015 10:49:16 +0200
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A7FCAD0F-53C8-4B5F-9ABA-1EB4858AB289@gmail.com>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-161-git-send-email-lizf@kernel.org>
To: lizf@kernel.org
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in this patch, so please include
7e46dddd6f6cd5dbf3c7bd04a7e75d19475ac9f2 ("KVM: x86: Fix far-jump to
non-canonical check”) as well.

Regards,
Nadav

lizf@kernel.org wrote:

> From: Nadav Amit <namit@cs.technion.ac.il>
> 
> 3.4.106-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> 
> commit 234f3ce485d54017f15cf5e0699cff4100121601 upstream.
> 
> Before changing rip (during jmp, call, ret, etc.) the target should be asserted
> to be canonical one, as real CPUs do.  During sysret, both target rsp and rip
> should be canonical. If any of these values is noncanonical, a #GP exception
> should occur.  The exception to this rule are syscall and sysenter instructions
> in which the assigned rip is checked during the assignment to the relevant
> MSRs.
> 
> This patch fixes the emulator to behave as real CPUs do for near branches.
> Far branches are handled by the next patch.
> 
> This fixes CVE-2014-3647.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [lizf: Backported to 3.4:
> - adjust context
> - use ctxt->regs rather than reg_read() and reg_write()]
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
> arch/x86/kvm/emulate.c | 78 ++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 54 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index fa23346..c3e1942 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -532,7 +532,8 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
> 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
> }
> 
> -static inline void assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
> +static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
> +			       int cs_l)
> {
> 	switch (ctxt->op_bytes) {
> 	case 2:
> @@ -542,16 +543,25 @@ static inline void assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
> 		ctxt->_eip = (u32)dst;
> 		break;
> 	case 8:
> +		if ((cs_l && is_noncanonical_address(dst)) ||
> +		    (!cs_l && (dst & ~(u32)-1)))
> +			return emulate_gp(ctxt, 0);
> 		ctxt->_eip = dst;
> 		break;
> 	default:
> 		WARN(1, "unsupported eip assignment size\n");
> 	}
> +	return X86EMUL_CONTINUE;
> +}
> +
> +static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst)
> +{
> +	return assign_eip_far(ctxt, dst, ctxt->mode == X86EMUL_MODE_PROT64);
> }
> 
> -static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> +static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> {
> -	assign_eip_near(ctxt, ctxt->_eip + rel);
> +	return assign_eip_near(ctxt, ctxt->_eip + rel);
> }
> 
> static u16 get_segment_selector(struct x86_emulate_ctxt *ctxt, unsigned seg)
> @@ -1802,13 +1812,15 @@ static int em_grp45(struct x86_emulate_ctxt *ctxt)
> 	case 2: /* call near abs */ {
> 		long int old_eip;
> 		old_eip = ctxt->_eip;
> -		ctxt->_eip = ctxt->src.val;
> +		rc = assign_eip_near(ctxt, ctxt->src.val);
> +		if (rc != X86EMUL_CONTINUE)
> +			break;
> 		ctxt->src.val = old_eip;
> 		rc = em_push(ctxt);
> 		break;
> 	}
> 	case 4: /* jmp abs */
> -		ctxt->_eip = ctxt->src.val;
> +		rc = assign_eip_near(ctxt, ctxt->src.val);
> 		break;
> 	case 5: /* jmp far */
> 		rc = em_jmp_far(ctxt);
> @@ -1840,10 +1852,14 @@ static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
> 
> static int em_ret(struct x86_emulate_ctxt *ctxt)
> {
> -	ctxt->dst.type = OP_REG;
> -	ctxt->dst.addr.reg = &ctxt->_eip;
> -	ctxt->dst.bytes = ctxt->op_bytes;
> -	return em_pop(ctxt);
> +	int rc;
> +	unsigned long eip;
> +
> +	rc = emulate_pop(ctxt, &eip, ctxt->op_bytes);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> +
> +	return assign_eip_near(ctxt, eip);
> }
> 
> static int em_ret_far(struct x86_emulate_ctxt *ctxt)
> @@ -2108,7 +2124,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
> {
> 	struct x86_emulate_ops *ops = ctxt->ops;
> 	struct desc_struct cs, ss;
> -	u64 msr_data;
> +	u64 msr_data, rcx, rdx;
> 	int usermode;
> 	u16 cs_sel = 0, ss_sel = 0;
> 
> @@ -2124,6 +2140,9 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
> 	else
> 		usermode = X86EMUL_MODE_PROT32;
> 
> +	rcx = ctxt->regs[VCPU_REGS_RCX];
> +	rdx = ctxt->regs[VCPU_REGS_RDX];
> +
> 	cs.dpl = 3;
> 	ss.dpl = 3;
> 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_CS, &msr_data);
> @@ -2141,6 +2160,9 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
> 		ss_sel = cs_sel + 8;
> 		cs.d = 0;
> 		cs.l = 1;
> +		if (is_noncanonical_address(rcx) ||
> +		    is_noncanonical_address(rdx))
> +			return emulate_gp(ctxt, 0);
> 		break;
> 	}
> 	cs_sel |= SELECTOR_RPL_MASK;
> @@ -2149,8 +2171,8 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
> 	ops->set_segment(ctxt, cs_sel, &cs, 0, VCPU_SREG_CS);
> 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
> 
> -	ctxt->_eip = ctxt->regs[VCPU_REGS_RDX];
> -	ctxt->regs[VCPU_REGS_RSP] = ctxt->regs[VCPU_REGS_RCX];
> +	ctxt->_eip = rdx;
> +	ctxt->regs[VCPU_REGS_RSP] = rcx;
> 
> 	return X86EMUL_CONTINUE;
> }
> @@ -2646,10 +2668,13 @@ static int em_das(struct x86_emulate_ctxt *ctxt)
> 
> static int em_call(struct x86_emulate_ctxt *ctxt)
> {
> +	int rc;
> 	long rel = ctxt->src.val;
> 
> 	ctxt->src.val = (unsigned long)ctxt->_eip;
> -	jmp_rel(ctxt, rel);
> +	rc = jmp_rel(ctxt, rel);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> 	return em_push(ctxt);
> }
> 
> @@ -2681,11 +2706,12 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
> static int em_ret_near_imm(struct x86_emulate_ctxt *ctxt)
> {
> 	int rc;
> +	unsigned long eip;
> 
> -	ctxt->dst.type = OP_REG;
> -	ctxt->dst.addr.reg = &ctxt->_eip;
> -	ctxt->dst.bytes = ctxt->op_bytes;
> -	rc = emulate_pop(ctxt, &ctxt->dst.val, ctxt->op_bytes);
> +	rc = emulate_pop(ctxt, &eip, ctxt->op_bytes);
> +	if (rc != X86EMUL_CONTINUE)
> +		return rc;
> +	rc = assign_eip_near(ctxt, eip);
> 	if (rc != X86EMUL_CONTINUE)
> 		return rc;
> 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RSP], ctxt->src.val);
> @@ -2994,20 +3020,24 @@ static int em_lmsw(struct x86_emulate_ctxt *ctxt)
> 
> static int em_loop(struct x86_emulate_ctxt *ctxt)
> {
> +	int rc = X86EMUL_CONTINUE;
> +
> 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RCX], -1);
> 	if ((address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) != 0) &&
> 	    (ctxt->b == 0xe2 || test_cc(ctxt->b ^ 0x5, ctxt->eflags)))
> -		jmp_rel(ctxt, ctxt->src.val);
> +		rc = jmp_rel(ctxt, ctxt->src.val);
> 
> -	return X86EMUL_CONTINUE;
> +	return rc;
> }
> 
> static int em_jcxz(struct x86_emulate_ctxt *ctxt)
> {
> +	int rc = X86EMUL_CONTINUE;
> +
> 	if (address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) == 0)
> -		jmp_rel(ctxt, ctxt->src.val);
> +		rc = jmp_rel(ctxt, ctxt->src.val);
> 
> -	return X86EMUL_CONTINUE;
> +	return rc;
> }
> 
> static int em_in(struct x86_emulate_ctxt *ctxt)
> @@ -4185,7 +4215,7 @@ special_insn:
> 		break;
> 	case 0x70 ... 0x7f: /* jcc (short) */
> 		if (test_cc(ctxt->b, ctxt->eflags))
> -			jmp_rel(ctxt, ctxt->src.val);
> +			rc = jmp_rel(ctxt, ctxt->src.val);
> 		break;
> 	case 0x8d: /* lea r16/r32, m */
> 		ctxt->dst.val = ctxt->src.addr.mem.ea;
> @@ -4224,7 +4254,7 @@ special_insn:
> 		break;
> 	case 0xe9: /* jmp rel */
> 	case 0xeb: /* jmp rel short */
> -		jmp_rel(ctxt, ctxt->src.val);
> +		rc = jmp_rel(ctxt, ctxt->src.val);
> 		ctxt->dst.type = OP_NONE; /* Disable writeback. */
> 		break;
> 	case 0xf4:              /* hlt */
> @@ -4327,7 +4357,7 @@ twobyte_insn:
> 		break;
> 	case 0x80 ... 0x8f: /* jnz rel, etc*/
> 		if (test_cc(ctxt->b, ctxt->eflags))
> -			jmp_rel(ctxt, ctxt->src.val);
> +			rc = jmp_rel(ctxt, ctxt->src.val);
> 		break;
> 	case 0x90 ... 0x9f:     /* setcc r/m8 */
> 		ctxt->dst.val = test_cc(ctxt->b, ctxt->eflags);
> -- 
> 1.9.1


