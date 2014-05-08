Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaEHD04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:26:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:61542 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaEHD0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1008,1389772800"; 
   d="scan'208";a="429229294"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <20140507212224.GC2844@laptop.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140507152640.GR30445@twins.programming.kicks-ass.net> <20140507210843.GS19657@tassilo.jf.intel.com> <20140507212224.GC2844@laptop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 May 2014 06:26:32 +0300
Message-ID: <87siolc5nb.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, May 07, 2014 at 02:08:43PM -0700, Andi Kleen wrote:
>> > Then, when data inside that aux data store changes they should inject an
>> > PERF_RECORD_AUX to indicate this did happen, which ties it back into the
>> > normal event flow.
>> 
>> What happens when the aux buffer wraps? How would the client know
>> if the data belongs to this _AUX entry or some later one?
>
> It belongs to the last one. Rewind them from 'now' until you hit
> collisions in AUX space, then you're done.

I guess the point here is that if we don't want to lose any data in aux
space, we need to stop the perf_event when it fills up. Also there's a
question if we need a separate wake up watermark for the AUX buffer or
do we simply wake up the poller every time there's new data.

>> May need some extra sequence numbers in the mmap header and the aux
>> entry to handle this.
>
> You're thinking of overwrite mode, right? We should update the tail in
> that case, I've not thought about how to do that for the AUX buffer.

In the overwrite mode we don't have to write out AUX records at all
before we stop the trace, we don't care how many times data in the AUX
space wraps.

> There have been some patches for the normal buffer, but they stalled;
>
> https://lkml.org/lkml/2013/7/8/154
>
> I'm all for merging that patch (or a fixed on, since it has fail in) if
> we can show the current !overwrite case doesn't regress.
>
> Also, would anybody want different mode for the data and aux parts? In
> that case we do need to add some extra state to the control page to
> indicate such.

For the decoder to make sense of the trace, it needs all the data in the
normal buffer (MMAPs, sched_switches), not just the latest bits, so it's
a good idea to have it.

Regards,
--
Alex
