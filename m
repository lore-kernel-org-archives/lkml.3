Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaAQIrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:47:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9540 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaAQIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:47:08 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-7a-52d8edfb1f0a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH] x86: dma-mapping: fix GFP_ATOMIC macro usage
Date: Fri, 17 Jan 2014 09:46:38 +0100
Message-id: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t9jAd3fb28EGfw6y2UxbaO4xeVdc9gs
	1h65y25x6cACJosFGx8xWmzeNJXZ4seGx6wO7B6bVnWyebw7d47d4/2+q2wefVtWMXp83iTn
	caLlC2sAWxSXTUpqTmZZapG+XQJXRs+jDWwF59gr9i/kaWBcydbFyMkhIWAi0fdwMyOELSZx
	4d56oDgXh5DAIkaJx4+bmEESQgKtTBIHn6qB2GwChhJdb7vAmkUEDCSWnpnEBNLALLCZUeLu
	2RcsIAlhAVuJo4fusYLYLAKqEk/OnwSzeQU8JHYcmQBkcwBtU5CYM8lmAiP3AkaGVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBofJMagfjygaLQ4wCHIxKPLwS4jeChFgTy4orcw8xSnAw
	K4nwbr0JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cB4
	4Wb0Mt/XXlNe/ok5bRMZ3xp4/WngrRX/gmYYinFM3TLDRGH3TLu378rkfef1+0RfYbpu9WUp
	R/udx++iuZ42FRrF/N9aL1FiVlt77dGG0zPKauaozF4Q+vF1qUmAtPTfHqFHwafnvU0LWam9
	7K5AS/ZkEc3ay4/dVgp3FPIavV9+9Mn7tbWWSizFGYmGWsxFxYkA++bryRECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence. This patch
fixes the issue introduced in v3.5-rc1

CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..32a81c9 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,7 +100,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 again:
 	page = NULL;
-	if (!(flag & GFP_ATOMIC))
+	if (flag & __GFP_WAIT)
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
-- 
1.7.9.5

