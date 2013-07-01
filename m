Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3GAUK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3GAUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 2/8] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
Date: Mon,  1 Jul 2013 13:10:34 -0700
Message-Id: <20130701200233.512652711@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200232.909858308@linuxfoundation.org>
References: <20130701200232.909858308@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/hw_breakpoint.c |    4 ++--
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
 


