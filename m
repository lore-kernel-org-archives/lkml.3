Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3J3I5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:57:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3J3I5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:57:39 -0400
Date: Wed, 30 Oct 2013 09:57:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] futex: Remove requirement for lock_page in
 get_futex_key
Message-ID: <20131030085732.GF16117@laptop.programming.kicks-ass.net>
References: <20131029173814.GH2400@suse.de>
 <20131029184827.10719.27487@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029184827.10719.27487@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 02:48:27PM -0400, Chris Mason wrote:
> > +               /* Should be impossible but lets be paranoid for now */
> > +               if (WARN_ON(inode->i_mapping != mapping)) {
> > +                       rcu_read_unlock();
> > +                       iput(inode);
> > +                       put_page(page_head);
> > +                       goto again;
> > +               }
> > +
> 
> Once you call iput, you add the potential to call the filesystem unlink
> operation if i_nlink had gone to zero.  This shouldn't be a problem
> since you've dropped the rcu lock, but just for fun I'd move the
> put_page up a line.
> 
> Or, change it to a BUG_ON instead, it really should be impossible.

So I still meant to have a look at the RCU freeing of inodes etc.. but
that comparison was to guard against inode reuse. I don't know if that
actually happens, the inode free path is a tad longer than is trivially
understood.

But if an inode would be put on a free list and reused the
atomic_inc_not_zero() could inc on a different inode than the one we
wanted and thus we need to validate we indeed got the object we set out
to acquire.

Now if its guaranteed that once an inode's refcount hits zero it will be
freed the above test is indeed superfluous and we can do the BUG_ON as
you suggest.
