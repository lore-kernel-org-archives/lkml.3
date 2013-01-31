Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3AaJzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:55:21 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39212 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3AaJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:55:18 -0500
Date: Thu, 31 Jan 2013 10:57:26 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 4/7] fence: dma-buf cross-device
 synchronization (v11)
Message-ID: <20130131095726.GD5885@phenom.ffwll.local>
Mail-Followup-To: Inki Dae <inki.dae@samsung.com>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
 <1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
 <CAAQKjZMpFin6s+-z8ei+JcxcdFrWUpFZrsCuxv7AH+8wVfTUqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAQKjZMpFin6s+-z8ei+JcxcdFrWUpFZrsCuxv7AH+8wVfTUqw@mail.gmail.com>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 06:32:15PM +0900, Inki Dae wrote:
> Hi,
> 
> below is my opinion.
> 
> > +struct fence;
> > +struct fence_ops;
> > +struct fence_cb;
> > +
> > +/**
> > + * struct fence - software synchronization primitive
> > + * @refcount: refcount for this fence
> > + * @ops: fence_ops associated with this fence
> > + * @cb_list: list of all callbacks to call
> > + * @lock: spin_lock_irqsave used for locking
> > + * @priv: fence specific private data
> > + * @flags: A mask of FENCE_FLAG_* defined below
> > + *
> > + * the flags member must be manipulated and read using the appropriate
> > + * atomic ops (bit_*), so taking the spinlock will not be needed most
> > + * of the time.
> > + *
> > + * FENCE_FLAG_SIGNALED_BIT - fence is already signaled
> > + * FENCE_FLAG_ENABLE_SIGNAL_BIT - enable_signaling might have been called*
> > + * FENCE_FLAG_USER_BITS - start of the unused bits, can be used by the
> > + * implementer of the fence for its own purposes. Can be used in different
> > + * ways by different fence implementers, so do not rely on this.
> > + *
> > + * *) Since atomic bitops are used, this is not guaranteed to be the case.
> > + * Particularly, if the bit was set, but fence_signal was called right
> > + * before this bit was set, it would have been able to set the
> > + * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
> > + * Adding a check for FENCE_FLAG_SIGNALED_BIT after setting
> > + * FENCE_FLAG_ENABLE_SIGNAL_BIT closes this race, and makes sure that
> > + * after fence_signal was called, any enable_signaling call will have either
> > + * been completed, or never called at all.
> > + */
> > +struct fence {
> > +       struct kref refcount;
> > +       const struct fence_ops *ops;
> > +       struct list_head cb_list;
> > +       spinlock_t *lock;
> > +       unsigned context, seqno;
> > +       unsigned long flags;
> > +};
> > +
> > +enum fence_flag_bits {
> > +       FENCE_FLAG_SIGNALED_BIT,
> > +       FENCE_FLAG_ENABLE_SIGNAL_BIT,
> > +       FENCE_FLAG_USER_BITS, /* must always be last member */
> > +};
> > +
> 
> It seems like that this fence framework need to add read/write flags.
> In case of two read operations, one might wait for another one. But
> the another is just read operation so we doesn't need to wait for it.
> Shouldn't fence-wait-request be ignored? In this case, I think it's
> enough to consider just only write operation.
> 
> For this, you could add the following,
> 
> enum fence_flag_bits {
>         ...
>         FENCE_FLAG_ACCESS_READ_BIT,
>         FENCE_FLAG_ACCESS_WRITE_BIT,
>         ...
> };
> 
> And the producer could call fence_init() like below,
> __fence_init(..., FENCE_FLAG_ACCESS_WRITE_BIT,...);
> 
> With this, fence->flags has FENCE_FLAG_ACCESS_WRITE_BIT as write
> operation and then other sides(read or write operation) would wait for
> the write operation completion.
> And also consumer calls that function with FENCE_FLAG_ACCESS_READ_BIT
> so that other consumers could ignore the fence-wait to any read
> operations.

Fences here match more to the sync-points concept from the android stuff.
The idea is that they only signal when a hw operation completes.

Synchronization integration happens at the dma_buf level, where you can
specify whether the new operation you're doing is exclusive (which means
that you need to wait for all previous operations to complete), i.e. a
write. Or whether the operation is non-excluses (i.e. just reading) in
which case you only need to wait for any still outstanding exclusive
fences attached to the dma_buf. But you _can_ attach more than one
non-exclusive fence to a dma_buf at the same time, and so e.g. read a
buffer objects from different engines concurrently.

There's been some talk whether we also need a non-exclusive write
attachment (i.e. allow multiple concurrent writers), but I don't yet fully
understand the use-case.

In short the proposed patches can do what you want to do, it's just that
read/write access isn't part of the fences, but how you attach fences to
dma_bufs.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
