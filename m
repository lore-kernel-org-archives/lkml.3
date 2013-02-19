Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3BSO2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:28:05 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33972 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3BSO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:28:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130218013720.GC10963@localhost>
References: <20130218013720.GC10963@localhost>
Date: Tue, 19 Feb 2013 14:28:00 +0000
Message-ID: <CAMuW1wfEW2ECthuCkWW_=QimXX9xUJQNfeM9U9gNRuLaJXZ_AQ@mail.gmail.com>
Subject: Re: WARNING: at kernel/mutex.c:386 __mutex_lock_common()
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

2013/2/18 Fengguang Wu <fengguang.wu@intel.com>:
> Greetings,
>
> I got the below warning and the first bad commit is
>
> commit 11eb5a2ce9655ee552f705f2da6b8f96f466c0d4
> Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Date:   Wed Nov 7 11:53:51 2012 +0100
>
>     mutex: add support for reservation style locks
>
>     GPU's do operations that commonly involve many buffers.  Those buffers
>     can be shared across contexts/processes, exist in different memory
>     domains (for example VRAM vs system memory), and so on.  And with
>     PRIME / dmabuf, they can even be shared across devices.  So there are
>     a handful of situations where the driver needs to wait for buffers to
>     become ready.  If you think about this in terms of waiting on a buffer
>     mutex for it to become available, this presents a problem because
>     there is no way to guarantee that buffers appear in a execbuf/batch in
>     the same order in all contexts.  That is directly under control of
>     userspace, and a result of the sequence of GL calls that an application
>     makes.  Which results in the potential for deadlock.  The problem gets
>     more complex when you consider that the kernel may need to migrate the
>     buffer(s) into VRAM before the GPU operates on the buffer(s), which
>     may in turn require evicting some other buffers (and you don't want to
>     evict other buffers which are already queued up to the GPU), but for a
>     simplified understanding of the problem you can ignore this.
>
>     The algorithm that TTM came up with for dealing with this problem is
>     quite simple.  For each group of buffers (execbuf) that need to be
>     locked, the caller would be assigned a unique reservation_id, from a
>     global counter.  In case of deadlock in the process of locking all the
>     buffers associated with a execbuf, the one with the lowest
>     reservation_id wins, and the one with the higher reservation_id
>     unlocks all of the buffers that it has already locked, and then tries
>     again.
>
>     How it is used:
>     ---------------
>
>     A very simplified version:
>
>         int lock_execbuf(execbuf)
>         {
>             struct buf *res_buf = NULL;
>
>             /* acquiring locks, before queuing up to GPU: */
>             seqno = assign_global_seqno();
>
>         retry:
>             for (buf in execbuf->buffers) {
>                 if (buf == res_buf) {
>                     res_buf = NULL;
>                     continue;
>                 }
>                 ret = mutex_reserve_lock(&buf->lock, seqno);
>                 if (ret < 0)
>                     goto err;
>             }
>
>             /* now everything is good to go, submit job to GPU: */
>             ...
>
>             return 0;
>
>         err:
>             for (all buf2 before buf in execbuf->buffers)
>                 mutex_unreserve_unlock(&buf2->lock);
>             if (res_buf)
>                 mutex_unreserve_unlock(&res_buf->lock);
>
>             if (ret == -EAGAIN) {
>                 /* we lost out in a seqno race, lock and retry.. */
>                 mutex_reserve_lock_slow(&buf->lock, seqno);
>                 res_buf = buf;
>                 goto retry;
>             }
>
>             return ret;
>         }
>
>         int unlock_execbuf(execbuf)
>         {
>             /* when GPU is finished; */
>             for (buf in execbuf->buffers)
>                 mutex_unreserve_unlock(&buf->lock);
>         }
>
>     Functions:
>     ----------
>
>     mutex_reserve_lock, and mutex_reserve_lock_interruptible:
>       Lock a buffer with a reservation_id set. reservation_id must not be
>       set to 0, since this is a special value that means no reservation_id.
>
>       Normally if reservation_id is not set, or is older than the
>       reservation_id that's currently set on the mutex, the behavior will
>       be to wait normally.  However, if  the reservation_id is newer than
>       the current reservation_id, -EAGAIN will be returned.
>
>       These functions will return -EDEADLK instead of -EAGAIN if
>       reservation_id is the same as the reservation_id that's attempted to
>       lock the mutex with, since in that case you presumably attempted to
>       lock the same lock twice.
>
>     mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>       Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
>       This is useful when mutex_reserve_lock failed with -EAGAIN, and you
>       unreserved all buffers so no deadlock can occur.
>
>     mutex_unreserve_unlock:
>        Unlock a buffer reserved with one of the mutex_reserve_*lock* calls.
>
>     Missing at the moment, maybe TODO?
>       * Check if lockdep warns if you unlock a lock that other locks were nested
>         to.
>         - spin_lock(m);
>           spin_lock_nest_lock(a, m);
>           spin_unlock(m);
>           spin_unlock(a);
>           It would be nice if this would give a splat on spin_unlock(m),
>           I'm not 100% sure if it does right now, though..
>       * In the *_slow calls, maybe add a check to ensure no other locks of the same
>         lockdep class are nested in the lock we have to nest to?
>         - This is making sure that mutex_unreserve_unlock have been called on all other locks.
>
>     Design:
>       I chose for ticket_mutex to encapsulate struct mutex, so the extra memory usage and
>       atomic set on init will only happen when you deliberately create a ticket lock.
>
>       Since the mutexes are mostly meant to protect buffer object serialization in ttm, not
>       much contention is expected. I could be slightly smarter with wakeups, but this would
>       be at the expense at adding a field to struct mutex_waiter. This would add
>       overhead to all cases where normal mutexes are used, and ticket_mutexes are less
>       performance sensitive anyway since they only protect buffer objects. As a result
>       I chose not to do this.
>
>       I needed this in kernel/mutex.c because of the extensions to __lock_common, which are
>       hopefully optimized away for all normal paths.
>
>       It is not illegal to use mutex_lock and mutex_unlock on ticket mutexes. This will work,
>       as long you don't mix lock/unlock calls. This is useful if you want to lock only a single
>       buffer.
>
>       All the mutex_reserve calls are nested into another lock. The idea is that the
>       seqno ticket you use functions as a lockdep class you have locked too. This will
>       prevent lockdep false positives on locking 2 objects of the same class. It's allowed
>       because they're nested to the seqno ticket. There are extensive tests for this in the
>       patch that introduces locking tests for reservation objects and reservation tickets.
>
>     Changes since RFC patch v1:
>      - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>      - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>      - removed mutex_locked_set_reservation_id (or w/e it was called)
>     Changes since RFC patch v2:
>      - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>        mutex_(,reserve_)lock/unlock.
>
>     Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>
> [    0.000000]
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:386 __mutex_lock_common+0x5a9/0x870()
> [    0.000000] Hardware name: Bochs
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc7-00071-g11eb5a2 #180
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
> [    0.000000]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
> [    0.000000]  [<ffffffff814ebdd9>] __mutex_lock_common+0x5a9/0x870
> [    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
> [    0.000000]  [<ffffffff810bcb8f>] ? trace_hardirqs_off_caller+0xaf/0x120
> [    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
> [    0.000000]  [<ffffffff810be38c>] ? lockdep_init_map+0xfc/0x230
> [    0.000000]  [<ffffffff814ec621>] mutex_lock_nested+0x61/0x80
> [    0.000000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
> [    0.000000]  [<ffffffff81a66ef8>] rcu_cpu_notify+0xa8/0x451
> [    0.000000]  [<ffffffff814ecc31>] ? mutex_unlock+0x11/0x20
> [    0.000000]  [<ffffffff81a3f952>] rcu_init+0x3b3/0x408
> [    0.000000]  [<ffffffff81a21e0c>] start_kernel+0x34a/0x744
> [    0.000000]  [<ffffffff81a216e6>] ? repair_env_string+0x81/0x81
> [    0.000000]  [<ffffffff81a21120>] ? early_idt_handlers+0x120/0x120
> [    0.000000]  [<ffffffff81a212fd>] x86_64_start_reservations+0x185/0x190
> [    0.000000]  [<ffffffff81a214a8>] x86_64_start_kernel+0x1a0/0x1b6
> [    0.000000] ---[ end trace 8e966724b1809892 ]---
Weird, that code path should not be hit from __mutex_lock_common from
mutex_lock_nested, I'll create a patch with some tests to make sure
that lib/locking-selftests.c will perform tests on common mutexes to
ensure that code path is not hit, and this bug will not happen again.

Can you change __mutex_lock_common from inline to __always_inline and
check if that gets rid of the warning?

~Maarten
