Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3KSLsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:48:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35727 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:48:20 -0500
Date: Tue, 19 Nov 2013 12:48:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119114810.GK3866@twins.programming.kicks-ass.net>
References: <52864ED1.1080607@gmail.com>
 <20131118090117.GE3866@twins.programming.kicks-ass.net>
 <20131118094036.GA26251@gmail.com>
 <877gc5utkf.fsf@sejong.aot.lge.com>
 <528AB229.6030603@gmail.com>
 <87wqk5t9yd.fsf@sejong.aot.lge.com>
 <528ACA41.4030202@gmail.com>
 <87ob5ht962.fsf@sejong.aot.lge.com>
 <528ACDE7.3050107@gmail.com>
 <20131119065835.GB32367@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119065835.GB32367@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:58:35AM +0100, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > This is mmap'ed output, not the ring buffers or its stack. As the 
> > output file grows, new pages are needed and those are allocated on 
> > access via page faults. The ftruncate only extends the file size, it 
> > does not allocate pages at that time.
> 
> Hm, doesn't MAP_POPULATE prefault pages in this case as well? 
> Prefaulting would avoid the most obvious page fault driven feedback 
> loops and it would probably be faster as well, because it avoids all 
> the pagefaults ...

MAP_POPULATE does indeed seem to write pre-fault for writable maps
(mm/mlock.c:__mlock_vma_pages_range).

And that does indeed seem to side-step the perf sw pagefault event, but
that is arguably a perf bug.

If we were to fix this, MAP_POPULATE would simply generate a metric ton
of events, we'd have to write out with yet more MAP_POPULATE.
