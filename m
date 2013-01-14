Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3ANC4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:56:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3ANC4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:56:37 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: [PATCH] Tracing: fix regression of trace_pipe
Date: Mon, 14 Jan 2013 10:54:11 +0800
Message-Id: <1358132051-5410-1-git-send-email-bo.li.liu@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0fb9656d changes the behaviour of trace_pipe, ie. it makes trace_pipe
return if we've read something and tracing is enabled, and this means that
we have to 'cat trace_pipe' again and again while running tests.

IMO the right way is if tracing is enabled, we always block and wait for
ring buffer, or we may lose what we want since ring buffer's size is limited.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e512567..fc76beb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3452,7 +3452,7 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EINTR;
 
 		/*
-		 * We block until we read something and tracing is enabled.
+		 * We block until we read something and tracing is disabled.
 		 * We still block if tracing is disabled, but we have never
 		 * read anything. This allows a user to cat this file, and
 		 * then enable tracing. But after we have read something,
@@ -3460,7 +3460,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (tracing_is_enabled() && iter->pos)
+		if (!tracing_is_enabled() && iter->pos)
 			break;
 	}
 
-- 
1.7.7.6

