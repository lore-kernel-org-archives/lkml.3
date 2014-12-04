Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbaLDTSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:18:20 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:56567 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaLDTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:18:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141204183628.GT25340@linux.vnet.ibm.com>
References: <20141204062005.GA2553@linux.vnet.ibm.com>
	<CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
	<CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
	<20141204070248.GJ25340@linux.vnet.ibm.com>
	<CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
	<20141204183628.GT25340@linux.vnet.ibm.com>
Date: Thu, 4 Dec 2014 11:18:17 -0800
X-Google-Sender-Auth: QqOZJnUiggkEgw8p7beU9lU3eHg
Message-ID: <CA+55aFzPZdk5F2q7HjTnjFq673xpZGWUtkMZFx24q8RWQE0-dg@mail.gmail.com>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 10:36 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> I have to ask...  Does this mean we can remove the current
> restrictions against 8-bit and 16-bit access from smp_load_acquire()
> and smp_store_release()?

I'd certainly be ok with it. Alpha doesn't have acquire/release
semantics anyway (really, it's the worst memory ordering model
*ever*), so those will end up being just plain (access-once) loads and
stores, followed/preceded by a memory barrier anyway. So it arguably
is no worse than the existing situation with ACCESS_ONCE() on alpha.

And quite frankly, I simply don't think that an old broken alpha
architecture should be something we worry about. Remember: the byte
and word ops were introduced in 21164, and released in 1996, so it's
not even like "alpha has broken behavior". It's literally just "the
very earliest alphas were broken", and I suspect most of those
machines (at least running Linux) weren't even SMP (ie somebody may
still have a Multia around for sentimental reasons, but SMP? No).

Of course, I'd like there to be a real reason to do so, not just "who
cares about really old alphas, nyaah, nyaah, nyaah"? But if there is a
clear case where a byte load-acquire and store-release would improve
on something important, then yes, I think we should do it.

We dropped support for the original i386, we can drop support for old
broken alphas. People running them for sentimental reasons might as
well be sentimental about software too, and run old kernels ;)

                    Linus
