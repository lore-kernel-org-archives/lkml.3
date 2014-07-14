Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaGNI2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:28:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21222 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaGNI2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:28:17 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-41-53c3949dc72e
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: [PATCH v2 RESEND 0/4] CMA & device tree, once again
Date: Mon, 14 Jul 2014 10:28:03 +0200
Message-id: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xq7pzpxwONvg708pizvo1bBaPX89j
	sfg76Ri7xftlPYwW84+cY7U48GcHo8XK7mY2i53r3jFanG16w26xvXMGu8WXKw+ZLDY9vsZq
	cXnXHDaLtUfusltseHmQyWLB8RZWiz/T5SzWHFnMbvF3+yYWi/UzXrNYLJx/n93i5ccTLA5i
	HmvmrWH0+P1rEqPH5b5eJo+ds+6ye3S9vcLkcefaHjaPEzN+s3g8OLSZxWPzknqP2/8eM3us
	+/OKyaP/r4HH3F19jB59W1YxenzeJBfAH8Vlk5Kak1mWWqRvl8CV8ebuTJaCh7IVv4/NZ25g
	nC7RxcjJISFgIrH+ZDc7hC0mceHeerYuRi4OIYGljBJ/PnZAOX1MEp+3rmIDqWITMJToetsF
	ZosIuEn8W3cIrIhZ4DWrxIpHn1lAEsICNhLzN74As1kEVCWOHXjACmLzCnhIzPmwAWqdnMT/
	lyuYJjByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREh1fdzAuPWZ1iFGAg1GJh7eA
	/3CwEGtiWXFl7iFGCQ5mJRHecDegEG9KYmVValF+fFFpTmrxIUYmDk6pBsaVvJmhq9deuvD+
	4561O9iCP91pUutPCluezJ8//yZ/4+aNHHwnWQ5xlddeWyDjc0H/t6TReS0hq0nOfXo5XRJX
	w3d2fQzOW7Dqj7y6+ckTE48wrN+b9nAtt3z76heBp04faStZ6PeCeYqgyiZujxeXheZ5aCyu
	cjfr1j53Lr/6pq6WsEXcWiYlluKMREMt5qLiRADRnuHGbAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(please ignore previous patchset, I've attached wrong version of patches)

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

 drivers/base/dma-coherent.c     | 137 ++++++++++++++++++++++++++++++++++------
 drivers/base/dma-contiguous.c   |  67 ++++++++++++++++++++
 drivers/of/of_reserved_mem.c    |  70 ++++++++++++++++++++
 drivers/of/platform.c           |   7 ++
 include/linux/cma.h             |   3 +
 include/linux/of_reserved_mem.h |   7 ++
 mm/cma.c                        |  62 ++++++++++++++----
 7 files changed, 323 insertions(+), 30 deletions(-)

-- 
1.9.2

