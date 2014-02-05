Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaBEWTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:19:04 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43668 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbaBEWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:18:56 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 49/51] mm, zswap: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-mm@kvack.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:43:37 +0530
Message-ID: <20140205221336.19080.49754.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-4790-0000-0000-00000C92CDB7
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


Fix the zswap code by using this latter form of callback registration.

Cc: linux-mm@kvack.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/zswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e55bab9..681fa3f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -387,18 +387,18 @@ static int zswap_cpu_init(void)
 {
 	unsigned long cpu;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	for_each_online_cpu(cpu)
 		if (__zswap_cpu_notifier(CPU_UP_PREPARE, cpu) != NOTIFY_OK)
 			goto cleanup;
-	register_cpu_notifier(&zswap_cpu_notifier_block);
-	put_online_cpus();
+	__register_cpu_notifier(&zswap_cpu_notifier_block);
+	cpu_maps_update_done();
 	return 0;
 
 cleanup:
 	for_each_online_cpu(cpu)
 		__zswap_cpu_notifier(CPU_UP_CANCELED, cpu);
-	put_online_cpus();
+	cpu_maps_update_done();
 	return -ENOMEM;
 }
 

