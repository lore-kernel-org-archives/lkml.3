Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbaGOSvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843AbaGOSuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:50:21 -0400
Date: Tue, 15 Jul 2014 20:48:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] tracing/uprobes: kill the dead
	TRACE_EVENT_FL_USE_CALL_FILTER logic
Message-ID: <20140715184824.GA20505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715184753.GA20470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_trace_uprobe() sets TRACE_EVENT_FL_USE_CALL_FILTER for unknown
reason and this is simply wrong. Fortunately this has no effect because
register_uprobe_event() clears call->flags after that.

Kill both. This trace_uprobe was kzalloc'ed and we rely on this fact
anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3c9b97e..33ff6a2 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -265,7 +265,6 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
-	tu->tp.call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
@@ -1292,7 +1291,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
-	call->flags = 0;
+
 	call->class->reg = trace_uprobe_register;
 	call->data = tu;
 	ret = trace_add_event_call(call);
-- 
1.5.5.1

