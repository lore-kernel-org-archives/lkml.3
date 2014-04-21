Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaDUEfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:35:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaDUEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: [PATCH 3.13 04/32] x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets
Date: Sun, 20 Apr 2014 19:13:21 -0700
Message-Id: <20140421021134.467873507@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 6f8a1b335fde143b7407036e2368d3cd6eb55674 upstream.

Commit 03bbcb2e7e2 (iommu/vt-d: add quirk for broken interrupt
remapping on 55XX chipsets) properly disables irq remapping on the
5500/5520 chipsets that don't correctly perform that feature.

However, when I wrote it, I followed the errata sheet linked in that
commit too closely, and explicitly tied the activation of the quirk to
revision 0x13 of the chip, under the assumption that earlier revisions
were not in the field.  Recently a system was reported to be suffering
from this remap bug and the quirk hadn't triggered, because the
revision id register read at a lower value that 0x13, so the quirk
test failed improperly.  Given this, it seems only prudent to adjust
this quirk so that any revision less than 0x13 has the quirk asserted.

[ tglx: Removed the 0x12 comparison of pci id 3405 as this is covered
    	by the <= 0x13 check already ]

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/1394649873-14913-1-git-send-email-nhorman@tuxdriver.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/early-quirks.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -203,18 +203,15 @@ static void __init intel_remapping_check
 	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
 
 	/*
- 	 * Revision 13 of all triggering devices id in this quirk have
-	 * a problem draining interrupts when irq remapping is enabled,
-	 * and should be flagged as broken.  Additionally revisions 0x12
-	 * and 0x22 of device id 0x3405 has this problem.
+	 * Revision <= 13 of all triggering devices id in this quirk
+	 * have a problem draining interrupts when irq remapping is
+	 * enabled, and should be flagged as broken. Additionally
+	 * revision 0x22 of device id 0x3405 has this problem.
 	 */
-	if (revision == 0x13)
+	if (revision <= 0x13)
 		set_irq_remapping_broken();
-	else if ((device == 0x3405) &&
-	    ((revision == 0x12) ||
-	     (revision == 0x22)))
+	else if (device == 0x3405 && revision == 0x22)
 		set_irq_remapping_broken();
-
 }
 
 /*


