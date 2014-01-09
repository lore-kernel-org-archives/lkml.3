Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbaAIVkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:40:06 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37203 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbaAIVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:39:57 -0500
Message-ID: <1389303595.19886.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/5] Fix ebizzy performance regression due to X86 TLB
 range flush v3
From: Davidlohr Bueso <davidlohr@hp.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 09 Jan 2014 13:39:55 -0800
In-Reply-To: <1389278098-27154-1-git-send-email-mgorman@suse.de>
References: <1389278098-27154-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 14:34 +0000, Mel Gorman wrote:
> Changelog since v2
> o Rebase to v3.13-rc7 to pick up scheduler-related fixes
> o Describe methodology in changelog
> o Reset tlb flush shift for all models except Ivybridge
> 
> Changelog since v1
> o Drop a pagetable walk that seems redundant
> o Account for TLB flushes only when debugging
> o Drop the patch that took number of CPUs to flush into account
> 
> ebizzy regressed between 3.4 and 3.10 while testing on a new
> machine. Bisection initially found at least three problems of which the
> first was commit 611ae8e3 (x86/tlb: enable tlb flush range support for
> x86). Second was related to TLB flush accounting. The third was related
> to ACPI cpufreq and so it was disabled for the purposes of this series.
> 
> The intent of the TLB range flush series was to preserve existing TLB
> entries by flushing a range one page at a time instead of flushing the
> address space. This makes a certain amount of sense if the address space
> being flushed was known to have existing hot entries.  The decision on
> whether to do a full mm flush or a number of single page flushes depends
> on the size of the relevant TLB and how many of these hot entries would
> be preserved by a targeted flush. This implicitly assumes a lot including
> the following examples
> 
> o That the full TLB is in use by the task being flushed
> o The TLB has hot entries that are going to be used in the near future
> o The TLB has entries for the range being cached
> o The cost of the per-page flushes is similar to a single mm flush
> o Large pages are unimportant and can always be globally flushed
> o Small flushes from workloads are very common
> 
> The first three are completely unknowable but unfortunately it is something
> that is probably true of micro benchmarks designed to exercise these
> paths. The fourth one depends completely on the hardware. The large page
> check used to make sense but now the number of entries required to do
> a range flush is so small that it is a redundant check. The last one is
> the strangest because generally only a process that was mapping/unmapping
> very small regions would hit this. It's possible it is the common case
> for virtualised workloads that is managing the address space of its
> guests. Maybe this was the real original motivation of the TLB range flush
> support for x86.  If this is the case then the patches need to be revisited
> and clearly flagged as being of benefit to virtualisation.
> 
> As things currently stand, Ebizzy sees very little benefit as it discards
> newly allocated memory very quickly and regressed badly on Ivybridge where
> it constantly flushes ranges of 128 pages one page at a time. Earlier
> machines may not have seen this problem as the balance point was at a
> different location. While I'm wary of optimising for such a benchmark,
> it's commonly tested and it's apparent that the worst case defaults for
> Ivybridge need to be re-examined.
> 
> The following small series brings ebizzy closer to 3.4-era performance
> for the very limited set of machines tested. It does not bring
> performance fully back in line but the recent idle power regression
> fix has already been identified as regressing ebizzy performance
> (http://www.spinics.net/lists/stable/msg31352.html) and would need to be
> addressed first. Benchmark results are included in the relevant patch's
> changelog.
> 
>  arch/x86/include/asm/tlbflush.h    |  6 ++---
>  arch/x86/kernel/cpu/amd.c          |  5 +---
>  arch/x86/kernel/cpu/intel.c        | 10 +++-----
>  arch/x86/kernel/cpu/mtrr/generic.c |  4 +--
>  arch/x86/mm/tlb.c                  | 52 ++++++++++----------------------------
>  include/linux/vm_event_item.h      |  4 +--
>  include/linux/vmstat.h             |  8 ++++++
>  7 files changed, 32 insertions(+), 57 deletions(-)

I Tried this set on a couple of workloads, no performance regressions.
So, fwiw:

Tested-by: Davidlohr Bueso <davidlohr@hp.com>

