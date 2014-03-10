Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaCJUll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:41:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56269 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaCJUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:41:38 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 44/52] hwmon,
 coretemp: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <jdelvare@suse.de>, Ingo Molnar <mingo@kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:11:11 +0530
Message-ID: <20140310204111.10746.4119.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-6102-0000-0000-0000051B2F81
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


Fix the hwmon coretemp code by using this latter form of callback
registration.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: lm-sensors@lm-sensors.org
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/hwmon/coretemp.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index bbb0b0d..746a6ad 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -849,20 +849,20 @@ static int __init coretemp_init(void)
 	if (err)
 		goto exit;
 
-	get_online_cpus();
+	cpu_notifier_register_begin();
 	for_each_online_cpu(i)
 		get_core_online(i);
 
 #ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
-		put_online_cpus();
+		cpu_notifier_register_done();
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
 #endif
 
-	register_hotcpu_notifier(&coretemp_cpu_notifier);
-	put_online_cpus();
+	__register_hotcpu_notifier(&coretemp_cpu_notifier);
+	cpu_notifier_register_done();
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
@@ -877,8 +877,8 @@ static void __exit coretemp_exit(void)
 {
 	struct pdev_entry *p, *n;
 
-	get_online_cpus();
-	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
+	cpu_notifier_register_begin();
+	__unregister_hotcpu_notifier(&coretemp_cpu_notifier);
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
 		platform_device_unregister(p->pdev);
@@ -886,7 +886,7 @@ static void __exit coretemp_exit(void)
 		kfree(p);
 	}
 	mutex_unlock(&pdev_list_mutex);
-	put_online_cpus();
+	cpu_notifier_register_done();
 	platform_driver_unregister(&coretemp_driver);
 }
 

