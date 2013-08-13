Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3HMQEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692Ab3HMP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:34 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=S-olR7q8SFQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AVKxA0uPELEA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155830.200189355@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vince Weaver <vincent.weaver@maine.edu>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [42/88] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0042-hw_breakpoint-Use-cpu_possible_mask-in-reserve-relea.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit c790b0ad23f427c7522ffed264706238c57c007e ]

fetch_bp_busy_slots() and toggle_bp_slot() use
for_each_online_cpu(), this is obviously wrong wrt cpu_up() or
cpu_down(), we can over/under account the per-cpu numbers.

For example:

	# echo 0 >> /sys/devices/system/cpu/cpu1/online
	# perf record -e mem:0x10 -p 1 &
	# echo 1 >> /sys/devices/system/cpu/cpu1/online
	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10 -C1 -a &
	# taskset -p 0x2 1

triggers the same WARN_ONCE("Can't find any breakpoint slot") in
arch_install_hw_breakpoint().

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20130620155009.GA6327@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/hw_breakpoint.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..4f06bf9 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -147,7 +147,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -233,7 +233,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
-- 
1.7.10.4


