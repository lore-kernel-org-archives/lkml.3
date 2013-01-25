Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3AYOTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:19:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3AYOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 04/19] oss/dmabuf: use dma_map_single
Date: Fri, 25 Jan 2013 14:14:21 +0000
Message-Id: <1359123276-15833-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DrX2BzMptP4Oy0sbRvhcfQVPjQZpCanI9pf6OgBZnG8
 1sba2cm0UM1gJ+NV2e28Z2IqDh5HQ0ajhsJ9ZGKNlsYKvrPqKv
 fFRkJlVH1HXjlD0sYP0SzfSaqInWFrS3YpTveNIYPjn5JBAzpL
 a7pOrourqUxLBfP5UuPX4+22HTLBqIF3WLcuWgriKlOGfsi7ja
 0iHJ918jJ5wcoqioJFyMybOybhv5vAdcJT6VUcUbeOs9Uvzphl
 GEP8RAe1e24qCi9O0DZZ9ugq0T3f02sIKoimOJ7u0E+4kvMDTS
 MQbajySI7nNMCdTm3EZkvCOt3bpQZ8AW9SDrU7gnjQ6NGrzZOU
 BEIOtd4P0hFFxOdyu+saKg7xIEBmYFOvaMVT1mMlx
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
1.8.0

