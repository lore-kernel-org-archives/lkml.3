Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966026AbaGSNRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:11686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755556AbaGSNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:17 -0400
Message-Id: <20140719131614.872713789@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Wang Nan <wangnan0@huawei.com>
Subject: [for-next][PATCH 31/32] ftrace: Do not copy old hash when resetting
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0031-ftrace-Do-not-copy-old-hash-when-resetting.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Nan <wangnan0@huawei.com>

Do not waste time copying the old hash if the hash is going to be
reset. Just allocate a new hash and free the old one, as that is
the same result as copying te old one and then resetting it.

Link: http://lkml.kernel.org/p/1405384820-48837-1-git-send-email-wangnan0@huawei.com

Signed-off-by: Wang Nan <wangnan0@huawei.com>
[ SDR: Removed unused ftrace_filter_reset() function ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4c61f28a08e0..762806026561 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2949,13 +2949,6 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
 	return iter ? 0 : -ENOMEM;
 }
 
-static void ftrace_filter_reset(struct ftrace_hash *hash)
-{
-	mutex_lock(&ftrace_lock);
-	ftrace_hash_clear(hash);
-	mutex_unlock(&ftrace_lock);
-}
-
 /**
  * ftrace_regex_open - initialize function tracer filter files
  * @ops: The ftrace_ops that hold the hash filters
@@ -3720,14 +3713,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	else
 		orig_hash = &ops->notrace_hash;
 
-	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (reset)
+		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
+	else
+		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+
 	if (!hash) {
 		ret = -ENOMEM;
 		goto out_regex_unlock;
 	}
 
-	if (reset)
-		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
 		ret = -EINVAL;
 		goto out_regex_unlock;
-- 
2.0.1


