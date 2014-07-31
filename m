Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaGaRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGaRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:06:44 -0400
Date: Thu, 31 Jul 2014 10:06:33 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-80a2670379b777ea45f2f6c73b2d2bc3f99066c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302348060.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302348060.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Remove x86_32_numa_cpu_node callback
Git-Commit-ID: 80a2670379b777ea45f2f6c73b2d2bc3f99066c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80a2670379b777ea45f2f6c73b2d2bc3f99066c8
Gitweb:     http://git.kernel.org/tip/80a2670379b777ea45f2f6c73b2d2bc3f99066c8
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:24 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:40 -0700

x86, apic: Remove x86_32_numa_cpu_node callback

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the x86_32_numa_cpu_node() apic callback has been obsolete.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302348060.17503@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h |  8 --------
 arch/x86/kernel/apic/apic.c | 11 -----------
 2 files changed, 19 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b40ea7e..067c2f8 100644
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
index 6b35d30..d705bb7 100644
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
