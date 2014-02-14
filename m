Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBNIBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:01:36 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48455 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBNIBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:01:31 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 30/52] arm64,
 hw_breakpoint.c: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:25:58 +0530
Message-ID: <20140214075557.22701.17533.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-5140-0000-0000-0000048EE460
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


Fix the hw-breakpoint code in arm64 by using this latter form of callback
registration.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/arm64/kernel/hw_breakpoint.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index f17f581..bee7897 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -913,6 +913,8 @@ static int __init arch_hw_breakpoint_init(void)
 	pr_info("found %d breakpoint and %d watchpoint registers.\n",
 		core_num_brps, core_num_wrps);
 
+	cpu_notifier_register_begin();
+
 	/*
 	 * Reset the breakpoint resources. We assume that a halting
 	 * debugger will leave the world in a nice state for us.
@@ -927,7 +929,10 @@ static int __init arch_hw_breakpoint_init(void)
 			      TRAP_HWBKPT, "hw-watchpoint handler");
 
 	/* Register hotplug notifier. */
-	register_cpu_notifier(&hw_breakpoint_reset_nb);
+	__register_cpu_notifier(&hw_breakpoint_reset_nb);
+
+	cpu_notifier_register_done();
+
 	/* Register cpu_suspend hw breakpoint restore hook */
 	cpu_suspend_set_dbg_restorer(hw_breakpoint_reset);
 

