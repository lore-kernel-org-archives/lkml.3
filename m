Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaCDUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbaCDUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3.13 105/172] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue,  4 Mar 2014 12:03:09 -0800
Message-Id: <20140304200303.072298838@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c091c71ad2218fc50a07b3d1dab85783f3b77efd upstream.

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags, where meaningful is the LACK of __GFP_WAIT flag. To check if caller
wants to perform an atomic allocation, the code must test for a lack of the
__GFP_WAIT flag. This patch fixes the issue introduced in v3.5-rc1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/pci-dma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,8 +100,10 @@ void *dma_generic_alloc_coherent(struct
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


