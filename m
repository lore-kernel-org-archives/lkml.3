Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaBEWRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:17:50 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60527 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaBEWRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:17:44 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 43/51] hwmon,
 via-cputemp: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:42:19 +0530
Message-ID: <20140205221218.19080.8681.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-5490-0000-0000-000004E467B5
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


Fix the hwmon via-cputemp code by using this latter form of callback
registration.

Cc: Jean Delvare <jdelvare@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/hwmon/via-cputemp.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 38944e9..a5c9b2b 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -319,7 +319,7 @@ static int __init via_cputemp_init(void)
 	if (err)
 		goto exit;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
 
@@ -339,14 +339,14 @@ static int __init via_cputemp_init(void)
 
 #ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
-		put_online_cpus();
+		cpu_maps_update_done();
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
 #endif
 
-	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
-	put_online_cpus();
+	__register_hotcpu_notifier(&via_cputemp_cpu_notifier);
+	cpu_maps_update_done();
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
@@ -361,8 +361,8 @@ static void __exit via_cputemp_exit(void)
 {
 	struct pdev_entry *p, *n;
 
-	get_online_cpus();
-	unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
+	cpu_maps_update_begin();
+	__unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		platform_device_unregister(p->pdev);
@@ -370,7 +370,7 @@ static void __exit via_cputemp_exit(void)
 		kfree(p);
 	}
 	mutex_unlock(&pdev_list_mutex);
-	put_online_cpus();
+	cpu_maps_update_done();
 	platform_driver_unregister(&via_cputemp_driver);
 }
 

