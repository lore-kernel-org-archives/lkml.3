Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3AaTWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab3AaTWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:22:12 -0500
Date: Thu, 31 Jan 2013 20:18:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] uprobes/tracing: Fully initialize
	uprobe_trace_consumer before uprobe_register()
Message-ID: <20130131191819.GA30437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131191752.GA30410@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_event_enable() does uprobe_register() and only after that sets
utc->tu and tu->consumer/flags. This can race with uprobe_dispatcher()
which can miss these assignments or see them out of order. Nothing
really bad can happen, but this doesn't look clean/safe.

And this does not allow to use uprobe_consumer->filter() we are going
to add, it is called by uprobe_register() and it needs utc->tu.

Change this code to initialize everything before uprobe_register(), and
reset tu->consumer/flags if it fails. We can't race with event_disable(),
the caller holds event_mutex, and if we could the code would be wrong
anyway.

In fact I think uprobe_trace_consumer should die, it buys nothing but
complicates the code. We can simply add uprobe_consumer into trace_uprobe.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 6563f00..7b75949 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -547,17 +547,18 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 		return -EINTR;
 
 	utc->cons.handler = uprobe_dispatcher;
+	utc->tu = tu;
+	tu->consumer = utc;
+	tu->flags |= flag;
+
 	ret = uprobe_register(tu->inode, tu->offset, &utc->cons);
 	if (ret) {
+		tu->consumer = NULL;
+		tu->flags &= ~flag;
 		kfree(utc);
-		return ret;
 	}
 
-	tu->flags |= flag;
-	utc->tu = tu;
-	tu->consumer = utc;
-
-	return 0;
+	return ret;
 }
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
-- 
1.5.5.1

