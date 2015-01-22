Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAVHy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:54:28 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:60093 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAVHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:54:19 -0500
MIME-Version: 1.0
In-Reply-To: <54C0A357.4070701@gmail.com>
References: <54C0A357.4070701@gmail.com>
Date: Thu, 22 Jan 2015 15:54:17 +0800
X-Google-Sender-Auth: HrWXP2SzgkAh0bbQGRXAcLQ5f6A
Message-ID: <CAFiDJ58imeQEZxySFOYoYd27YU4wCYrsw+oDe8Pi3j3n13o2mg@mail.gmail.com>
Subject: Re: [PATCH] nios2: __kuser_sigtramp placement fix
From: Ley Foon Tan <lftan@altera.com>
To: Chung-Lin Tang <chunglin.tang@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 3:14 PM, Chung-Lin Tang <chunglin.tang@gmail.com> wrote:
> The address of __kuser_sigtramp is wrong by one word, due to padding
> __kuser_cmpxchg to fully 64 bytes. The version word at the start of the
> page displaces __kuser_sigtramp to 0x1044, instead of the intended 0x1040.
>
> Fixed by counting the 64-byte frame from the start of the page instead
> of __kuser_cmpxchg. This shortens the __kuser_cmpxchg frame to 60-bytes,
> but that's likely enough.
>
> The zero-byte padding parts of the kuser_pad macro has been removed, due
> to the .if command refusing to behave properly when there are other
> .word directives in between. Probably a binutils gas bug.
>
> Thanks,
> Chung-Lin
>
> Cc: Ley Foon Tan <lftan@altera.com>
> Cc: Tobias Klauser <tklauser@distanz.ch>
> Signed-off-by: Chung-Lin Tang <cltang@codesourcery.com>
>
> diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
> index 0bdfd13..3224839 100644
> --- a/arch/nios2/kernel/entry.S
> +++ b/arch/nios2/kernel/entry.S
> @@ -492,14 +492,7 @@ ENTRY(ret_from_kernel_thread)
>
>   /* Filling pads with undefined instructions. */
>  .macro kuser_pad sym size
> -       .if     ((. - \sym) & 3)
> -       .rept   (4 - (. - \sym) & 3)
> -       .byte   0
> -       .endr
> -       .endif
> -       .rept   ((\size - (. - \sym)) / 4)
> -       .word   0xdeadbeef
> -       .endr
> +       .fill   ((\size - (. - \sym)) / 4), 4, 0xdeadbeef
>  .endm
>
>         .align  6
> @@ -526,7 +519,10 @@ cmpxchg_stw:
>  cmpxchg_ret:
>         ret
>
> -       kuser_pad __kuser_cmpxchg, 64
> +       /* The first 64-byte frame contains the version word, so note
> +          that the first padding entry is based from the start of the kuser
> +          page, instead of __kuser_cmpxchg.  */
> +       kuser_pad __kuser_helper_start, 64
>
>         .globl  __kuser_sigtramp
>  __kuser_sigtramp:
> --
Hi Chung-Lin

I thought this is our original intention for it.

First 4 bytes is the __kuser_version and each __kuser function will
have 64 bytes size.

0x1000 __kuser_helper_version
0x1004 __kuser_cmpxchg
0x1044 __kuser_sigtramp

Any reason you can't use __kuser_sigtramp @ 0x1044?
Thanks.

Regards
Ley Foon
