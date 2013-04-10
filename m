Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab3DJASX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:18:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46928 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765442Ab3DJASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:18:21 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-fd-5164afcad3b1
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] tracing: Check cpu file on tracing_release()
Date: Wed, 10 Apr 2013 09:18:13 +0900
Message-Id: <1365553093-10180-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It looks like tracing_release() lacks checking iter->cpu_file so that
closing a per_cpu trace file would attempt to close all cpu buffers.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7270460cfe3c..0beddcb80509 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2883,7 +2883,13 @@ static int tracing_release(struct inode *inode, struct file *file)
 	WARN_ON(!tr->ref);
 	tr->ref--;
 
-	for_each_tracing_cpu(cpu) {
+	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
+		for_each_tracing_cpu(cpu) {
+			if (iter->buffer_iter[cpu])
+				ring_buffer_read_finish(iter->buffer_iter[cpu]);
+		}
+	} else {
+		cpu = iter->cpu_file;
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
-- 
1.7.11.7

