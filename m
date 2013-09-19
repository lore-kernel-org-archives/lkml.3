Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3ISO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:28:24 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37761 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3ISO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
	<20130917205742.16147.qmail@science.horizon.com>
	<201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
Date: Thu, 19 Sep 2013 07:28:21 -0700
X-Google-Sender-Auth: d26ObyltyXAarZ0r-VwyPrcNOcM
Message-ID: <CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jan Beulich <JBeulich@suse.com>, Joe Perches <joe@perches.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 1:56 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> George Spelvin wrote:
>> >>   seq_setwidth(m, 21);
>> >>   seq_printf(m, "%s%d", con->name, con->index);
>> >>   seq_pad(m, '\n');
>>
>> > Ooh, I like this a lot! Much cleaner.
>>
>> That's certainly a good way to do it, too.
>> My "general principles" filter thinks it should be in a local variable
>> if it can, but if hiding it in the struct seq_file is fine if people
>> find that cleaner.
>
> I think the good point of seq_file is that users don't need to worry about
> length calculation for overflow detection. This patch helps users to simplify
> length calculation for alignment. I think this approach is better if adding
> a size_t to the seq_file is acceptable.
>
> So, the patch follows.
> ----------------------------------------
> >From 02b28fd709971f71e5de9a5b595ff4fd059028b3 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 19 Sep 2013 17:23:17 +0900
> Subject: [PATCH] seq_file: Introduce seq_setwidth() and seq_pad()
>
> There are several users who want to know bytes written by seq_*() for alignment
> purpose. Currently they are using %n format for knowing it because seq_*()
> returns 0 on success.
>
> This patch introduces seq_setwidth() and seq_pad() for allowing them to align
> without using %n format.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

This really feels like a clean solution to me.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/seq_file.c            |   15 +++++++++++++++
>  include/linux/seq_file.h |   15 +++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3135c25..40e471e 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -764,6 +764,21 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
>  }
>  EXPORT_SYMBOL(seq_write);
>
> +/**
> + * seq_pad - write padding spaces to buffer
> + * @m: seq_file identifying the buffer to which data should be written
> + * @c: the byte to append after padding if non-zero
> + */
> +void seq_pad(struct seq_file *m, char c)
> +{
> +       int size = m->pad_until - m->count;
> +       if (size > 0)
> +               seq_printf(m, "%*s", size, "");
> +       if (c)
> +               seq_putc(m, c);
> +}
> +EXPORT_SYMBOL(seq_pad);
> +
>  struct list_head *seq_list_start(struct list_head *head, loff_t pos)
>  {
>         struct list_head *lh;
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 4e32edc..52e0097 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -20,6 +20,7 @@ struct seq_file {
>         size_t size;
>         size_t from;
>         size_t count;
> +       size_t pad_until;
>         loff_t index;
>         loff_t read_pos;
>         u64 version;
> @@ -79,6 +80,20 @@ static inline void seq_commit(struct seq_file *m, int num)
>         }
>  }
>
> +/**
> + * seq_setwidth - set padding width
> + * @m: the seq_file handle
> + * @size: the max number of bytes to pad.
> + *
> + * Call seq_setwidth() for setting max width, then call seq_printf() etc. and
> + * finally call seq_pad() to pad the remaining bytes.
> + */
> +static inline void seq_setwidth(struct seq_file *m, size_t size)
> +{
> +       m->pad_until = m->count + size;
> +}
> +void seq_pad(struct seq_file *m, char c);
> +
>  char *mangle_path(char *s, const char *p, const char *esc);
>  int seq_open(struct file *, const struct seq_operations *);
>  ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
> --
> 1.7.1



-- 
Kees Cook
Chrome OS Security
