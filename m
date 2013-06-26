Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3FZURR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:17:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3FZURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:17:15 -0400
Date: Wed, 26 Jun 2013 22:17:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
Message-ID: <20130626201713.GH6123@two.firstfloor.org>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
 <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * The combined data structure is 8-byte aligned. So proper placement of this
> + * structure in the larger embedding data structure is needed to ensure that
> + * there is no hole in it.

On i386 u64 is only 4 bytes aligned. So you need to explicitely align
it to 8 bytes. Otherwise you risk the two members crossing a cache line, which
would be really expensive with atomics.

> +	/*
> +	 * Code doesn't work if raw spinlock is larger than 4 bytes
> +	 * or is empty.
> +	 */
> +	BUG_ON((sizeof(arch_spinlock_t) > 4) || (sizeof(arch_spinlock_t) == 0));

BUILD_BUG_ON 

> +
> +	spin_unlock_wait(plock);	/* Wait until lock is released */
> +	old.__lock_count = ACCESS_ONCE(*plockcnt);
> +	get_lock = ((threshold >= 0) && (old.count == threshold));
> +	if (likely(!get_lock && spin_can_lock(&old.lock))) {

What is that for? Why can't you do the CMPXCHG unconditially ?

If it's really needed, it is most likely a race?

The duplicated code should be likely an inline.

> +/*
> + * The presence of either one of the CONFIG_DEBUG_SPINLOCK or
> + * CONFIG_DEBUG_LOCK_ALLOC configuration parameter will force the
> + * spinlock_t structure to be 8-byte aligned.
> + *
> + * To support the spinlock/reference count combo data type for 64-bit SMP
> + * environment with spinlock debugging turned on, the reference count has
> + * to be integrated into the spinlock_t data structure in this special case.
> + * The spinlock_t data type will be 8 bytes larger if CONFIG_GENERIC_LOCKBREAK
> + * is also defined.

I would rather just disable the optimization when these CONFIGs are set

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
