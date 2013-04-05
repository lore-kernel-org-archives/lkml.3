Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161637Ab3DEMBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:01:39 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34799 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161750Ab3DEMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <1363618233-6375-3-git-send-email-nschichan@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-3-git-send-email-nschichan@freebox.fr>
Date: Fri, 5 Apr 2013 14:01:21 +0200
Message-ID: <CAN9tCgT0kxJrowV1Y6RX2RhnBgxOCc0o-8Jb2t5-jryG3M95Pg@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] ARM: net: bpf_jit: make code generation less
 dependent on struct sk_filter.
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
> This is in preparation of bpf_jit support for seccomp filters.
>
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>  arch/arm/net/bpf_jit_32.c |   46 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index 6828ef6..0ea29e0 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -55,7 +55,8 @@
>  #define FLAG_NEED_X_RESET      (1 << 0)
>
>  struct jit_ctx {
> -       const struct sk_filter *skf;
> +       unsigned short prog_len;
> +       struct sock_filter *prog_insns;
>         unsigned idx;
>         unsigned prologue_bytes;
>         int ret0_fp_idx;
> @@ -131,8 +132,8 @@ static u16 saved_regs(struct jit_ctx *ctx)
>  {
>         u16 ret = 0;
>
> -       if ((ctx->skf->len > 1) ||
> -           (ctx->skf->insns[0].code == BPF_S_RET_A))
> +       if ((ctx->prog_len > 1) ||
> +           (ctx->prog_insns[0].code == BPF_S_RET_A))
>                 ret |= 1 << r_A;
>
>  #ifdef CONFIG_FRAME_POINTER
> @@ -181,7 +182,7 @@ static inline bool is_load_to_a(u16 inst)
>  static void build_prologue(struct jit_ctx *ctx)
>  {
>         u16 reg_set = saved_regs(ctx);
> -       u16 first_inst = ctx->skf->insns[0].code;
> +       u16 first_inst = ctx->prog_insns[0].code;
>         u16 off;
>
>  #ifdef CONFIG_FRAME_POINTER
> @@ -279,7 +280,7 @@ static u16 imm_offset(u32 k, struct jit_ctx *ctx)
>                 ctx->imms[i] = k;
>
>         /* constants go just after the epilogue */
> -       offset =  ctx->offsets[ctx->skf->len];
> +       offset =  ctx->offsets[ctx->prog_len];
>         offset += ctx->prologue_bytes;
>         offset += ctx->epilogue_bytes;
>         offset += i * 4;
> @@ -419,7 +420,7 @@ static inline void emit_err_ret(u8 cond, struct jit_ctx *ctx)
>                 emit(ARM_MOV_R(ARM_R0, ARM_R0), ctx);
>         } else {
>                 _emit(cond, ARM_MOV_I(ARM_R0, 0), ctx);
> -               _emit(cond, ARM_B(b_imm(ctx->skf->len, ctx)), ctx);
> +               _emit(cond, ARM_B(b_imm(ctx->prog_len, ctx)), ctx);
>         }
>  }
>
> @@ -469,14 +470,13 @@ static inline void update_on_xread(struct jit_ctx *ctx)
>  static int build_body(struct jit_ctx *ctx)
>  {
>         void *load_func[] = {jit_get_skb_b, jit_get_skb_h, jit_get_skb_w};
> -       const struct sk_filter *prog = ctx->skf;
>         const struct sock_filter *inst;
>         unsigned i, load_order, off, condt;
>         int imm12;
>         u32 k;
>
> -       for (i = 0; i < prog->len; i++) {
> -               inst = &(prog->insns[i]);
> +       for (i = 0; i < ctx->prog_len; i++) {
> +               inst = &(ctx->prog_insns[i]);
>                 /* K as an immediate value operand */
>                 k = inst->k;
>
> @@ -769,8 +769,8 @@ cmp_x:
>                                 ctx->ret0_fp_idx = i;
>                         emit_mov_i(ARM_R0, k, ctx);
>  b_epilogue:
> -                       if (i != ctx->skf->len - 1)
> -                               emit(ARM_B(b_imm(prog->len, ctx)), ctx);
> +                       if (i != ctx->prog_len - 1)
> +                               emit(ARM_B(b_imm(ctx->prog_len, ctx)), ctx);
>                         break;
>                 case BPF_S_MISC_TAX:
>                         /* X = A */
> @@ -858,7 +858,7 @@ b_epilogue:
>  }
>
>
> -void bpf_jit_compile(struct sk_filter *fp)
> +static void __bpf_jit_compile(struct jit_ctx *out_ctx)
>  {
>         struct jit_ctx ctx;
>         unsigned tmp_idx;
> @@ -867,11 +867,10 @@ void bpf_jit_compile(struct sk_filter *fp)
>         if (!bpf_jit_enable)
>                 return;
>
> -       memset(&ctx, 0, sizeof(ctx));
> -       ctx.skf         = fp;
> +       ctx = *out_ctx;
>         ctx.ret0_fp_idx = -1;
>
> -       ctx.offsets = kzalloc(4 * (ctx.skf->len + 1), GFP_KERNEL);
> +       ctx.offsets = kzalloc(4 * (ctx.prog_len + 1), GFP_KERNEL);
>         if (ctx.offsets == NULL)
>                 return;
>
> @@ -921,13 +920,26 @@ void bpf_jit_compile(struct sk_filter *fp)
>                 print_hex_dump(KERN_INFO, "BPF JIT code: ",
>                                DUMP_PREFIX_ADDRESS, 16, 4, ctx.target,
>                                alloc_size, false);
> -
> -       fp->bpf_func = (void *)ctx.target;
>  out:
>         kfree(ctx.offsets);
> +
> +       *out_ctx = ctx;
>         return;
>  }
>
> +void bpf_jit_compile(struct sk_filter *fp)
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
>  static void bpf_jit_free_worker(struct work_struct *work)
>  {
>         module_free(NULL, work);
> --
> 1.7.10.4
>

Acked-by: Mircea Gherzan <mgherzan@gmail.com>
