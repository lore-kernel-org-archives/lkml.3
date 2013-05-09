Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3EIX3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:29:19 -0400
Received: from www.sr71.net ([198.145.64.142]:34045 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3EIX3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:29:18 -0400
Message-ID: <518C314C.9040905@sr71.net>
Date: Thu, 09 May 2013 16:29:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, eranian@google.com
Subject: NMIs induced by 'perf top' hogging all CPU time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I boot a recent kernel (bb9055b) and run 'perf top' on my machine, it
hangs.  It is 100% reproducible; it happens every single time.  If I'm
lucky, I'll get some of the hardlockup detection messages on the console.

A little bit of digging showed that the reason it hangs is that we're
seeing an average x86 PMU NMI take around 0.5ms (and *up* to about 1ms)
to complete, and doing thousands of them a second.  IOW, we're spending
virtually all the CPU time just processing perf events in NMI context.

When we get a bunch of these in a row, and they happen to occur while
running an hrtimer, the hrtimer code notices and complains:

	[ 1623.552970] hrtimer: interrupt took 20,981,718 ns

My personal "best" is:

	[  273.247983] hrtimer: interrupt took 1,015,221,558 ns

My suspicion is that my particular machine is just really slow at poking
the PMU counters for some reason.  It could be its NUMA properties or
something even more subtle.  But, the result is still that it falls flat
on its face with the defaults.  Passing "-c" to perf to manually raise
the sample period works around this, but it's _awfully_ easy to bring
down a system this way.

Any ideas what we can do here?  I'm planning on trying to track down the
source of _why_ the NMIs are so slow, but it does seem like we should be
able to notice and back off on the NMI rate when we spend so much time
in there.

Andi suggested collecting some data about how the kernel was tuning the
sample period over time:

	https://www.sr71.net/~dave/intel/perf-hangs-201305/f1.html

There is one obviously goofy-looking points in there where the period
got set to 96!  We'd get another NMI 96 cycles after we exit the current
one!
