Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796Ab3GaWID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:08:03 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:47788 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3GaWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130731174335.006a58f9@annuminas.surriel.com>
References: <20130731174335.006a58f9@annuminas.surriel.com>
Date: Wed, 31 Jul 2013 15:07:58 -0700
X-Google-Sender-Auth: u4CXDaxQ5wTCtrrOQaeOMRLUBE8
Message-ID: <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, dzickus@redhat.com, Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 2:43 PM, Rik van Riel <riel@redhat.com> wrote:
>
> The cause turned out to be unnecessary atomic accesses to the
> mm_cpumask. When in lazy TLB mode, the CPU is only removed from
> the mm_cpumask if there is a TLB flush event.
>
> Most of the time, no such TLB flush happens, and the kernel
> skips the TLB reload.  It can also skip the atomic memory
> set & test.

The patch looks obvious, and I'm not seeing any very clear reasons for
why we would want that test-and-set to be atomic. That said, I'd like
to have some explicit comments about exactly why it doesn't need the
atomicity. Because afaik, there actually are concurrent readers _and_
writers of that mask, and the accesses are not locked by anything
here.

I _think_ the reason for this all being safe is simply that the only
real race is "We need to set the bit before we load the page table,
and we're protected against that bit being cleared because the TLB
state is TLBSTATE_OK and thus TLB flushing will no longer leave that
mm".

But damn, it all looks subtle as hell. That code does:

                this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
                BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);

                if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {

and I'm wondering if we need a barrier to make sure that that
TLBSTATE_OK write happens *before* we test the cpumask. With
test_and_set(), we have the barrier in the test-and-set. But with just
test_bit, I'm not seeing why the compiler couldn't re-order them. I
suspect it won't, but...

So I think the patch is _probably_ fine, but I think this is a hell of
a lot more subtle than it all looks, and I'd like people to show that
they have thought this through. And I don't see any indication of that
in the changelog - it only talks about the performance issues, not
about the *correctness* issues.

Please?

               Linus
