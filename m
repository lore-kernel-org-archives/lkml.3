Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaDWOoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:44:04 -0400
Received: from mtaout28.012.net.il ([80.179.55.184]:60398 "EHLO
	mtaout28.012.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDWOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:43:59 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2014 10:43:59 EDT
Date: Wed, 23 Apr 2014 17:38:52 +0300
From: Oren Twaig <oren@scalemp.com>
Subject: [PATCH] X86: Hook apic vector allocation domain only when interrupt routing are set to ignore
X-012-Sender: ira_oren@012.net.il
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Message-id: <5357D07C.5080407@scalemp.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Antivirus: avast! (VPS 140423-0, 04/23/2014), Outbound message
X-Antivirus-Status: Clean
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set all inclusive vector allocation domain only if interrupt routing is 
set to ignore. When in comply mode, vector allocation behavior isn't 
changed.

Signed-off-by: Oren Twaig <oren@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a9..60a195d 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -27,6 +27,9 @@
  #define TOPOLOGY_REGISTER_OFFSET 0x10

  #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
+
+static int irc = 1;
+
  /*
   * Interrupt control on vSMPowered systems:
   * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -101,6 +104,10 @@ static void __init set_vsmp_pv_ops(void)
  #ifdef CONFIG_SMP
      if (cap & ctl & BIT(8)) {
          ctl &= ~BIT(8);
+
+        /* Interrupt routing set to ignore */
+        irc = 0;
+
  #ifdef CONFIG_PROC_FS
          /* Don't let users change irq affinity via procfs */
          no_irq_affinity = 1;
@@ -218,7 +225,9 @@ static void vsmp_apic_post_init(void)
  {
      /* need to update phys_pkg_id */
      apic->phys_pkg_id = apicid_phys_pkg_id;
-    apic->vector_allocation_domain = fill_vector_allocation_domain;
+
+    if (!irc)
+        apic->vector_allocation_domain = fill_vector_allocation_domain;
  }

  void __init vsmp_init(void)


---
This email is free from viruses and malware because avast! Antivirus protection is active.
http://www.avast.com

