Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKFWrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:47:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaKFWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 030/162] sparc32: dma_alloc_coherent must honour gfp flags
Date: Thu,  6 Nov 2014 14:34:54 -0800
Message-Id: <1415313426-9622-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hellstrom <daniel@gaisler.com>

[ Upstream commit d1105287aabe88dbb3af825140badaa05cf0442c ]

dma_zalloc_coherent() calls dma_alloc_coherent(__GFP_ZERO)
but the sparc32 implementations sbus_alloc_coherent() and
pci32_alloc_coherent() doesn't take the gfp flags into
account.

Tested on the SPARC32/LEON GRETH Ethernet driver which fails
due to dma_alloc_coherent(__GFP_ZERO) returns non zeroed
pages.

Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/ioport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index e7e215d..c2d81ad 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -278,7 +278,8 @@ static void *sbus_alloc_coherent(struct device *dev, size_t len,
 	}
 
 	order = get_order(len_total);
-	if ((va = __get_free_pages(GFP_KERNEL|__GFP_COMP, order)) == 0)
+	va = __get_free_pages(gfp, order);
+	if (va == 0)
 		goto err_nopages;
 
 	if ((res = kzalloc(sizeof(struct resource), GFP_KERNEL)) == NULL)
@@ -443,7 +444,7 @@ static void *pci32_alloc_coherent(struct device *dev, size_t len,
 	}
 
 	order = get_order(len_total);
-	va = (void *) __get_free_pages(GFP_KERNEL, order);
+	va = (void *) __get_free_pages(gfp, order);
 	if (va == NULL) {
 		printk("pci_alloc_consistent: no %ld pages\n", len_total>>PAGE_SHIFT);
 		goto err_nopages;
-- 
1.9.1

