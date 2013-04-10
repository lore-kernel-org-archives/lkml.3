Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab3DJA0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:26:21 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42913 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935934Ab3DJA0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:26:19 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 04/10] staging: ramster: Provide accessory functions for counter decrease
Date: Wed, 10 Apr 2013 08:25:54 +0800
Message-Id: <1365553560-32258-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041000-4790-0000-0000-000007C725B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables these functions to be wrapped and
can disable/enable this with CONFIG_DEBUG_FS.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/ramster/ramster.c |   32 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/zcache/ramster/ramster.c b/drivers/staging/zcache/ramster/ramster.c
index b60e884..c3d7f96 100644
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
@@ -73,6 +73,10 @@ static inline void inc_ramster_flnodes(void)
 	if (ramster_flnodes > ramster_flnodes_max)
 		ramster_flnodes_max = ramster_flnodes;
 }
+static inline void dec_ramster_flnodes(void)
+{
+	ramster_flnodes = atomic_dec_return(&ramster_flnodes_atomic);
+}
 static ssize_t ramster_foreign_eph_pages;
 static atomic_t ramster_foreign_eph_pages_atomic = ATOMIC_INIT(0);
 static ssize_t ramster_foreign_eph_pages_max;
@@ -83,6 +87,11 @@ static inline void inc_ramster_foreign_eph_pages(void)
 	if (ramster_foreign_eph_pages > ramster_foreign_eph_pages_max)
 		ramster_foreign_eph_pages_max = ramster_foreign_eph_pages;
 }
+static inline void dec_ramster_foreign_eph_pages(void)
+{
+	ramster_foreign_eph_pages = atomic_dec_return(
+			&ramster_foreign_eph_pages_atomic);
+}
 static ssize_t ramster_foreign_pers_pages;
 static atomic_t ramster_foreign_pers_pages_atomic = ATOMIC_INIT(0);
 static ssize_t ramster_foreign_pers_pages_max;
@@ -93,6 +102,11 @@ static inline void inc_ramster_foreign_pers_pages(void)
 	if (ramster_foreign_pers_pages > ramster_foreign_pers_pages_max)
 		ramster_foreign_pers_pages_max = ramster_foreign_pers_pages;
 }
+static inline void dec_ramster_foreign_pers_pages(void)
+{
+	ramster_foreign_pers_pages = atomic_dec_return(
+		&ramster_foreign_pers_pages_atomic);
+}
 static ssize_t ramster_eph_pages_remoted;
 static ssize_t ramster_pers_pages_remoted;
 static ssize_t ramster_eph_pages_remote_failed;
@@ -188,10 +202,8 @@ static struct flushlist_node *ramster_flnode_alloc(struct tmem_pool *pool)
 static void ramster_flnode_free(struct flushlist_node *flnode,
 				struct tmem_pool *pool)
 {
-	int flnodes;
-
-	flnodes = atomic_dec_return(&ramster_flnodes_atomic);
-	BUG_ON(flnodes < 0);
+	dec_ramster_flnodes();
+	BUG_ON(ramster_flnodes < 0);
 	kmem_cache_free(ramster_flnode_cache, flnode);
 }
 
@@ -484,26 +496,20 @@ void *ramster_pampd_free(void *pampd, struct tmem_pool *pool,
 
 void ramster_count_foreign_pages(bool eph, int count)
 {
-	int c;
-
 	BUG_ON(count != 1 && count != -1);
 	if (eph) {
 		if (count > 0) {
 			inc_ramster_foreign_eph_pages();
 		} else {
-			c = atomic_dec_return(&ramster_foreign_eph_pages_atomic);
-			WARN_ON_ONCE(c < 0);
+			dec_ramster_foreign_eph_pages();
+			WARN_ON_ONCE(ramster_foreign_eph_pages < 0);
 		}
-		ramster_foreign_eph_pages = c;
 	} else {
 		if (count > 0) {
 			inc_ramster_foreign_pers_pages();
 		} else {
-			c = atomic_dec_return(
-					&ramster_foreign_pers_pages_atomic);
-			WARN_ON_ONCE(c < 0);
+			WARN_ON_ONCE(ramster_foreign_pers_pages < 0);
 		}
-		ramster_foreign_pers_pages = c;
 	}
 }
 
-- 
1.7.10.4

