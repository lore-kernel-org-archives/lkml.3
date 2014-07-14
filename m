Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaGNET5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:19:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:19097 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaGNETw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:19:52 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: Do not copy old hash when resetting.
Date: Mon, 14 Jul 2014 12:10:00 +0800
Message-ID: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are going to reset hash, we don't need to duplicate old hash
and remove every entries right after allocation.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3..52d6931 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3471,14 +3471,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	else
 		orig_hash = &ops->notrace_hash;
 
-	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!reset)
+		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	else
+		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
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
1.8.4

