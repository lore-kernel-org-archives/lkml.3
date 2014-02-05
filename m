Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaBEWKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:10:51 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34405 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaBEWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:10:46 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 04/51] ia64, salinfo: Fix hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:35:23 +0530
Message-ID: <20140205220523.19080.78240.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-3864-0000-0000-00000C47075D
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


Fix the salinfo code in ia64 by using this latter form of callback
registration.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/ia64/kernel/salinfo.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 960a396..e630bce 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -635,6 +635,8 @@ salinfo_init(void)
 					   (void *)salinfo_entries[i].feature);
 	}
 
+	cpu_maps_update_begin();
+
 	for (i = 0; i < ARRAY_SIZE(salinfo_log_name); i++) {
 		data = salinfo_data + i;
 		data->type = i;
@@ -669,7 +671,9 @@ salinfo_init(void)
 	salinfo_timer.function = &salinfo_timeout;
 	add_timer(&salinfo_timer);
 
-	register_hotcpu_notifier(&salinfo_cpu_notifier);
+	__register_hotcpu_notifier(&salinfo_cpu_notifier);
+
+	cpu_maps_update_done();
 
 	return 0;
 }

