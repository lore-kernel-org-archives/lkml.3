Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3GKNiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:38:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:6683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab3GKNh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368462451"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, hpa@linux.intel.com, yinghai@kernel.org,
        tglx@linutronix.de, mingo@kernel.org
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Date: Thu, 11 Jul 2013 21:22:39 -0400
Message-Id: <1373592159-459-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2APIC extends APICID from 8 bits to 32 bits, but the device interrupt routed
from IOAPIC or delivered in MSI mode will keep 8 bits destination APICID. 
In order to support x2APIC, the VT-d interrupt remapping is introduced to
translate the destination APICID to 32 bits in x2APIC mode and keep the device
compatible in this way.

x2APIC support both logical and physical mode in destination mode.  
In logical destination mode, the 32 bits Logical APICID has 2 sub-fields: 
 16 bits cluster ID and 16 bits logical ID within the cluster and it is 
required VT-d interrupt remapping in x2APIC cluster mode.
In physical destination mode, the 8 bits physical id is compatible with 32 
bits physical id when CPU number < 256. 
When interrupt remapping initialization fail on platform with CPU number < 256, 
current kernel only enables x2APIC physical mode in virutalization environment,
while we also can enable x2APIC physcial mode in native kernel this situation,
and the device interrupt will use 8 bits destination APICID in physical mode
and be compatible with x2APIC physical when < 256 CPUs.
 
So we can benefit from x2APIC vs xAPIC MMIO:
 - x2APIC MSR read/write is faster than xAPIC mmio
 - x2APIC only ICR write to deliver interrupt without polling ICR deliver 
   status bit and xAPIC need poll to read ICR deliver status bit.
 - x2APIC 64 bits ICR access instead of xAPIC two 32 bits access.
  
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 arch/x86/kernel/apic/apic.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 904611b..51a065a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1603,11 +1603,8 @@ void __init enable_IR_x2apic(void)
 		goto skip_x2apic;
 
 	if (ret < 0) {
-		/* IR is required if there is APIC ID > 255 even when running
-		 * under KVM
-		 */
-		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available()) {
+		/* IR is required if there is APIC ID > 255 */
+		if (max_physical_apicid > 255) {
 			if (x2apic_preenabled)
 				disable_x2apic();
 			goto skip_x2apic;
-- 
1.7.7.4

