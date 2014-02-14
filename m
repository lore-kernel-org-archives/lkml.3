Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaBNIBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:01:06 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56056 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaBNIBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:01:03 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 28/52] x86, oprofile,
 nmi: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Robert Richter <rric@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:25:29 +0530
Message-ID: <20140214075528.22701.64691.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-1396-0000-0000-0000044B36C6
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


Fix the oprofile code in x86 by using this latter form of callback
registration. But retain the calls to get/put_online_cpus(), since they are
used in other places as well, to protect the variables 'nmi_enabled' and
'ctr_running'. Strictly speaking, this is not necessary since
cpu_notifier_register_begin/done() provide a stronger synchronization
with CPU hotplug than get/put_online_cpus(). However, let's retain the
calls to get/put_online_cpus() to be consistent with the other call-sites.

By nesting get/put_online_cpus() *inside* cpu_notifier_register_begin/done(),
we avoid the ABBA deadlock possibility mentioned above.

Cc: Robert Richter <rric@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/oprofile/nmi_int.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 6890d84..379e8bd 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -494,14 +494,19 @@ static int nmi_setup(void)
 	if (err)
 		goto fail;
 
+	cpu_notifier_register_begin();
+
+	/* Use get/put_online_cpus() to protect 'nmi_enabled' */
 	get_online_cpus();
-	register_cpu_notifier(&oprofile_cpu_nb);
 	nmi_enabled = 1;
 	/* make nmi_enabled visible to the nmi handler: */
 	smp_mb();
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
+	__register_cpu_notifier(&oprofile_cpu_nb);
 	put_online_cpus();
 
+	cpu_notifier_register_done();
+
 	return 0;
 fail:
 	free_msrs();
@@ -512,12 +517,18 @@ static void nmi_shutdown(void)
 {
 	struct op_msrs *msrs;
 
+	cpu_notifier_register_begin();
+
+	/* Use get/put_online_cpus() to protect 'nmi_enabled' & 'ctr_running' */
 	get_online_cpus();
-	unregister_cpu_notifier(&oprofile_cpu_nb);
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	nmi_enabled = 0;
 	ctr_running = 0;
+	__unregister_cpu_notifier(&oprofile_cpu_nb);
 	put_online_cpus();
+
+	cpu_notifier_register_done();
+
 	/* make variables visible to the nmi handler: */
 	smp_mb();
 	unregister_nmi_handler(NMI_LOCAL, "oprofile");

