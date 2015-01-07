Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbbAGH3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:50367 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbbAGH3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633909"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v2 11/16] x86/apic: Only disable CPU x2apic mode when necessary
Date: Wed,  7 Jan 2015 15:31:38 +0800
Message-Id: <1420615903-28253-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When interrupt remapping hardware is not in X2APIC, CPU X2APIC mode
will be disabled if:
1) Maximum CPU APIC ID is bigger than 255
2) hypervisior doesn't support x2apic mode.

But we should only check whether hypervisor supports X2APIC mode when
hypervisor(CONFIG_HYPERVISOR_GUEST) is enabled, otherwise X2APIC will
always be disabled when CONFIG_HYPERVISOR_GUEST is disabled and IR
doesn't work in X2APIC mode.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 09ac1e4ef86b..d714e72ed6d5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1601,7 +1601,8 @@ static __init void try_to_enable_x2apic(int ir_stat)
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available()) {
+		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
+		     !hypervisor_x2apic_available())) {
 			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
 			if (x2apic_preenabled)
 				disable_x2apic();
-- 
1.7.10.4

