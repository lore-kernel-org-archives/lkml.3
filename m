Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBNIAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:00:13 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40949 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaBNIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:00:07 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 23/52] x86, intel,
 cacheinfo: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Borislav Petkov <bp@suse.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:24:27 +0530
Message-ID: <20140214075426.22701.76958.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021407-5490-0000-0000-000004F30327
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


Fix the intel cacheinfo code in x86 by using this latter form of callback
registration.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0641113..a952e9c 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1225,21 +1225,24 @@ static struct notifier_block cacheinfo_cpu_notifier = {
 
 static int __init cache_sysfs_init(void)
 {
-	int i;
+	int i, err = 0;
 
 	if (num_cache_leaves == 0)
 		return 0;
 
+	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
-		int err;
 		struct device *dev = get_cpu_device(i);
 
 		err = cache_add_dev(dev);
 		if (err)
-			return err;
+			goto out;
 	}
-	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
-	return 0;
+	__register_hotcpu_notifier(&cacheinfo_cpu_notifier);
+
+out:
+	cpu_notifier_register_done();
+	return err;
 }
 
 device_initcall(cache_sysfs_init);

