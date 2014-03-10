Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaCJUgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:36:39 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58485 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaCJUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:36:36 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 13/52] sparc, sysfs: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:06:09 +0530
Message-ID: <20140310203609.10746.87407.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-0260-0000-0000-000004832B9A
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


Fix the sysfs code in sparc by using this latter form of callback
registration.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: sparclinux@vger.kernel.org
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/sparc/kernel/sysfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
index c21c673..a364000 100644
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -300,7 +300,7 @@ static int __init topology_init(void)
 
 	check_mmu_stats();
 
-	register_cpu_notifier(&sysfs_cpu_nb);
+	cpu_notifier_register_begin();
 
 	for_each_possible_cpu(cpu) {
 		struct cpu *c = &per_cpu(cpu_devices, cpu);
@@ -310,6 +310,10 @@ static int __init topology_init(void)
 			register_cpu_online(cpu);
 	}
 
+	__register_cpu_notifier(&sysfs_cpu_nb);
+
+	cpu_notifier_register_done();
+
 	return 0;
 }
 

