Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbaJVLLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:11:40 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:49494 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbaJVLJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:09:39 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kvm@vger.kernel.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH v3 0/4] mm: new function to forbid zeropage mappings for a process
Date: Wed, 22 Oct 2014 13:09:26 +0200
Message-Id: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102211-0025-0000-0000-00000202975A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 has the special notion of storage keys which are some sort of page flags
associated with physical pages and live outside of direct addressable memory.
These storage keys can be queried and changed with a special set of instructions.
The mentioned instructions behave quite nicely under virtualization, if there is: 
- an invalid pte, then the instructions will work on memory in the host page table
- a valid pte, then the instructions will work with the real storage key

Thanks to Martin with his software reference and dirty bit tracking,
the kernel does not issue any storage key instructions as now a 
software based approach will be taken, on the other hand distributions 
in the wild are currently using them.

However, for virtualized guests we still have a problem with guest pages 
mapped to zero pages and the kernel same page merging.  
With each one multiple guest pages will point to the same physical page
and share the same storage key.

Let's fix this by introducing a new function which s390 will define to
forbid new zero page mappings.  If the guest issues a storage key related 
instruction we flag the mm_struct, drop existing zero page mappings
and unmerge the guest memory.

v2 -> v3:
 - Clearing up patch description Patch 3/4
 - removing unnecessary flag in mmu_context (Paolo)

v1 -> v2: 
 - Following Dave and Paolo suggestion removing the vma flag

Dominik Dingel (4):
  s390/mm: recfactor global pgste updates
  mm: introduce mm_forbids_zeropage function
  s390/mm: prevent and break zero page mappings in case of storage keys
  s390/mm: disable KSM for storage key enabled pages

 arch/s390/include/asm/pgalloc.h |   2 -
 arch/s390/include/asm/pgtable.h |   8 +-
 arch/s390/kvm/kvm-s390.c        |   2 +-
 arch/s390/kvm/priv.c            |  17 ++--
 arch/s390/mm/pgtable.c          | 180 ++++++++++++++++++----------------------
 include/linux/mm.h              |   4 +
 mm/huge_memory.c                |   2 +-
 mm/memory.c                     |   2 +-
 8 files changed, 106 insertions(+), 111 deletions(-)

-- 
1.8.5.5

