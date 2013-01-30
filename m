Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3A3AYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:24:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3A3AYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:24:33 -0500
Date: Tue, 29 Jan 2013 16:24:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: xtu4 <xiaobing.tu@intel.com>
Cc: linux-kernel@vger.kernel.org, guifang.tang@intel.com,
        linX.z.chen@intel.com,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Avoid high order memory allocating with kmalloc, when read
 large seq file
Message-Id: <20130129162431.58754538.akpm@linux-foundation.org>
In-Reply-To: <510768B6.3070000@intel.com>
References: <510768B6.3070000@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 14:14:14 +0800
xtu4 <xiaobing.tu@intel.com> wrote:

> @@ -209,8 +209,17 @@ ssize_t seq_read(struct file *file, char __user 
> *buf, size_t size, loff_t *ppos)
>           if (m->count < m->size)
>               goto Fill;
>           m->op->stop(m, p);
> -        kfree(m->buf);
> -        m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +        if (m->size > 2 * PAGE_SIZE) {
> +            vfree(m->buf);
> +        } else
> +            kfree(m->buf);
> +        m->size <<= 1;
> +        if (m->size > 2 * PAGE_SIZE) {
> +            m->buf = vmalloc(m->size);
> +        } else
> +            m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +
> +
>           if (!m->buf)
>               goto Enomem;
>           m->count = 0;
> @@ -325,7 +334,10 @@ EXPORT_SYMBOL(seq_lseek);

The conventional way of doing this is to attempt the kmalloc with
__GFP_NOWARN and if that failed, fall back to vmalloc().

Using vmalloc is generally not a good thing, mainly because of
fragmentation issues, but for short-lived allocations like this, that
shouldn't be too bad.

But really, the binder code is being obnoxious here and it would be
best to fix it up.  Please identify with some care which part of the
binder code is causing this problem.  binder_stats_show(), from a
guess?  It looks like that function's output size is proportional to
the number of processes on binder_procs?  If so, there is no upper
bound, is there?  Problem!

btw, binder_debug_no_lock should just go away.  That list needs
locking.
