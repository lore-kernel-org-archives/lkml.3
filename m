Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaBNIJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:09:46 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55993 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBNIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:00:12 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 24/52] x86, intel,
 rapl: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:24:41 +0530
Message-ID: <20140214075441.22701.79.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-9574-0000-0000-00000BF2FC13
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


Fix the intel rapl code in x86 by using this latter form of callback
registration.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/perf_event_intel_rapl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 5ad35ad..059218e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -646,19 +646,20 @@ static int __init rapl_pmu_init(void)
 		/* unsupported */
 		return 0;
 	}
-	get_online_cpus();
+
+	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu) {
 		rapl_cpu_prepare(cpu);
 		rapl_cpu_init(cpu);
 	}
 
-	perf_cpu_notifier(rapl_cpu_notifier);
+	__perf_cpu_notifier(rapl_cpu_notifier);
 
 	ret = perf_pmu_register(&rapl_pmu_class, "power", -1);
 	if (WARN_ON(ret)) {
 		pr_info("RAPL PMU detected, registration failed (%d), RAPL PMU disabled\n", ret);
-		put_online_cpus();
+		cpu_notifier_register_done();
 		return -1;
 	}
 
@@ -672,7 +673,7 @@ static int __init rapl_pmu_init(void)
 		hweight32(rapl_cntr_mask),
 		ktime_to_ms(pmu->timer_interval));
 
-	put_online_cpus();
+	cpu_notifier_register_done();
 
 	return 0;
 }

