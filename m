Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaCHBIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:08:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaCHBID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:08:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 91/99] iwlwifi: dont handle masked interrupt
Date: Fri,  7 Mar 2014 17:08:27 -0800
Message-Id: <20140308010614.484624887@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Pass bus(trans), not trans, to iwl_{read,write}32()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wujg: Backported to 3.4:
 - adjust context
 - Pass trans to iwl_{read,write}32()}]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1264,12 +1264,20 @@ static irqreturn_t iwl_isr(int irq, void
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
@@ -1353,7 +1361,7 @@ irqreturn_t iwl_isr_ict(int irq, void *d
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 


