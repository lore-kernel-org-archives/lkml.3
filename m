Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3DZOEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:04:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3DZOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:04:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Subject: Re: [PATCH V3 2/3] ARM: net: bpf_jit: make code generation less dependent on struct sk_filter.
Date: Fri, 26 Apr 2013 16:04:44 +0200
Message-ID: <3592414.M8kQZLCXlW@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366824429-26652-3-git-send-email-nschichan@freebox.fr>
References: <1366824429-26652-1-git-send-email-nschichan@freebox.fr> <1366824429-26652-3-git-send-email-nschichan@freebox.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rjzKgtTLflyZt59M5XvXNRnArulqwnR/cr4yVtweNYJ
 NfKeeJaFLiRFGuNVO1RyG4qRK2WIqtvAOsRXZ6lZLPiMwsSayR
 7DofHwEhxv6tohRGeJmfsWuQ9jkz9U5M+26FsT0f6KzDcvPR7r
 KHnXBI8/yKxJvDGI05FgMVGWUQ4XEWTIrqdWH0u8Q4W/z3qABJ
 cofMElAss/ubwse/CXYOsmLt9e9qCJCsIGYhFElkOJdn1GA1v6
 0ri0IxtWLbauek1BL4ez04DL+wLM8wHchn24fPFDHwe3Tfg4V0
 HQB5MThlQigvJamEAmoBEhRn5aA+qQyFfDVuGGiVQptegVBpnT
 QxmyPNPPlZR6mPwIJmz8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013 19:27:08 Nicolas Schichan wrote:
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

This part of the patch, in combination with 79617801e "filter: bpf_jit_comp:
refactor and unify BPF JIT image dump output" is now causing build errors
in linux-next:

arch/arm/net/bpf_jit_32.c: In function '__bpf_jit_compile':
arch/arm/net/bpf_jit_32.c:930:16: error: 'fp' undeclared (first use in this function)
   bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);
                ^


	Arnd
