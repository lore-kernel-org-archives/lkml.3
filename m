Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3GDQH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:07:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab3GDQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:07:26 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC] mm: Honor min_free_kbytes set by user
Date: Thu,  4 Jul 2013 18:07:16 +0200
Message-Id: <1372954036-16988-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

min_free_kbytes is updated during memory hotplug (by init_per_zone_wmark_min)
currently which is right thing to do in most cases but this could be
unexpected if admin increased the value to prevent from allocation
failures and the new min_free_kbytes would be decreased as a result of
memory hotadd.

This patch saves the user defined value and allows updating
min_free_kbytes only if it is higher than the saved one.

A warning is printed when the new value is ignored.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/page_alloc.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 22c528e..a785fad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -204,6 +204,7 @@ static char * const zone_names[MAX_NR_ZONES] = {
 };
 
 int min_free_kbytes = 1024;
+int user_min_free_kbytes;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
@@ -5592,14 +5593,22 @@ static void __meminit setup_per_zone_inactive_ratio(void)
 int __meminit init_per_zone_wmark_min(void)
 {
 	unsigned long lowmem_kbytes;
+	int new_min_free_kbytes;
 
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
-
-	min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
-	if (min_free_kbytes < 128)
-		min_free_kbytes = 128;
-	if (min_free_kbytes > 65536)
-		min_free_kbytes = 65536;
+	new_min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
+
+	if (new_min_free_kbytes > user_min_free_kbytes) {
+		min_free_kbytes = new_min_free_kbytes;
+		if (min_free_kbytes < 128)
+			min_free_kbytes = 128;
+		if (min_free_kbytes > 65536)
+			min_free_kbytes = 65536;
+	} else {
+		printk(KERN_WARNING "min_free_kbytes is not updated to %d"
+				"because user defined value %d is preferred\n",
+				new_min_free_kbytes, user_min_free_kbytes);
+	}
 	setup_per_zone_wmarks();
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
@@ -5617,8 +5626,10 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
-	if (write)
+	if (write) {
+		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
+	}
 	return 0;
 }
 
-- 
1.8.3.1

