Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbaELPOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:14:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63058 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758671AbaELPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:07 -0400
Message-Id: <20140512151203.583791492@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 06/13] ftrace: Remove boolean of hash_enable and hash_disable
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-ftrace-Remove-boolean-of-hash_enable-and-hash_disabl.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 4104d326b670 "ftrace: Remove global function list and call
function directly" cleaned up the global_ops filtering and made
the code simpler, but it left a variable "hash_enable" that was used
to know if the hash functions should be updated or not. It was
updated if the global_ops did not override them. As the global_ops
are now no different than any other ftrace_ops, the hash always
gets updated and there's no reason to use the hash_enable boolean.

The same goes for hash_disable used in ftrace_shutdown().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 38e5cf7..2c99d1f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2042,7 +2042,6 @@ static void ftrace_startup_enable(int command)
 
 static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
-	bool hash_enable = true;
 	int ret;
 
 	if (unlikely(ftrace_disabled))
@@ -2056,8 +2055,8 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	command |= FTRACE_UPDATE_CALLS;
 
 	ops->flags |= FTRACE_OPS_FL_ENABLED;
-	if (hash_enable)
-		ftrace_hash_rec_enable(ops, 1);
+
+	ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
 
@@ -2066,7 +2065,6 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 
 static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
-	bool hash_disable = true;
 	int ret;
 
 	if (unlikely(ftrace_disabled))
@@ -2084,8 +2082,7 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
-	if (hash_disable)
-		ftrace_hash_rec_disable(ops, 1);
+	ftrace_hash_rec_disable(ops, 1);
 
 	if (!global_start_up)
 		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
-- 
1.8.5.3


