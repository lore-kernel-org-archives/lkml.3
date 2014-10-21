Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaJUMPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:15:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36995 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaJUMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:15:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/cma: Make kmemleak ignore CMA regions
Date: Tue, 21 Oct 2014 14:14:56 +0200
Message-Id: <1413893696-25484-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

kmemleak will add allocations as objects to a pool. The memory allocated
for each object in this pool is periodically searched for pointers to
other allocated objects. This only works for memory that is mapped into
the kernel's virtual address space, which happens not to be the case for
most CMA regions.

Furthermore, CMA regions are typically used to store data transferred to
or from a device and therefore don't contain pointers to other objects.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note: I'm not sure this is really the right fix. But without this, the
kernel crashes on the first execution of the scan_gray_list() because
it tries to access highmem. Perhaps a more appropriate fix would be to
reject any object that can't map to a kernel virtual address?
---
 mm/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/cma.c b/mm/cma.c
index 963bc4add9af..349f9266f6d3 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -280,6 +280,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
 			ret = -ENOMEM;
 			goto err;
 		} else {
+			kmemleak_ignore(phys_to_virt(addr));
 			base = addr;
 		}
 	}
-- 
2.1.2

