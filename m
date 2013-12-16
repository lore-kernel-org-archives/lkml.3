Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3LPHSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 02:18:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3LPHSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 02:18:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,493,1384272000"; 
   d="scan'208";a="9267210"
From: Miao Xie <miaox@cn.fujitsu.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: initialize the ftrace profile for each possible cpu
Date: Mon, 16 Dec 2013 15:20:01 +0800
Message-Id: <1387178401-10619-1-git-send-email-miaox@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 15:18:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/16 15:18:23,
	Serialize complete at 2013/12/16 15:18:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just initialize the ftrace profile for each online cpu currently, this
implementation has two problems:
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

So it is better that initialize the ftrace profile for each possible cpu
every time we enable the function profile, not only for each online cpu.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.8.3.1

