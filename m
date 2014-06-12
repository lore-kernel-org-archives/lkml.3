Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaFLDUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:20:08 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55539 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaFLDRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:17:52 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 00/10] CMA: generalize CMA reserved area management code
Date: Thu, 12 Jun 2014 12:21:37 +0900
Message-Id: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there are two users on CMA functionality, one is the DMA
subsystem and the other is the kvm on powerpc. They have their own code
to manage CMA reserved area even if they looks really similar.
>From my guess, it is caused by some needs on bitmap management. Kvm side
wants to maintain bitmap not for 1 page, but for more size. Eventually it
use bitmap where one bit represents 64 pages.

When I implement CMA related patches, I should change those two places
to apply my change and it seem to be painful to me. I want to change
this situation and reduce future code management overhead through
this patch.

This change could also help developer who want to use CMA in their
new feature development, since they can use CMA easily without
copying & pasting this reserved area management code.

v2:
  Although this patchset looks very different with v1, the end result,
  that is, mm/cma.c is same with v1's one. So I carry Ack to patch 6-7.

Patch 1-5 prepare some features to cover ppc kvm's requirements.
Patch 6-7 generalize CMA reserved area management code and change users
to use it.
Patch 8-10 clean-up minor things.

Joonsoo Kim (10):
  DMA, CMA: clean-up log message
  DMA, CMA: fix possible memory leak
  DMA, CMA: separate core cma management codes from DMA APIs
  DMA, CMA: support alignment constraint on cma region
  DMA, CMA: support arbitrary bitmap granularity
  CMA: generalize CMA reserved area management functionality
  PPC, KVM, CMA: use general CMA reserved area management framework
  mm, cma: clean-up cma allocation error path
  mm, cma: move output param to the end of param list
  mm, cma: use spinlock instead of mutex

 arch/powerpc/kvm/book3s_hv_builtin.c |   17 +-
 arch/powerpc/kvm/book3s_hv_cma.c     |  240 ------------------------
 arch/powerpc/kvm/book3s_hv_cma.h     |   27 ---
 drivers/base/Kconfig                 |   10 -
 drivers/base/dma-contiguous.c        |  248 ++-----------------------
 include/linux/cma.h                  |   12 ++
 include/linux/dma-contiguous.h       |    3 +-
 mm/Kconfig                           |   11 ++
 mm/Makefile                          |    1 +
 mm/cma.c                             |  333 ++++++++++++++++++++++++++++++++++
 10 files changed, 382 insertions(+), 520 deletions(-)
 delete mode 100644 arch/powerpc/kvm/book3s_hv_cma.c
 delete mode 100644 arch/powerpc/kvm/book3s_hv_cma.h
 create mode 100644 include/linux/cma.h
 create mode 100644 mm/cma.c

-- 
1.7.9.5

