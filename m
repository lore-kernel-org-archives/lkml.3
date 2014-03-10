Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaCJUkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:40:18 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38017 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaCJUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:40:13 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 36/52] zsmalloc: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:09:59 +0530
Message-ID: <20140310203959.10746.61303.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-2000-0000-0000-0000101B3A8C
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


Fix the zsmalloc code by using this latter form of callback registration.

Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/zsmalloc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index c03ca5e..36b4591 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -814,21 +814,32 @@ static void zs_exit(void)
 {
 	int cpu;
 
+	cpu_notifier_register_begin();
+
 	for_each_online_cpu(cpu)
 		zs_cpu_notifier(NULL, CPU_DEAD, (void *)(long)cpu);
-	unregister_cpu_notifier(&zs_cpu_nb);
+	__unregister_cpu_notifier(&zs_cpu_nb);
+
+	cpu_notifier_register_done();
 }
 
 static int zs_init(void)
 {
 	int cpu, ret;
 
-	register_cpu_notifier(&zs_cpu_nb);
+	cpu_notifier_register_begin();
+
+	__register_cpu_notifier(&zs_cpu_nb);
 	for_each_online_cpu(cpu) {
 		ret = zs_cpu_notifier(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-		if (notifier_to_errno(ret))
+		if (notifier_to_errno(ret)) {
+			cpu_notifier_register_done();
 			goto fail;
+		}
 	}
+
+	cpu_notifier_register_done();
+
 	return 0;
 fail:
 	zs_exit();

