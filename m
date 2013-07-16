Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab3GPSCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:02:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3GPSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:02:30 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mCAVkOgLIqkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=B58MYnjVUS0A:10 a=v0K8d5DZXxS8PdBnlqsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373997748.6458.26.camel@gandalf.local.home>
Subject: [PATCH] Thermal: Fix lockup of cpu_down()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Date: Tue, 16 Jul 2013 14:02:28 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f1a18a105 "Thermal: CPU Package temperature thermal" had code
that did a get_online_cpus(), run a loop and then do a
put_online_cpus(). The problem is that the loop had an error exit that
would skip the put_online_cpus() part.

In the error exit part of the function, it also did a get_online_cpus(),
run a loop and then put_online_cpus(). The only way to get to the error
exit part is with get_online_cpus() already performed. If this error
condition is hit, the system will be prevented from taking CPUs offline.
The process taking the CPU offline will lock up hard.

Removing the get_online_cpus() removes the lockup as the hotplug CPU
refcount is back to zero.

This was bisected with ktest.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/x86_pkg_temp_thermal.c
index 5de56f6..d47624c 100644
--- a/drivers/thermal/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/x86_pkg_temp_thermal.c
@@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(void)
 	return 0;
 
 err_ret:
-	get_online_cpus();
 	for_each_online_cpu(i)
 		put_core_offline(i);
 	put_online_cpus();


