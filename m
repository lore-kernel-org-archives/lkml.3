Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3LBRG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:06:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3LBRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:06:25 -0500
Date: Mon, 2 Dec 2013 17:06:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via
 prepare_creds())
Message-ID: <20131202170621.GG10323@ZenIV.linux.org.uk>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 08:00:38AM -0800, Linus Torvalds wrote:
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
> reference count and dropped the inode lock. So another CPU can come in
> and free the structure concurrently with that __pipe_unlock(pipe).
> 
> This happens in two places, and we don't actually need or want the
> pipe lock for the pipe->files accesses (since pipe->files is protected
> by inode->i_lock, not the pipe lock), so the solution is to just do
> the __pipe_unlock() before the whole dance about the pipe->files
> reference count.
> 
> Patch appended. And no wonder nobody has ever seen it, because the
> race is unlikely as hell to ever happen. Simon, I assume it will be
> another few months before we can say "yeah, that fixed it", but I
> really think this is it. It explains all the symptoms, including
> "DEBUG_PAGEALLOC didn't catch it" (because the access happens just as
> it is released, and DEBUG_PAGEALLOC takes too long to actually free
> unmap the page etc).

Nice catch.  I'd probably add

/* we are holding inode->i_pipe->files */
static void drop_pipe(struct inode *inode, struct pipe_inode_info *pipe)
{
	int kill = 0;
        spin_lock(&inode->i_lock);
	WARN_ON(pipe != inode->i_pipe);
        if (!--pipe->files) {
                inode->i_pipe = NULL;
                kill = 1;
        }
        spin_unlock(&inode->i_lock);
        if (kill)
                free_pipe_info(pipe);
}

and use it in both places...
