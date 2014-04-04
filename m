Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaDDHLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:11:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41086 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaDDHLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:11:04 -0400
Date: Fri, 4 Apr 2014 09:10:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 2/2] mm: add FAULT_AROUND_ORDER Kconfig paramater for
 powerpc
Message-ID: <20140404071059.GA1397@gmail.com>
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
 <1396592835-24767-3-git-send-email-maddy@linux.vnet.ibm.com>
 <20140404070241.GA984@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404070241.GA984@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Madhavan Srinivasan <maddy@linux.vnet.ibm.com> wrote:
> 
> > Performance data for different FAULT_AROUND_ORDER values from 4 
> > socket Power7 system (128 Threads and 128GB memory) is below. perf 
> > stat with repeat of 5 is used to get the stddev values. This patch 
> > create FAULT_AROUND_ORDER Kconfig parameter and defaults it to 3 
> > based on the performance data.
> > 
> > FAULT_AROUND_ORDER      Baseline        1               3               4               5               7
> > 
> > Linux build (make -j64)
> > minor-faults            7184385         5874015         4567289         4318518         4193815         4159193
> > times in seconds        61.433776136    60.865935292    59.245368038    60.630675011    60.56587624     59.828271924
> >  stddev for time	( +-  1.18% )	( +-  1.78% )	( +-  0.44% )	( +-  2.03% )	( +-  1.66% )	( +-  1.45% )
> 
> Ok, this is better, but it is still rather incomplete statistically, 
> please also calculate the percentage difference to baseline, so that 
> the stddev becomes meaningful and can be compared to something!
> 
> As an example I did this for the first line of measurements (all 
> errors in the numbers are mine, this was done manually), and it 
> gives:
> 
> >  stddev for time   ( +-  1.18% ) ( +-  1.78% ) ( +-  0.44% ) ( +-  2.03% ) ( +-  1.66% ) ( +-  1.45% )
>                                         +0.9%         +3.5%         +1.3%         +1.4%         +2.6%
> 
> This shows that there is probably a statistically significant 
> (positiv) effect from the change, but from these numbers alone I 
> would not draw any quantitative (sizing, tuning) conclusions, 
> because in 3 out of 5 cases the stddev was larger than the effect, 
> so the resulting percentages are not comparable.

Also note that because we calculate the percentage by dividing result 
with baseline, the stddev of the two values roughly adds up. So for 
example the second column the true noise is around 1.5%, not 0.4%

So for good sizing decisions the stddev must be 'comfortably' below 
the effect. (or sizing should be done based on the other workloads yu 
tested, I have not checked them.)

It also makes sense to run more measurements to reduce the stddev of 
the baseline. So if each measurement is run 3 times then it makes 
sense to run the baseline 6 times, this gives a ~30% improvement in 
the confidence of our result, at just a small increase in test time.

[ For such cases it might also make sense to script all of that, 
  combined with a debug patch that puts the tuned fault-around value 
  into a dynamic knob in /proc/sys/, so that you can run the full 
  measurement in a single pass, with no reboot and with no human 
  intervention. ]

Thanks,

	Ingo
