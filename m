Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFWJaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:30:23 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43322 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaFWJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <1403317797-3977-1-git-send-email-yinghai@kernel.org>
References: <1403317797-3977-1-git-send-email-yinghai@kernel.org>
Date: Mon, 23 Jun 2014 11:30:19 +0200
X-Google-Sender-Auth: ac1_LIjMmKU8TEwmp4lUY4GeqQw
Message-ID: <CAMuHMdVFt-dCnmf3KH6HABdBvN7pzND_vOzpCGvnW9em22LWxw@mail.gmail.com>
Subject: Re: [PATCH v2] initramfs: Support initrd that is bigger than 2GiB
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 4:29 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> --- linux-2.6.orig/init/initramfs.c
> +++ linux-2.6/init/initramfs.c
> @@ -19,6 +19,26 @@
>  #include <linux/syscalls.h>
>  #include <linux/utime.h>
>
> +static long __init xwrite(unsigned int fd, char *p,
> +                                  size_t count)

Shouldn't this return ssize_t instead of long?

> +{
> +       ssize_t left = count;
> +       long written;

ssize_t written

> +
> +       /* sys_write only can write MAX_RW_COUNT aka 2G-4K bytes at most */
> +       while (left > 0) {
> +               written = sys_write(fd, p, left);
> +
> +               if (written <= 0)
> +                       break;
> +
> +               left -= written;
> +               p += written;
> +       }
> +
> +       return (written < 0) ? written : count;
> +}
> +
>  static __initdata char *message;
>  static void __init error(char *x)
>  {

> @@ -604,8 +624,13 @@ static int __init populate_rootfs(void)
>                 fd = sys_open("/initrd.image",
>                               O_WRONLY|O_CREAT, 0700);
>                 if (fd >= 0) {
> -                       sys_write(fd, (char *)initrd_start,
> -                                       initrd_end - initrd_start);
> +                       long written = xwrite(fd, (char *)initrd_start,

ssize_t written

> +                                               initrd_end - initrd_start);
> +
> +                       if (written != initrd_end - initrd_start)
> +                               pr_err("/initrd.image: incomplete write (%ld != %ld)\n",

"%zd", once written is ssize_t.

> +                                      written, initrd_end - initrd_start);
> +
>                         sys_close(fd);
>                         free_initrd();
>                 }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
