Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaFPHLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:11:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40358 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFPHLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:11:36 -0400
MIME-Version: 1.0
Date: Mon, 16 Jun 2014 09:11:34 +0200
X-Google-Sender-Auth: qxKw2XBj6zsuk-bJo_xzvc-GebM
Message-ID: <CAMuHMdWx-+1WHQUXUZDGB1ZX9kpnyRALJB0NnhJddHD5X_Uo8g@mail.gmail.com>
Subject: iter_file_splice_write() return value (was: Re: ->splice_write() via ->write_iter())
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Thu, Jun 12, 2014 at 8:14 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=8d0207652cbe27d1f962050737848e5ad4671958
> Commit:     8d0207652cbe27d1f962050737848e5ad4671958

>     ->splice_write() via ->write_iter()
>
>     iter_file_splice_write() - a ->splice_write() instance that gathers the
>     pipe buffers, builds a bio_vec-based iov_iter covering those and feeds
>     it to ->write_iter().  A bunch of simple cases coverted to that...
>
>     [AV: fixed the braino spotted by Cyrill]
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

> @@ -1052,6 +1053,145 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>
>  EXPORT_SYMBOL(generic_file_splice_write);
>
> +/**
> + * iter_file_splice_write - splice data from a pipe to a file
> + * @pipe:      pipe info
> + * @out:       file to write to
> + * @ppos:      position in @out
> + * @len:       number of bytes to splice
> + * @flags:     splice modifier flags
> + *
> + * Description:
> + *    Will either move or copy pages (determined by @flags options) from
> + *    the given pipe inode to the given file.
> + *    This one is ->write_iter-based.

What's the meaning of the return value? This is not documented.

> +ssize_t
> +iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
> +                         loff_t *ppos, size_t len, unsigned int flags)
> +{
> +       struct splice_desc sd = {
> +               .total_len = len,
> +               .flags = flags,
> +               .pos = *ppos,
> +               .u.file = out,
> +       };
> +       int nbufs = pipe->buffers;
> +       struct bio_vec *array = kcalloc(nbufs, sizeof(struct bio_vec),
> +                                       GFP_KERNEL);
> +       ssize_t ret;

fs/splice.c:954: warning: ‘ret’ may be used uninitialized in this function

> +
> +       if (unlikely(!array))
> +               return -ENOMEM;
> +
> +       pipe_lock(pipe);
> +
> +       splice_from_pipe_begin(&sd);
> +       while (sd.total_len) {

If the "len" parameter is zero, this loop will be skipped, and "ret" will
be uninitialized.

What should it return? 0? -EINVAL?

> +       }
> +done:
> +       kfree(array);
> +       splice_from_pipe_end(pipe, &sd);
> +
> +       pipe_unlock(pipe);
> +
> +       if (sd.num_spliced)
> +               ret = sd.num_spliced;
> +
> +       return ret;
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
