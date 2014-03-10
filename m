Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaCJUh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:37:57 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48151 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaCJUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:37:49 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 21/52] x86, therm_throt.c: Remove unused therm_cpu_lock
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:07:28 +0530
Message-ID: <20140310203728.10746.58165.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-9264-0000-0000-0000059CA49A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fixing the CPU hotplug callback registration code, the callbacks
invoked for each online CPU, during the initialization phase in
thermal_throttle_init_device(), can no longer race with the actual CPU
hotplug notifier callbacks (in thermal_throttle_cpu_callback). Hence the
therm_cpu_lock is unnecessary now. Remove it.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-edac@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e05dfa3..d921b7e 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -271,9 +271,6 @@ static void thermal_throttle_remove_dev(struct device *dev)
 	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
 }
 
-/* Mutex protecting device creation against CPU hotplug: */
-static DEFINE_MUTEX(therm_cpu_lock);
-
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int
 thermal_throttle_cpu_callback(struct notifier_block *nfb,
@@ -289,18 +286,14 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(dev, cpu);
-		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		mutex_lock(&therm_cpu_lock);
 		thermal_throttle_remove_dev(dev);
-		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
 	return notifier_from_errno(err);
@@ -321,17 +314,11 @@ static __init int thermal_throttle_init_device(void)
 
 	cpu_notifier_register_begin();
 
-#ifdef CONFIG_HOTPLUG_CPU
-	mutex_lock(&therm_cpu_lock);
-#endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
 		err = thermal_throttle_add_dev(get_cpu_device(cpu), cpu);
 		WARN_ON(err);
 	}
-#ifdef CONFIG_HOTPLUG_CPU
-	mutex_unlock(&therm_cpu_lock);
-#endif
 
 	__register_hotcpu_notifier(&thermal_throttle_cpu_notifier);
 	cpu_notifier_register_done();

