Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaAHNxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:53:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321AbaAHNtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:49:03 -0500
Date: Wed, 8 Jan 2014 13:48:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: athorlton@sgi.com, riel@redhat.com, chegu_vinod@hp.com,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140108134858.GF27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140108104340.GC27046@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding LKML to the list as this -stable snifftest has identified an
upstream regression.

On Wed, Jan 08, 2014 at 10:43:40AM +0000, Mel Gorman wrote:
> On Tue, Jan 07, 2014 at 08:30:12PM +0000, Mel Gorman wrote:
> > On Tue, Jan 07, 2014 at 10:54:40AM -0800, Greg KH wrote:
> > > On Tue, Jan 07, 2014 at 06:17:15AM -0800, Greg KH wrote:
> > > > On Tue, Jan 07, 2014 at 02:00:35PM +0000, Mel Gorman wrote:
> > > > > A number of NUMA balancing patches were tagged for -stable but I got a
> > > > > number of rejected mails from either Greg or his robot minion.  The list
> > > > > of relevant patches is
> > > > > 
> > > > > FAILED: patch "[PATCH] mm: numa: serialise parallel get_user_page against THP"
> > > > > FAILED: patch "[PATCH] mm: numa: call MMU notifiers on THP migration"
> > > > > MERGED: Patch "mm: clear pmd_numa before invalidating"
> > > > > FAILED: patch "[PATCH] mm: numa: do not clear PMD during PTE update scan"
> > > > > FAILED: patch "[PATCH] mm: numa: do not clear PTE for pte_numa update"
> > > > > MERGED: Patch "mm: numa: ensure anon_vma is locked to prevent parallel THP splits"
> > > > > MERGED: Patch "mm: numa: avoid unnecessary work on the failure path"
> > > > > MERGED: Patch "sched: numa: skip inaccessible VMAs"
> > > > > FAILED: patch "[PATCH] mm: numa: clear numa hinting information on mprotect"
> > > > > FAILED: patch "[PATCH] mm: numa: avoid unnecessary disruption of NUMA hinting during"
> > > > > Patch "mm: fix TLB flush race between migration, and change_protection_range"
> > > > > Patch "mm: numa: guarantee that tlb_flush_pending updates are visible before page table updates"
> > > > > FAILED: patch "[PATCH] mm: numa: defer TLB flush for THP migration as long as"
> > > > > 
> > > > > Fixing the rejects one at a time may cause other conflicts due to ordering
> > > > > issues. Instead, this patch series against 3.12.6 is the full list of
> > > > > backported patches in the expected order. Greg, unfortunately this means
> > > > > you may have to drop some patches already in your stable tree and reapply
> > > > > but on the plus side they should be then in the correct order for bisection
> > > > > purposes and you'll know I've tested this combination of patches.
> > > > 
> > > > Many thanks for these, I'll go queue them up in a bit and drop the
> > > > others to ensure I got all of this correct.
> > > 
> > > Ok, I've now queued all of these up, in this order, so we should be
> > > good.
> > > 
> > > I'll do a -rc2 in a bit as it needs some testing.
> > > 
> > 
> > Thanks a million. I should be cc'd on some of those so I'll pick up the
> > final result and run it through the same tests just to be sure.
> > 
> 
> Ok, tests completed and look more or less as expected. This is not to
> say the performance results are *good* as such.  Workloads that normally
> demonstrate automatic numa balancing suffered because of other patches that
> were merged (primarily fair zone allocation policy) that had interesting
> side-effects. However, it now does not crash under heavy stress and I
> prefer working a little slowly than crashing fast. NAS at least looks
> better.
> 
> Other workloads like kernel builds, page fault microbench looked good as
> expected from the fair zone allocation policy fixes.
> 
> Big downside is that ebizzy performance is *destroyed* in that RC2 patch
> somewhere
> 
> ebizzy
>                          3.12.6                3.12.6            3.12.7-rc2
>                         vanilla         backport-v1r2             stablerc2
> Mean   1      3278.67 (  0.00%)     3180.67 ( -2.99%)     3212.00 ( -2.03%)
> Mean   2      2322.67 (  0.00%)     2294.67 ( -1.21%)     1839.00 (-20.82%)
> Mean   3      2257.00 (  0.00%)     2218.67 ( -1.70%)     1664.00 (-26.27%)
> Mean   4      2268.00 (  0.00%)     2224.67 ( -1.91%)     1629.67 (-28.15%)
> Mean   5      2247.67 (  0.00%)     2255.67 (  0.36%)     1582.33 (-29.60%)
> Mean   6      2263.33 (  0.00%)     2251.33 ( -0.53%)     1547.67 (-31.62%)
> Mean   7      2273.67 (  0.00%)     2222.67 ( -2.24%)     1545.67 (-32.02%)
> Mean   8      2254.67 (  0.00%)     2232.33 ( -0.99%)     1535.33 (-31.90%)
> Mean   12     2237.67 (  0.00%)     2266.33 (  1.28%)     1543.33 (-31.03%)
> Mean   16     2201.33 (  0.00%)     2252.67 (  2.33%)     1540.33 (-30.03%)
> Mean   20     2205.67 (  0.00%)     2229.33 (  1.07%)     1537.33 (-30.30%)
> Mean   24     2162.33 (  0.00%)     2168.67 (  0.29%)     1535.33 (-29.00%)
> Mean   28     2139.33 (  0.00%)     2107.67 ( -1.48%)     1535.00 (-28.25%)
> Mean   32     2084.67 (  0.00%)     2089.00 (  0.21%)     1537.33 (-26.26%)
> Mean   36     2002.00 (  0.00%)     2020.00 (  0.90%)     1530.33 (-23.56%)
> Mean   40     1972.67 (  0.00%)     1978.67 (  0.30%)     1530.33 (-22.42%)
> Mean   44     1951.00 (  0.00%)     1953.67 (  0.14%)     1531.00 (-21.53%)
> Mean   48     1931.67 (  0.00%)     1930.67 ( -0.05%)     1526.67 (-20.97%)
> 
> Figures are records/sec, more is better for increasing numbers of threads
> up to 48 which is the number of logical CPUs in the machine. Three kernels
> tested
> 
> 3.12.6        is self-explanatory
> backport-v1r2 is the backported series I sent you
> stablerc2     is the rc2 patch I pulled from kernel.org
> 
> I'm not that familiar with the stable workflow but stable-queue.git looked
> like it had the correct quilt tree so bisection is in progress. If I had
> to bet money on it, I'd bet it's going to be scheduler or power management
> related mostly because problems in both of those areas have tended to
> screw ebizzy recently.
> 

