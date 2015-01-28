Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbbA2EJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:09:08 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47759 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbbA2EJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:09:05 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3.4 152/177] KVM: x86: Fix uninitialized op->type for some immediate values
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1422418236-12852-243-git-send-email-lizf@kernel.org>
Date: Wed, 28 Jan 2015 10:47:02 +0200
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <861C01D3-25A0-4411-9FBF-C72128CF3EBC@gmail.com>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-243-git-send-email-lizf@kernel.org>
To: lizf@kernel.org
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug should have no effect on Linux 3.4. It shouldn’t hurt, but the
problem it fixes was introduced in 3.16 or 3.17.

Nadav

lizf@kernel.org wrote:

> From: Nadav Amit <namit@cs.technion.ac.il>
> 
> 3.4.106-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> 
> commit d29b9d7ed76c0b961603ca692b8a562556a20212 upstream.
> 
> The emulator could reuse an op->type from a previous instruction for some
> immediate values.  If it mistakenly considers the operands as memory
> operands, it will performs a memory read and overwrite op->val.
> 
> Consider for instance the ROR instruction - src2 (the number of times)
> would be read from memory instead of being used as immediate.
> 
> Mark every immediate operand as such to avoid this problem.
> 
> Fixes: c44b4c6ab80eef3a9c52c7b3f0c632942e6489aa
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
> arch/x86/kvm/emulate.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e125c3e..0a12507 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3833,6 +3833,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
> 		fetch_register_operand(op);
> 		break;
> 	case OpCL:
> +		op->type = OP_IMM;
> 		op->bytes = 1;
> 		op->val = ctxt->regs[VCPU_REGS_RCX] & 0xff;
> 		break;
> @@ -3840,6 +3841,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
> 		rc = decode_imm(ctxt, op, 1, true);
> 		break;
> 	case OpOne:
> +		op->type = OP_IMM;
> 		op->bytes = 1;
> 		op->val = 1;
> 		break;
> @@ -3879,21 +3881,27 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
> 		ctxt->memop.bytes = ctxt->op_bytes + 2;
> 		goto mem_common;
> 	case OpES:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_ES;
> 		break;
> 	case OpCS:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_CS;
> 		break;
> 	case OpSS:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_SS;
> 		break;
> 	case OpDS:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_DS;
> 		break;
> 	case OpFS:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_FS;
> 		break;
> 	case OpGS:
> +		op->type = OP_IMM;
> 		op->val = VCPU_SREG_GS;
> 		break;
> 	case OpImplicit:
> -- 
> 1.9.1


