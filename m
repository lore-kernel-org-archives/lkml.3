Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3GXOQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:16:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45765 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab3GXOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Vince Weaver" <vincent.weaver@maine.edu>,
        "Oleg Nesterov" <oleg@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.874013700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [29/85] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/hw_breakpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -147,7 +147,7 @@ fetch_bp_busy_slots(struct bp_busy_slots
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -233,7 +233,7 @@ toggle_bp_slot(struct perf_event *bp, bo
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 

