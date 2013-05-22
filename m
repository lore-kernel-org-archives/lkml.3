Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3EVQtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:49:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42851 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3EVQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:49:06 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130522161831.GQ18810@twins.programming.kicks-ass.net>
References: <20130428165914.17075.57751.stgit@patser>
	<20130428170407.17075.80082.stgit@patser>
	<20130430191422.GA5763@phenom.ffwll.local>
	<519CA976.9000109@canonical.com>
	<20130522161831.GQ18810@twins.programming.kicks-ass.net>
Date: Wed, 22 May 2013 18:49:04 +0200
X-Google-Sender-Auth: XnE1CDRtuvO1qTR23XBRk38M0xI
Message-ID: <CAKMK7uHYPdUgbuXAHCZi7xMQUUF8EU5z3F09ZkvGmm33iYtjPA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 6:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 22, 2013 at 01:18:14PM +0200, Maarten Lankhorst wrote:
>
> Lacking the actual msg atm, I'm going to paste in here...

Just replying to the interface/doc comments, Maarten's the guy for the
gory details ;-)

>> Subject: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
>> From: Maarten Lankhorst <maarten.lankhorst@xxxxxxxxxxxxx>
>>
>> Changes since RFC patch v1:
>>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>>  - removed mutex_locked_set_reservation_id (or w/e it was called)
>> Changes since RFC patch v2:
>>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>>    mutex_(,reserve_)lock/unlock.
>> Changes since v1:
>>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>>    for the constant 0 in that case. Tests for this have been added in the next patch.
>>  - Updated documentation slightly.
>> Changes since v2:
>>  - Renamed everything to ww_mutex. (mlankhorst)
>>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>>  - Added a lot of checks for wrong api usage. (mlankhorst)
>>  - Documentation updates. (danvet)
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@xxxxxxxxxxxxx>
>> Signed-off-by: Daniel Vetter <daniel.vetter@xxxxxxxx>
>> ---
>>  Documentation/ww-mutex-design.txt |  322 +++++++++++++++++++++++++++
>>  include/linux/mutex-debug.h       |    1
>>  include/linux/mutex.h             |  257 +++++++++++++++++++++
>>  kernel/mutex.c                    |  445 ++++++++++++++++++++++++++++++++++++-
>>  lib/debug_locks.c                 |    2
>>  5 files changed, 1010 insertions(+), 17 deletions(-)
>>  create mode 100644 Documentation/ww-mutex-design.txt
>>
>> diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
>> new file mode 100644
>> index 0000000..154bae3
>> --- /dev/null
>> +++ b/Documentation/ww-mutex-design.txt
>> @@ -0,0 +1,322 @@
>> +Wait/Wound Deadlock-Proof Mutex Design
>> +======================================
>> +
>> +Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
>> +
>> +Motivation for WW-Mutexes
>> +-------------------------
>> +
>> +GPU's do operations that commonly involve many buffers.  Those buffers
>> +can be shared across contexts/processes, exist in different memory
>> +domains (for example VRAM vs system memory), and so on.  And with
>> +PRIME / dmabuf, they can even be shared across devices.  So there are
>> +a handful of situations where the driver needs to wait for buffers to
>> +become ready.  If you think about this in terms of waiting on a buffer
>> +mutex for it to become available, this presents a problem because
>> +there is no way to guarantee that buffers appear in a execbuf/batch in
>> +the same order in all contexts.  That is directly under control of
>> +userspace, and a result of the sequence of GL calls that an application
>> +makes.       Which results in the potential for deadlock.  The problem gets
>> +more complex when you consider that the kernel may need to migrate the
>> +buffer(s) into VRAM before the GPU operates on the buffer(s), which
>> +may in turn require evicting some other buffers (and you don't want to
>> +evict other buffers which are already queued up to the GPU), but for a
>> +simplified understanding of the problem you can ignore this.
>> +
>> +The algorithm that TTM came up with for dealing with this problem is quite
>> +simple.  For each group of buffers (execbuf) that need to be locked, the caller
>> +would be assigned a unique reservation id/ticket, from a global counter.  In
>> +case of deadlock while locking all the buffers associated with a execbuf, the
>> +one with the lowest reservation ticket (i.e. the oldest task) wins, and the one
>> +with the higher reservation id (i.e. the younger task) unlocks all of the
>> +buffers that it has already locked, and then tries again.
>> +
>> +In the RDBMS literature this deadlock handling approach is called wait/wound:
>> +The older tasks waits until it can acquire the contended lock. The younger tasks
>> +needs to back off and drop all the locks it is currently holding, i.e. the
>> +younger task is wounded.
>> +
>> +Concepts
>> +--------
>> +
>> +Compared to normal mutexes two additional concepts/objects show up in the lock
>> +interface for w/w mutexes:
>> +
>> +Acquire context: To ensure eventual forward progress it is important the a task
>> +trying to acquire locks doesn't grab a new reservation id, but keeps the one it
>> +acquired when starting the lock acquisition. This ticket is stored in the
>> +acquire context. Furthermore the acquire context keeps track of debugging state
>> +to catch w/w mutex interface abuse.
>> +
>> +W/w class: In contrast to normal mutexes the lock class needs to be explicit for
>> +w/w mutexes, since it is required to initialize the acquire context.
>> +
>> +Furthermore there are three different classe of w/w lock acquire functions:
>> +- Normal lock acquisition with a context, using ww_mutex_lock
>> +- Slowpath lock acquisition on the contending lock, used by the wounded task
>> +  after having dropped all already acquired locks. These functions have the
>> +  _slow postfix.
>
> See below, I don't see the need for this interface.

