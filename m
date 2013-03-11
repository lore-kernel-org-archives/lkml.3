Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3CKJki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:40:38 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48097 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3CKJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:40:37 -0400
Date: Mon, 11 Mar 2013 10:40:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
Message-ID: <20130311094031.GA14221@gmail.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
 <1362645372.2606.11.camel@laptop>
 <20130311082105.GB12742@gmail.com>
 <513DA076.80009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DA076.80009@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Wang <wangyun@linux.vnet.ibm.com> wrote:

> Hi, Ingo
> 
> On 03/11/2013 04:21 PM, Ingo Molnar wrote:
> [snip]
> > 
> > I have actually written the prctl() approach before, for instrumentation 
> > purposes, and it does wonders to system analysis.
> 
> The idea sounds great, we could get many new info to implement more
> smart scheduler, that's amazing :)
> 
> > 
> > Any objections?
> 
> Just one concern, may be I have misunderstand you, but will it cause 
> trouble if the prctl() was indiscriminately used by some applications, 
> will we get fake data?

It's their problem: overusing it will increase their CPU overhead. The two 
boundary worst-cases are that they either call it too frequently or too 
rarely:

 - too frequently: it approximates the current cpu-runtime work metric

 - too infrequently: we just ignore it and fall back to a runtime metric
   if it does not change.

It's not like it can be used to get preferential treatment - we don't ever 
balance other tasks against these tasks based on work throughput, we try 
to maximize this workload's work throughput.

What could happen is if an app is 'optimized' for a buggy scheduler by 
changing the work metric frequency. We offer no guarantee - apps will be 
best off (and users will be least annoyed) if apps honestly report their 
work metric.

Instrumentation/stats/profiling will also double check the correctness of 
this data: if developers/users start relying on the work metric as a 
substitute benchmark number, then app writers will have an additional 
incentive to make them correct.

Thanks,

	Ingo
