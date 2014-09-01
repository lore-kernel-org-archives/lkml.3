Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaIAMzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:55:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaIAMzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:55:09 -0400
Date: Mon, 1 Sep 2014 14:55:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Ben Segall <bsegall@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140901125505.GK27892@worktop.ger.corp.intel.com>
References: <1409094682.29189.23.camel@j-VirtualBox>
 <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
 <1409160893.31379.24.camel@j-VirtualBox>
 <1409182369.27939.9.camel@schen9-desk2.jf.intel.com>
 <1409255196.4945.7.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409255196.4945.7.camel@j-VirtualBox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:46:36PM -0700, Jason Low wrote:
> On Wed, 2014-08-27 at 16:32 -0700, Tim Chen wrote:

> > If there are multiple non-forced updates, option 1's error seems to
> > accumulate and non-bounded as we do not actually update?  
> > Is this a concern?
> 
> It should be fine. Once the delta is large enough, we will end up doing
> the update anyway.

Well, the thing is you can have nr_cpus * 12.5% of outstanding delta;
that might be a lot, esp on the large machines.

Now there's two problems with all this; the first is the relative
threshold, typically such per-cpu things have a fixed update threshold,
this makes it much easier to qualify the actual error.

Secondly the indeed the nr_cpus in the error bound. Some things; like
the proportion code scale the threshold by log2(nr_cpus) in an attempt
to do something sensible there.

But yes, unbounded errors here are a problem, sure relaxing the updates
makes things go fast, they also make things go skew.
