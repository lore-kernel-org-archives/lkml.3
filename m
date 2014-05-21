Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaEUTSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:18:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEUTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:18:39 -0400
Date: Wed, 21 May 2014 12:18:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] ptrace: task_clear_jobctl_trapping()->wake_up_bit()
 needs mb()
Message-Id: <20140521121837.7efc35b2bb455bd45bbc8970@linux-foundation.org>
In-Reply-To: <20140516135116.GA19210@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
	<1399974350-11089-20-git-send-email-mgorman@suse.de>
	<20140513125313.GR23991@suse.de>
	<20140513141748.GD2485@laptop.programming.kicks-ass.net>
	<20140514161152.GA2615@redhat.com>
	<20140514161755.GQ30445@twins.programming.kicks-ass.net>
	<20140516135116.GA19210@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 15:51:16 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/14, Peter Zijlstra wrote:
> >
> > On Wed, May 14, 2014 at 06:11:52PM +0200, Oleg Nesterov wrote:
> > >
> > > I mean, we do not need mb() before __wake_up(). We need it only because
> > > __wake_up_bit() checks waitqueue_active().
> > >
> > >
> > > And at least
> > >
> > > 	fs/cachefiles/namei.c:cachefiles_delete_object()
> > > 	fs/block_dev.c:blkdev_get()
> > > 	kernel/signal.c:task_clear_jobctl_trapping()
> > > 	security/keys/gc.c:key_garbage_collector()
> > >
> > > look obviously wrong.
> > >
> > > I would be happy to send the fix, but do I need to split it per-file?
> > > Given that it is trivial, perhaps I can send a single patch?
> >
> > Since its all the same issue a single patch would be fine I think.
> 
> Actually blkdev_get() is fine, it relies on bdev_lock. But bd_prepare_to_claim()
> is the good example of abusing bit_waitqueue(). Not only it is itself suboptimal,
> this doesn't allow to optimize wake_up_bit-like paths. And there are more, say,
> inode_sleep_on_writeback(). Plus we have wait_on_atomic_t() which I think should
> be generalized or even unified with the regular wait_on_bit(). Perhaps I'll try
> to do this later, fortunately the recent patch from Neil greatly reduced the
> number of "action" functions.
> 
> As for cachefiles_walk_to_object() and key_garbage_collector(), it still seems
> to me they need smp_mb__after_clear_bit() but I'll leave this to David, I am
> not comfortable to change the code I absolutely do not understand. In particular,
> I fail to understand why key_garbage_collector() does smp_mb() before clear_bit().
> At least it could be smp_mb__before_clear_bit().

This is all quite convincing evidence that these interfaces are too
tricky for regular kernel developers to use. 

Can we fix them?

One way would be to make the interfaces safe to use and provide
lower-level no-barrier interfaces for use by hot-path code where the
author knows what he/she is doing.  And there are probably other ways.
