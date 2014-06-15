Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaFOUn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:43:28 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:36010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752591AbaFOUir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:4321:4605:5007:6261:8603:9592:10004:10026:10848:11026:11233:11657:11658:11914:12043:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shelf56_698221f6d6861
X-Filterd-Recvd-Size: 3726
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org
Subject: [PATCH -next 13/26] ath: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:42 -0700
Message-Id: <55b103a2ec78c0031b348e103603bf9a0d9cac3b.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath10k/pci.c  | 8 ++------
 drivers/net/wireless/ath/ath10k/wmi.c  | 8 ++------
 drivers/net/wireless/ath/wcn36xx/dxe.c | 6 ++----
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d0004d5..35045a4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -359,16 +359,12 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	 *   2) Buffer in DMA-able space
 	 */
 	orig_nbytes = nbytes;
-	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
-						       orig_nbytes,
-						       &ce_data_base,
-						       GFP_ATOMIC);
-
+	data_buf = dma_zalloc_coherent(ar->dev, orig_nbytes, &ce_data_base,
+				       GFP_ATOMIC);
 	if (!data_buf) {
 		ret = -ENOMEM;
 		goto done;
 	}
-	memset(data_buf, 0, orig_nbytes);
 
 	remaining_bytes = orig_nbytes;
 	ce_data = ce_data_base;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4b7782a..0093269 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1889,17 +1889,13 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	if (!pool_size)
 		return -EINVAL;
 
-	ar->wmi.mem_chunks[idx].vaddr = dma_alloc_coherent(ar->dev,
-							   pool_size,
-							   &paddr,
-							   GFP_ATOMIC);
+	ar->wmi.mem_chunks[idx].vaddr = dma_zalloc_coherent(ar->dev, pool_size,
+							    &paddr, GFP_ATOMIC);
 	if (!ar->wmi.mem_chunks[idx].vaddr) {
 		ath10k_warn("failed to allocate memory chunk\n");
 		return -ENOMEM;
 	}
 
-	memset(ar->wmi.mem_chunks[idx].vaddr, 0, pool_size);
-
 	ar->wmi.mem_chunks[idx].paddr = paddr;
 	ar->wmi.mem_chunks[idx].len = pool_size;
 	ar->wmi.mem_chunks[idx].req_id = req_id;
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 73f12f1..1975a1a 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -177,13 +177,11 @@ static int wcn36xx_dxe_init_descs(struct wcn36xx_dxe_ch *wcn_ch)
 	int i;
 
 	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
-	wcn_ch->cpu_addr = dma_alloc_coherent(NULL, size, &wcn_ch->dma_addr,
-					      GFP_KERNEL);
+	wcn_ch->cpu_addr = dma_zalloc_coherent(NULL, size, &wcn_ch->dma_addr,
+					       GFP_KERNEL);
 	if (!wcn_ch->cpu_addr)
 		return -ENOMEM;
 
-	memset(wcn_ch->cpu_addr, 0, size);
-
 	cur_dxe = (struct wcn36xx_dxe_desc *)wcn_ch->cpu_addr;
 	cur_ctl = wcn_ch->head_blk_ctl;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

