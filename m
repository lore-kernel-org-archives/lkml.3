Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaGOQYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:24:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42126 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752794AbaGOQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:24:29 -0400
Date: Tue, 15 Jul 2014 12:24:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] tracing: instance_rmdir() leaks
 ftrace_event_file->filter
Message-ID: <20140715122426.7f2c8cd1@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Oleg Nesterov fixed a memory leak that happens if a user creates
a tracing instance, sets up a filter in an event, and then removes
that instance. The filter allocates memory that is never freed
when the instance is destroyed.

Please pull the latest trace-fixes-v3.16-rc5 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.16-rc5

Tag SHA1: 669ea50dfcff14f49119e15133c0b0eb32d1999a
Head SHA1: 2448e3493cb3874baa90725c87869455ebf11cd2


Oleg Nesterov (1):
      tracing: instance_rmdir() leaks ftrace_event_file->filter

----
 kernel/trace/trace_events.c | 1 +
 1 file changed, 1 insertion(+)
---------------------------
commit 2448e3493cb3874baa90725c87869455ebf11cd2
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Fri Jul 11 21:06:38 2014 +0200

    tracing: instance_rmdir() leaks ftrace_event_file->filter
    
    instance_rmdir() path destroys the event files but forgets to free
    file->filter. Change remove_event_file_dir() to free_event_filter().
    
    Link: http://lkml.kernel.org/p/20140711190638.GA19517@redhat.com
    
    Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
    Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
    Cc: stable@vger.kernel.org # 3.11+
    Fixes: f6a84bdc75b5 "tracing: Introduce remove_event_file_dir()"
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f99e0b3bca8c..2de53628689f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -470,6 +470,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
 
 	list_del(&file->list);
 	remove_subsystem(file->system);
+	free_event_filter(file->filter);
 	kmem_cache_free(file_cachep, file);
 }
 
