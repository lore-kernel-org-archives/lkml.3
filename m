Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3BCNNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:13:48 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40450 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3BCNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:13:45 -0500
Message-ID: <510E6280.3070203@gmail.com>
Date: Sun, 03 Feb 2013 21:13:36 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: "Eric W. Biederman" <ebiederm@xmission.com>, benh@kernel.crashing.org,
        mahesh@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/proc/vmcore.c: Put if tests in the top of the while loop
 to reduce duplication
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

In function read_vmcore, two if tests are duplicate. Change the position
of them could reduce the duplication. This change does not affect
the behaviour of the function.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 fs/proc/vmcore.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0d5071d..c74a901 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -175,15 +175,16 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
 	if (!curr_m)
         	return -EINVAL;
-	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-		tsz = buflen;
-
-	/* Calculate left bytes in current memory segment. */
-	nr_bytes = (curr_m->size - (start - curr_m->paddr));
-	if (tsz > nr_bytes)
-		tsz = nr_bytes;
 
 	while (buflen) {
+		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
+			tsz = buflen;
+
+		/* Calculate left bytes in current memory segment. */
+		nr_bytes = (curr_m->size - (start - curr_m->paddr));
+		if (tsz > nr_bytes)
+			tsz = nr_bytes;
+
 		tmp = read_from_oldmem(buffer, tsz, &start, 1);
 		if (tmp < 0)
 			return tmp;
@@ -198,12 +199,6 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 						struct vmcore, list);
 			start = curr_m->paddr;
 		}
-		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-			tsz = buflen;
-		/* Calculate left bytes in current memory segment. */
-		nr_bytes = (curr_m->size - (start - curr_m->paddr));
-		if (tsz > nr_bytes)
-			tsz = nr_bytes;
 	}
 	return acc;
 }
-- 
1.7.1
