Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3AaJcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:32:20 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61665 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3AaJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
Date: Thu, 31 Jan 2013 18:32:15 +0900
X-Google-Sender-Auth: BSh2Po05xJ45LXpqYb_562TsXRU
Message-ID: <CAAQKjZMpFin6s+-z8ei+JcxcdFrWUpFZrsCuxv7AH+8wVfTUqw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/7] fence: dma-buf cross-device
 synchronization (v11)
From: Inki Dae <inki.dae@samsung.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

below is my opinion.

> +struct fence;
> +struct fence_ops;
> +struct fence_cb;
> +
> +/**
> + * struct fence - software synchronization primitive
> + * @refcount: refcount for this fence
> + * @ops: fence_ops associated with this fence
> + * @cb_list: list of all callbacks to call
> + * @lock: spin_lock_irqsave used for locking
> + * @priv: fence specific private data
> + * @flags: A mask of FENCE_FLAG_* defined below
> + *
> + * the flags member must be manipulated and read using the appropriate
> + * atomic ops (bit_*), so taking the spinlock will not be needed most
> + * of the time.
> + *
> + * FENCE_FLAG_SIGNALED_BIT - fence is already signaled
> + * FENCE_FLAG_ENABLE_SIGNAL_BIT - enable_signaling might have been called*
> + * FENCE_FLAG_USER_BITS - start of the unused bits, can be used by the
> + * implementer of the fence for its own purposes. Can be used in different
> + * ways by different fence implementers, so do not rely on this.
> + *
> + * *) Since atomic bitops are used, this is not guaranteed to be the case.
> + * Particularly, if the bit was set, but fence_signal was called right
> + * before this bit was set, it would have been able to set the
> + * FENCE_FLAG_SIGNALED_BIT, before enable_signaling was called.
> + * Adding a check for FENCE_FLAG_SIGNALED_BIT after setting
> + * FENCE_FLAG_ENABLE_SIGNAL_BIT closes this race, and makes sure that
> + * after fence_signal was called, any enable_signaling call will have either
> + * been completed, or never called at all.
> + */
> +struct fence {
> +       struct kref refcount;
> +       const struct fence_ops *ops;
> +       struct list_head cb_list;
> +       spinlock_t *lock;
> +       unsigned context, seqno;
> +       unsigned long flags;
> +};
> +
> +enum fence_flag_bits {
> +       FENCE_FLAG_SIGNALED_BIT,
> +       FENCE_FLAG_ENABLE_SIGNAL_BIT,
> +       FENCE_FLAG_USER_BITS, /* must always be last member */
> +};
> +

It seems like that this fence framework need to add read/write flags.
In case of two read operations, one might wait for another one. But
the another is just read operation so we doesn't need to wait for it.
Shouldn't fence-wait-request be ignored? In this case, I think it's
enough to consider just only write operation.

For this, you could add the following,

enum fence_flag_bits {
        ...
        FENCE_FLAG_ACCESS_READ_BIT,
        FENCE_FLAG_ACCESS_WRITE_BIT,
        ...
};

And the producer could call fence_init() like below,
__fence_init(..., FENCE_FLAG_ACCESS_WRITE_BIT,...);

With this, fence->flags has FENCE_FLAG_ACCESS_WRITE_BIT as write
operation and then other sides(read or write operation) would wait for
the write operation completion.
And also consumer calls that function with FENCE_FLAG_ACCESS_READ_BIT
so that other consumers could ignore the fence-wait to any read
operations.

Thanks,
Inki Dae
