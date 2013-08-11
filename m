Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3HKRcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab3HKRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:32:53 -0400
Date: Sun, 11 Aug 2013 19:27:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch for lost wakeups
Message-ID: <20130811172704.GB10081@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com> <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com> <20130808191749.GA12062@redhat.com> <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com> <20130809130457.GA27493@redhat.com> <CA+55aFxh+4yK3AkPQWGq+hGhBgvDdWuPSfzko2aO76y7ej=Veg@mail.gmail.com> <20130811172510.GA10081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130811172510.GA10081@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Oleg Nesterov wrote:
>
> On 08/09, Linus Torvalds wrote:
> >
> > I guess that instead of a "smp_wmb()", we could do another
> > "smp_mb__before_spinlock()" thing, like we already allow for other
> > architectures to do a weaker form of mb in case the spinlock is
> > already a full mb. That would allow avoiding extra synchronization. Do
> > a
> >
> >    #ifndef smp_mb__before_spinlock
> >      #define smp_mb__before_spinlock() smp_wmb()
> >    #endif
> >
> > in <linux/spinlock.h> to not force everybody to implement it. Because
> > a wmb+acquire should be close enough to a full mb that nobody cares
> > (ok, so reads could move into the critical region from outside, but by
> > the time anybody has called "schedule()", I can't see it mattering, so
> > "close enough").
>
> Yes, this is what I tried to suggest. And of course we should turn that
> wmb() in try_to_wake_up() into smp_mb__before_spinlock().
>
> I event started the patch, but we already have smp_mb__after_lock(), so
> it should be smp_mb__before_lock() for consistency and we need to turn
> it to "define" too. Or change ARCH_HAS_SMP_MB_AFTER_LOCK, or add
> ARCH_HAS_SMP_MB_BEFORE_LOCK.

Ah, please ignore. According to /bin/grep smp_mb__before_lock() no longer
have users. So we can probably simply kill it in the same patch. I'll try
to write the changelog and send it tomorrow.

Oleg.

