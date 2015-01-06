Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbbAFOvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:51:22 -0500
Received: from 8bytes.org ([81.169.241.247]:37842 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbbAFOvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:51:18 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/3 v2] Fix kdump failures with crashkernel=high
Date: Tue,  6 Jan 2015 15:51:11 +0100
Message-Id: <1420555874-11506-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:

* Updated comments based on feedback from Konrad
* Added Acked-bys
* Rebased to v3.19-rc3

Hi,

here is a patch-set to fix failed kdump kernel boots when
the systems was booted with crashkernel=X,high. On those
systems the kernel allocates only 72MiB of low-memory for
DMA buffers, which showed to be too low on some systems.

The problem is that 64MiB of the low-memory is allocated by
swiotlb, leaving 8MB for the page-allocator. But swiotlb
tries to allocate DMA memory from the page-allocator first,
which fails pretty fast in the boot sequence, causing
warnings. This patch-set removes these warnings.

But even the 64MiB for swiotlb are eaten up on some systems,
so that the default of low-memory allocated for the
crash-kernel is increase from 72MB to 256MB (only changing
the defaults, can still be overwritten by crashkernel=X,low).

This number comes from experiments on the affected systems,
128MiB low-memory was still not enough there, thus I set the
value to 256MiB to fix the issues.

Any feedback appreciated.

Thanks,

	Joerg

Joerg Roedel (3):
  swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
  x86, swiotlb: Try coherent allocations with __GFP_NOWARN
  x86, crash: Allocate enough low-mem when crashkernel=high

 arch/x86/kernel/pci-swiotlb.c |  8 ++++++++
 arch/x86/kernel/setup.c       |  5 ++++-
 lib/swiotlb.c                 | 11 +++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
1.9.1

Joerg Roedel (3):
  swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
  x86, swiotlb: Try coherent allocations with __GFP_NOWARN
  x86, crash: Allocate enough low-mem when crashkernel=high

 arch/x86/kernel/pci-swiotlb.c |  8 ++++++++
 arch/x86/kernel/setup.c       |  5 ++++-
 lib/swiotlb.c                 | 11 +++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
1.9.1

