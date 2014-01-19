Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaASJkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 04:40:23 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64564 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaASJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 04:40:19 -0500
MIME-Version: 1.0
Date: Sun, 19 Jan 2014 10:40:18 +0100
X-Google-Sender-Auth: wCxC1nBVezTRg0yJEevcGkNCYYs
Message-ID: <CAMuHMdWx9QVn1j2QauMQfza_e_+4DHRg9WpZkocCr7+jtjwtMQ@mail.gmail.com>
Subject: Re: don't use module_init in non-modular ... (was: Re: [PATCH] m68k:
 don't use module_init in non-modular mvme16x/rtc.c code)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Jan 16, 2014 at 11:15 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> The rtc.o is built for obj-y, i.e. always built in.  It will
> never be modular, so using module_init as an alias for __initcall
> can be somewhat misleading.
>
> Fix this up now, so that we can relocate module_init from
> init.h into module.h in the future.  If we don't do this, we'd
> have to add module.h to obviously non-modular code, and that
> would be a worse thing.

The word "module" has different meanings: it can be a "loadable kernel module",
or just a "code module". include/linux/init.h seems to agree with this:
    /**
     * module_init() - driver initialization entry point
     * @x: function to be run at kernel boot time or module insertion
     *
     * module_init() will either be called during do_initcalls() (if
     * builtin) or at module insertion time (if a module).  There can only
     * be one per module.
     */
    #define module_init(x)  __initcall(x);

I can understand you want to restrict "module_init()" to real loadable
modules, but "device_initcall()" sounds like a real bad name or this.

Furthermore, many places that contain always compiled-in code and
currently only use module_init() should probably start using module_exit()
as well, to do the proper cleanups to make kexec work.

So I'm not really convinced this is the way we want to go...

> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of device_initcall
> directly in this change means that the runtime impact is
> zero -- it will remain at level 6 in initcall ordering.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
> index 6ef7a81a3b12..1755e2f7137d 100644
> --- a/arch/m68k/mvme16x/rtc.c
> +++ b/arch/m68k/mvme16x/rtc.c
> @@ -161,4 +161,4 @@ static int __init rtc_MK48T08_init(void)
>         printk(KERN_INFO "MK48T08 Real Time Clock Driver v%s\n", RTC_VERSION);
>         return misc_register(&rtc_dev);
>  }
> -module_init(rtc_MK48T08_init);
> +device_initcall(rtc_MK48T08_init);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
