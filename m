Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3CDDpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:45:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757477Ab3CDDo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:58 -0500
Message-Id: <20130304033709.738060965@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchand@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 022/153] zram: Fix deadlock bug in partial read/write
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/staging/zram/zram_drv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -242,7 +242,7 @@ static int zram_bvec_read(struct zram *z
 
 	if (is_partial_io(bvec)) {
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			return -ENOMEM;
@@ -338,7 +338,7 @@ static int zram_bvec_write(struct zram *
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;


