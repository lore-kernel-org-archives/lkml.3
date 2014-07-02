Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaGBXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:30:10 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35783 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGBXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:30:08 -0400
Date: Wed, 2 Jul 2014 16:30:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
In-Reply-To: <20140702133105.GG19379@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1407021623380.5931@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com> <20140701093442.GN6758@twins.programming.kicks-ass.net> <CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
 <20140702133105.GG19379@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Peter Zijlstra wrote:

> > David and I discussed this. He can probably add more background
> > info, if needed.
> 
> It would still be good to see why compaction etc is failing.
> 

"Why compaction is failing" has been the story of my life for the past few 
weeks, unfortunately.  One person ran into this and here is the breakdown 
at the time of the page allocation failure:

Node 0 DMA32: 12478*4kB 7595*8kB 2087*16kB 26*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 144896kB
Node 0 Normal: 55037*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 222196kB
Node 1 Normal: 165860*4kB 18*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 663600kB

So we really don't have any order-4 or higher memory and if compaction and 
reclaim fails, then the allocation failure is printed every time.  This is 
what the patch is trying to address and we can't guarantee order-4 is 
always allocatable even with GFP_KERNEL.  This allocation is just outside 
the PAGE_ALLOC_COSTLY_ORDER == 3 threshold that would have oom killed 
something and retried; the oom killer is deferred for this case because 
there's no guarantee killing a process would have resulted in order-4 
memory being available (and nobody wants killing when they are 902MB above 
the per-zone min watermarks like this poor guy).