I was not far off. Bisection identified the following commit

3d97ea0816589c818ac62fb401e61c3b6a59f351 is the first bad commit
commit 3d97ea0816589c818ac62fb401e61c3b6a59f351
Author: Len Brown <len.brown@intel.com>
Date:   Wed Dec 18 16:44:57 2013 -0500

    x86 idle: Repair large-server 50-watt idle-power regression

    commit 40e2d7f9b5dae048789c64672bf3027fbb663ffa upstream.

    Linux 3.10 changed the timing of how thread_info->flags is touched:

        x86: Use generic idle loop
        (7d1a941731fabf27e5fb6edbebb79fe856edb4e5)

    This caused Intel NHM-EX and WSM-EX servers to experience a large number
    of immediate MONITOR/MWAIT break wakeups, which caused cpuidle to demote
    from deep C-states to shallow C-states, which caused these platforms
    to experience a significant increase in idle power.

    Note that this issue was already present before the commit above,
    however, it wasn't seen often enough to be noticed in power measurements.

    Here we extend an errata workaround from the Core2 EX "Dunnington"
    to extend to NHM-EX and WSM-EX, to prevent these immediate
    returns from MWAIT, reducing idle power on these platforms.

    While only acpi_idle ran on Dunnington, intel_idle
    may also run on these two newer systems.
    As of today, there are no other models that are known
    to need this tweak.

    Link: http://lkml.kernel.org/r/CAJvTdK=%2BaNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com
    Signed-off-by: Len Brown <len.brown@intel.com>
    Link: http://lkml.kernel.org/r/baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Len, HPA, the x86 idle regression fix fubars ebizzy as a consequence, I
don't know why. I know the workload is not that important (and I expected
ebizzy to be unaffected in this test) but it is probably indicative of
other performance regressions hiding in there. It was caught via -stable
testing by accident but I checked and upstream is also affected. This is
a snippet from the bisection log

Wed 8 Jan 09:53:59 GMT 2014 compass ebizzy v3.12.6 mean-4:2317 good
Wed 8 Jan 10:13:04 GMT 2014 compass ebizzy v3.12.7-rc2 mean-4:1631 bad
Wed 8 Jan 10:27:45 GMT 2014 compass ebizzy a202b4808e500f4fd53b6cec150c8fe214c70183 mean-4:1620 bad
Wed 8 Jan 10:41:36 GMT 2014 compass ebizzy c915b8fa860e189cb84898a30f135399baa827fa mean-4:2290 good
Wed 8 Jan 10:55:14 GMT 2014 compass ebizzy c915b8fa860e189cb84898a30f135399baa827fa mean-4:2266 good
Wed 8 Jan 11:09:04 GMT 2014 compass ebizzy c62a6f8a28bf8897ba0903cf332d761c1132e48d mean-4:1624 bad
Wed 8 Jan 11:22:46 GMT 2014 compass ebizzy 346679aad15c3608844f6b433b8d8ba56ad03802 mean-4:2280 good
Wed 8 Jan 11:36:32 GMT 2014 compass ebizzy 36b9512dc19b535d72c1035048a95ec1c765d403 mean-4:1641 bad
Wed 8 Jan 11:50:22 GMT 2014 compass ebizzy 1a82fc9ab8bb6b4a5ee5cd32d570d6ff0b77efb2 mean-4:1627 bad
Wed 8 Jan 12:04:15 GMT 2014 compass ebizzy 3d97ea0816589c818ac62fb401e61c3b6a59f351 mean-4:1619 bad
Wed 8 Jan 13:10:03 GMT 2014 compass ebizzy v3.13-rc7 mean-4:1619 bad
Wed 8 Jan 13:39:19 GMT 2014 compass ebizzy v3.12.7-rc2-revert mean-4:2276 good

mean-4 figures are records/sec as recorded by the bisection test. The
bisection points are based on the -stable quilt tree so the commit ids are
meaningless but you can see good/bad figures are relatively stable leading
me to conclude the bisection is valid.

v3.12.6 was 2317 records/second and considered "good". The 3.12.7-rc2
stable candidate and 3.13-rc7 are both "bad". Reverting the single patch
from v3.12.7-rc2 restores performance.

Greg, this does not affect your -stable release as such because upstream is
also affected. If you release with the patch merged then the upstream fix
(whatever that is) will also need to be included in -stable later. If you
release without the patch then both upstream fixes will be later required
and some Intel machines will continue to consume excessive amounts of
power in the meantime.

-- 
Mel Gorman
SUSE Labs
