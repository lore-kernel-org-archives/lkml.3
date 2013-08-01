Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3HAJJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:09:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:9053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3HAJJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,793,1367996400"; 
   d="scan'208";a="374446319"
Message-ID: <51FA256C.80001@intel.com>
Date: Thu, 01 Aug 2013 17:07:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ilari Stenroth <ilari.stenroth@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
References: <kt91u2$jhs$1@ger.gmane.org> <20130730193530.GB23299@pd.tnic> <kt951r$m5m$1@ger.gmane.org> <20130730195402.GD23299@pd.tnic> <51FA220B.5070307@intel.com>
In-Reply-To: <51FA220B.5070307@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 04:53 PM, Alex Shi wrote:
> ------
> From 1322ea9e17ad4d9e49e2d93cfc04805368e28273 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Thu, 1 Aug 2013 16:30:23 +0800
> Subject: [PATCH 2/2] tlb/tlb_flushall_shift: add haswell tlb_flush_shift
> 
> Tested on i5 4350U with munmap case, https://lkml.org/lkml/2012/5/17/59
> The best performance is tlb_flush_shift = 1.
> The balance point is 256 entries.

Before above patch, I also added the IVB EP cpu tlb_flushall_shift. testing 
show the best performance at 2. The box has 12 core * HT * 2S.

test command
  #for t in `echo 12 24 48 96`; do
       echo "=============== t = $t ";
       for i in `echo 8 16 32 64 128 256 512 `; do
             sudo  ./munmap -t $t -n $i;
       done
  done

detailed result as following:
tlb_flushall_shift = 2;
=============== t = 12
munmap use 516ms 15768ns/time, memory access uses 120232 times/thread/ms, cost 8ns/time
munmap use 297ms 18157ns/time, memory access uses 114378 times/thread/ms, cost 8ns/time
munmap use 175ms 21371ns/time, memory access uses 96932 times/thread/ms, cost 10ns/time
munmap use 115ms 28270ns/time, memory access uses 100961 times/thread/ms, cost 9ns/time
munmap use 90ms 44421ns/time, memory access uses 91293 times/thread/ms, cost 10ns/time
munmap use 28ms 27384ns/time, memory access uses 100032 times/thread/ms, cost 9ns/time
munmap use 20ms 40723ns/time, memory access uses 114393 times/thread/ms, cost 8ns/time
=============== t = 24
munmap use 700ms 21380ns/time, memory access uses 119336 times/thread/ms, cost 8ns/time
munmap use 398ms 24338ns/time, memory access uses 78586 times/thread/ms, cost 12ns/time
munmap use 215ms 26264ns/time, memory access uses 83551 times/thread/ms, cost 11ns/time
munmap use 148ms 36289ns/time, memory access uses 61251 times/thread/ms, cost 16ns/time
munmap use 117ms 57573ns/time, memory access uses 83114 times/thread/ms, cost 12ns/time
munmap use 34ms 33767ns/time, memory access uses 82493 times/thread/ms, cost 12ns/time
munmap use 25ms 50686ns/time, memory access uses 68961 times/thread/ms, cost 14ns/time
=============== t = 48
munmap use 1250ms 38153ns/time, memory access uses 35963 times/thread/ms, cost 27ns/time
munmap use 582ms 35563ns/time, memory access uses 34776 times/thread/ms, cost 28ns/time
munmap use 348ms 42544ns/time, memory access uses 33767 times/thread/ms, cost 29ns/time
munmap use 200ms 49034ns/time, memory access uses 31150 times/thread/ms, cost 32ns/time
munmap use 140ms 68527ns/time, memory access uses 28236 times/thread/ms, cost 35ns/time
munmap use 44ms 43445ns/time, memory access uses 33564 times/thread/ms, cost 29ns/time
munmap use 27ms 54053ns/time, memory access uses 34163 times/thread/ms, cost 29ns/time
=============== t = 96
munmap use 5189ms 158378ns/time, memory access uses 17812 times/thread/ms, cost 56ns/time
munmap use 1236ms 75476ns/time, memory access uses 17563 times/thread/ms, cost 56ns/time
munmap use 628ms 76755ns/time, memory access uses 16746 times/thread/ms, cost 59ns/time
munmap use 319ms 77978ns/time, memory access uses 15956 times/thread/ms, cost 62ns/time
munmap use 258ms 126385ns/time, memory access uses 15307 times/thread/ms, cost 65ns/time
munmap use 130ms 127057ns/time, memory access uses 16644 times/thread/ms, cost 60ns/time
munmap use 31ms 61663ns/time, memory access uses 14797 times/thread/ms, cost 67ns/time

