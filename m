Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3GDDkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:40:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3GDDkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:40:40 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=odXrFLFfAhoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BdHU2U2mihYA:10 a=Q00xHw_dJstCAtue8jQA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130704034038.819592356@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe event files are open
References: <20130704033347.807661713@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-kprobes-Fail-to-unregister-if-probe-event-fi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When one of the event files is opened, we need to prevent them from
being removed. Modules do with with the module owner set (automated
from the VFS layer).  The ftrace buffer instances have a ref count added
to the trace_array when the enabled file is opened (the others are not
that big of a deal, as they only reference the event calls which
still exist when an instance disappears). But kprobes and uprobes
do not have any protection.

 # cd /sys/kernel/debug/tracing
 # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
 # enable_probe() {
    sleep 10
    echo 1
 }
 # file=events/kprobes/sigprocmask/enable
 # enable_probe > $file &
 > kprobe_events

The above will corrupt the kprobe system, as the write to the enable
file will happen after the kprobe was deleted.

Trying to create the probe again fails:

 # echo 'p:sigprocmask sigprocmask' > kprobe_events
 # cat kprobe_events
p:kprobes/sigprocmask sigprocmask
 # ls events/kprobes/
enable  filter

Have the unregister probe fail when the event files are open, in use
are used by perf.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..ffcaf42 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -95,7 +95,7 @@ static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
 }
 
 static int register_probe_event(struct trace_probe *tp);
-static void unregister_probe_event(struct trace_probe *tp);
+static int unregister_probe_event(struct trace_probe *tp);
 
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
@@ -340,9 +340,12 @@ static int unregister_trace_probe(struct trace_probe *tp)
 	if (trace_probe_is_enabled(tp))
 		return -EBUSY;
 
+	/* Will fail if probe is being used by ftrace or perf */
+	if (unregister_probe_event(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
-	unregister_probe_event(tp);
 
 	return 0;
 }
@@ -621,7 +624,9 @@ static int release_all_trace_probes(void)
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
-		unregister_trace_probe(tp);
+		ret = unregister_trace_probe(tp);
+		if (ret)
+			goto end;
 		free_trace_probe(tp);
 	}
 
@@ -1242,11 +1247,15 @@ static int register_probe_event(struct trace_probe *tp)
 	return ret;
 }
 
-static void unregister_probe_event(struct trace_probe *tp)
+static int unregister_probe_event(struct trace_probe *tp)
 {
+	int ret;
+
 	/* tp->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tp->call);
-	kfree(tp->call.print_fmt);
+	ret = trace_remove_event_call(&tp->call);
+	if (!ret)
+		kfree(tp->call.print_fmt);
+	return ret;
 }
 
 /* Make a debugfs interface for controlling probe points */
-- 
1.7.10.4


