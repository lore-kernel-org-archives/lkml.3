Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490Ab3JQS03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:26:29 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:53901 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762426Ab3JQS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131017163039.GR10651@twins.programming.kicks-ass.net>
References: <20131015143227.GY26785@twins.programming.kicks-ass.net>
	<20131015150736.GZ26785@twins.programming.kicks-ass.net>
	<20131015154104.GA227855@redhat.com>
	<20131016105755.GX10651@twins.programming.kicks-ass.net>
	<20131016205227.GJ7456@tassilo.jf.intel.com>
	<20131016210319.GI10651@twins.programming.kicks-ass.net>
	<20131016230712.GC26785@twins.programming.kicks-ass.net>
	<20131017094145.GE3364@laptop.programming.kicks-ass.net>
	<20131017160034.GO227855@redhat.com>
	<20131017160439.GP227855@redhat.com>
	<20131017163039.GR10651@twins.programming.kicks-ass.net>
Date: Thu, 17 Oct 2013 11:26:23 -0700
X-Google-Sender-Auth: Y8c76XWaNlQCbPijJci5-ut01qQ
Message-ID: <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 9:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> So avoid having to call copy_from_user_nmi() for every instruction.
> Since we already limit the max basic block size, we can easily
> pre-allocate a piece of memory to copy the entire thing into in one
> go.

copy_from_user_nmi() itself is all kinds of nasty.

Using __get_user_pages_fast() for a single page is quite expensive,
and mucks around with the page counts etc.

If copy_from_user_nmi() just did the (simple) page table walk by hand,
it could avoid *all* of that. No page count stuff - just have
interrupts disabled over not just the page walk, but the copy too - to
guarantee that no cross-CPU TLB flush can come in.

So instead of trying to improve __get_user_pages_fast() - which is
impossible because the interface fundamentally means that it has to
iterate over things and check page counts - you could simplify the
caller instead.

That is, if we really care any more. Maybe this "do the
copy_from_user_nmi() just once" is already good enough that nobody
much cares.

                 Linus
