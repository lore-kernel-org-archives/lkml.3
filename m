Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaA0GA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:00:27 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49835 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaA0GAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:00:25 -0500
From: Barry Song <21cnbao@gmail.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>,
        Bin Shi <Bin.Shi@csr.com>
Subject: [PATCH] kernel/power/swap.c: print the speed of compressed image instead of uncompressed one
Date: Mon, 27 Jan 2014 13:59:55 +0800
Message-Id: <1390802395-2336-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

For users of hibernation, people care more about the size of the compressed
image than uncompressed one. as embedded guys will try to improve the speed
of SD, NAND and do the best to shrink memory to make the image as less as
possible.
so printing the speed of compressed image is more important and making more
senses here.

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Bin Shi <Bin.Shi@csr.com>
---
 kernel/power/swap.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c33ed2..bcb5c51 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -587,6 +587,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	unsigned char *page = NULL;
 	struct cmp_data *data = NULL;
 	struct crc_data *crc = NULL;
+	unsigned int nr_cmp_written = 0;
 
 	/*
 	 * We'll limit the number of threads for compression to limit memory
@@ -747,6 +748,8 @@ static int save_image_lzo(struct swap_map_handle *handle,
 			     off += PAGE_SIZE) {
 				memcpy(page, data[thr].cmp + off, PAGE_SIZE);
 
+				nr_cmp_written++;
+
 				ret = swap_write_page(handle, page, &bio);
 				if (ret)
 					goto out_finish;
@@ -764,7 +767,11 @@ out_finish:
 		ret = err2;
 	if (!ret)
 		printk(KERN_INFO "PM: Image saving done.\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+
+	printk(KERN_INFO "PM: Saved %lu Kbytes (uncompressed Image)\n",
+		nr_to_write * (PAGE_SIZE / 1024));
+	swsusp_show_speed(&start, &stop, nr_cmp_written, "Wrote compressed");
+
 out_clean:
 	if (crc) {
 		if (crc->thr)
-- 
1.7.5.4

