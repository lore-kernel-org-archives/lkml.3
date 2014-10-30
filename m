Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbaJ3KUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:20:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:27716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbaJ3KUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="628214126"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 18/20] perf: Allocate ring buffers for inherited per-task kernel events
In-Reply-To: <20141030084359.GD23531@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com> <20141023123855.GC12706@worktop.programming.kicks-ass.net> <87egtx3o95.fsf@ashishki-desk.ger.corp.intel.com> <20141030084359.GD23531@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 30 Oct 2014 12:20:33 +0200
Message-ID: <878ujxdfke.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Oct 24, 2014 at 10:44:54AM +0300, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Mon, Oct 13, 2014 at 04:45:46PM +0300, Alexander Shishkin wrote:
>> >> Normally, per-task events can't be inherited parents' ring buffers to
>> >> avoid multiple events contending for the same buffer. And since buffer
>> >> allocation is typically done by the userspace consumer, there is no
>> >> practical interface to allocate new buffers for inherited counters.
>> >> 
>> >> However, for kernel users we can allocate new buffers for inherited
>> >> events as soon as they are created (and also reap them on event
>> >> destruction). This pattern has a number of use cases, such as event
>> >> sample annotation and process core dump annotation.
>> >> 
>> >> When a new event is inherited from a per-task kernel event that has a
>> >> ring buffer, allocate a new buffer for this event so that data from the
>> >> child task is collected and can later be retrieved for sample annotation
>> >> or core dump inclusion. This ring buffer is released when the event is
>> >> freed, for example, when the child task exits.
>> >> 
>> >
>> > This causes a pinned memory explosion, not at all nice that.
>> >
>> > I think I see why and all, but it would be ever so good to not have to
>> > allocate so much memory.
>> 
>> Are there any controls we could use to limit such memory usage?
>
> I'd say the same limit we're already accounting the mmap()s against. But
> the question is; what do we do when we run out?
>
> Will we fail clone()? That might 'surprise' quite a few people, that
> their application won't work when profiled.

Or we just don't allocate any more buffers for this user; if there's a
perf stream involved, we can output a record saying that.

> In any case, lets focus on the other parts of this work and delay this
> feature till later.

Agreed.

Regards,
--
Alex
