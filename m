Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaACWHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:07:52 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:34389 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaACWHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:07:50 -0500
Date: Fri, 3 Jan 2014 23:07:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20140103220745.GB11061@localhost.localdomain>
References: <528E1EE6.9040407@tu-dresden.de>
 <20131127135137.GA24403@gmail.com>
 <52B437AA.4090102@tu-dresden.de>
 <52B479E1.7020204@gmail.com>
 <20131223131051.GB585@localhost.localdomain>
 <52B84C49.70001@gmail.com>
 <20131226151429.GA15303@localhost.localdomain>
 <52BC4A13.1090508@gmail.com>
 <20131226153033.GC15303@localhost.localdomain>
 <52C46083.9070605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C46083.9070605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 11:37:55AM -0700, David Ahern wrote:
> On 12/26/13, 8:30 AM, Frederic Weisbecker wrote:
> >On Thu, Dec 26, 2013 at 10:24:03AM -0500, David Ahern wrote:
> >>On 12/26/13, 10:14 AM, Frederic Weisbecker wrote:
> >>>>I was carrying that patch while working on perf-kvm-stat-live last
> >>>>Fall. It does not solve the problem for live commands, so ended up
> >>>>dropping it and going with local (to the command) hacks. I still
> >>>>think for live commands getting a perf_clock timestamp at the start
> >>>>of a round and using that as the flush time will work best.
> 
> For perf-kvm-stat-live using perf_clock value at the start of the
> round as the flush time works beautifully:
> 
> https://github.com/dsahern/linux/commit/ba8b7b63d5dbdc95aedbbafa670c2232e0cc07a2
> 
> Never once failed with "Warning: Timestamp below last timeslice
> flush" error.

I'm not sure I understand why we need that. Why doesn't it work by simply flushing
events prior to the earliest timestamp among every CPUs last event?

I can see one remaining issue when an event interrupts another in a CPU. If the
interrupt happens after perf_prepare_sample() -> perf_clock() and perf_output_begin(),
we may have locally non-monotonic timestamps in a CPU buffer.

That could be solved with a heuristic similar to yours: flush events prior a few millisecs
before the barrier since interrupt are supposed to be short. Or we could move the perf_clock()
event snapshot to perf_output_sample() to make sure that the event space is reserved before
we get the timestamp, thus the interrupting events having superior timestamps are guaranteed
to be past the interrupted event in the stream.
