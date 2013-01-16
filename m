Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3APQD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36126 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab3APQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 099/222] iwlwifi: don't handle masked interrupt
Date: Wed, 16 Jan 2013 13:54:59 -0200
Message-Id: <1358351822-7675-100-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 25a172655f837bdb032e451f95441bb4acec51bb upstream.

This can lead to a panic if the driver isn't ready to
handle them. Since our interrupt line is shared, we can get
an interrupt at any time (and CONFIG_DEBUG_SHIRQ checks
that even when the interrupt is being freed).

If the op_mode has gone away, we musn't call it. To avoid
this the transport disables the interrupts when the hw is
stopped and the op_mode is leaving.
If there is an event that would cause an interrupt the INTA
register is updated regardless of the enablement of the
interrupts: even if the interrupts are disabled, the INTA
will be changed, but the device won't issue an interrupt.
But the ISR can be called at any time, so we ought ignore
the value in the INTA otherwise we can call the op_mode
after it was freed.

I found this bug when the op_mode_start failed, and called
iwl_trans_stop_hw(trans, true). Then I played with the
RFKILL button, and removed the module.
While removing the module, the IRQ is freed, and the ISR is
called (CONFIG_DEBUG_SHIRQ enabled). Panic.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: code to patch is in drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c,
  under functions iwl_isr and iwl_isr_ict ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index f774778..34d35a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -919,12 +919,20 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
+	if (inta & (~inta_mask)) {
+		IWL_DEBUG_ISR(trans,
+			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
+			      inta & (~inta_mask));
+		iwl_write32(trans, CSR_INT, inta & (~inta_mask));
+		inta &= inta_mask;
+	}
+
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
@@ -1008,7 +1016,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 
-- 
1.7.9.5

