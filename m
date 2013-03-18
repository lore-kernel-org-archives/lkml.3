Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3CRWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:15:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:30246 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3CRWOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,867,1355126400"; 
   d="scan'208";a="216130293"
Subject: [PATCH 1/2] dma-debug: Fix locking bug in check_unmap
To: linux-kernel@vger.kernel.org
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: konrad.wilk@oracle.com, joerg.roedel@amd.com, konrad@kernel.org,
        christoph.paasch@uclouvain.be, mingo@redhat.com, shuahkhan@gmail.com,
        hpa@zytor.com, akpm@linux-foundation.org, shuah.khan@hp.com,
        netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com
Date: Mon, 18 Mar 2013 15:12:43 -0700
Message-ID: <20130318221243.7349.64147.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20130318220241.7349.5030.stgit@ahduyck-cp1.jf.intel.com>
References: <20130318220241.7349.5030.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In check_unmap it is possible to get into a dead-locked state if
dma_mapping_error is called.  The problem is that the bucket is locked in
check_unmap, and locked again by debug_dma_mapping_error which is called by
dma_mapping_error.  To resolve that we must release the lock on the bucket
before making the call to dma_mapping_error.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 lib/dma-debug.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 5e396ac..724bd4d 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -862,17 +862,18 @@ static void check_unmap(struct dma_debug_entry *ref)
 	entry = bucket_find_exact(bucket, ref);
 
 	if (!entry) {
+		/* must drop lock before calling dma_mapping_error */
+		put_hash_bucket(bucket, &flags);
+
 		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
 			err_printk(ref->dev, NULL,
-				   "DMA-API: device driver tries "
-				   "to free an invalid DMA memory address\n");
-			return;
+				   "DMA-API: device driver tries to free an invalid DMA memory address\n");
+		} else {
+			err_printk(ref->dev, NULL,
+				   "DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x%016llx] [size=%llu bytes]\n",
+				   ref->dev_addr, ref->size);
 		}
-		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
-			   "to free DMA memory it has not allocated "
-			   "[device address=0x%016llx] [size=%llu bytes]\n",
-			   ref->dev_addr, ref->size);
-		goto out;
+		return;
 	}
 
 	if (ref->size != entry->size) {
@@ -936,7 +937,6 @@ static void check_unmap(struct dma_debug_entry *ref)
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
 
-out:
 	put_hash_bucket(bucket, &flags);
 }
 

