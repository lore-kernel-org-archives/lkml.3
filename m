Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3GBLLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:11:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3GBLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 39/50] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
Date: Tue,  2 Jul 2013 12:07:27 +0100
Message-Id: <1372763258-20664-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c790b0ad23f427c7522ffed264706238c57c007e upstream.

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
Link: http://lkml.kernel.org/r/20130620155009.GA6327@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/hw_breakpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index bb38c4d..fc8bfcf 100644
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
1.8.1.2

