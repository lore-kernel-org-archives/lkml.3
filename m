Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3K0Loi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:44:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3K0LoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:44:06 -0500
Date: Wed, 27 Nov 2013 12:43:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf events: how to implement TLB misses as SW event ?
Message-ID: <20131127114354.GZ10022@twins.programming.kicks-ass.net>
References: <52924132.2080209@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52924132.2080209@c-s.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 07:10:58PM +0100, christophe leroy wrote:
> Today in the perfevents subsystem it looks like DTLB/ITLB misses are
> implemented as HW counter only.
> On some processors, like PowerPC 8xx, there is no counter for that. However
> DTLB/ITLB misses are handled as exceptions via software, so we have an
> opportunity to implement a SW counter for that.
> What's the easiest/best way to implement it ?

The very easiest way would be to place a trace_event in your tlb miss
handler.

_HOWEVER_ I suspect you're quite limited in what you can do from an
actual tlb miss handler -- seeing as generating another miss from a
miss-handler might be a bad thing.

So I suspect that'll not actually work.

You'll need to educate me a bit on what you can (and can not) do from a
tlb miss handler on your platforms.

I'm assuming you have a limited fixed memory map to work from while in
the tlb fault handler -- you need something like that for such a handler
to run.

So one possible option would be to keep a free-running counter in
whatever fixed mapped memory region you have, and read from that. This
would allow you to implement a non-sampling software pmu for these
events.

If you have means of raising an interrupt; or other means of causing
some routine to run in a 'normal' context. You could implement a more
complete counter.

For example, you could decrement your fixed map counter on each tlb
miss, and when it hits 0, write some state -- eg. the instruction
pointer of the instruction that caused the tlb miss -- into a related
field in the fixed map and raise the interrupt.

You can then use this mechanism from either your hardware pmu driver or
a separate pmu implementation as a 'regular' fixed purpose counter.

Since its all software, you can even implement whatever filters your
hardware counters have to match its capabilities.
