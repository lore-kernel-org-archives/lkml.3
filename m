Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJJLwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:52:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45165 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaJJLwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:52:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,691,1406592000"; 
   d="scan'208";a="180113941"
Date: Fri, 10 Oct 2014 12:50:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 0/7] introduce GNTTABOP_cache_flush
Message-ID: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces support for GNTTABOP_cache_flush to perform
cache maintenance operation on foreign pages and reverts the current
code based on XENFEAT_grant_map_identity.

It also provides a very slow fallback by bouncing on the swiotlb buffer,
in case the hypercall is not available.


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
      [RFC] arm/arm64: introduce is_dma_coherent
      xen/arm: use is_dma_coherent
      xen/arm/arm64: merge xen/mm32.c into xen/mm.c
      xen/arm/arm64: introduce xen_arch_need_swiotlb
      xen/arm: introduce GNTTABOP_cache_flush

 arch/arm/include/asm/dma-mapping.h         |    6 +
 arch/arm/include/asm/xen/page.h            |    4 +
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/enlighten.c                   |    5 -
 arch/arm/xen/mm.c                          |  161 +++++++++++++++++++++-
 arch/arm/xen/mm32.c                        |  202 ----------------------------
 arch/arm64/include/asm/dma-mapping.h       |    5 +
 arch/arm64/include/asm/xen/page-coherent.h |   44 +-----
 arch/x86/include/asm/xen/page.h            |    7 +
 drivers/xen/swiotlb-xen.c                  |    5 +-
 include/xen/interface/features.h           |    3 -
 include/xen/interface/grant_table.h        |   19 +++
 12 files changed, 207 insertions(+), 256 deletions(-)
 delete mode 100644 arch/arm/xen/mm32.c
