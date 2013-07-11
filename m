Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3GKAmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:42:16 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33691 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3GKAmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:42:14 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 2/2] tracing: Fix error handling to ensure instances can always be removed
Date: Wed, 10 Jul 2013 17:34:34 -0700
Message-Id: <1373502874-1706-2-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373502874-1706-1-git-send-email-azl@google.com>
References: <1373502874-1706-1-git-send-email-azl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove debugfs directories for tracing instances during creation if an error
occurs causing the trace_array for that instance to not be added to
ftrace_trace_arrays. If the directory continues to exist after the error, it
cannot be removed because the respective trace_array is not in
ftrace_trace_arrays.

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ca2743b..4ea9967 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5985,8 +5985,10 @@ static int new_instance_create(const char *name)
 		goto out_free_tr;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
-	if (ret)
+	if (ret) {
+		debugfs_remove_recursive(tr->dir);
 		goto out_free_tr;
+	}
 
 	init_tracer_debugfs(tr, tr->dir);
 
-- 
1.8.3

