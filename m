Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3ITQAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:00:21 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:47619 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3ITQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130920154518.GE5015@mudshark.cambridge.arm.com>
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
	<CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
	<20130920100806.GA5015@mudshark.cambridge.arm.com>
	<20130920154518.GE5015@mudshark.cambridge.arm.com>
Date: Fri, 20 Sep 2013 11:00:19 -0500
X-Google-Sender-Auth: 0FyoHcU0biho_IN-B2G8vq4NytA
Message-ID: <CA+55aFxh-ueQgpY9sgizTBxqKqrGCTcAM-tw_50LG9wmakziPg@mail.gmail.com>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:45 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> Right, turns out I can get some interesting numbers from your simple t.c
> program on my dual-cluster, 5 CPU ARMv7 machine. The new cmpxchg-based lockref
> code gives ~50% improvement, but the fun part is that implementing cmpxchg64
> without memory barriers doubles this win to ~100% over current mainline.

Ok, that's certainly noticeable.

> If we can guarantee that the CODE just messes around with the lockref, those
> barriers probably aren't needed...

Yes. I've been thyinking about the barrier issue, and as far as I can
see, as long as the lockref code only ever messes with the reference
count, a totally unordered cmpxchg is fine.

And at least right now we indeed only ever mess with the reference count.

I have been idly toying with the concept of using the cmpxchg also for
possibly taking the lock (for the "xyz_or_lock" versions), but every
time I look at it it seems unlikely to help, and it would require
memory ordering and various architecture-dependent issues, so I
suspect it's never going to make much sense. So yes, an unordered
cmpxchg64 should be perfectly fine.

> As for AIM7/re-aim, I'm having a hard time getting repeatable numbers out of
> it to establish a baseline, so it's not proving to be especially helpful.

That's fine, and yeah, I doubt the t.c improvement really shows
anywhere else (it's kind of extreme), but your numbers are certainly
already sufficient to say "ok, it makes sense even on 32-bit
machines".

                  Linus
