Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbaJ2QgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994AbaJ2QgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:36:20 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: [PATCH 0/5] get_user_pages_locked|unlocked v1
Date: Wed, 29 Oct 2014 17:35:15 +0100
Message-Id: <1414600520-7664-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset standalone is an optimization leveraging the page fault
FAULT_FLAG_ALLOW_RETRY flag which allows the page fault paths to drop
the mmap_sem before I/O.

For the userfaultfd patchset this patch is instead a dependency as we
need that flag always set the first time any thread attempts a page
fault, in order to release the mmap_sem before stopping the page fault
(while waiting for a later userland wakeup).

http://thread.gmane.org/gmane.linux.kernel.mm/123575

Andrea Arcangeli (5):
  mm: gup: add get_user_pages_locked and get_user_pages_unlocked
  mm: gup: add __get_user_pages_unlocked to customize gup_flags
  mm: gup: use get_user_pages_unlocked within get_user_pages_fast
  mm: gup: use get_user_pages_unlocked
  mm: gup: kvm use get_user_pages_unlocked

 arch/mips/mm/gup.c                 |   8 +-
 arch/powerpc/mm/gup.c              |   6 +-
 arch/s390/mm/gup.c                 |   6 +-
 arch/sh/mm/gup.c                   |   6 +-
 arch/sparc/mm/gup.c                |   6 +-
 arch/x86/mm/gup.c                  |   7 +-
 drivers/iommu/amd_iommu_v2.c       |   6 +-
 drivers/media/pci/ivtv/ivtv-udma.c |   6 +-
 drivers/scsi/st.c                  |   7 +-
 drivers/video/fbdev/pvr2fb.c       |   6 +-
 include/linux/kvm_host.h           |  11 --
 include/linux/mm.h                 |  11 ++
 mm/gup.c                           | 203 ++++++++++++++++++++++++++++++++++---
 mm/nommu.c                         |  33 ++++++
 mm/process_vm_access.c             |   7 +-
 mm/util.c                          |  10 +-
 net/ceph/pagevec.c                 |   6 +-
 virt/kvm/async_pf.c                |   2 +-
 virt/kvm/kvm_main.c                |  50 +--------
 19 files changed, 265 insertions(+), 132 deletions(-)
