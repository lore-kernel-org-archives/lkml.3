Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaGKTbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:31:55 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51720 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaGKTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140711175345.19079.28143.stgit@gimli.home>
References: <20140711175345.19079.28143.stgit@gimli.home>
Date: Fri, 11 Jul 2014 12:31:51 -0700
Message-ID: <CAG7+5M3Er0bd2pnuGjzp8z8MMBJG9bKTpsCQ_SrZASnjcwLW5A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86 emulator: emulate MOVNTDQ
From: Eric Northup <digitaleric@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:56 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Windows 8.1 guest with NVIDIA driver and GPU fails to boot with an
> emulation failure.  The KVM spew suggests the fault is with lack of
> movntdq emulation (courtesy of Paolo):
>
> Code=02 00 00 b8 08 00 00 00 f3 0f 6f 44 0a f0 f3 0f 6f 4c 0a e0 <66> 0f e7 41 f0 66 0f e7 49 e0 48 83 e9 40 f3 0f 6f 44 0a 10 f3 0f 6f 0c 0a 66 0f e7 41 10
>
> $ as -o a.out
>         .section .text
>         .byte 0x66, 0x0f, 0xe7, 0x41, 0xf0
>         .byte 0x66, 0x0f, 0xe7, 0x49, 0xe0
> $ objdump -d a.out
>     0:  66 0f e7 41 f0          movntdq %xmm0,-0x10(%rcx)
>     5:  66 0f e7 49 e0          movntdq %xmm1,-0x20(%rcx)
>
> Add the necessary emulation.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>
> Hope I got all the flags correct from copying similar MOV ops, but it
> allows the guest to boot, so I suspect it's ok.
>
>  arch/x86/kvm/emulate.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e4e833d..ae39f08 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3681,6 +3681,10 @@ static const struct gprefix pfx_0f_28_0f_29 = {
>         I(Aligned, em_mov), I(Aligned, em_mov), N, N,
>  };
>
> +static const struct gprefix pfx_0f_e7 = {
> +       N, I(Sse, em_mov), N, N,

I think you need 'Aligned' flag in here - from my reading of the
manual, this instruction will #GP if the memory operand isn't aligned.

> +};
> +
>  static const struct escape escape_d9 = { {
>         N, N, N, N, N, N, N, I(DstMem, em_fnstcw),
>  }, {
> @@ -3951,7 +3955,8 @@ static const struct opcode twobyte_table[256] = {
>         /* 0xD0 - 0xDF */
>         N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
>         /* 0xE0 - 0xEF */
> -       N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
> +       N, N, N, N, N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_e7),
> +       N, N, N, N, N, N, N, N,
>         /* 0xF0 - 0xFF */
>         N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
>  };
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
