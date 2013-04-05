Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161750Ab3DEMB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:01:59 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:65380 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161226Ab3DEMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <1363618233-6375-4-git-send-email-nschichan@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-4-git-send-email-nschichan@freebox.fr>
Date: Fri, 5 Apr 2013 14:01:55 +0200
Message-ID: <CAN9tCgQB1xa_AVBSjt4kYeJmXLPJ+X+oRp4T2PydsvVxWEfeSQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] ARM: net: bpf_jit: add support for jitted seccomp filters.
From: Mircea Gherzan <mgherzan@gmail.com>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org >> linux-kernel@vger.kernel.org" 
	<linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18 Nicolas Schichan <nschichan@freebox.fr>:
> This patch selects HAVE_SECCOMP_FILTER_JIT in the ARM Kconfig file,
> implements and seccomp_jit_compile() and seccomp_jit_free(), and adds
> support for BPF_S_ANC_SECCOMP_LD_W instruction.
>
> BPF_S_ANC_SECCOMP_LD_W instructions trigger the generation of a call
> to C function seccomp_bpf_load().
>
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>  arch/arm/Kconfig          |    1 +
>  arch/arm/net/bpf_jit_32.c |   36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dedf02b..b3dce17 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -24,6 +24,7 @@ config ARM
>         select HAVE_ARCH_SECCOMP_FILTER
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_BPF_JIT
> +       select HAVE_SECCOMP_FILTER_JIT
>         select HAVE_C_RECORDMCOUNT
>         select HAVE_DEBUG_KMEMLEAK
>         select HAVE_DMA_API_DEBUG
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index 0ea29e0..86e3b78 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -548,6 +548,15 @@ load_common:
>                         emit_err_ret(ARM_COND_NE, ctx);
>                         emit(ARM_MOV_R(r_A, ARM_R0), ctx);
>                         break;
> +#ifdef CONFIG_SECCOMP_FILTER_JIT
> +               case BPF_S_ANC_SECCOMP_LD_W:
> +                       ctx->seen |= SEEN_CALL;
> +                       emit_mov_i(ARM_R3, (u32)seccomp_bpf_load, ctx);
> +                       emit_mov_i(ARM_R0, k, ctx);
> +                       emit_blx_r(ARM_R3, ctx);
> +                       emit(ARM_MOV_R(r_A, ARM_R0), ctx);
> +                       break;
> +#endif
>                 case BPF_S_LD_W_IND:
>                         load_order = 2;
>                         goto load_ind;
> @@ -956,3 +965,30 @@ void bpf_jit_free(struct sk_filter *fp)
>                 schedule_work(work);
>         }
>  }
> +
> +#ifdef CONFIG_SECCOMP_FILTER_JIT
> +void seccomp_jit_compile(struct seccomp_filter *fp)
> +{
> +       struct jit_ctx ctx;
> +
> +       memset(&ctx, 0, sizeof(ctx));
> +       ctx.prog_len = fp->len;
> +       ctx.prog_insns = fp->insns;
> +
> +       __bpf_jit_compile(&ctx);
> +       if (ctx.target)
> +               fp->bpf_func = (void*)ctx.target;
> +}
> +
> +void seccomp_jit_free(struct seccomp_filter *fp)
> +{
> +       struct work_struct *work;
> +
> +       if (fp->bpf_func != sk_run_filter) {
> +               work = (struct work_struct *)fp->bpf_func;
> +
> +               INIT_WORK(work, bpf_jit_free_worker);
> +               schedule_work(work);
> +       }
> +}
> +#endif
> --
> 1.7.10.4
>

Acked-by: Mircea Gherzan <mgherzan@gmail.com>
