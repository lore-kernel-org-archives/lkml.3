Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3LSOez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:34:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3LSOey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:34:54 -0500
Date: Thu, 19 Dec 2013 14:34:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131219143449.GN11295@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
 <20131218072814.GA798@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131218072814.GA798@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:28:14PM +0800, Fengguang Wu wrote:
> Hi Mel,
> 
> I'd like to share some test numbers with your patches applied on top of v3.13-rc3.
> 
> Basically there are
> 
> 1) no big performance changes
> 
>   76628486           -0.7%   76107841       TOTAL vm-scalability.throughput
>     407038           +1.2%     412032       TOTAL hackbench.throughput
>      50307           -1.5%      49549       TOTAL ebizzy.throughput
> 

I'm assuming this was an ivybridge processor. How many threads were ebizzy
tested with? The memory ranges used by the vm scalability benchmarks are
probably too large to be affected by the series but I'm guessing. I doubt
hackbench is doing any flushes and the 1.2% is noise.

> 2) huge proc-vmstat.nr_tlb_* increases
> 
>   99986527         +3e+14%  2.988e+20       TOTAL proc-vmstat.nr_tlb_local_flush_one
>  3.812e+08       +2.2e+13%  8.393e+19       TOTAL proc-vmstat.nr_tlb_remote_flush_received
>  3.301e+08       +2.2e+13%  7.241e+19       TOTAL proc-vmstat.nr_tlb_remote_flush
>    5990864       +1.2e+15%  7.032e+19       TOTAL proc-vmstat.nr_tlb_local_flush_all
> 

The accounting changes can be mostly explained by "x86: mm: Clean up
inconsistencies when flushing TLB ranges". flush_all was simply not
being counted before so I would claim that the old figure was simply
wrong and did not reflect reality.

Alterations on when range versus global flushes would affect the other
counters but arguably it's now behaving as originally intended by the tlb
flush shift.

> Here are the detailed numbers. eabb1f89905a0c809d13 is the HEAD commit
> with 4 patches applied. The "~ N%" notations are the stddev percent.
> The "[+-] N%" notations are the increase/decrease percent. The
> brickland2, lkp-snb01, lkp-ib03 etc. are testbox names.
> 

Are positive numbers always better? If so, most of these figures look good
to me and support the series being merged. Please speak up if that is in
error.

I do see a few major regressions like this

>     324497 ~ 0%    -100.0%          0 ~ 0%  brickland2/micro/vm-scalability/16G-truncate

but I have no idea what the test is doing and whether something happened
that the test broke that time or if it's something to be really
concerned about.

Thanks

-- 
Mel Gorman
SUSE Labs
