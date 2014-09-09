Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaIIVtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:49:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaIIVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:49:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trace/trace_stat: Fix return values in error handling paths
Date: Tue,  9 Sep 2014 22:49:41 +0100
Message-Id: <1410299381-20108-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_stat_init() was always returning '0', even on the error paths.  It
now returns -ENODEV if tracing_init_dentry() fails or -ENOMEM if it fails
to created the 'trace_stat' debugfs directory.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_stat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index cb70ac12cfe4..b7a6fcebfbb7 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -277,19 +277,23 @@ static int tracing_stat_init(void)
 
 	d_tracing = tracing_init_dentry();
 	if (!d_tracing)
-		return 0;
+		return -ENODEV;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
-	if (!stat_dir)
+	if (!stat_dir) {
 		pr_warning("Could not create debugfs "
 			   "'trace_stat' entry\n");
+		return -ENOMEM;
+	}
 	return 0;
 }
 
 static int init_stat_file(struct stat_session *session)
 {
-	if (!stat_dir && tracing_stat_init())
-		return -ENODEV;
+	int ret;
+
+	if (!stat_dir && (ret = tracing_stat_init()))
+		return ret;
 
 	session->file = debugfs_create_file(session->ts->name, 0644,
 					    stat_dir,
-- 
1.9.1

