Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaCXTfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbaCXTfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com, andi.kleen@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/6] perf: Update sort to handle MAP_SHARED bits
Date: Mon, 24 Mar 2014 15:34:35 -0400
Message-Id: <1395689676-214799-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some of the false positives when sorting by utilizing the MAP_SHARED bit.

This helps deal with the COW cases where a virtual address is modified but is
mapped to a read-only shared library area because the perf tool doesn't understand
COW faults.

Using the MAP_SHARED bit tells the tool in this example the memory is private
and will not cause contention with other processes accessing the same shared
library area.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/sort.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index e016fc1..be675f4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,3 +1,4 @@
+#include <sys/mman.h>
 #include "sort.h"
 #include "hist.h"
 #include "comm.h"
@@ -1001,7 +1002,8 @@ sort__physid_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * assumed to be unity mapped.  Sort those on address then pid.
 	 */
 
-	if (l_map->maj || l_map->min || l_map->ino || l_map->ino_generation) {
+	if ((l_map->flags & MAP_SHARED) &&
+	   (l_map->maj || l_map->min || l_map->ino || l_map->ino_generation)) {
 		/* mmapped areas */
 
 		if (l_map->maj > r_map->maj) return -1;
-- 
1.7.11.7

