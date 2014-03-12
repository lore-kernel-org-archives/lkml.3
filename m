Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaCLSpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:45:01 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38438 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaCLSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:44:53 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH] x86: adjust irq remapping quirk for older revisions of 5500/5520 chipsets
Date: Wed, 12 Mar 2014 14:44:33 -0400
Message-Id: <1394649873-14913-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while back I posted this commit:

commit 03bbcb2e7e292838bb0244f5a7816d194c911d62
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Tue Apr 16 16:38:32 2013 -0400

    iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

Which properly disables irq remapping on the 5500/5520 chipsets that don't
correctly perform that feature.  However, when I wrote it, I followed the errata
sheet linked in that commit too closely, and explicitly tied the activation of
the quirk to revision 0x13 of the chip, under the assumption that earlier
revisions were not in the field.  Recently a system was reported to be suffering
from this remap bug and the quirk hadn't triggered, because the revision id
register read at a lower value that 0x13, so the quirk test failed improperly.
Given this, it seems only prudent to adjust this quirk so that any revision less
than 0x13 has the quirk asserted.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/kernel/early-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..2237b36 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -208,7 +208,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
 	 * and should be flagged as broken.  Additionally revisions 0x12
 	 * and 0x22 of device id 0x3405 has this problem.
 	 */
-	if (revision == 0x13)
+	if (revision < 0x13)
 		set_irq_remapping_broken();
 	else if ((device == 0x3405) &&
 	    ((revision == 0x12) ||
-- 
1.8.3.1

