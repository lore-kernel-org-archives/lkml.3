Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaGNHdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:33:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50335 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaGNHd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:33:29 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6f-53c387c5bc9b
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] CMA & device tree, once again
Date: Mon, 14 Jul 2014 09:12:42 +0200
Message-id: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7rH2g8HG1w2sZizfg2bxePX81gs
	/k46xm7xoamV2eL9sh5Gi/lHzrFaHPizg9FiZXczm8XOde8YLc42vWG32N45g93iy5WHTBab
	Hl9jtbi8aw6bxdojd9ktNrw8yGSx4HgLq8Wf6XIWa44sZrf4u30Ti8X6Ga9ZLBbOv89u8fLj
	CRYHcY8189Ywevz+NYnR43JfL5PHzll32T163rSwenS9vcLkcefaHjaPEzN+s3g8OLSZxWPz
	knqP2/8eM3us+/OKyaP/r4HH3F19jB59W1YxenzeJBcgEMVlk5Kak1mWWqRvl8CV8X/aNfaC
	nbIVTc2P2RsYmyS6GDk5JARMJI63vWGHsMUkLtxbz9bFyMUhJLCUUaLz0gUop49J4u2aGUwg
	VWwChhJdb7vYQGwRATeJf+sOgRUxCyxgkzj6/wcjSEJYwFTiybwWsLEsAqoSP7Y+BGrm4OAV
	8JDoeGoOsU1O4v/LFUwTGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJli87GBcf
	szrEKMDBqMTDWyF2OFiINbGsuDL3EKMEB7OSCG+4G1CINyWxsiq1KD++qDQntfgQIxMHp1QD
	Y5/E1U2ifusb/8Vkbu1xY74iXjeZ/2gBx2tmwweJPyT562Yfk96xbZkem7v+1DlV85wsVu+5
	PK3Afd16061Tq9g/NPAtSvgnfG7emv23pulNFXR2rZOf/eqa9hzO7pKfcWLvTPRN3Tb/DVa+
	wT4302TH6ZfzZZ+nue81WMR2gWU/P58eR1DifiWW4oxEQy3mouJEAEv/8LF0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is one more respin of the patches which add support for creating
reserved memory regions defined in device tree. The last attempt
(http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html)
ended in merging only half of the code, so right now we have complete
documentation merged and only basic code, which implements a half of it
is written in the documentation. Although the merged patches allow to
reserve memory, there is no way of using it for devices and drivers.

This situation makes CMA rather useless, as the main architecture (ARM),
which used it, has been converted from board-file based system
initialization to device tree. Thus there is no place to use direct
calls to dma_declare_contiguous() and some new solution, which bases on
device tree, is urgently needed.

This patch series fixes this issue. It provides two, already widely
discussed and already present in the kernel, drivers for reserved
memory: first based on DMA-coherent allocator, second using Contiguous
Memory Allocator. The first one nicely implements typical 'carved out'
reserved memory way of allocating contiguous buffers in a kernel-style
way. The memory is used exclusively by devices assigned to the given
memory region. The second one allows to reuse reserved memory for
movable kernel pages (like disk buffers, anonymous memory) and migrates
it out when device to allocates contiguous memory buffer. Both driver
provides memory buffers via standard dma-mapping API.

The patches have been rebased on top of latest CMA and mm changes merged
to akmp kernel tree.

To define a 64MiB CMA region following node is needed:

multimedia_reserved: multimedia_mem_region {
	compatible = "shared-dma-pool";
	reusable;
	size = <0x4000000>;
	alignment = <0x400000>;
};

Similarly, one can define 64MiB region with DMA coherent memory:

multimedia_reserved: multimedia_mem_region {
	compatible = "shared-dma-pool";
	no-map;
	size = <0x4000000>;
	alignment = <0x400000>;
};

Then the defined region can be assigned to devices:

scaler: scaler@12500000 {
	memory-region = <&multimedia_reserved>;
	/* ... */
};
codec: codec@12600000 {
	memory-region = <&multimedia_reserved>;
	/* ... */
};

Best regards
Marek Szyprowski
Samsung R&D Institute Poland

Changes since v1:
(http://www.spinics.net/lists/arm-kernel/msg343702.html)
- fixed possible memory leak in case of reserved memory allocation failure
  (thanks to Joonsoo Kim)

Changes since the version posted in '[PATCH v6 00/11] reserved-memory 
regions/CMA in devicetree, again' thread 
http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html:
- rebased on top of '[PATCH v3 -next 0/9] CMA: generalize CMA reserved
area management code' patch series on v3.16-rc3
- improved dma-coherent driver, now it correctly handles assigning more
than one device to the given memory region


Patch summary:

Marek Szyprowski (4):
  drivers: of: add automated assignment of reserved regions to client
    devices
  drivers: of: initialize and assign reserved memory to newly created
    devices
  drivers: dma-coherent: add initialization from device tree
  drivers: dma-contiguous: add initialization from device tree

 drivers/base/dma-coherent.c     | 40 +++++++++++++++++++++++
 drivers/base/dma-contiguous.c   | 60 +++++++++++++++++++++++++++++++++++
 drivers/of/of_reserved_mem.c    | 70 +++++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c           |  7 +++++
 include/linux/cma.h             |  3 ++
 include/linux/of_reserved_mem.h |  7 +++++
 mm/cma.c                        | 62 +++++++++++++++++++++++++++++-------
 7 files changed, 238 insertions(+), 11 deletions(-)

-- 
1.9.2

