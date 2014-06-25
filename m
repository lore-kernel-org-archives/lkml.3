Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaFYLML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:12:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:22511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbaFYLJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,545,1400050800"; 
   d="scan'208";a="533853468"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 2/7] perf: add AUX area to ring buffer for raw data streams
In-Reply-To: <20140624171943.GR3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com> <1402501310-31940-3-git-send-email-alexander.shishkin@linux.intel.com> <20140624171943.GR3213@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 25 Jun 2014 14:09:31 +0300
Message-ID: <87lhslxn2s.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jun 11, 2014 at 06:41:45PM +0300, Alexander Shishkin wrote:
>> +	/*
>> +	 * Set up pmu-private data structures for an AUX area
>> +	 */
>> +	void *(*setup_aux)		(int cpu, void **pages,
>> +					 int nr_pages, bool overwrite);
>> +					/* optional */
>> +
>> +	/*
>> +	 * Free pmu-private AUX data structures
>> +	 */
>> +	void (*free_aux)		(void *aux); /* optional */
>
> I was hoping you could replace those with a PERF_CAP_AUX or something
> and then have one generic allocation routine like you provide in the
> subsequent patches.

I need these to allocate pmu-specific SG tables now, which I don't see
how to generalize nicely. User-visible aux_pages are allocated in the
generic rb_alloc_aux().

As for sg tables, the alternative would be to allocate them in the
event::pmu::add() path, which is probably not very good for
performance, unless I'm missing something? Like, I can allocate stuff in
the first add() and then free it in event::destroy().

Or, we can assume a generic sg table format and allocate them in the
generic code, but then we'll need more capabilities to indicate at least
the size of a table entry. PT needs 64 bits per entry, ARM's TMC needs
32 and the non-SG PT will still need some tables. But I'd rather leave
this part to the pmu drivers. What do you think?

Regards,
--
Alex
