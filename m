Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab3DYR3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab3DYR30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 07/21] oss/dmabuf: use dma_map_single
Date: Thu, 25 Apr 2013 19:28:50 +0200
Message-Id: <1366910944-3033663-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+B8FrqSp/bn+S7UH2y09L6MPnzM8BcUZXT+Zh3XMV92
 P58zcH9pnEP7rDlcCDxT1pDHXo9/OQs58RcGRyGdh2foTx1tKt
 lMvpW7XyVac5I1Vy+ua11aIcpk4+SWlMNHxxrqfXbPtp9yXtCZ
 dWm2yC4/vyYtbvuq2/2BSrcn7VE+2k6/OOngXmIhubr6KJcDUb
 zws9FcpC53imZzqZhaC/oHPmeQsH3FIb5vsD8D/Iow1ENrm9KH
 TAB6aoqHBoZI+KTMFTzlxc7RYLPleZnLAfrIJlmnk4QT6x75hQ
 a0ffYriX/KLjLfvDs+r+QAy4yEh8OxgxsiKl+RZRZ5LnH+q9vv
 RSMj04kfq6iASNHwGoop1rAq0ikd6czevDcaf5y8x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virt_to_bus/bus_to_virt functions have been deprecated
for as long as I can remember, and they are used in very
few remaining instances, usually in obscure ISA device
drivers. The OSS sound drivers are the only ones that are
still used on the ARM architecture, and only on some of
the earliest StrongARM machines.

The problem for converting the OSS subsystem to use
dma_map_single instead is that the caller of virt_to_bus
does not have a device pointer, since the subsystem has
never been ported to use the common device infrastructure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/dmabuf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/oss/dmabuf.c b/sound/oss/dmabuf.c
index bcc3e8e..a59c888 100644
--- a/sound/oss/dmabuf.c
+++ b/sound/oss/dmabuf.c
@@ -114,7 +114,7 @@ static int sound_alloc_dmap(struct dma_buffparms *dmap)
 		}
 	}
 	dmap->raw_buf = start_addr;
-	dmap->raw_buf_phys = virt_to_bus(start_addr);
+	dmap->raw_buf_phys = dma_map_single(NULL, start_addr, dmap->buffsize, DMA_BIDIRECTIONAL);
 
 	for (page = virt_to_page(start_addr); page <= virt_to_page(end_addr); page++)
 		SetPageReserved(page);
@@ -139,6 +139,7 @@ static void sound_free_dmap(struct dma_buffparms *dmap)
 	for (page = virt_to_page(start_addr); page <= virt_to_page(end_addr); page++)
 		ClearPageReserved(page);
 
+	dma_unmap_single(NULL, dmap->raw_buf_phys, dmap->buffsize, DMA_BIDIRECTIONAL);
 	free_pages((unsigned long) dmap->raw_buf, sz);
 	dmap->raw_buf = NULL;
 }
-- 
1.8.1.2

