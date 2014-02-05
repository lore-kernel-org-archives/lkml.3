Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaBEWPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:15:36 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36772 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbaBEWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:15:29 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 30/51] powercap,
 intel-rapl: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:40:07 +0530
Message-ID: <20140205221006.19080.85166.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-8256-0000-0000-00000B524C49
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


Fix the intel-rapl code in the powercap driver by using this latter form
of callback registration. But retain the calls to get/put_online_cpus(),
since they also protect the function rapl_cleanup_data(). By nesting
get/put_online_cpus() *inside* cpu_maps_update_begin/done(), we avoid
the ABBA deadlock possibility mentioned above.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/powercap/intel_rapl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 3c67683..b460d46 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1369,6 +1369,9 @@ static int __init rapl_init(void)
 
 		return -ENODEV;
 	}
+
+	cpu_maps_update_begin();
+
 	/* prevent CPU hotplug during detection */
 	get_online_cpus();
 	ret = rapl_detect_topology();
@@ -1380,20 +1383,23 @@ static int __init rapl_init(void)
 		ret = -ENODEV;
 		goto done;
 	}
-	register_hotcpu_notifier(&rapl_cpu_notifier);
+	__register_hotcpu_notifier(&rapl_cpu_notifier);
 done:
 	put_online_cpus();
+	cpu_maps_update_done();
 
 	return ret;
 }
 
 static void __exit rapl_exit(void)
 {
+	cpu_maps_update_begin();
 	get_online_cpus();
-	unregister_hotcpu_notifier(&rapl_cpu_notifier);
+	__unregister_hotcpu_notifier(&rapl_cpu_notifier);
 	rapl_unregister_powercap();
 	rapl_cleanup_data();
 	put_online_cpus();
+	cpu_maps_update_done();
 }
 
 module_init(rapl_init);

