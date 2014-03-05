Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaCEO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:59:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbaCEOhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 04/62] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Wed,  5 Mar 2014 14:36:08 +0000
Message-Id: <1394030226-26652-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c091c71ad2218fc50a07b3d1dab85783f3b77efd upstream.

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags, where meaningful is the LACK of __GFP_WAIT flag. To check if caller
wants to perform an atomic allocation, the code must test for a lack of the
__GFP_WAIT flag. This patch fixes the issue introduced in v3.5-rc1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/pci-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index c0f420f..4baa8ff 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -109,8 +109,10 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
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
1.9.0

