Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3FRJN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:13:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38123 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3FRJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:13:20 -0400
Date: Tue, 18 Jun 2013 11:13:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old
 events
Message-ID: <20130618091313.GH3204@twins.programming.kicks-ass.net>
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:58:06PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> If perf event buffer is in overwrite mode, the kernel only updates
> the data head when it overwrites old samples. The program that owns
> the buffer need periodically check the buffer and update a variable
> that tracks the date tail. If the program fails to do this in time,
> the data tail can be overwritted by new samples. The program has to
> rewind the buffer because it does not know where is the first vaild
> sample.
> 
> This patch makes the kernel update the date tail when it overwrites
> old events. So the program that owns the event buffer can always
> read the latest samples. This is convenient for programs that use
> perf to do branch tracing. One use case is GDB branch tracing:
> (http://sourceware.org/ml/gdb-patches/2012-06/msg00172.html)
> It uses perf interface to read BTS, but only cares the branches
> before the ptrace event.
> 
> I added code to perf_output_{begin/end} to count how many cycles
> are spent by sample output, then ran "perf record" to profile kernel
> compilation 10 times on IvyBridge-EP. (perf record -a make -j 60)
> The first number is scaled to 1000, the rest numbers are scaled by
> the same factor.
> 
>         before   overwrite mode      after   overwrite mode
> AVG      1000        999             1046        1044
> STDEV    19.4        19.5            17.1        17.9
> 

Right, so it all gets about 5% more expensive.. I don't suppose there's
anything smart we can do to avoid this for the !overwrite mode?
