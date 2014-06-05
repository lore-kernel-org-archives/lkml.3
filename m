Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFEEVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaFEEVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchand@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@kernel.org>,
        Minchan Kim <minchan@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 102/214] zram: Fix deadlock bug in partial read/write
Date: Wed,  4 Jun 2014 21:17:45 -0700
Message-Id: <20140605041653.411654637@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: no reordering is needed in the read path]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -235,7 +235,7 @@ static int zram_bvec_read(struct zram *z
 
 	if (is_partial_io(bvec)) {
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			return -ENOMEM;
@@ -330,7 +330,7 @@ static int zram_bvec_write(struct zram *
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;


