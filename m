Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab3BAUwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:52:45 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55311 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3BAUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:33 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 04/16]  zcache: The last of the atomic reads has now an accessory function.
Date: Fri,  1 Feb 2013 15:52:07 -0500
Message-Id: <1359751939-23584-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
References: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And now we can move the code to its own file.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index a55a95b..01da8f6 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -252,6 +252,14 @@ static inline void dec_zcache_pers_zpages(unsigned zpages)
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
 static unsigned long zcache_flush_total;
 static unsigned long zcache_flush_found;
@@ -551,10 +559,7 @@ static void zcache_free_page(struct page *page)
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
1.7.11.7

