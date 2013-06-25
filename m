Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3FYIRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:17:39 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:7624 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3FYIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:17:37 -0400
Message-ID: <51C951BF.1090509@huawei.com>
Date: Tue, 25 Jun 2013 16:15:59 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/kprobes: move free_trace_probe into unregister_trace_probe
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have no good reason to call free_trace_probe
every time when unregister_trace_probe return 0.

Move free_trace_probe into unregister_trace_probe,
make code simpler.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_kprobe.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98..f193c38 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -401,6 +401,7 @@ static int unregister_trace_probe(struct trace_probe *tp)
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 	unregister_probe_event(tp);
+	free_trace_probe(tp);

 	return 0;
 }
@@ -419,7 +420,6 @@ static int register_trace_probe(struct trace_probe *tp)
 		ret = unregister_trace_probe(old_tp);
 		if (ret < 0)
 			goto end;
-		free_trace_probe(old_tp);
 	}

 	/* Register new event */
@@ -550,8 +550,6 @@ static int create_trace_probe(int argc, char **argv)
 		}
 		/* delete an event */
 		ret = unregister_trace_probe(tp);
-		if (ret == 0)
-			free_trace_probe(tp);
 		mutex_unlock(&probe_lock);
 		return ret;
 	}
@@ -680,7 +678,6 @@ static int release_all_trace_probes(void)
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
 		unregister_trace_probe(tp);
-		free_trace_probe(tp);
 	}

 end:
-- 
1.7.9.7


