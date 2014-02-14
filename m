Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBNH5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:57:06 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39790 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBNH5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:57:02 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 09/52] arm,
 hw-breakpoint: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:21:09 +0530
Message-ID: <20140214075108.22701.93980.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021407-5140-0000-0000-0000048EE2FB
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


Fix the hw-breakpoint code in arm by using this latter form of callback
registration.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/arm/kernel/hw_breakpoint.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 3d44660..3702de8 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -1072,6 +1072,8 @@ static int __init arch_hw_breakpoint_init(void)
 	core_num_brps = get_num_brps();
 	core_num_wrps = get_num_wrps();
 
+	cpu_notifier_register_begin();
+
 	/*
 	 * We need to tread carefully here because DBGSWENABLE may be
 	 * driven low on this core and there isn't an architected way to
@@ -1088,6 +1090,7 @@ static int __init arch_hw_breakpoint_init(void)
 	if (!cpumask_empty(&debug_err_mask)) {
 		core_num_brps = 0;
 		core_num_wrps = 0;
+		cpu_notifier_register_done();
 		return 0;
 	}
 
@@ -1107,7 +1110,10 @@ static int __init arch_hw_breakpoint_init(void)
 			TRAP_HWBKPT, "breakpoint debug exception");
 
 	/* Register hotplug and PM notifiers. */
-	register_cpu_notifier(&dbg_reset_nb);
+	__register_cpu_notifier(&dbg_reset_nb);
+
+	cpu_notifier_register_done();
+
 	pm_init();
 	return 0;
 }

