Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaEVPaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:30:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42362 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaEVPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:30:10 -0400
Date: Thu, 22 May 2014 17:30:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] x86, MCE: Kill CPU_POST_DEAD
Message-ID: <20140522153006.GK4383@pd.tnic>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
 <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
 <20140522123251.GU30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140522123251.GU30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 02:32:51PM +0200, Peter Zijlstra wrote:
> So I think we can reduce it to just the one rwsem (with recursion) if we
> shoot CPU_POST_DEAD in the head.

Here's the first bullet. Stressing my box here with Steve's hotplug
script seems to work fine.

Tony, any objections?

---
From: Borislav Petkov <bp@suse.de>
Date: Thu, 22 May 2014 16:40:54 +0200
Subject: [PATCH] x86, MCE: Kill CPU_POST_DEAD

In conjunction with cleaning up CPU hotplug, we want to get rid of
CPU_POST_DEAD. Kill this instance here and rediscover CMCI banks at the
end of CPU_DEAD.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c80de7f..ee35d621815b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2391,6 +2391,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
 		mce_intel_hcpu_update(cpu);
+		cmci_rediscover();
 		break;
 	case CPU_DOWN_PREPARE:
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
@@ -2402,11 +2403,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	}
 
-	if (action == CPU_POST_DEAD) {
-		/* intentionally ignoring frozen here */
-		cmci_rediscover();
-	}
-
 	return NOTIFY_OK;
 }
 
-- 
1.9.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
