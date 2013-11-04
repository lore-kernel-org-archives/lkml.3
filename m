Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3KDLj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KDLgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:35 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/19] GFS2: Move gfs2_icbit_munge into quota.c
Date: Mon,  4 Nov 2013 11:09:34 +0000
Message-Id: <1383563382-8535-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called twice, and both callers are
quota related, so lets move this function into quota.c and
make it static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8fe7a0a..fd1ec52 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -289,6 +289,26 @@ static void slot_hold(struct gfs2_quota_data *qd)
 	spin_unlock(&qd_lru_lock);
 }
 
+static void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
+			     unsigned int bit, int new_value)
+{
+	unsigned int c, o, b = bit;
+	int old_value;
+
+	c = b / (8 * PAGE_SIZE);
+	b %= 8 * PAGE_SIZE;
+	o = b / 8;
+	b %= 8;
+
+	old_value = (bitmap[c][o] & (1 << b));
+	gfs2_assert_withdraw(sdp, !old_value != !new_value);
+
+	if (new_value)
+		bitmap[c][o] |= 1 << b;
+	else
+		bitmap[c][o] &= ~(1 << b);
+}
+
 static void slot_put(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 6402fb6..f7109f6 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -268,23 +268,3 @@ int gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	return rv;
 }
 
-void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
-		      unsigned int bit, int new_value)
-{
-	unsigned int c, o, b = bit;
-	int old_value;
-
-	c = b / (8 * PAGE_SIZE);
-	b %= 8 * PAGE_SIZE;
-	o = b / 8;
-	b %= 8;
-
-	old_value = (bitmap[c][o] & (1 << b));
-	gfs2_assert_withdraw(sdp, !old_value != !new_value);
-
-	if (new_value)
-		bitmap[c][o] |= 1 << b;
-	else
-		bitmap[c][o] &= ~(1 << b);
-}
-
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 8053573..b7ffb09 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -164,8 +164,6 @@ static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 #define gfs2_tune_get(sdp, field) \
 gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 
-void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
-		      unsigned int bit, int new_value);
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...);
 
 #endif /* __UTIL_DOT_H__ */
-- 
1.7.4.4

