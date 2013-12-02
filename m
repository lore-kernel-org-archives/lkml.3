Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3LBQ2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:28:02 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:41715 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3LBQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:27:59 -0500
Date: Mon, 2 Dec 2013 17:27:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via
 prepare_creds())
Message-ID: <20131202162755.GB27781@gmail.com>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Nov 30, 2013 at 1:08 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I still don't see what could be wrong with the pipe_inode_info thing,
> > but the fact that it's been so consistent in your traces does make me
> > suspect it really is *that* particular slab.
> 
> I think I finally found it.
> 
> I've spent waaayy too much time looking at and thinking about that
> code without seeing anything wrong, but this morning I woke up and
> thought to myself "What if.."
> 
> And looking at the code again, I went "BINGO".
> 
> All our reference counting etc seems right, but we have one very
> subtle bug: on the freeing path, we have a pattern like this:
> 
>         spin_lock(&inode->i_lock);
>         if (!--pipe->files) {
>                 inode->i_pipe = NULL;
>                 kill = 1;
>         }
>         spin_unlock(&inode->i_lock);
>         __pipe_unlock(pipe);
>         if (kill)
>                 free_pipe_info(pipe);
> 
> which on the face of it is trying to be very careful in not accessing
> the pipe-info after it is released by having that "kill" flag, and
> doing the release last.
> 
> And it's complete garbage.
> 
> Why?
> 
> Because the thread that decrements "pipe->files" *without* releasing 
> it, will very much access it after it has been dropped: that 
> "__pipe_unlock(pipe)" happens *after* we've decremented the pipe 
> reference count and dropped the inode lock. So another CPU can come 
> in and free the structure concurrently with that 
> __pipe_unlock(pipe).
> 
> This happens in two places, and we don't actually need or want the 
> pipe lock for the pipe->files accesses (since pipe->files is 
> protected by inode->i_lock, not the pipe lock), so the solution is 
> to just do the __pipe_unlock() before the whole dance about the 
> pipe->files reference count.
> 
> Patch appended. And no wonder nobody has ever seen it, because the 
> race is unlikely as hell to ever happen. Simon, I assume it will be 
> another few months before we can say "yeah, that fixed it", but I 
> really think this is it. It explains all the symptoms, including 
> "DEBUG_PAGEALLOC didn't catch it" (because the access happens just 
> as it is released, and DEBUG_PAGEALLOC takes too long to actually 
> free unmap the page etc).
> 
>                      Linus
>  fs/pipe.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index d2c45e14e6d8..18f1a4b2dbbc 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -743,13 +743,14 @@ pipe_release(struct inode *inode, struct file *file)
>  		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>  		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>  	}
> +	__pipe_unlock(pipe);
> +
>  	spin_lock(&inode->i_lock);
>  	if (!--pipe->files) {
>  		inode->i_pipe = NULL;
>  		kill = 1;
>  	}
>  	spin_unlock(&inode->i_lock);
> -	__pipe_unlock(pipe);

I'm wondering why pipe-mutex was introduced. It was done fairly 
recently, with no justification given:

  From 72b0d9aacb89f3759931ec440e1b535671145bb4 Mon Sep 17 00:00:00 2001
  From: Al Viro <viro@zeniv.linux.org.uk>
  Date: Thu, 21 Mar 2013 02:32:24 -0400
  Subject: [PATCH] pipe: don't use ->i_mutex

  now it can be done - put mutex into pipe_inode_info, use it instead
  of ->i_mutex

  Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
  ---
   fs/ocfs2/file.c           | 6 ++----
   fs/pipe.c                 | 5 +++--
   include/linux/pipe_fs_i.h | 2 ++
   3 files changed, 7 insertions(+), 6 deletions(-)

It's not like there should be many (any?) VFS operations where a pipe 
is used via i_mutex and pipe->mutex in parallel, which would improve 
scalability - so I don't see the scalability advantage. (But I might 
be missing something)

Barring such kind of workload the extra mutex just adds extra 
micro-costs because now two locks have to be taken on 
creation/destruction, plus it adds extra complexity and races.

So unless I'm missing something obvious, another good fix would be to 
just revert pipe->mutex and rely on i_mutex as before?

Thanks,

	Ingo
