Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaEYXNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:13:39 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:46676 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaEYXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <CALeycy_nOLYiCePv8=dkM--iUjzpkNSErfGd4pDBFcu12c4JdA@mail.gmail.com>
References: <CALeycy_nOLYiCePv8=dkM--iUjzpkNSErfGd4pDBFcu12c4JdA@mail.gmail.com>
Date: Sun, 25 May 2014 18:13:36 -0500
Message-ID: <CALeycy-X94kCViSc=9nbFFsU=AFxXGx-P25XtNaHnQTswWabRw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: x86: check CS.DPL against RPL during task switch
From: Wei Huang <huangwei.virt@gmail.com>
To: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, gleb@kernel.org, avi.kivity@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 1:12 PM, Wei Huang <huangwei.virt@gmail.com> wrote:
> Table 7-1 of the SDM mentions a check that the code segment's
> DPL must match the selector's RPL.  This was not done by KVM,
> fix it.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 47e716ef46b7..2fa7ab069817 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1411,7 +1411,7 @@ static int write_segment_descriptor(struct
> x86_emulate_ctxt *ctxt,
>
>  /* Does not support long mode */
>  static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
> -     u16 selector, int seg, u8 cpl)
> +     u16 selector, int seg, u8 cpl, bool in_task_switch)

A small nit-picking: a new line to comply with 80 characters per line
rule. otherwise looks good to me.

Reviewed-by: Wei Huang <huangwei.virt@gmail.com>

>  {
>   struct desc_struct seg_desc, old_desc;
>   u8 dpl, rpl;
> @@ -1486,6 +1486,9 @@ static int __load_segment_descriptor(struct
> x86_emulate_ctxt *ctxt,
>   goto exception;
>   break;
>   case VCPU_SREG_CS:
> + if (in_task_switch && rpl != dpl)
> + goto exception;
> +
>   if (!(seg_desc.type & 8))
>   goto exception;
>
> @@ -1547,7 +1550,7 @@ static int load_segment_descriptor(struct
> x86_emulate_ctxt *ctxt,
>     u16 selector, int seg)
>  {
>   u8 cpl = ctxt->ops->cpl(ctxt);
> - return __load_segment_descriptor(ctxt, selector, seg, cpl);
> + return __load_segment_descriptor(ctxt, selector, seg, cpl, false);
>  }
>
>  static void write_register_operand(struct operand *op)
> @@ -2440,19 +2443,19 @@ static int load_state_from_tss16(struct
> x86_emulate_ctxt *ctxt,
>   * Now load segment descriptors. If fault happens at this stage
>   * it is handled in a context of new task
>   */
> - ret = __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
>
> @@ -2577,25 +2580,25 @@ static int load_state_from_tss32(struct
> x86_emulate_ctxt *ctxt,
>   * Now load segment descriptors. If fault happenes at this stage
>   * it is handled in a context of new task
>   */
> - ret = __load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ldt_selector,
> VCPU_SREG_LDTR, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
> - ret = __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl);
> + ret = __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl, true);
>   if (ret != X86EMUL_CONTINUE)
>   return ret;
>
> --
> 1.8.3.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
