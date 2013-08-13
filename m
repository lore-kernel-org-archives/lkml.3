Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab3HMSDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:03:12 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36242 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:03:08 -0400
Message-ID: <520A74D6.2050808@hp.com>
Date: Tue, 13 Aug 2013 14:03:02 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 0/4] Lockless update of reference count protected by
 spinlock
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:12 PM, Waiman Long wrote:
> v6->v7:
>   - Substantially reduce the number of patches from 14 to 4 because a
>     lot of the minor filesystem related changes had been merged to
>     v3.11-rc1.
>   - Remove architecture specific customization (LOCKREF_WAIT_SHIFT&
>     LOCKREF_RETRY_COUNT).
>   - Tune single-thread performance of lockref_put/get to within 10%
>     of old lock->update->unlock code.
>
> v5->v6:
>   - Add a new GENERIC_SPINLOCK_REFCOUNT config parameter for using the
>     generic implementation.
>   - Add two parameters LOCKREF_WAIT_SHIFT and LOCKREF_RETRY_COUNT which
>     can be specified differently for each architecture.
>   - Update various spinlock_refcount.* files to incorporate review
>     comments.
>   - Replace reference of d_refcount() macro in Lustre filesystem code in
>     the staging tree to use the new d_count() helper function.
>
> v4->v5:
>   - Add a d_count() helper for readonly access of reference count and
>     change all references to d_count outside of dcache.c, dcache.h
>     and namei.c to use d_count().
>
> v3->v4:
>   - Replace helper function access to d_lock and d_count by using
>     macros to redefine the old d_lock name to the spinlock and new
>     d_refcount name to the reference count. This greatly reduces the
>     size of this patchset from 25 to 12 and make it easier to review.
>
> v2->v3:
>   - Completely revamp the packaging by adding a new lockref data
>     structure that combines the spinlock with the reference
>     count. Helper functions are also added to manipulate the new data
>     structure. That results in modifying over 50 files, but the changes
>     were trivial in most of them.
>   - Change initial spinlock wait to use a timeout.
>   - Force 64-bit alignment of the spinlock&  reference count structure.
>   - Add a new way to use the combo by using a new union and helper
>     functions.
>
> v1->v2:
>   - Add one more layer of indirection to LOCK_WITH_REFCOUNT macro.
>   - Add __LINUX_SPINLOCK_REFCOUNT_H protection to spinlock_refcount.h.
>   - Add some generic get/put macros into spinlock_refcount.h.
>
> This patchset supports a generic mechanism to atomically update
> a reference count that is protected by a spinlock without actually
> acquiring the lock itself. If the update doesn't succeeed, the caller
> will have to acquire the lock and update the reference count in the
> the old way.  This will help in situation where there is a lot of
> spinlock contention because of frequent reference count update.
>
> The d_lock and d_count fields of the struct dentry in dcache.h was
> modified to use the new lockref data structure and the d_lock name
> is now a macro to the actual spinlock.
>
> This patch set causes significant performance improvement in the
> short workload of the AIM7 benchmark on a 8-socket x86-64 machine
> with 80 cores.
>
> Thank to Thomas Gleixner, Andi Kleen and Linus for their valuable
> input in shaping this patchset.
>
> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>
> Waiman Long (4):
>    spinlock: A new lockref structure for lockless update of refcount
>    spinlock: Enable x86 architecture to do lockless refcount update
>    dcache: replace d_lock/d_count by d_lockcnt
>    dcache: Enable lockless update of dentry's refcount
>
>   arch/x86/Kconfig                        |    3 +
>   fs/dcache.c                             |   78 +++++++------
>   fs/namei.c                              |    6 +-
>   include/asm-generic/spinlock_refcount.h |   46 +++++++
>   include/linux/dcache.h                  |   22 ++--
>   include/linux/spinlock_refcount.h       |  126 ++++++++++++++++++++
>   kernel/Kconfig.locks                    |   15 +++
>   lib/Makefile                            |    2 +
>   lib/spinlock_refcount.c                 |  198 +++++++++++++++++++++++++++++++
>   9 files changed, 449 insertions(+), 47 deletions(-)
>   create mode 100644 include/asm-generic/spinlock_refcount.h
>   create mode 100644 include/linux/spinlock_refcount.h
>   create mode 100644 lib/spinlock_refcount.c

So far, I haven't heard back anything about if further change and 
improvement is needed for this patch set. Any comment or feedback will 
be appreciated.

Thank in advance for your time.

Regards,
Longman
