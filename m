Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3GXDze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:55:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3GXDzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:55:31 -0400
Date: Tue, 23 Jul 2013 20:55:15 -0700
From: tip-bot for Youquan Song <tipbot@zytor.com>
Message-ID: <tip-3d1acb49d22fbbae96524040e9e2d4cbbb3adbef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, youquan.song@intel.com,
        youquan.song@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, youquan.song@intel.com,
        youquan.song@linux.intel.com
In-Reply-To: <1373592159-459-1-git-send-email-youquan.song@intel.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Enable x2APIC physical mode on native hardware too,
  when there are fewer than 256 CPUs
Git-Commit-ID: 3d1acb49d22fbbae96524040e9e2d4cbbb3adbef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:55:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d1acb49d22fbbae96524040e9e2d4cbbb3adbef
Gitweb:     http://git.kernel.org/tip/3d1acb49d22fbbae96524040e9e2d4cbbb3adbef
Author:     Youquan Song <youquan.song@intel.com>
AuthorDate: Thu, 11 Jul 2013 21:22:39 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 11:15:42 +0200

x86/apic: Enable x2APIC physical mode on native hardware too, when there are fewer than 256 CPUs

x2APIC extends APICID from 8 bits to 32 bits, but the device
interrupt routed from IOAPIC or delivered in MSI mode will keep
8 bits destination APICID.  In order to support x2APIC, the VT-d
interrupt remapping is introduced to translate the destination
APICID to 32 bits in x2APIC mode and keep the device compatible
in this way.

x2APIC support both logical and physical mode in destination
mode.

In logical destination mode, the 32 bits Logical APICID
has 2 sub-fields: 16 bits cluster ID and 16 bits logical ID within
the cluster and it is required VT-d interrupt remapping in x2APIC
cluster mode.

In physical destination mode, the 8 bits physical id is
compatible with 32  bits physical id when CPU number < 256.

When interrupt remapping initialization fails on platforms with
CPU number < 256, the current kernel only enables x2APIC physical
mode in virtualization environment, while we could also can enable
x2APIC physcial mode in native kernel this situation.

In this case the device interrupt will use 8 bits destination
APICID in physical mode and be compatible with x2APIC physical
when < 256 CPUs.

So we can benefit from x2APIC vs xAPIC MMIO:

 - x2APIC MSR read/write is faster than xAPIC mmio

 - x2APIC only ICR write to deliver interrupt without polling ICR deliver
   status bit and xAPIC need poll to read ICR deliver status bit.

 - x2APIC 64 bits ICR access instead of xAPIC two 32 bits access.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: Youquan Song <youquan.song@linux.intel.com>
Cc: hpa@linux.intel.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/1373592159-459-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index eca89c5..d9dd5a6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1622,11 +1622,8 @@ void __init enable_IR_x2apic(void)
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
