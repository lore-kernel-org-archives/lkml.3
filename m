Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaBNIDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:03:16 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48761 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaBNIDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:03:10 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 37/52] acpi-cpufreq: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:27:37 +0530
Message-ID: <20140214075736.22701.78024.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-6102-0000-0000-000004F22F32
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


Fix the acpi-cpufreq code by using this latter form of callback registration.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: cpufreq@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/acpi-cpufreq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 18448a7..245ae078e 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -907,15 +907,16 @@ static void __init acpi_cpufreq_boost_init(void)
 
 		acpi_cpufreq_driver.boost_supported = true;
 		acpi_cpufreq_driver.boost_enabled = boost_state(0);
-		get_online_cpus();
+
+		cpu_notifier_register_begin();
 
 		/* Force all MSRs to the same value */
 		boost_set_msrs(acpi_cpufreq_driver.boost_enabled,
 			       cpu_online_mask);
 
-		register_cpu_notifier(&boost_nb);
+		__register_cpu_notifier(&boost_nb);
 
-		put_online_cpus();
+		cpu_notifier_register_done();
 	}
 }
 

