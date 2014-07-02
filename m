Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaGBNQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:16:42 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62432 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140701093442.GN6758@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
	<20140701093442.GN6758@twins.programming.kicks-ass.net>
Date: Wed, 2 Jul 2014 15:16:40 +0200
Message-ID: <CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer failure
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 11:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 04:04:08PM -0700, David Rientjes wrote:
>> It's unnecessary to excessively spam the kernel log anytime the BTS buffer
>> cannot be allocated, so make this allocation __GFP_NOWARN.
>>
>> The user probably will want to at least find some artifact that the
>> allocation has failed in the past, probably due to fragmentation because
>> of its large size, when it's not allocated at bootstrap.  Thus, add a
>> WARN_ONCE() so something is left behind for them to understand why perf
>> commnads that require PEBS is not working properly.
>
> Can you elaborate a bit under which conditions this triggered? Typically
> we should be doing fairly well allocating such buffers with GFP_KERNEL,
> that should allow things like compaction to run and create higher order
> pages.
>
I think this triggers when you have fragmented memory and you have
perf_events active and inactive (i.e., 0 users = no nmi watchdog) frequently.
Each first user invokes the reserve_ds() function to reserve DS, PEBS, BTS.

The reason for BTS rather then PEBS is the size of the allocation.
PEBS allocates one page, i.e., less likely to get a failure than BTS
which allocates 4 pages, I think.

David and I discussed this. He can probably add more background
info, if needed.

> And the BTS (branch trace store) isn't _that_ large.
>
> That said, the patch is reasonable; although arguably we should maybe do
> the same to alloc_pebs_buffer().
