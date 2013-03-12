Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab3CLSsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:48:53 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55443 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3CLSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:48:49 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 0/1] mm/hugetlb: add more arch-defined huge_pte_xxx functions
Date: Tue, 12 Mar 2013 19:48:25 +0100
Message-Id: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.12.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031218-4966-0000-0000-00000521AF9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using pte_t and pte_xxx functions in mm/hugetlbfs.c for "huge ptes" has
always been confusing and error-prone on architectures that have a
different layout for the pte/pmd/... level entries. That was the reason
for the individual arch header files in <arch>/include/asm/hugetlb.h
containing implementations for various huge_pte_xxx versions of the
original pte_xxx functions, if needed.

Commit abf09bed3c "s390/mm: implement software dirty bits" introduced
another difference in the pte layout vs. the pmd layout on s390,
thoroughly breaking the s390 support for hugetlbfs. This requires
replacing some more pte_xxx functions in mm/hugetlbfs.c with a
huge_pte_xxx version.

This patch introduces those huge_pte_xxx functions and their
implementation on all architectures supporting hugetlbfs. This change
will be a no-op for all architectures other than s390.

I am also thinking about a more complete clean-up patch, replacing all
remaining pte_xxx invocations in mm/hugetlbfs.c and maybe also
introducing a separate type like hpte_t to make this issue more
transparent and prevent future problems. But that may also require some
functional changes, and it probably won't be ready in time for Kernel
3.9. So for now, this patch only fixes the impact of the software dirty
bit changes on s390, hoping that it can be included in Kernel 3.9,
since that will be the first release including the sw dirty bits.

Gerald Schaefer (1):
  mm/hugetlb: add more arch-defined huge_pte_xxx functions

 arch/ia64/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
 arch/mips/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
 arch/powerpc/include/asm/hugetlb.h | 36 ++++++++++++++++++++++++
 arch/s390/include/asm/hugetlb.h    | 56 +++++++++++++++++++++++++++++++++++++-
 arch/s390/include/asm/pgtable.h    | 20 --------------
 arch/s390/mm/hugetlbpage.c         |  2 +-
 arch/sh/include/asm/hugetlb.h      | 36 ++++++++++++++++++++++++
 arch/sparc/include/asm/hugetlb.h   | 36 ++++++++++++++++++++++++
 arch/tile/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
 arch/x86/include/asm/hugetlb.h     | 36 ++++++++++++++++++++++++
 mm/hugetlb.c                       | 23 ++++++++--------
 11 files changed, 320 insertions(+), 33 deletions(-)

-- 
1.7.12.4

