Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab3CHS7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:59:13 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49603 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3CHS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <s5h6211lrx3.wl%tiwai@suse.de>
References: <CA+ydwtpxXb2SSpyG9vn7mvvRU6Z+1BhOe5qi+QXf-6+E_iZ3kg@mail.gmail.com>
	<s5h6211lrx3.wl%tiwai@suse.de>
Date: Fri, 8 Mar 2013 20:59:11 +0200
Message-ID: <CA+ydwtriiYSkT5fN_VOw4kHodoadgC80dDg4K3iydjaT5c5jAA@mail.gmail.com>
Subject: Re: snd_seq_timer_open() NULL pointer dereference
From: Tommi Rantala <tt.rantala@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 Takashi Iwai <tiwai@suse.de>:
> At Thu, 7 Mar 2013 21:59:32 +0200,
> Tommi Rantala wrote:
>>
>> Hello,
>>
>> I'm hitting this while fuzzing the kernel with Trinity:
>
> The patch below fixes a clear bug in the code path.
> Could you check whether it'll fit?
>
>
> thanks,
>
> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: seq: Fix missing error handling in snd_seq_timer_open()
>
> snd_seq_timer_open() didn't catch the whole error path but let through
> if the timer id is a slave.  This may lead to Oops by accessing the
> uninitialized pointer.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Confirmed, this fixes the bug. Thanks!

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>

> ---
>  sound/core/seq/seq_timer.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
> index 160b1bd..24d44b2 100644
> --- a/sound/core/seq/seq_timer.c
> +++ b/sound/core/seq/seq_timer.c
> @@ -290,10 +290,10 @@ int snd_seq_timer_open(struct snd_seq_queue *q)
>                         tid.device = SNDRV_TIMER_GLOBAL_SYSTEM;
>                         err = snd_timer_open(&t, str, &tid, q->queue);
>                 }
> -               if (err < 0) {
> -                       snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err);
> -                       return err;
> -               }
> +       }
> +       if (err < 0) {
> +               snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err);
> +               return err;
>         }
>         t->callback = snd_seq_timer_interrupt;
>         t->callback_data = q;
> --
> 1.8.1.4
>
