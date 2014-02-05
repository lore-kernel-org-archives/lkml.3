Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaBEWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:16:59 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49649 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaBEWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:16:56 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 39/51] oprofile,
 nmi-timer: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Robert Richter <rric@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:41:32 +0530
Message-ID: <20140205221132.19080.60842.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-6102-0000-0000-000004E4490D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems that want to register CPU hotplug callbacks, as well as perform
initialization for the CPUs that are already online, often do it as shown
below:

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

This is wrong, since it is prone to ABBA deadlocks involving the
cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
with CPU hotplug operations).

Instead, the correct and race-free way of performing the callback
registration is:

	cpu_maps_update_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_maps_update_done();


Fix the nmi-timer code in oprofile by using this latter form of callback
registration.

Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/oprofile/nmi_timer_int.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/nmi_timer_int.c b/drivers/oprofile/nmi_timer_int.c
index 76f1c93..bbceee6 100644
--- a/drivers/oprofile/nmi_timer_int.c
+++ b/drivers/oprofile/nmi_timer_int.c
@@ -108,8 +108,8 @@ static void nmi_timer_shutdown(void)
 	struct perf_event *event;
 	int cpu;
 
-	get_online_cpus();
-	unregister_cpu_notifier(&nmi_timer_cpu_nb);
+	cpu_maps_update_begin();
+	__unregister_cpu_notifier(&nmi_timer_cpu_nb);
 	for_each_possible_cpu(cpu) {
 		event = per_cpu(nmi_timer_events, cpu);
 		if (!event)
@@ -119,7 +119,7 @@ static void nmi_timer_shutdown(void)
 		perf_event_release_kernel(event);
 	}
 
-	put_online_cpus();
+	cpu_maps_update_done();
 }
 
 static int nmi_timer_setup(void)
@@ -132,20 +132,23 @@ static int nmi_timer_setup(void)
 	do_div(period, HZ);
 	nmi_timer_attr.sample_period = period;
 
-	get_online_cpus();
-	err = register_cpu_notifier(&nmi_timer_cpu_nb);
+	cpu_maps_update_begin();
+	err = __register_cpu_notifier(&nmi_timer_cpu_nb);
 	if (err)
 		goto out;
+
 	/* can't attach events to offline cpus: */
 	for_each_online_cpu(cpu) {
 		err = nmi_timer_start_cpu(cpu);
-		if (err)
-			break;
+		if (err) {
+			cpu_maps_update_done();
+			nmi_timer_shutdown();
+			return err;
+		}
 	}
-	if (err)
-		nmi_timer_shutdown();
+
 out:
-	put_online_cpus();
+	cpu_maps_update_done();
 	return err;
 }
 

