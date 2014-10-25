Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJYSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:25:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:59781 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaJYSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:25:44 -0400
X-IronPort-AV: E=Sophos;i="5.04,786,1406592000"; 
   d="scan'208";a="186161816"
Date: Sat, 25 Oct 2014 14:56:15 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 0/6] introduce GNTTABOP_cache_flush
Message-ID: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces support for GNTTABOP_cache_flush to perform
cache maintenance operation on foreign pages and reverts the current
code based on XENFEAT_grant_map_identity.

It also provides a very slow fallback by bouncing on the swiotlb buffer,
in case the hypercall is not available.

v6 introduces is_dma_coherent as a utility function under arch/arm/xen
based on of_dma_is_coherent.



Changes in v6:
- rename xen_is_dma_coherent to is_dma_coherent;
- use of_dma_is_coherent to detect the dma coherency of a device;
- remove arch/arm64/include/asm/xen/page-coherent.h, include
../../arm/include/asm/xen/page-coherent.h instead;
- fix indentation.

Changes in v5:
- introduce xen_is_dma_coherent as a xen specific function;
- call xen_is_dma_coherent instead of is_dma_coherent;
- introduce xen_is_dma_coherent to
arch/arm64/include/asm/xen/page-coherent.h;
- do not remove arch/arm64/include/asm/xen/page-coherent.h, add
the missing dma_ops calls from it;
- fix indentation;
- rename hypercall_flush to hypercall_cflush;
- remove spurious change.

Changes in v4:
- remove outer_*_range call;
- introduce is_dma_coherent;
- use is_dma_coherent in arch/arm/xen/mm32.c;
- merge xen/mm32.c into xen/mm.c;
- xen/arm/arm64: introduce xen_arch_need_swiotlb;
- avoid bouncing dma map operations that involve foreign grants and
non-coherent devices if GNTTABOP_cache_flush is provided by Xen.

Changes in v3:
- fix the cache maintenance op call to match what Linux does natively;
- update the hypercall interface to match Xen.

Changes in v2:
- remove the definition of XENFEAT_grant_map_identity;
- update the hypercall interface to match Xen;
- call the interface on a single page at a time.


Stefano Stabellini (7):
      xen/arm: remove handling of XENFEAT_grant_map_identity
      xen/arm: remove outer_*_range call
      xen/arm: introduce is_dma_coherent
      xen/arm: use is_dma_coherent
      xen/arm/arm64: merge xen/mm32.c into xen/mm.c
      xen/arm/arm64: introduce xen_arch_need_swiotlb
      xen/arm: introduce GNTTABOP_cache_flush

 arch/arm/include/asm/xen/page.h            |    4 +
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/enlighten.c                   |    5 -
 arch/arm/xen/mm.c                          |  164 ++++++++++++++++++++++
 arch/arm/xen/mm32.c                        |  202 ----------------------------
 arch/arm64/include/asm/xen/page-coherent.h |   44 +-----
 arch/x86/include/asm/xen/page.h            |    7 +
 drivers/xen/swiotlb-xen.c                  |    5 +-
 include/xen/interface/features.h           |    3 -
 include/xen/interface/grant_table.h        |   19 +++
 10 files changed, 200 insertions(+), 255 deletions(-)
 delete mode 100644 arch/arm/xen/mm32.c
