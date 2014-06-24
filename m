Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaFXXzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:55:04 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55132 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaFXXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <1403650817-21641-1-git-send-email-benchan@chromium.org>
References: <1403650817-21641-1-git-send-email-benchan@chromium.org>
Date: Tue, 24 Jun 2014 16:55:00 -0700
X-Google-Sender-Auth: Ew9HiDbn-tloOk_N5jrjQN8AufI
Message-ID: <CAGXu5j+gntXQQdC4aOiH9mOTv5rEqXqbQ1rt2XN_BkWznLR=7A@mail.gmail.com>
Subject: Re: [PATCH] MIPS: ZBOOT: implement stack protector in compressed boot phase
From: Kees Cook <keescook@chromium.org>
To: Ben Chan <benchan@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 4:00 PM, Ben Chan <benchan@chromium.org> wrote:
> This patch implements the stack protector code in MIPS compressed boot
> phase based on the same code added to arm in commit
> 8779657d29c0ebcc0c94ede4df2f497baf1b563f "stackprotector: Introduce
> CONFIG_CC_STACKPROTECTOR_STRONG" by Kees Cook <keescook@chromium.org>
>
> Signed-off-by: Ben Chan <benchan@chromium.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Olof Johansson <olofj@chromium.org>
> ---
>  arch/mips/boot/compressed/decompress.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compressed/decompress.c
> index c00c4dd..b49c7ad 100644
> --- a/arch/mips/boot/compressed/decompress.c
> +++ b/arch/mips/boot/compressed/decompress.c
> @@ -67,10 +67,24 @@ void error(char *x)
>  #include "../../../../lib/decompress_unxz.c"
>  #endif
>
> +unsigned long __stack_chk_guard;
> +
> +void __stack_chk_guard_setup(void)
> +{
> +       __stack_chk_guard = 0x000a0dff;
> +}
> +
> +void __stack_chk_fail(void)
> +{
> +       error("stack-protector: Kernel stack is corrupted\n");
> +}
> +
>  void decompress_kernel(unsigned long boot_heap_start)
>  {
>         unsigned long zimage_start, zimage_size;
>
> +       __stack_chk_guard_setup();
> +
>         zimage_start = (unsigned long)(&__image_begin);
>         zimage_size = (unsigned long)(&__image_end) -
>             (unsigned long)(&__image_begin);
> --
> 2.0.0.526.g5318336

Yup, that looks correct to me. As in the ARM case, gathering entropy
for the canary here is overkill, so this is sufficient to build and
provide basic canary support in the decompression phase of boot.

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
