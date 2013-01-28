Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab3A1S0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:26:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3A1S0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:26:11 -0500
Date: Mon, 28 Jan 2013 19:24:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] uprobes: Ensure inode != NULL in create_trace_uprobe()
Message-ID: <20130128182450.GA18300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182423.GA18273@redhat.com>
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
index 0c05288..f49ccf9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -349,6 +349,8 @@ static int create_trace_uprobe(int argc, char **argv)
 
 	inode = igrab(path.dentry->d_inode);
 	path_put(&path);
+	if (!inode)
+		goto fail_address_parse;
 
 	ret = kstrtoul(arg, 0, &offset);
 	if (ret)
@@ -645,7 +647,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	struct uprobe_trace_consumer *utc;
 	int ret = 0;
 
-	if (!tu->inode || tu->consumer)
+	if (tu->consumer)
 		return -EINTR;
 
 	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
@@ -670,7 +672,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!tu->inode || !tu->consumer)
+	if (!tu->consumer)
 		return;
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
-- 
1.5.5.1

