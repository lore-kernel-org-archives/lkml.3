Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3CDSSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:18:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab3CDSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:18:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: dan.magenheimer@oracle.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/11] zcache: The last of the atomic reads has now an accessory function.
Date: Mon,  4 Mar 2013 13:18:14 -0500
Message-Id: <1362421101-15896-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
References: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And now we can move the code ([inc|dec]_zcache_[*]) to their own file
with a header to make them nops or feed in debugfs.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 4272ab9..f455151 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -253,6 +253,14 @@ static inline void dec_zcache_pers_zpages(unsigned zpages)
 {
 	zcache_pers_zpages = atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
 }
+
+static inline unsigned long curr_pageframes_count(void)
+{
+	return zcache_pageframes_alloced -
+		atomic_read(&zcache_pageframes_freed_atomic) -
+		atomic_read(&zcache_eph_pageframes_atomic) -
+		atomic_read(&zcache_pers_pageframes_atomic);
+};
 /* but for the rest of these, counting races are ok */
 static ssize_t zcache_flush_total;
 static ssize_t zcache_flush_found;
@@ -565,10 +573,7 @@ static void zcache_free_page(struct page *page)
 		BUG();
 	__free_page(page);
 	inc_zcache_pageframes_freed();
-	curr_pageframes = zcache_pageframes_alloced -
-			atomic_read(&zcache_pageframes_freed_atomic) -
-			atomic_read(&zcache_eph_pageframes_atomic) -
-			atomic_read(&zcache_pers_pageframes_atomic);
+	curr_pageframes = curr_pageframes_count();
 	if (curr_pageframes > max_pageframes)
 		max_pageframes = curr_pageframes;
 	if (curr_pageframes < min_pageframes)
-- 
1.8.0.2

