Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaBEWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:17:24 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40816 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaBEWRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:17:18 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 41/51] thermal,
 x86-pkg-temp: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:41:57 +0530
Message-ID: <20140205221156.19080.83761.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-2674-0000-0000-00000C94B1B7
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


Fix the thermal x86-pkg-temp code by using this latter form of callback
registration.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/thermal/x86_pkg_temp_thermal.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/x86_pkg_temp_thermal.c
index 972e1c7..55f9eac 100644
--- a/drivers/thermal/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/x86_pkg_temp_thermal.c
@@ -589,12 +589,12 @@ static int __init pkg_temp_thermal_init(void)
 	platform_thermal_package_rate_control =
 			pkg_temp_thermal_platform_thermal_rate_control;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	for_each_online_cpu(i)
 		if (get_core_online(i))
 			goto err_ret;
-	register_hotcpu_notifier(&pkg_temp_thermal_notifier);
-	put_online_cpus();
+	__register_hotcpu_notifier(&pkg_temp_thermal_notifier);
+	cpu_maps_update_done();
 
 	pkg_temp_debugfs_init(); /* Don't care if fails */
 
@@ -603,7 +603,7 @@ static int __init pkg_temp_thermal_init(void)
 err_ret:
 	for_each_online_cpu(i)
 		put_core_offline(i);
-	put_online_cpus();
+	cpu_maps_update_done();
 	kfree(pkg_work_scheduled);
 	platform_thermal_package_notify = NULL;
 	platform_thermal_package_rate_control = NULL;
@@ -616,8 +616,8 @@ static void __exit pkg_temp_thermal_exit(void)
 	struct phy_dev_entry *phdev, *n;
 	int i;
 
-	get_online_cpus();
-	unregister_hotcpu_notifier(&pkg_temp_thermal_notifier);
+	cpu_maps_update_begin();
+	__unregister_hotcpu_notifier(&pkg_temp_thermal_notifier);
 	mutex_lock(&phy_dev_list_mutex);
 	list_for_each_entry_safe(phdev, n, &phy_dev_list, list) {
 		/* Retore old MSR value for package thermal interrupt */
@@ -635,7 +635,7 @@ static void __exit pkg_temp_thermal_exit(void)
 	for_each_online_cpu(i)
 		cancel_delayed_work_sync(
 			&per_cpu(pkg_temp_thermal_threshold_work, i));
-	put_online_cpus();
+	cpu_maps_update_done();
 
 	kfree(pkg_work_scheduled);
 

