Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab3B0BPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:15:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044Ab3BZX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchand@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@kernel.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [ 030/150] zram: Fix deadlock bug in partial read/write
Date: Tue, 26 Feb 2013 15:54:47 -0800
Message-Id: <20130226235527.355720207@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit 7e5a5104c6af709a8d97d5f4711e7c917761d464 upstream.

Now zram allocates new page with GFP_KERNEL in zram I/O path
if IO is partial. Unfortunately, It may cause deadlock with
reclaim path like below.

write_page from fs
fs_lock
allocation(GFP_KERNEL)
reclaim
pageout
				write_page from fs
				fs_lock <-- deadlock

This patch fixes it by using GFP_NOIO.  In read path, we
reorganize code flow so that kmap_atomic is called after the
GFP_NOIO allocation.

Acked-by: Jerome Marchand <jmarchand@redhat.com>
Acked-by: Nitin Gupta <ngupta@vflare.org>
[ penberg@kernel.org: don't use GFP_ATOMIC ]
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -228,11 +228,12 @@ static int zram_bvec_read(struct zram *z
 		return 0;
 	}
 
-	user_mem = kmap_atomic(page);
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	else
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
+
+	user_mem = kmap_atomic(page);
+	if (!is_partial_io(bvec))
 		uncmem = user_mem;
 
 	if (!uncmem) {
@@ -279,7 +280,7 @@ static int zram_bvec_write(struct zram *
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;


