Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaJAJBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaJAI5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:57:21 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: [PATCH 0/4] leverage FAULT_FOLL_ALLOW_RETRY in get_user_pages
Date: Wed,  1 Oct 2014 10:56:33 +0200
Message-Id: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAULT_FOLL_ALLOW_RETRY allows the page fault to drop the mmap_sem for
reading to reduce the mmap_sem contention (for writing), like while
waiting for I/O completion. The problem is that right now practically
no get_user_pages call uses FAULT_FOLL_ALLOW_RETRY, so we're not
leveraging that nifty feature.

Andres fixed it for the KVM page fault. However get_user_pages_fast
remains uncovered, and 99% of other get_user_pages aren't using it
either (the only exception being FOLL_NOWAIT in KVM which is really
nonblocking and in fact it doesn't even release the mmap_sem).

So this patchsets extends the optimization Andres did in the KVM page
fault to the whole kernel. It makes most important places (including
gup_fast) to use FAULT_FOLL_ALLOW_RETRY to reduce the mmap_sem hold
times during I/O.

The only few places that remains uncovered are drivers like v4l and
other exceptions that tends to work on their own memory and they're
not working on random user memory (for example like O_DIRECT that uses
gup_fast and is fully covered by this patch).

A follow up patch should probably also add a printk_once warning to
get_user_pages that should go obsolete and be phased out
eventually. The "vmas" parameter of get_user_pages makes it
fundamentally incompatible with FAULT_FOLL_ALLOW_RETRY (vmas array
becomes meaningless the moment the mmap_sem is released). 

While this is just an optimization, this becomes an absolute
requirement for the userfaultfd. The userfaultfd allows to block the
page fault, and in order to do so I need to drop the mmap_sem
first. So this patch also ensures that all memory where
userfaultfd could be registered by KVM, the very first fault (no
matter if it is a regular page fault, or a get_user_pages) always
has FAULT_FOLL_ALLOW_RETRY set. Then the userfaultfd blocks and it is
waken only when the pagetable is already mapped. The second fault
attempt after the wakeup doesn't need FAULT_FOLL_ALLOW_RETRY, so it's
ok to retry without it.

So I need this merged before I can attempt to merge the userfaultfd.

This has been running fully stable on a heavy KVM postcopy live
migration workload that also includes the new userfaultfd API allows
an unlimited number of userfaultfds per process and each one can at
any time register and unregister memory ranges, so each thread or each
shared lib can do userfaults in its own private memory independently
of each other and independently of the main process. This is also the
same load that exposed the nfs silent memory corruption and it uses
O_DIRECT also on nfs so get_user_pages_fast and all sort of
get_user_pages are exercised both by NFS and KVM at the same time on
the userfaultfd backed memory.

Reviews would be welcome, thanks,
Andrea

Andrea Arcangeli (3):
  mm: gup: add get_user_pages_locked and get_user_pages_unlocked
  mm: gup: use get_user_pages_fast and get_user_pages_unlocked
  mm: gup: use get_user_pages_unlocked within get_user_pages_fast

Andres Lagar-Cavilla (1):
  mm: gup: add FOLL_TRIED

 arch/mips/mm/gup.c                 |   8 +-
 arch/powerpc/mm/gup.c              |   6 +-
 arch/s390/kvm/kvm-s390.c           |   4 +-
 arch/s390/mm/gup.c                 |   6 +-
 arch/sh/mm/gup.c                   |   6 +-
 arch/sparc/mm/gup.c                |   6 +-
 arch/x86/mm/gup.c                  |   7 +-
 drivers/dma/iovlock.c              |  10 +-
 drivers/iommu/amd_iommu_v2.c       |   6 +-
 drivers/media/pci/ivtv/ivtv-udma.c |   6 +-
 drivers/misc/sgi-gru/grufault.c    |   3 +-
 drivers/scsi/st.c                  |  10 +-
 drivers/video/fbdev/pvr2fb.c       |   5 +-
 include/linux/mm.h                 |   8 ++
 mm/gup.c                           | 182 ++++++++++++++++++++++++++++++++++---
 mm/mempolicy.c                     |   2 +-
 mm/nommu.c                         |  23 +++++
 mm/process_vm_access.c             |   7 +-
 mm/util.c                          |  10 +-
 net/ceph/pagevec.c                 |   9 +-
 20 files changed, 236 insertions(+), 88 deletions(-)

