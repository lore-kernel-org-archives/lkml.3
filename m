Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaJEXts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJEXto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:49:44 -0400
Date: Sun, 5 Oct 2014 16:49:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] ring-buffer: Fix infinite spin in reading buffer
Message-ID: <20141005234943.GB23078@kroah.com>
References: <20141003162043.6817a486@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003162043.6817a486@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 04:20:43PM -0400, Steven Rostedt wrote:
> 
> Linus,
> 
> While testing some new changes for 3.18, I kept hitting a bug every so
> often in the ring buffer. At first I thought it had to do with some
> of the changes I was working on, but then testing something else I
> realized that the bug was in 3.17 itself. I ran several bisects as the
> bug was not very reproducible, and finally came up with the commit
> that I could reproduce easily within a few minutes, and without the change
> I could run the tests over an hour without issue. The change fit the
> bug and I figured out a fix. That bad commit was:
> 
> Commit 651e22f2701b "ring-buffer: Always reset iterator to reader page"
> 
> This commit fixed a bug, but in the process created another one. It used
> the wrong value as the cached value that is used to see if things changed
> while an iterator was in use. This made it look like a change always
> happened, and could cause the iterator to go into an infinite loop.
> 
> 
> Greg (and stable et al),
> 
> This fixes a commit that was marked for stable as far back as 2.6.28.
> This patch needs to be added to all stable trees that included the
> first fix. Obviously after Linus applies it.
> 
> Please pull the latest trace-fixes-v3.17-rc7 tree, which can be found at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> trace-fixes-v3.17-rc7
> 
> Tag SHA1: 0c08f2a68c694e7d95dcf2109dc08772056b4746
> Head SHA1: 24607f114fd14f2f37e3e0cb3d47bce96e81e848
> 
> 
> Steven Rostedt (Red Hat) (1):
>       ring-buffer: Fix infinite spin in reading buffer
> 
> ----
>  kernel/trace/ring_buffer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---------------------------
> commit 24607f114fd14f2f37e3e0cb3d47bce96e81e848
> Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
> Date:   Thu Oct 2 16:51:18 2014 -0400
> 
>     ring-buffer: Fix infinite spin in reading buffer
>     
>     Commit 651e22f2701b "ring-buffer: Always reset iterator to reader page"
>     fixed one bug but in the process caused another one. The reset is to
>     update the header page, but that fix also changed the way the cached
>     reads were updated. The cache reads are used to test if an iterator
>     needs to be updated or not.
>     
>     A ring buffer iterator, when created, disables writes to the ring buffer
>     but does not stop other readers or consuming reads from happening.
>     Although all readers are synchronized via a lock, they are only
>     synchronized when in the ring buffer functions. Those functions may
>     be called by any number of readers. The iterator continues down when
>     its not interrupted by a consuming reader. If a consuming read
>     occurs, the iterator starts from the beginning of the buffer.
>     
>     The way the iterator sees that a consuming read has happened since
>     its last read is by checking the reader "cache". The cache holds the
>     last counts of the read and the reader page itself.
>     
>     Commit 651e22f2701b changed what was saved by the cache_read when
>     the rb_iter_reset() occurred, making the iterator never match the cache.
>     Then if the iterator calls rb_iter_reset(), it will go into an
>     infinite loop by checking if the cache doesn't match, doing the reset
>     and retrying, just to see that the cache still doesn't match! Which
>     should never happen as the reset is suppose to set the cache to the
>     current value and there's locks that keep a consuming reader from
>     having access to the data.
>     
>     Fixes: 651e22f2701b "ring-buffer: Always reset iterator to reader page"
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Next time, please also add a Cc: stable...  here so that my tools pick
it up automatically.

greg k-h
