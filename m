Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3AaTT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:19:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3AaTTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:19:24 -0500
Date: Thu, 31 Jan 2013 20:18:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] uprobes/tracing: Ensure inode != NULL in
	create_trace_uprobe()
Message-ID: <20130131191822.GA30444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131191752.GA30410@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_event_enable/disable() check tu->inode != NULL at the start.
This is ugly, if igrab() can fail create_trace_uprobe() should not
succeed and "postpone" the failure.

Note: alloc_uprobe() should probably check igrab() != NULL as well.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 7b75949..f02bbec 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -255,6 +255,8 @@ static int create_trace_uprobe(int argc, char **argv)
 
 	inode = igrab(path.dentry->d_inode);
 	path_put(&path);
+	if (!inode)
+		goto fail_address_parse;
 
 	ret = kstrtoul(arg, 0, &offset);
 	if (ret)
@@ -539,7 +541,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	struct uprobe_trace_consumer *utc;
 	int ret = 0;
 
-	if (!tu->inode || tu->consumer)
+	if (tu->consumer)
 		return -EINTR;
 
 	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
@@ -563,7 +565,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!tu->inode || !tu->consumer)
+	if (!tu->consumer)
 		return;
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
-- 
1.5.5.1

