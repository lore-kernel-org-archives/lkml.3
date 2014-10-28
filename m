Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaJ1Dkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaJ1Dkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 120/146] sparc32: dma_alloc_coherent must honour gfp flags
Date: Tue, 28 Oct 2014 11:34:22 +0800
Message-Id: <20141028033348.650262791@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/ioport.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -278,7 +278,8 @@ static void *sbus_alloc_coherent(struct
 	}
 
 	order = get_order(len_total);
-	if ((va = __get_free_pages(GFP_KERNEL|__GFP_COMP, order)) == 0)
+	va = __get_free_pages(gfp, order);
+	if (va == 0)
 		goto err_nopages;
 
 	if ((res = kzalloc(sizeof(struct resource), GFP_KERNEL)) == NULL)
@@ -443,7 +444,7 @@ static void *pci32_alloc_coherent(struct
 	}
 
 	order = get_order(len_total);
-	va = (void *) __get_free_pages(GFP_KERNEL, order);
+	va = (void *) __get_free_pages(gfp, order);
 	if (va == NULL) {
 		printk("pci_alloc_consistent: no %ld pages\n", len_total>>PAGE_SHIFT);
 		goto err_nopages;


