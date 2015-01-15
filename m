Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbbAONDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:03:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbbAONDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:03:09 -0500
Date: Thu, 15 Jan 2015 05:02:05 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5fcee53ce705d49c766f8a302c7e93bdfc33c124@git.kernel.org>
Cc: d.hatayama@jp.fujitsu.com, hpa@linux.intel.com, bp@alien8.de,
        benh@kernel.crashing.org, rientjes@google.com, oren@scalemp.com,
        mingo@kernel.org, joro@8bytes.org, jiang.liu@linux.intel.com,
        yinghai@kernel.org, JBeulich@suse.com, richard@nod.at,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        tony.luck@intel.com
Reply-To: tony.luck@intel.com, hpa@zytor.com, tglx@linutronix.de,
        richard@nod.at, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        jiang.liu@linux.intel.com, yinghai@kernel.org, mingo@kernel.org,
        oren@scalemp.com, joro@8bytes.org, rientjes@google.com,
        benh@kernel.crashing.org, bp@alien8.de, d.hatayama@jp.fujitsu.com,
        hpa@linux.intel.com
In-Reply-To: <1420615903-28253-12-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-12-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Only disable CPU x2apic mode when necessary
Git-Commit-ID: 5fcee53ce705d49c766f8a302c7e93bdfc33c124
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

Commit-ID:  5fcee53ce705d49c766f8a302c7e93bdfc33c124
Gitweb:     http://git.kernel.org/tip/5fcee53ce705d49c766f8a302c7e93bdfc33c124
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

x86/apic: Only disable CPU x2apic mode when necessary

When interrupt remapping hardware is not in X2APIC, CPU X2APIC mode
will be disabled if:
1) Maximum CPU APIC ID is bigger than 255
2) hypervisior doesn't support x2apic mode.

But we should only check whether hypervisor supports X2APIC mode when
hypervisor(CONFIG_HYPERVISOR_GUEST) is enabled, otherwise X2APIC will
always be disabled when CONFIG_HYPERVISOR_GUEST is disabled and IR
doesn't work in X2APIC mode.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-12-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 04aec6b..2f16116 100644
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
