Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3CCXBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 18:01:45 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55219 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3CCXBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 18:01:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130303225110.GQ4503@ZenIV.linux.org.uk>
References: <20130303184736.GM4503@ZenIV.linux.org.uk>
	<CA+55aFzxNKDdJsjT-xtv_XEWkCstFxN4hhhPz078p4LJZuHD2Q@mail.gmail.com>
	<20130303225110.GQ4503@ZenIV.linux.org.uk>
Date: Sun, 3 Mar 2013 15:01:43 -0800
X-Google-Sender-Auth: O4GxIgvguSzMEwD3lWYEBDXxHi0
Message-ID: <CA+55aFxMXbsrPfO1aA0dC9SzE5pZoG9QgnCwA2i0qSUMU49rJw@mail.gmail.com>
Subject: Re: [RFC][PATCH] making vfree() safe from interrupt contexts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 2:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> +struct vfree_deferred {
> +       spinlock_t lock;
> +       void *list;
> +       struct work_struct wq;
> +};

Looking more at this, just get rid of the spinlock entirely, and use
<linux/llist.h> for the list.

IRQ-safety without the locking. Because you got the locking wrong
again, and made free_work() use spin_lock_irq(), but

> +static inline void deferred_vfree(void *addr)
> +{
> +       struct vfree_deferred *p = &get_cpu_var(vfree_deferred);
> +       spin_lock(&p->lock);

This needs to be a spin_lock_irqsave() too.

> +       *(void **)addr = p->list;
> +       p->list = addr;
> +       schedule_work(&p->wq);
> +       spin_unlock(&p->lock);
> +       put_cpu_var(vfree_deferred);

And there is no reason to hold the lock - or even stay on the CPU -
over the work-scheduling (which had better be irq- and smp-safe on its
own anyway), so you're actually best off just using

    struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
    struct llist_node *new = (void *)addr;

    llist_add(new, &p->list);
    schedule_work(&p->wq);

and you're done.

I'm not even sure it's worth it making it per-cpu, but I guess it
won't hurt either.

                  Linus
