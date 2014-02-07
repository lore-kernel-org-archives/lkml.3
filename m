Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaBGMnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:43:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBGLu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/233] iwlwifi: pcie: enable oscillator for L1 exit
Date: Fri,  7 Feb 2014 11:45:38 +0000
Message-Id: <1391773652-25214-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 2d93aee152b1758a94a18fe15d72153ba73b5679 upstream.

Enabling the oscillator consumes slightly more power (100uA)
but allows to make sure that we exit from L1 on time.

Not doing so might lead to a PCIe specification violation
since we might wake up from L1 at the wrong time.
This issue has been identified on 3160 and 7260 only.
On older NICs L1 off is not enabled, on newer NICs (7265),
the issue is fixed.

When the bug occurs the user sees that the NIC has
disappeared from the PCI bridge, any access to the device
returns 0xff.

This fixes:
	https://bugzilla.kernel.org/show_bug.cgi?id=64541

and has been extensively discussed here:
	http://markmail.org/thread/mfmpzqt3r333n4bo

Fixes: 99cd47142399 ("iwlwifi: add 7000 series device configuration")
Reported-and-tested-by: wzyboy <wzyboy@wzyboy.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ff8cc75..4e6dfba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -272,4 +272,8 @@ static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
 
 /*********************** END TX SCHEDULER *************************************/
 
+/* Oscillator clock */
+#define OSC_CLK				(0xa04068)
+#define OSC_CLK_FORCE_CONTROL		(0x8)
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ca06967..6c61ee5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -206,6 +206,28 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 		goto out;
 	}
 
+	if (trans->cfg->host_interrupt_operation_mode) {
+		/*
+		 * This is a bit of an abuse - This is needed for 7260 / 3160
+		 * only check host_interrupt_operation_mode even if this is
+		 * not related to host_interrupt_operation_mode.
+		 *
+		 * Enable the oscillator to count wake up time for L1 exit. This
+		 * consumes slightly more power (100uA) - but allows to be sure
+		 * that we wake up from L1 on time.
+		 *
+		 * This looks weird: read twice the same register, discard the
+		 * value, set a bit, and yet again, read that same register
+		 * just to discard the value. But that's the way the hardware
+		 * seems to like it.
+		 */
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_set_bits_prph(trans, OSC_CLK, OSC_CLK_FORCE_CONTROL);
+		iwl_read_prph(trans, OSC_CLK);
+		iwl_read_prph(trans, OSC_CLK);
+	}
+
 	/*
 	 * Enable DMA clock and wait for it to stabilize.
 	 *
-- 
1.8.3.2

