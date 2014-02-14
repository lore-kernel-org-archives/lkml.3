Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBNIEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:04:07 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42911 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaBNIEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:04:02 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 41/52] oprofile,
 nmi-timer: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Robert Richter <rric@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:28:32 +0530
Message-ID: <20140214075831.22701.70305.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-3864-0000-0000-00000C6BB493
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

	cpu_notifier_register_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_notifier_register_done();


Fix the nmi-timer code in oprofile by using this latter form of callback
registration.

Cc: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/oprofile/nmi_timer_int.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/nmi_timer_int.c b/drivers/oprofile/nmi_timer_int.c
index 76f1c93..9559829 100644
--- a/drivers/oprofile/nmi_timer_int.c
+++ b/drivers/oprofile/nmi_timer_int.c
@@ -108,8 +108,8 @@ static void nmi_timer_shutdown(void)
 	struct perf_event *event;
 	int cpu;
 
-	get_online_cpus();
-	unregister_cpu_notifier(&nmi_timer_cpu_nb);
+	cpu_notifier_register_begin();
+	__unregister_cpu_notifier(&nmi_timer_cpu_nb);
 	for_each_possible_cpu(cpu) {
 		event = per_cpu(nmi_timer_events, cpu);
 		if (!event)
@@ -119,7 +119,7 @@ static void nmi_timer_shutdown(void)
 		perf_event_release_kernel(event);
 	}
 
-	put_online_cpus();
+	cpu_notifier_register_done();
 }
 
 static int nmi_timer_setup(void)
@@ -132,20 +132,23 @@ static int nmi_timer_setup(void)
 	do_div(period, HZ);
 	nmi_timer_attr.sample_period = period;
 
-	get_online_cpus();
-	err = register_cpu_notifier(&nmi_timer_cpu_nb);
+	cpu_notifier_register_begin();
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
+			cpu_notifier_register_done();
+			nmi_timer_shutdown();
+			return err;
+		}
 	}
-	if (err)
-		nmi_timer_shutdown();
+
 out:
-	put_online_cpus();
+	cpu_notifier_register_done();
 	return err;
 }
 

