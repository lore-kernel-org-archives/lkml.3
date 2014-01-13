Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaAMO2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaAMOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miao Xie <miaox@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 38/96] ftrace: Initialize the ftrace profiler for each possible cpu
Date: Mon, 13 Jan 2014 14:24:01 +0000
Message-Id: <1389623099-18783-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Xie <miaox@cn.fujitsu.com>

commit c4602c1c818bd6626178d6d3fcc152d9f2f48ac0 upstream.

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

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9d7ae0c..7b7455a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -688,7 +688,7 @@ static int ftrace_profile_init(void)
 	int cpu;
 	int ret = 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		ret = ftrace_profile_init_cpu(cpu);
 		if (ret)
 			break;
-- 
1.8.3.2

