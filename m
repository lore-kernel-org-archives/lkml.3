Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3HLVt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:49:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3HLVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:49:46 -0400
Date: Mon, 12 Aug 2013 14:49:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun KS <arunks.linux@gmail.com>
Cc: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Subject: Re: Seq File: Return error if d_path fails
Message-Id: <20130812144943.a09d6251bc20f8c3d0a6e8d8@linux-foundation.org>
In-Reply-To: <CAKZGPANjwYxoAtO068UN1iMuMZPtkbjACz8C3yHjZMr5BkM63A@mail.gmail.com>
References: <CAKZGPANjwYxoAtO068UN1iMuMZPtkbjACz8C3yHjZMr5BkM63A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013 19:03:31 +0530 Arun KS <arunks.linux@gmail.com> wrote:

> >From 2558382c8a030f7261e47977ac62412cd78e6d38 Mon Sep 17 00:00:00 2001
> From: Arun KS <arun.ks@broadcom.com>
> Date: Thu, 8 Aug 2013 18:23:04 +0530
> Subject: Seq File: Return error if d_path fails
> 
> Return error if d_path fails in seq_path funciton. If we do not return
> from here,
> seq_commit sets seq_file state as overflow. And this continues in a
> loop utill we
> increase the size of seq buf beyond KMALLOC_MAX_SIZE.
> 
> ...
>
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -471,7 +471,8 @@ int seq_path(struct seq_file *m, const struct path
> *path, const char *esc)
>                         char *end = mangle_path(buf, p, esc);
>                         if (end)
>                                 res = end - buf;
> -               }
> +               } else
> +                       return PTR_ERR(p);
>         }
>         seq_commit(m, res);

hm, does that really fix the bug?  Isn't the core problem the word "or":

/**
 * seq_commit - commit data to the buffer
 * @m: the seq_file handle
 * @num: the number of bytes to commit
 *
 * Commit @num bytes of data written to a buffer previously acquired
 * by seq_buf_get.  To signal an error condition, or that the data
                                                  ^^
 * didn't fit in the available space, pass a negative @num value.
 */

seq_path()/seq_commit() is treating a d_path() failure as an overflow
condition, but it isn't.

