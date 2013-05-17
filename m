Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3EQLBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:01:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47461 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3EQLBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:01:02 -0400
X-Spam-Score: -100.8
Message-ID: <51960DB6.30808@asianux.com>
Date: Fri, 17 May 2013 19:00:06 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: mgorman@suse.de, minchan@kernel.org, m.szyprowski@samsung.com,
        kamezawa.hiroyu@jp.fujitsu.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/page_alloc.c: add additional checking and return value
 for the 'table->data'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If 'table->data' is invalid, also need check its length to know whether
is invalid, firstly.

When __parse_numa_zonelist_order() fails, also need save the related
error code for return.

Beautify code ('char*' --> 'char *') to pass "./scripts/checkpatch.pl"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 mm/page_alloc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0a0acfe..48c83e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3250,18 +3250,25 @@ int numa_zonelist_order_handler(ctl_table *table, int write,
 	static DEFINE_MUTEX(zl_order_mutex);
 
 	mutex_lock(&zl_order_mutex);
-	if (write)
-		strcpy(saved_string, (char*)table->data);
+	if (write) {
+		if (strlen((char *)table->data) >= NUMA_ZONELIST_ORDER_LEN) {
+			ret = -EINVAL;
+			goto out;
+		}
+		strcpy(saved_string, (char *)table->data);
+	}
 	ret = proc_dostring(table, write, buffer, length, ppos);
 	if (ret)
 		goto out;
 	if (write) {
 		int oldval = user_zonelist_order;
-		if (__parse_numa_zonelist_order((char*)table->data)) {
+
+		ret = __parse_numa_zonelist_order((char *)table->data);
+		if (ret) {
 			/*
 			 * bogus value.  restore saved string
 			 */
-			strncpy((char*)table->data, saved_string,
+			strncpy((char *)table->data, saved_string,
 				NUMA_ZONELIST_ORDER_LEN);
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order) {
-- 
1.7.7.6
