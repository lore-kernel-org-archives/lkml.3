Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3BRK3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:29:21 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41535 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab3BRK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
Date: Mon, 18 Feb 2013 11:29:18 +0100
X-Google-Sender-Auth: ub5PijvdzM2LBCr1OU1VeeseFU8
Message-ID: <CAMuHMdXJ+waZJ95bRLPYYsneXf98c=9d9n1jdkWMKhUpAAB_RA@mail.gmail.com>
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer Driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org, kys@microsoft.com,
        olaf@aepfle.de, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 8:09 PM, Haiyang Zhang <haiyangz@microsoft.com> wrote:
> +/* Allocate framebuffer memory */
> +#define FOUR_MEGA (4*1024*1024)
> +#define NALLOC 10
> +static void *hvfb_getmem(void)
> +{
> +       ulong *p;
> +       int i, j;
> +       ulong ret = 0;
> +
> +       if (screen_fb_size == FOUR_MEGA) {
> +               ret = __get_free_pages(GFP_KERNEL|__GFP_ZERO,
> +                                      get_order(FOUR_MEGA));
> +               goto out1;
> +       }
> +
> +       if (screen_fb_size != FOUR_MEGA * 2)
> +               return NULL;
> +
> +       /*
> +        * Windows 2012 requires frame buffer size to be 8MB, which exceeds
> +        * the limit of __get_free_pages(). So, we allocate multiple 4MB
> +        * chunks, and find out two adjacent ones.
> +        */
> +       p = kmalloc(NALLOC * sizeof(ulong), GFP_KERNEL);
> +       if (!p)
> +               return NULL;
> +
> +       for (i = 0; i < NALLOC; i++)
> +               p[i] = __get_free_pages(GFP_KERNEL|__GFP_ZERO,
> +                                       get_order(FOUR_MEGA));
> +
> +       for (i = 0; i < NALLOC; i++)
> +               for (j = 0; j < NALLOC; j++) {
> +                       if (p[j] && p[i] && virt_to_phys((void *)p[j]) -
> +                           virt_to_phys((void *)p[i]) == FOUR_MEGA &&
> +                           p[j] - p[i] == FOUR_MEGA) {
> +                               ret = p[i];
> +                               goto out;
> +                       }
> +               }
> +
> +out:
> +       for (i = 0; i < NALLOC; i++)
> +               if (p[i] && !(ret && (p[i] == ret || p[i] == ret + FOUR_MEGA)))
> +                       free_pages(p[i], get_order(FOUR_MEGA));
> +
> +       kfree(p);
> +
> +out1:
> +       if (!ret)
> +               return NULL;
> +
> +       /* Get an extra ref-count to prevent page error when x-window exits */
> +       for (i = 0; i < screen_fb_size; i += PAGE_SIZE)
> +               atomic_inc(&virt_to_page((void *)ret + i)->_count);
> +
> +       return (void *)ret;
> +}

Please instead reserve some memory at boot time, or allocate it very early
(cfr. ps3fb).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
