Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaCYSCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:02:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaCYRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 11/81] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue, 25 Mar 2014 10:15:24 -0700
Message-Id: <1395767794-5012-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c091c71ad2218fc50a07b3d1dab85783f3b77efd upstream.

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags, where meaningful is the LACK of __GFP_WAIT flag. To check if caller
wants to perform an atomic allocation, the code must test for a lack of the
__GFP_WAIT flag. This patch fixes the issue introduced in v3.5-rc1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/pci-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..f7d0672 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,8 +100,10 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 again:
 	page = NULL;
-	if (!(flag & GFP_ATOMIC))
+	/* CMA can be used only in the context which permits sleeping */
+	if (flag & __GFP_WAIT)
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
 	if (!page)
-- 
1.8.3.2