tlb_flushall_shift = -1; //keep tlb flush all for any scenarios.
=============== t = 12
munmap use 485ms 14815ns/time, memory access uses 96048 times/thread/ms, cost 10ns/time
munmap use 232ms 14167ns/time, memory access uses 83143 times/thread/ms, cost 12ns/time
munmap use 133ms 16252ns/time, memory access uses 96413 times/thread/ms, cost 10ns/time
munmap use 67ms 16489ns/time, memory access uses 86718 times/thread/ms, cost 11ns/time
munmap use 46ms 22943ns/time, memory access uses 105914 times/thread/ms, cost 9ns/time
munmap use 29ms 28740ns/time, memory access uses 92108 times/thread/ms, cost 10ns/time
munmap use 20ms 40128ns/time, memory access uses 110841 times/thread/ms, cost 9ns/time
=============== t = 24
munmap use 590ms 18022ns/time, memory access uses 81828 times/thread/ms, cost 12ns/time
munmap use 336ms 20526ns/time, memory access uses 80119 times/thread/ms, cost 12ns/time
munmap use 189ms 23125ns/time, memory access uses 48884 times/thread/ms, cost 20ns/time
munmap use 104ms 25607ns/time, memory access uses 83410 times/thread/ms, cost 11ns/time
munmap use 54ms 26795ns/time, memory access uses 49105 times/thread/ms, cost 20ns/time
munmap use 29ms 29079ns/time, memory access uses 94668 times/thread/ms, cost 10ns/time
munmap use 25ms 49228ns/time, memory access uses 80346 times/thread/ms, cost 12ns/time
=============== t = 48
munmap use 1000ms 30541ns/time, memory access uses 35379 times/thread/ms, cost 28ns/time
munmap use 540ms 33010ns/time, memory access uses 32934 times/thread/ms, cost 30ns/time
munmap use 326ms 39891ns/time, memory access uses 32601 times/thread/ms, cost 30ns/time
munmap use 143ms 35140ns/time, memory access uses 32842 times/thread/ms, cost 30ns/time
munmap use 91ms 44713ns/time, memory access uses 32021 times/thread/ms, cost 31ns/time
munmap use 44ms 43337ns/time, memory access uses 32962 times/thread/ms, cost 30ns/time
munmap use 29ms 56936ns/time, memory access uses 31399 times/thread/ms, cost 31ns/time
=============== t = 96
munmap use 4551ms 138892ns/time, memory access uses 17208 times/thread/ms, cost 58ns/time
munmap use 776ms 47383ns/time, memory access uses 16560 times/thread/ms, cost 60ns/time
munmap use 513ms 62707ns/time, memory access uses 16478 times/thread/ms, cost 60ns/time
munmap use 184ms 45111ns/time, memory access uses 16368 times/thread/ms, cost 61ns/time
munmap use 205ms 100519ns/time, memory access uses 16631 times/thread/ms, cost 60ns/time
munmap use 47ms 46059ns/time, memory access uses 15144 times/thread/ms, cost 66ns/time
munmap use 34ms 66474ns/time, memory access uses 13951 times/thread/ms, cost 71ns/time


-----------
>From 6fb21a9ce475cfc6c7c39bdfd3d9422be24cdb74 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Wed, 31 Jul 2013 16:28:42 +0800
Subject: [PATCH 1/2] x86/tlb_flushall_shift: add Ivybridge EP CPU support

Tested with munmap.c on Ivybridge EP 2S machine, the best shift value is
2, that means when the tlb flush entries less than 64, single invlpg has
performance benefit on this machine.
The testcase come from: https://lkml.org/lkml/2012/5/17/59
Results show it has about 5% to 30% performance increase.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ec72995..9a4bc51 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -629,6 +629,9 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 	case 0x63a: /* Ivybridge */
 		tlb_flushall_shift = 1;
 		break;
+	case 0x63e: /* Ivybridge EP */
+		tlb_flushall_shift = 2;
+		break;
 	default:
 		tlb_flushall_shift = 6;
 	}
-- 
1.7.12

