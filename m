Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3KZEoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:44:32 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52641 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3KZEoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:44:30 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v1 2/2] USB: storage: use sg_miter_* APIs to access scsi buffer
Date: Tue, 26 Nov 2013 12:44:13 +0800
Message-Id: <1385441053-5810-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have sg_miter_* APIs for accessing scsi sg buffer, so
use them to make code clean and bug free.

Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/storage/protocol.c |   80 +++++++++++++---------------------------
 1 file changed, 26 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 5dfb4c3..f54e5fe 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -135,69 +135,41 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
 	unsigned int *offset, enum xfer_buf_dir dir)
 {
-	unsigned int cnt;
+	unsigned int cnt = 0;
 	struct scatterlist *sg = *sgptr;
+	struct sg_mapping_iter miter;
+	unsigned int nents = scsi_sg_count(srb);
 
-	/* We have to go through the list one entry
-	 * at a time.  Each s-g entry contains some number of pages, and
-	 * each page has to be kmap()'ed separately.  If the page is already
-	 * in kernel-addressable memory then kmap() will return its address.
-	 * If the page is not directly accessible -- such as a user buffer
-	 * located in high memory -- then kmap() will map it to a temporary
-	 * position in the kernel's virtual address space.
-	 */
-
-	if (!sg)
+	if (sg)
+		nents = sg_nents(sg);
+	else
 		sg = scsi_sglist(srb);
 
-	/* This loop handles a single s-g list entry, which may
-	 * include multiple pages.  Find the initial page structure
-	 * and the starting offset within the page, and update
-	 * the *offset and **sgptr values for the next loop.
-	 */
-	cnt = 0;
-	while (cnt < buflen && sg) {
-		struct page *page = sg_page(sg) +
-				((sg->offset + *offset) >> PAGE_SHIFT);
-		unsigned int poff = (sg->offset + *offset) & (PAGE_SIZE-1);
-		unsigned int sglen = sg->length - *offset;
-
-		if (sglen > buflen - cnt) {
-
-			/* Transfer ends within this s-g entry */
-			sglen = buflen - cnt;
-			*offset += sglen;
-		} else {
+	sg_miter_start(&miter, sg, nents, dir == FROM_XFER_BUF ?
+		SG_MITER_FROM_SG: SG_MITER_TO_SG);
 
-			/* Transfer continues to next s-g entry */
-			*offset = 0;
-			sg = sg_next(sg);
-		}
+	if (!sg_miter_skip(&miter, *offset))
+		return cnt;
+
+	while (sg_miter_next(&miter) && cnt < buflen) {
+		unsigned int len = min(miter.length, buflen - cnt);
+
+		if (dir == FROM_XFER_BUF)
+			memcpy(buffer + cnt, miter.addr, len);
+		else
+			memcpy(miter.addr, buffer + cnt, len);
 
-		/* Transfer the data for all the pages in this
-			* s-g entry.  For each page: call kmap(), do the
-			* transfer, and call kunmap() immediately after. */
-		while (sglen > 0) {
-			unsigned int plen = min(sglen, (unsigned int)
-					PAGE_SIZE - poff);
-			unsigned char *ptr = kmap(page);
-
-			if (dir == TO_XFER_BUF)
-				memcpy(ptr + poff, buffer + cnt, plen);
-			else
-				memcpy(buffer + cnt, ptr + poff, plen);
-			kunmap(page);
-
-			/* Start at the beginning of the next page */
-			poff = 0;
-			++page;
-			cnt += plen;
-			sglen -= plen;
+		if (*offset + len < miter.piter.sg->length) {
+			*offset += len;
+			*sgptr = miter.piter.sg;
+		} else {
+			*offset = 0;
+			*sgptr = sg_next(miter.piter.sg);
 		}
+		cnt += len;
 	}
-	*sgptr = sg;
+	sg_miter_stop(&miter);
 
-	/* Return the amount actually transferred */
 	return cnt;
 }
 EXPORT_SYMBOL_GPL(usb_stor_access_xfer_buf);
-- 
1.7.9.5

