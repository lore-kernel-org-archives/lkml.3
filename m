Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaBEHzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 02:55:14 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61931 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaBEHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 02:55:08 -0500
Date: Tue, 4 Feb 2014 23:55:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [patch 4/4] x86, apic: Always define nox2apic and define it as
 initdata
In-Reply-To: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402042354380.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "nox2apic" variable can be defined as __initdata since it is only
used for bootstrap.  It can now unconditionally be defined since it will
later be freed.

At the same time, it is also better off as a bool.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h | 1 -
 arch/x86/kernel/apic/apic.c | 9 ++++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -217,7 +217,6 @@ static inline void x2apic_force_phys(void)
 {
 }
 
-#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -133,6 +133,10 @@ static inline void imcr_apic_to_pic(void)
  * +1=force-enable
  */
 static int force_enable_local_apic __initdata;
+
+/* Control whether x2APIC mode is enabled or not */
+static bool nox2apic __initdata;
+
 /*
  * APIC command line parameters
  */
@@ -162,8 +166,7 @@ int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
-static int nox2apic;
-static __init int setup_nox2apic(char *str)
+static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
 		int apicid = native_apic_msr_read(APIC_ID);
@@ -178,7 +181,7 @@ static __init int setup_nox2apic(char *str)
 	} else
 		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 
-	nox2apic = 1;
+	nox2apic = true;
 
 	return 0;
 }
