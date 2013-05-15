Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3EOI2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:28:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52367
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932187Ab3EOI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:28:45 -0400
Date: Wed, 15 May 2013 10:28:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: majianpeng <majianpeng@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, mingo@redhat.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC][PATCH] f2fs: Avoid print false deadlock messages.
Message-ID: <20130515082834.GB10510@laptop.programming.kicks-ass.net>
References: <5193322D.1080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5193322D.1080009@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 02:58:53PM +0800, majianpeng wrote:
> When mounted the f2fs, kernel will print the following messages:
> 
> [  105.533038] =============================================
> [  105.533065] [ INFO: possible recursive locking detected ]
> [  105.533088] 3.10.0-rc1+ #101 Not tainted
> [  105.533105] ---------------------------------------------
> [  105.533127] mount/5833 is trying to acquire lock:
> [  105.533147]  (&sbi->fs_lock[i]){+.+...}, at: [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
> [  105.533204]
> [  105.533204] but task is already holding lock:
> [  105.533228]  (&sbi->fs_lock[i]){+.+...}, at: [<ffffffffa02017a6>] write_checkpoint+0xb6/0xaf0 [f2fs]
> [  105.533278]
> [  105.533278] other info that might help us debug this:
> [  105.533305]  Possible unsafe locking scenario:
> [  105.533305]
> [  105.533329]        CPU0
> [  105.533341]        ----
> [  105.533353]   lock(&sbi->fs_lock[i]);
> [  105.533373]   lock(&sbi->fs_lock[i]);
> [  105.533394]
> [  105.533394]  *** DEADLOCK ***
> [  105.533394]

> By adding some messages, i found this problem because the gcc
> optimizing. For those codes:
> >        for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> >                mutex_init(&sbi->fs_lock[i]);
> The defination of mutex_init is:
> > #define mutex_init(mutex)
> >do {
> >
> >        static struct lock_class_key __key;
> >
> >                                                                      
> >        __mutex_init((mutex), #mutex, &__key);
> >
> >} while (0)
> 
> Because the optimizing of gcc, there are only one __key rather than
> NR_GLOBAL_LOCKS times.

Its not a gcc specific optimization, any C compiler would. Its also very
much on purpose.

> Add there is other problems about lockname.Using 'for()' the lockname is
> the same which is '&sbi->fs_lock[i]'.If it met problem about
> mutex-operation, it can't find which one.
> 
> Although my patch can work,i think it's not best.Because if
> NR_GLOBAL_LOCKS changed, we may leak to change this.
> 
> BTY, if who know how to avoid optimize, please tell me. Thanks!

There isn't. What you typically want to do is annotate the lock site.

In particular it looks like mutex_lock_all() is the offensive piece of
code (horrible function name though; the only redeeming thing being that
f2fs.h isn't likely to be included elsewhere).

One thing you can do here is modify it to look like:

static inline void mutex_lock_all(struct f2fs_sb_info *sbi)
{
	int i;

	for (i = 0; i < NR_GLOBAL_LOCKS; i++) {
		/*
		 * This is the only time we take multiple fs_lock[]
		 * instances; the order is immaterial since we
		 * always hold cp_mutex, which serializes multiple
		 * such operations.
		 */
		mutex_lock_nest_lock(&sbi->fs_lock[i], &sbi->cp_mutex);
	}
}

That tells the lock validator that it is ok to lock multiple instances
of the fs_lock[i] class because the lock order is guarded by cp_mutex.

While your patch also works, it has multiple down-sides; its easy to get
out of sync when you modify NR_GLOBAL_LOCKS; also it consumes more
static lockdep resources (lockdep has to allocate all its resources
from static arrays since allocating memory also uses locks -- recursive
problem).


