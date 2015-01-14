Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbbANIF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:05:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbbANHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.14 25/77] UBI: Fix double free after do_sync_erase()
Date: Tue, 13 Jan 2015 23:23:05 -0800
Message-Id: <20150114072225.575454941@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit aa5ad3b6eb8feb2399a5d26c8fb0060561bb9534 upstream.

If the erase worker is unable to erase a PEB it will
free the ubi_wl_entry itself.
The failing ubi_wl_entry must not free()'d again after
do_sync_erase() returns.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/wl.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1205,7 +1205,6 @@ static int wear_leveling_worker(struct u
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -1219,10 +1218,8 @@ static int wear_leveling_worker(struct u
 		dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
 		       e2->pnum, vol_id, lnum);
 		err = do_sync_erase(ubi, e2, vol_id, lnum, 0);
-		if (err) {
-			kmem_cache_free(ubi_wl_entry_slab, e2);
+		if (err)
 			goto out_ro;
-		}
 	}
 
 	dbg_wl("done");
@@ -1258,10 +1255,9 @@ out_not_moved:
 
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	err = do_sync_erase(ubi, e2, vol_id, lnum, torture);
-	if (err) {
-		kmem_cache_free(ubi_wl_entry_slab, e2);
+	if (err)
 		goto out_ro;
-	}
+
 	mutex_unlock(&ubi->move_mutex);
 	return 0;
 


