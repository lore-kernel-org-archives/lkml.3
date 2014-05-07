Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaEGVWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:22:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEGVWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:22:32 -0400
Date: Wed, 7 May 2014 23:22:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140507212224.GC2844@laptop.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140507152640.GR30445@twins.programming.kicks-ass.net>
 <20140507210843.GS19657@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140507210843.GS19657@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:08:43PM -0700, Andi Kleen wrote:
> > Then, when data inside that aux data store changes they should inject an
> > PERF_RECORD_AUX to indicate this did happen, which ties it back into the
> > normal event flow.
> 
> What happens when the aux buffer wraps? How would the client know
> if the data belongs to this _AUX entry or some later one?

It belongs to the last one. Rewind them from 'now' until you hit
collisions in AUX space, then you're done.

> May need some extra sequence numbers in the mmap header and the aux
> entry to handle this.

You're thinking of overwrite mode, right? We should update the tail in
that case, I've not thought about how to do that for the AUX buffer.

There have been some patches for the normal buffer, but they stalled;

https://lkml.org/lkml/2013/7/8/154

I'm all for merging that patch (or a fixed on, since it has fail in) if
we can show the current !overwrite case doesn't regress.

Also, would anybody want different mode for the data and aux parts? In
that case we do need to add some extra state to the control page to
indicate such.
