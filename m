Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaGaGxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:32 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:61380 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaGaGx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:27 -0400
Date: Wed, 30 Jul 2014 23:53:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [patch 1/9] x86, apic: Remove x86_32_numa_cpu_node callback
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302348060.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the x86_32_numa_cpu_node() apic callback has been obsolete.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h |  8 --------
 arch/x86/kernel/apic/apic.c | 11 -----------
 2 files changed, 19 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -370,14 +370,6 @@ struct apic {
 	 * won't be applied properly during early boot in this case.
 	 */
 	int (*x86_32_early_logical_apicid)(int cpu);
-
-	/*
-	 * Optional method called from setup_local_APIC() after logical
-	 * apicid is guaranteed to be known to initialize apicid -> node
-	 * mapping if NUMA initialization hasn't done so already.  Don't
-	 * add new users.
-	 */
-	int (*x86_32_numa_cpu_node)(int cpu);
 #endif
 };
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1342,17 +1342,6 @@ void setup_local_APIC(void)
 	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
-
-	/*
-	 * Some NUMA implementations (NUMAQ) don't initialize apicid to
-	 * node mapping during NUMA init.  Now that logical apicid is
-	 * guaranteed to be known, give it another chance.  This is already
-	 * a bit too late - percpu allocation has already happened without
-	 * proper NUMA affinity.
-	 */
-	if (apic->x86_32_numa_cpu_node)
-		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
-				   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
 	/*
