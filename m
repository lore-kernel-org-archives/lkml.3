Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbbAONBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:01:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbbAONBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:51 -0500
Date: Thu, 15 Jan 2015 05:00:50 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ef1b2b8ad13858ab2f87c05261b8ce3253f90af9@git.kernel.org>
Cc: yinghai@kernel.org, mingo@kernel.org, d.hatayama@jp.fujitsu.com,
        benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        tony.luck@intel.com, hpa@linux.intel.com, oren@scalemp.com,
        JBeulich@suse.com, richard@nod.at, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, bp@alien8.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, d.hatayama@jp.fujitsu.com, yinghai@kernel.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        tony.luck@intel.com, JBeulich@suse.com, oren@scalemp.com,
        hpa@linux.intel.com, tglx@linutronix.de, richard@nod.at,
        linux-kernel@vger.kernel.org, hpa@zytor.com, rientjes@google.com,
        bp@alien8.de, joro@8bytes.org
In-Reply-To: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Handle XAPIC remap mode proper.
Git-Commit-ID: ef1b2b8ad13858ab2f87c05261b8ce3253f90af9
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

Commit-ID:  ef1b2b8ad13858ab2f87c05261b8ce3253f90af9
Gitweb:     http://git.kernel.org/tip/ef1b2b8ad13858ab2f87c05261b8ce3253f90af9
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

x86/apic: Handle XAPIC remap mode proper.

If remapping is in XAPIC mode, the setup code just skips X2APIC
initialization without checking max CPU APIC ID in system, which may
cause problem if system has a CPU with APIC ID bigger than 255.

Handle IR in XAPIC mode the same way as if remapping is disabled.

[ tglx: Split out from previous patch ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fa77be8..04aec6b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1596,7 +1596,7 @@ static __init void try_to_enable_x2apic(int ir_stat)
 	if (!x2apic_supported())
 		return;
 
-	if (ir_stat < 0) {
+	if (ir_stat != IRQ_REMAP_X2APIC_MODE) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
@@ -1613,10 +1613,6 @@ static __init void try_to_enable_x2apic(int ir_stat)
 		 * only in physical mode
 		 */
 		x2apic_force_phys();
-
-	} else if (ir_stat == IRQ_REMAP_XAPIC_MODE) {
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-		return;
 	}
 
 	if (!x2apic_mode) {