I think it helps the code clarity to have special slowpath locking
functions. But it also helps with interface safety:
- __must_check int vs. void returns values sign up gcc to help check
for correct usage. Of course the first locking operation can't really
fail, but since those usually happen in a loop this shouldn't ever
hurt. At least the examples all need to check the return value to be
correct.
- _slow functions can check whether all acquire locks have been
released and whether the caller is indeed blocking on the contending
lock. Not doing so could either result in needless spinning instead of
blocking (when blocking on the wrong lock) or in deadlocks (when not
dropping all acquired).

Together with the debug patch to forcefully go through the slowpath
this should catch all interface abuse. Dropping the _slow functions
would rid us of this nice safety net.

>> +- Functions to only acquire a single w/w mutex, which results in the exact same
>> +  semantics as a normal mutex. These functions have the _single postfix.
>
> This is missing rationale.

Again it signs up gcc with the __must_check int vs. void return
values. In addition you don't need to set up a ww_acquire_ctx for the
single version. Since gem/ttm has quite a few interfaces to check the
status of buffer objects we have a lot of places that only acquire the
lock for a single object. So I think the added interface scope is
worth the upside of simpler code in ww mutex users.

>> +
>> +Of course, all the usual variants for handling wake-ups due to signals are also
>> +provided.
>> +
>> +Usage
>> +-----
>> +
>> +Three different ways to acquire locks within the same w/w class. Common
>> +definitions for methods 1&2.
>> +
>> +static DEFINE_WW_CLASS(ww_class);
>> +
>> +struct obj {
>> +     sct ww_mutex lock;
>> +     /* obj data */
>> +};
>> +
>> +struct obj_entry {
>> +     struct list_head *list;
>> +     struct obj *obj;
>> +};
>> +
>> +Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
>> +This is useful if a list of required objects is already tracked somewhere.
>> +Furthermore the lock helper can use propagate the -EALREADY return code back to
>> +the caller as a signal that an object is twice on the list. This is useful if
>> +the list is constructed from userspace input and the ABI requires userspace to
>> +no have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
>> +
>> +int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
>> +{
>> +     struct obj *res_obj = NULL;
>> +     struct obj_entry *contended_entry = NULL;
>> +     struct obj_entry *entry;
>> +
>> +     ww_acquire_init(ctx, &ww_class);
>> +
>> +retry:
>> +     list_for_each_entry (list, entry) {
>> +             if (entry == res_obj) {
>> +                     res_obj = NULL;
>> +                     continue;
>> +             }
>> +             ret = ww_mutex_lock(&entry->obj->lock, ctx);
>> +             if (ret < 0) {
>> +                     contended_obj = entry;
>> +                     goto err;
>> +             }
>> +     }
>> +
>> +     ww_acquire_done(ctx);
>> +     return 0;
>> +
>> +err:
>> +     list_for_each_entry_continue_reverse (list, contended_entry, entry)
>> +             ww_mutex_unlock(&entry->obj->lock);
>> +
>> +     if (res_obj)
>> +             ww_mutex_unlock(&res_obj->lock);
>> +
>> +     if (ret == -EDEADLK) {
>> +             /* we lost out in a seqno race, lock and retry.. */
>> +             ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);
>
> I missing the need for ww_mutex_lock_slow(). AFAICT we should be able to tell
> its the first lock in the ctx and thus we cannot possibly deadlock.

See above, it's only for better debugging checks and (imho) clearer
code in the ww mutex users.

>> +             res_obj = contended_entry->obj;
>> +             goto retry;
>> +     }
>> +     ww_acquire_fini(ctx);
>> +
>> +     return ret;
>> +}
>> +
>
> ... you certainly went all out on documentation.

Thanks ;-) And I think it was a good exercise in clarfying the details
of the interfaces and especially checking whether full debugging will
catch all the MUST and MUST NOT case. Like I've mentioned in the docs
somewhere I'm fairly convinced that the only untested ww mutex user
bug is not taking all required locks, everything else should be fully
covered.

Cheers, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
