Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3LQWcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:32:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63105 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754461Ab3LQWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:32:46 -0500
Date: Tue, 17 Dec 2013 17:32:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>,
        stable <stable@vger.kernel.org>
Subject: [GIT PULL] ftrace: Initialize the ftrace profiler for each possible
 cpu
Message-ID: <20131217173244.79a44103@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This fixes a long standing bug in the ftrace profiler.
The problem is that the profiler only initializes the online
CPUs, and not possible CPUs. This causes issues if the user takes
CPUs online or offline while the profiler is running.

If we online a CPU after starting the profiler, we lose all the
trace information on the CPU going online.

If we offline a CPU after running a test and start a new test, it
will not clear the old data from that CPU.

This bug causes incorrect data to be reported to the user if they
online or offline CPUs during the profiling.

Please pull the latest trace-fixes-v3.13-rc2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.13-rc2

Tag SHA1: bf7af594d3f90d7715db2b19b2579cf88fac0a58
Head SHA1: c4602c1c818bd6626178d6d3fcc152d9f2f48ac0


Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

----
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit c4602c1c818bd6626178d6d3fcc152d9f2f48ac0
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Mon Dec 16 15:20:01 2013 +0800

    ftrace: Initialize the ftrace profiler for each possible cpu
    
    Ftrace currently initializes only the online CPUs. This implementation has
    two problems:
    - If we online a CPU after we enable the function profile, and then run the
      test, we will lose the trace information on that CPU.
      Steps to reproduce:
      # echo 0 > /sys/devices/system/cpu/cpu1/online
      # cd <debugfs>/tracing/
      # echo <some function name> >> set_ftrace_filter
      # echo 1 > function_profile_enabled
      # echo 1 > /sys/devices/system/cpu/cpu1/online
      # run test
    - If we offline a CPU before we enable the function profile, we will not clear
      the trace information when we enable the function profile. It will trouble
      the users.
      Steps to reproduce:
      # cd <debugfs>/tracing/
      # echo <some function name> >> set_ftrace_filter
      # echo 1 > function_profile_enabled
      # run test
      # cat trace_stat/function*
      # echo 0 > /sys/devices/system/cpu/cpu1/online
      # echo 0 > function_profile_enabled
      # echo 1 > function_profile_enabled
      # cat trace_stat/function*
      # run test
      # cat trace_stat/function*
    
    So it is better that we initialize the ftrace profiler for each possible cpu
    every time we enable the function profile instead of just the online ones.
    
    Link: http://lkml.kernel.org/r/1387178401-10619-1-git-send-email-miaox@cn.fujitsu.com
    
    Cc: stable@vger.kernel.org # 2.6.31+
    Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0e9f9ea..72a0f81 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -775,7 +775,7 @@ static int ftrace_profile_init(void)
 	int cpu;
 	int ret = 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		ret = ftrace_profile_init_cpu(cpu);
 		if (ret)
 			break;
