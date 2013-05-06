Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3EFG7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 02:59:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33291 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3EFG7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 02:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <0000013e6b0fcf7b-9fabe4c8-2667-4bea-a9d1-f1c77e18fe78-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b0fcf7b-9fabe4c8-2667-4bea-a9d1-f1c77e18fe78-000000@email.amazonses.com>
Date: Mon, 6 May 2013 08:59:39 +0200
X-Google-Sender-Auth: sBisUDfYWdZ2p7fU7MgAC02BleM
Message-ID: <CAMuHMdUEmfOUT8xLZgH+i57uKA4TvYt_8DoDk4_3HbedFKY10A@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, glommer@parallels.com,
        Pekka Enberg <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:43 PM, Christoph Lameter <cl@linux.com> wrote:
> Subject: slab: Return NULL for oversized allocations
>
> The inline path seems to have changed the SLAB behavior for very large
> kmalloc allocations. This patch restores the old behavior but also
> adds diagnostics so that we can figure where in the code these
> large allocations occur.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
>
> Index: linux/include/linux/slab_def.h
> ===================================================================
> --- linux.orig/include/linux/slab_def.h 2013-05-03 10:36:46.019564801 -0500
> +++ linux/include/linux/slab_def.h      2013-05-03 10:37:28.860302188 -0500
> @@ -126,6 +126,11 @@ static __always_inline void *kmalloc(siz
>                 if (!size)
>                         return ZERO_SIZE_PTR;
>
> +               if (size > KMALLOC_MAX_SIZE) {
> +                       WARN_ON(1);

As we were worried about this being triggered frm userspace, this needs
some rate limiting, to avoid flooding the kernel logs.

> +                       return NULL;
> +               }
> +
>                 i = kmalloc_index(size);
>
>  #ifdef CONFIG_ZONE_DMA
> @@ -172,6 +177,11 @@ static __always_inline void *kmalloc_nod
>                 if (!size)
>                         return ZERO_SIZE_PTR;
>
> +               if (size > KMALLOC_MAX_SIZE) {
> +                       WARN_ON(1);

Idem ditto.

> +                       return NULL;
> +               }
> +
>                 i = kmalloc_index(size);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
