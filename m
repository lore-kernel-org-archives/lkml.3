Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab3DJA2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:28:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36602 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549Ab3DJA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:26:17 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 03/10] staging: ramster: Provide accessory functions for counter increase
Date: Wed, 10 Apr 2013 08:25:53 +0800
Message-Id: <1365553560-32258-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041000-1618-0000-0000-000003A79A7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables these functions to be wrapped and 
can disable/enable this with CONFIG_DEBUG_FS.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/ramster/ramster.c |   34 ++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/zcache/ramster/ramster.c b/drivers/staging/zcache/ramster/ramster.c
index 01fc672..b60e884 100644
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
@@ -67,12 +67,32 @@ static int ramster_remote_target_nodenum __read_mostly = -1;
 static long ramster_flnodes;
 static atomic_t ramster_flnodes_atomic = ATOMIC_INIT(0);
 static unsigned long ramster_flnodes_max;
+static inline void inc_ramster_flnodes(void)
+{
+	ramster_flnodes = atomic_inc_return(&ramster_flnodes_atomic);
+	if (ramster_flnodes > ramster_flnodes_max)
+		ramster_flnodes_max = ramster_flnodes;
+}
 static ssize_t ramster_foreign_eph_pages;
 static atomic_t ramster_foreign_eph_pages_atomic = ATOMIC_INIT(0);
 static ssize_t ramster_foreign_eph_pages_max;
+static inline void inc_ramster_foreign_eph_pages(void)
+{
+	ramster_foreign_eph_pages = atomic_inc_return(
+			&ramster_foreign_eph_pages_atomic);
+	if (ramster_foreign_eph_pages > ramster_foreign_eph_pages_max)
+		ramster_foreign_eph_pages_max = ramster_foreign_eph_pages;
+}
 static ssize_t ramster_foreign_pers_pages;
 static atomic_t ramster_foreign_pers_pages_atomic = ATOMIC_INIT(0);
 static ssize_t ramster_foreign_pers_pages_max;
+static inline void inc_ramster_foreign_pers_pages(void)
+{
+	ramster_foreign_pers_pages = atomic_inc_return(
+		&ramster_foreign_pers_pages_atomic);
+	if (ramster_foreign_pers_pages > ramster_foreign_pers_pages_max)
+		ramster_foreign_pers_pages_max = ramster_foreign_pers_pages;
+}
 static ssize_t ramster_eph_pages_remoted;
 static ssize_t ramster_pers_pages_remoted;
 static ssize_t ramster_eph_pages_remote_failed;
@@ -159,9 +179,7 @@ static struct flushlist_node *ramster_flnode_alloc(struct tmem_pool *pool)
 	flnode = kp->flnode;
 	BUG_ON(flnode == NULL);
 	kp->flnode = NULL;
-	ramster_flnodes = atomic_inc_return(&ramster_flnodes_atomic);
-	if (ramster_flnodes > ramster_flnodes_max)
-		ramster_flnodes_max = ramster_flnodes;
+	inc_ramster_flnodes();
 	return flnode;
 }
 
@@ -471,10 +489,7 @@ void ramster_count_foreign_pages(bool eph, int count)
 	BUG_ON(count != 1 && count != -1);
 	if (eph) {
 		if (count > 0) {
-			c = atomic_inc_return(
-					&ramster_foreign_eph_pages_atomic);
-			if (c > ramster_foreign_eph_pages_max)
-				ramster_foreign_eph_pages_max = c;
+			inc_ramster_foreign_eph_pages();
 		} else {
 			c = atomic_dec_return(&ramster_foreign_eph_pages_atomic);
 			WARN_ON_ONCE(c < 0);
@@ -482,10 +497,7 @@ void ramster_count_foreign_pages(bool eph, int count)
 		ramster_foreign_eph_pages = c;
 	} else {
 		if (count > 0) {
-			c = atomic_inc_return(
-					&ramster_foreign_pers_pages_atomic);
-			if (c > ramster_foreign_pers_pages_max)
-				ramster_foreign_pers_pages_max = c;
+			inc_ramster_foreign_pers_pages();
 		} else {
 			c = atomic_dec_return(
 					&ramster_foreign_pers_pages_atomic);
-- 
1.7.10.4

