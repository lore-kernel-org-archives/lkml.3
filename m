Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaBLIbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:31:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbaBLIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <rostedt@goodmis.org>,
        "Miao Xie" <miaox@cn.fujitsu.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.308570580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 43/79] ftrace: Initialize the ftrace profiler for each
 possible cpu
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -618,7 +618,7 @@ static int ftrace_profile_init(void)
 	int cpu;
 	int ret = 0;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		ret = ftrace_profile_init_cpu(cpu);
 		if (ret)
 			break;

