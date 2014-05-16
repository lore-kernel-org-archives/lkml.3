Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbaEPNw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbaEPNwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:52:24 -0400
Date: Fri, 16 May 2014 15:51:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/1] ptrace: task_clear_jobctl_trapping()->wake_up_bit()
	needs mb()
Message-ID: <20140516135116.GA19210@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net> <20140514161152.GA2615@redhat.com> <20140514161755.GQ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514161755.GQ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Peter Zijlstra wrote:
>
> On Wed, May 14, 2014 at 06:11:52PM +0200, Oleg Nesterov wrote:
> >
> > I mean, we do not need mb() before __wake_up(). We need it only because
> > __wake_up_bit() checks waitqueue_active().
> >
> >
> > And at least
> >
> > 	fs/cachefiles/namei.c:cachefiles_delete_object()
> > 	fs/block_dev.c:blkdev_get()
> > 	kernel/signal.c:task_clear_jobctl_trapping()
> > 	security/keys/gc.c:key_garbage_collector()
> >
> > look obviously wrong.
> >
> > I would be happy to send the fix, but do I need to split it per-file?
> > Given that it is trivial, perhaps I can send a single patch?
>
> Since its all the same issue a single patch would be fine I think.

Actually blkdev_get() is fine, it relies on bdev_lock. But bd_prepare_to_claim()
is the good example of abusing bit_waitqueue(). Not only it is itself suboptimal,
this doesn't allow to optimize wake_up_bit-like paths. And there are more, say,
inode_sleep_on_writeback(). Plus we have wait_on_atomic_t() which I think should
be generalized or even unified with the regular wait_on_bit(). Perhaps I'll try
to do this later, fortunately the recent patch from Neil greatly reduced the
number of "action" functions.

As for cachefiles_walk_to_object() and key_garbage_collector(), it still seems
to me they need smp_mb__after_clear_bit() but I'll leave this to David, I am
not comfortable to change the code I absolutely do not understand. In particular,
I fail to understand why key_garbage_collector() does smp_mb() before clear_bit().
At least it could be smp_mb__before_clear_bit().

So let me send a trivial patch which only changes task_clear_jobctl_trapping().

Oleg.

