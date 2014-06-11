Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaFKIHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:07:03 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52663 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaFKIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:06:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/2] tracing: Do not copy hash if O_TRUNC is set
Date: Wed, 11 Jun 2014 17:06:54 +0900
Message-Id: <1402474014-28655-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
References: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a filter file is open for writing and O_TRUNC is set, there's no
need to copy and free the filter entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ddfda763ded7..13885590a184 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2759,7 +2759,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
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
@@ -2768,10 +2774,6 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
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

