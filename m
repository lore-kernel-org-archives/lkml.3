Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3GAJ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3GAJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/12] GFS2: Sort buffer lists by inplace block number
Date: Mon,  1 Jul 2013 10:33:04 +0100
Message-Id: <1372671195-3472-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch simply sort the data and metadata buffer lists by their
inplace block number.  This makes gfs2_log_flush issue the inplace IO
in sequential order, which will hopefully speed up writing the IO
out to disk.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6c33d7b..cb017a6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -16,6 +16,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/bio.h>
 #include <linux/fs.h>
+#include <linux/list_sort.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -401,6 +402,20 @@ static void gfs2_check_magic(struct buffer_head *bh)
 	kunmap_atomic(kaddr);
 }
 
+static int blocknr_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct gfs2_bufdata *bda, *bdb;
+
+	bda = list_entry(a, struct gfs2_bufdata, bd_list);
+	bdb = list_entry(b, struct gfs2_bufdata, bd_list);
+
+	if (bda->bd_bh->b_blocknr < bdb->bd_bh->b_blocknr)
+		return -1;
+	if (bda->bd_bh->b_blocknr > bdb->bd_bh->b_blocknr)
+		return 1;
+	return 0;
+}
+
 static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 				unsigned int total, struct list_head *blist,
 				bool is_databuf)
@@ -413,6 +428,7 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 	__be64 *ptr;
 
 	gfs2_log_lock(sdp);
+	list_sort(NULL, blist, blocknr_cmp);
 	bd1 = bd2 = list_prepare_entry(bd1, blist, bd_list);
 	while(total) {
 		num = total;
-- 
1.7.4

