Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936814Ab3DJPIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab3DJPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:08:12 -0400
Date: Wed, 10 Apr 2013 16:58:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: [PATCH 0/1] uprobes/tracing: Don't pass addr=ip to
	perf_trace_buf_submit()
Message-ID: <20130410145818.GA30670@redhat.com>
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51628DF8.6030102@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Masami Hiramatsu wrote:
>
> (2013/04/06 0:01), Oleg Nesterov wrote:
> >
> > Masami, perhaps you can also answer the question I asked in 0/4
> > marc.info/?l=linux-kernel&m=136458107403835 ?
> >
> > 	Off-topic question... Why uprobe_perf_func() passes "addr = ip" to
> > 	perf_trace_buf_submit() ? This just sets perf_sample_data->addr for
> > 	PERF_SAMPLE_ADDR, do we really need this? and we already have
> > 	perf_sample_data->ip initialized by perf.
> >
> > kprobe_perf_func() and kretprobe_perf_func() do the same.
> >
>
> Good catch! I guess that I might misunderstood that it was used
> for sampling execution address. It should be replaced with (u64)0,
> as perf_trace_##call() does.

Thanks!

How about this trivial cleanup then? If I have your ack I'll add this
patch to other pending changes.

And... Cough, another question ;) To simplify, lets discuss kprobe_perf_func()
only. Suppose that a task hits the kprobe but this task/cpu doesn't have
a counter. Can't we avoid perf_trace_buf_prepare/submit in this case?
IOW, what do you think about the change below?

Oleg.

--- x/kernel/trace/trace_kprobe.c
+++ x/kernel/trace/trace_kprobe.c
@@ -985,6 +985,10 @@ static __kprobes void kprobe_perf_func(s
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1001,7 +1005,6 @@ static __kprobes void kprobe_perf_func(s
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
 					entry->ip, 1, regs, head, NULL);
 }

