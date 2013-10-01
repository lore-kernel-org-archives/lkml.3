Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3JABpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 21:45:01 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:58036 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3JABo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 21:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
Date: Mon, 30 Sep 2013 18:44:58 -0700
X-Google-Sender-Auth: cc8BTXmYf13fn5abEZfz7i8xA4Q
Message-ID: <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
Subject: Re: spinlock contention of files->file_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 6:05 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Speaking of spinlock contention, the files->file_lock is a good example.
>
> Multi threaded programs hit this spinlock three times per fd :

.. do you actually have programs that see contention?

> alloc_fd() / fd_install() / close()
>
> I think fd_install() could be done without this spinlock.

Yes, I haven't thought much about it, but from a quick look it should
be trivial to do fd_install(). We already free the fdtable using rcu
(because we look things up without locking), so we could just get the
rcu read-lock, do fd_install() without any locking at all, and then
verify that the fd-table is still the same. Rinse and repeat if not.

> - Add a seqcount, and cmpxchg() to synchronize fd_install() with the
> potential resizer. (Might need additional RCU locking)

I don't think you even need that. alloc_fd() has already reserved the
spot, so I think you really can just assign without any fancy cmpxchg
at all. If you write to the old fdtable, who cares? Probably just
something like

   do {
      fdt = files_fdtable(files);
      rcu_assign_pointer(fdt->fd[fd], file);
      smp_mb();
   } while (fdt != files_fdtable(files));

or similar. Under the RCU lock to guarantee the allocations don't
disappear from under you, but with no other locking.

Maybe I'm missing something, but it really doesn't look that bad.

Now, that only gets rid of fd_install(), but I suspect you could do
something similar for put_unused_fd() (that one does need cmpxchg for
the "next_fd" thing, though). We'd have to replace the non-atomic
bitops on open_fds[] with atomic ones, just to make sure adjacent bit
clearings don't screw up concurrent adjacent bit values, but that
looks fairly straightforward too.

Now, getting rid of the spinlock for alloc_fd() would be more work,
and you'd likely want to keep it for actually resizing (just to keep
that case more straightforward), but you could probably do the
non-resizing cases fairly easily there too without holding the lock.
Scan for a free bit optimistically and without any locking, and then
be somewhat careful with setting that open_fds[] bit - not only using
an atomic test_and_set() for it, but also do the same "let's check
that the fdtable base pointers haven't changed in the meantime and
repeat".

On the whole the fd table looks like if it really is a contention
point, it would be fairly straightforward to fix without any huge
contortions. Sure, lots of care and small details to look out for, but
nothing looks really all that fundamentally difficult.

But is it really a contention point on any real load?

                 Linus
