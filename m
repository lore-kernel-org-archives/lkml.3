Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3J2O1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:27:21 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40356 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3J2O1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:27:20 -0400
Date: Tue, 29 Oct 2013 15:27:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131029142716.GA28113@gmail.com>
References: <20131028174630.GB31048@hmsreliant.think-freely.org>
 <20131028182913.GD31048@hmsreliant.think-freely.org>
 <20131029082542.GA24625@gmail.com>
 <20131029112022.GA24477@neilslaptop.think-freely.org>
 <20131029113031.GA16897@gmail.com>
 <20131029114907.GE24477@neilslaptop.think-freely.org>
 <20131029125233.GA17449@gmail.com>
 <20131029130712.GA25078@neilslaptop.think-freely.org>
 <20131029131149.GB20408@gmail.com>
 <20131029141706.GC25078@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029141706.GC25078@neilslaptop.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> So, I apologize, you were right.  I was running the test.sh script 
> but perf was measuring itself. [...]

Ok, cool - one mystery less!

> Which overall looks alot more like I expect, save for the parallel 
> ALU cases. It seems here that the parallel ALU changes actually 
> hurt performance, which really seems counter-intuitive.  I don't 
> yet have any explination for that.  I do note that we seem to have 
> more stalls in the both case so perhaps the parallel chains call 
> for a more agressive prefetch.  Do you have any thoughts?

Note that with -ddd you 'overload' the PMU with more counters than 
can be run at once, which introduces extra noise. Since you are 
running the tests for 0.150 secs or so, the results are not very 
representative:

               734 dTLB-load-misses          #    0.00% of all dTLB cache hits   ( +-  8.40% ) [13.94%]
        13,314,660 iTLB-loads                #  280.759 M/sec                    ( +-  0.05% ) [12.97%]

with such low runtimes those results are very hard to trust.

So -ddd is typically used to pick up the most interesting PMU events 
you want to see measured, and then use them like this:

   -e dTLB-load-misses -e iTLB-loads

etc. For such short runtimes make sure the last column displays 
close to 100%, so that the PMU results become trustable.

A nehalem+ PMU will allow 2-4 events to be measured in parallel, 
plus generics like 'cycles', 'instructions' can be added 'for free' 
because they get counted in a separate (fixed purpose) PMU register.

The last colum tells you what percentage of the runtime that 
particular event was actually active. 100% (or empty last column) 
means it was active all the time.

Thanks,

	Ingo
