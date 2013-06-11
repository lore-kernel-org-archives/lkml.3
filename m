Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3FKTRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:17:47 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58677 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3FKTRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130611184113.GA2288@www.outflux.net>
References: <20130611184113.GA2288@www.outflux.net>
Date: Tue, 11 Jun 2013 12:17:46 -0700
X-Google-Sender-Auth: Gh7aywNppac73GoH4oxSDOJtJj0
Message-ID: <CAE9FiQXCj+H=h+SPcfW82dBK5n6aDGuX+pmg7zr+6mKtdD4nMg@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: access cmdline when loaded high
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 11:41 AM, Kees Cook <keescook@chromium.org> wrote:
> The __cmdline_find_option routine requires that the kernel cmdline be
> located under 0x10000. When running the compressed boot code, if the
> cmdline is loaded above this range, it will be ignored. This breaks
> recognition of things like "earlyprintk=...". Since the compressed boot
> code is already tricking the cmdline routines about locations, take it all
> the way and access the cmdline via offset instead of via actual location.

Hi,

What is point of the patch?
It looks like it try to fix one bug, but it doesn't,
as there is no bug out there.

Before the patch, command line that is loaded high
can be processed correctly in arch/x86/boot/compressed/cmdline.c.

>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/boot/compressed/cmdline.c |   21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
> index bffd73b..2e39280 100644
> --- a/arch/x86/boot/compressed/cmdline.c
> +++ b/arch/x86/boot/compressed/cmdline.c
> @@ -2,32 +2,29 @@
>
>  #ifdef CONFIG_EARLY_PRINTK
>
> +/*
> + * We know where the cmdline is, so just retain it, and use a non-zero
> + * offset to trick __cmdline_find_option into running.
> + */
>  static unsigned long fs;
>  static inline void set_fs(unsigned long seg)
>  {
> -       fs = seg << 4;  /* shift it back */
> +       fs = real_mode->hdr.cmd_line_ptr;
> +       fs |= (u64)real_mode->ext_cmd_line_ptr << 32;
>  }
>  typedef unsigned long addr_t;
>  static inline char rdfs8(addr_t addr)
>  {
> -       return *((char *)(fs + addr));
> +       return *((char *)(fs + addr - 0x1));
>  }
>  #include "../cmdline.c"
> -static unsigned long get_cmd_line_ptr(void)
> -{
> -       unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
> -
> -       cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
> -
> -       return cmd_line_ptr;
> -}
>  int cmdline_find_option(const char *option, char *buffer, int bufsize)
>  {
> -       return __cmdline_find_option(get_cmd_line_ptr(), option, buffer, bufsize);
> +       return __cmdline_find_option(0x1, option, buffer, bufsize);

that's funny, why do you pick 0x1 here?
why not use 0x10 or 0?

>  }
>  int cmdline_find_option_bool(const char *option)
>  {
> -       return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
> +       return __cmdline_find_option_bool(0x1, option);
>  }
>
>  #endif
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
