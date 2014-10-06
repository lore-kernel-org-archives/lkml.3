Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaJFQVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:21:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:21:14 -0400
Date: Mon, 6 Oct 2014 18:20:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20141006162056.GD6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908070242.GS19379@twins.programming.kicks-ass.net>
 <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
 <20140908113422.GD6758@twins.programming.kicks-ass.net>
 <87a96auv9s.fsf@ashishki-desk.ger.corp.intel.com>
 <20140908131230.GE6758@twins.programming.kicks-ass.net>
 <87k34do9a4.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k34do9a4.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 12:08:19PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Mon, Sep 08, 2014 at 03:55:11PM +0300, Alexander Shishkin wrote:
> >
> >> Fair enough. Then I'd like to disable the ACTIVE ones before freeing AUX
> >> stuff and then re-enabling them since perf_event_{en,dis}able() already
> >> provide the convenient cross-cpu calls, which would also avoid
> >> concurrency between pmu::{add,del} callbacks and this unmap path. Makes
> >> sense?
> >
> > But why? The buffer stuff is RCU freed, so if the hardware observes
> > pages and does get_page_unless_zero() on them its good. The memory will
> > not be freed from underneath the hardware writer because of the
> > get_page().
> >
> > Then when the buffer is full and we 'swap', we'll find there is no next
> > buffer. At that point we can not provide a new buffer, effectively
> > stopping the hardware writes and release the old buffer, freeing the
> > memory.
> 
> There are several problems with this. Firstly, aux buffers can be quite
> large, which means that we have to do get_page() on thousands of pages
> on every pmu::add, which is a hot path and free_page() again in
> pmu::del.
> 
> Secondly, all the sg bookkeeping that the driver keeps in aux_priv needs
> to be refcounted. Right now, in the mmap_close path we just free
> everything. But if we want to free the aux_pages in pmu::del, we need to
> keep a list of these pages still around after mmap_close() and same goes
> for the actual sg tables. I can see a way of doing that on the ring
> buffer side (as opposed to the driver side), but are you quite sure we
> should go down this road?

No, and I think I realized this after sending that email, but at the
time I figured there was another way to do it. Of course, now that
several weeks have passed I cannot for the life of me remember what it
was.

Lemme go over these patches again to refresh my mind and maybe I'll
remember.
