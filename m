Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3AUVVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3AUVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:29 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=TUtcM5IvybkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=V7PpXP85_1cA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=3gRumsna6GbH_Khi68kA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=yBKBg3l6v9-5Xem1:21 a=58G-PIjQtznjs7H2:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211727.903605908@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jovi Zhang <bookjovi@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 04/13 -next] tracing: Verify target file before registering a uprobe event
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Verify-target-file-before-registering-a-upro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

Without this patch, we can register a uprobe event for a directory.
Enabling such a uprobe event would anyway fail.

Example:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

However dirctories cannot be valid targets for uprobe.
Hence verify if the target is a regular file during the probe
registration.

Link: http://lkml.kernel.org/r/20130103004212.690763002@goodmis.org

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
[ cleaned up whitespace and removed redundant IS_DIR() check ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c86e6d4..87b6db4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -258,6 +258,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;
 
 	inode = igrab(path.dentry->d_inode);
+	if (!S_ISREG(inode->i_mode)) {
+		ret = -EINVAL;
+		goto fail_address_parse;
+	}
 
 	argc -= 2;
 	argv += 2;
@@ -356,7 +360,7 @@ fail_address_parse:
 	if (inode)
 		iput(inode);
 
-	pr_info("Failed to parse address.\n");
+	pr_info("Failed to parse address or file.\n");
 
 	return ret;
 }
-- 
1.7.10.4


