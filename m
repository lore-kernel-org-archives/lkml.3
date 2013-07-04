Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab3GDDkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:40:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3GDDkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:40:40 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0vUztAmQDFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ZsfqWoJG6IoA:10 a=Tl9GD7HQPryz-F9VVIEA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130704033347.807661713@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:47 -0400
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
Subject: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between opening probe event files and deleting probe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently there exists a race with deleting a kprobe or uprobe and
a user opening the probe event file or using perf events.

The problem stems from not being able to take the probe_lock from the
unregister code because we may have the event_mutex at the time, and
the event mutex may be taken with the probe_lock held.

To solve this, the events get a ref count (using the flags field), where
when an event file is opened, the ftrace_event_call ref count increments.
Then this is checked under event_mutex and if set, the unregistering
of the probe will fail.

Here's a test that shows how things break:

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

After applying these patches, the "> kprobe_events" fails due to the
event being busy.

Masami, please review these patches and give your ack.

Srikar, can you please review the last patch. I didn't test uprobes
with this. I'll do that after the 4th.

Thanks,

-- Steve


Oleg Nesterov (1):
      tracing: trace_remove_event_call() should fail if call/file is in use

Steven Rostedt (Red Hat) (3):
      tracing: Add ref count to ftrace_event_call
      tracing/kprobes: Fail to unregister if probe event files are open
      tracing/uprobes: Fail to unregister if probe event files are open

----
 include/linux/ftrace_event.h |    8 +++-
 kernel/trace/trace_events.c  |  109 +++++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_kprobe.c  |   21 +++++---
 kernel/trace/trace_uprobe.c  |   48 ++++++++++++++-----
 4 files changed, 160 insertions(+), 26 deletions(-)

