Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbaGCQMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759160AbaGCQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:27 -0400
Message-Id: <20140703161226.246757842@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 16/21] ftrace: Do not copy hash if O_TRUNC is set
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0016-ftrace-Do-not-copy-hash-if-O_TRUNC-is-set.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When a filter file is open for writing and O_TRUNC is set, there's no
need to copy and free the filter entries.

Link: http://lkml.kernel.org/p/1402474014-28655-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e14ff4c1713e..232b898eebbd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3010,7 +3010,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		hash = ops->filter_hash;
 
 	if (file->f_mode & FMODE_WRITE) {
-		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
+		const int size_bits = FTRACE_HASH_DEFAULT_BITS;
+
+		if (file->f_flags & O_TRUNC)
+			iter->hash = alloc_ftrace_hash(size_bits);
+		else
+			iter->hash = alloc_and_copy_ftrace_hash(size_bits, hash);
+
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
 			kfree(iter);
@@ -3019,10 +3025,6 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	}
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC))
-		ftrace_filter_reset(iter->hash);
-
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 
-- 
2.0.0


