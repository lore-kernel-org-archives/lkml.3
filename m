Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaBNH4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:56:12 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51444 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaBNH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:56:08 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 06/52] ia64, palinfo: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-ia64@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:20:30 +0530
Message-ID: <20140214075030.22701.23304.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021407-6102-0000-0000-000004F22CE8
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


Fix the palinfo code in ia64 by using this latter form of callback
registration.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/ia64/kernel/palinfo.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index ab33328..c39c3cd 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -996,13 +996,17 @@ palinfo_init(void)
 	if (!palinfo_dir)
 		return -ENOMEM;
 
+	cpu_notifier_register_begin();
+
 	/* Create palinfo dirs in /proc for all online cpus */
 	for_each_online_cpu(i) {
 		create_palinfo_proc_entries(i);
 	}
 
 	/* Register for future delivery via notify registration */
-	register_hotcpu_notifier(&palinfo_cpu_notifier);
+	__register_hotcpu_notifier(&palinfo_cpu_notifier);
+
+	cpu_notifier_register_done();
 
 	return 0;
 }

