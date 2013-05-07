Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab3EGNm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3EGNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 103/118] ixgbe: fix EICR write in ixgbe_msix_other
Date: Tue,  7 May 2013 14:39:09 +0100
Message-Id: <1367933964-1564-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit d87d830720a1446403ed38bfc2da268be0d356d1 upstream.

Previously, the ixgbe_msix_other was writing the full 32bits of the set
interrupts, instead of only the ones which the ixgbe_msix_other is
handling. This resulted in a loss of performance when the X540's PPS feature is
enabled due to sometimes clearing queue interrupts which resulted in the driver
not getting the interrupt for cleaning the q_vector rings often enough. The fix
is to simply mask the lower 16bits off so that this handler does not write them
in the EICR, which causes them to remain high and be properly handled by the
clean_rings interrupt routine as normal.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8d882..543659a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2293,6 +2293,16 @@ static irqreturn_t ixgbe_msix_other(int irq, void *data)
 	 * with the write to EICR.
 	 */
 	eicr = IXGBE_READ_REG(hw, IXGBE_EICS);
+
+	/* The lower 16bits of the EICR register are for the queue interrupts
+	 * which should be masked here in order to not accidently clear them if
+	 * the bits are high when ixgbe_msix_other is called. There is a race
+	 * condition otherwise which results in possible performance loss
+	 * especially if the ixgbe_msix_other interrupt is triggering
+	 * consistently (as it would when PPS is turned on for the X540 device)
+	 */
+	eicr &= 0xFFFF0000;
+
 	IXGBE_WRITE_REG(hw, IXGBE_EICR, eicr);
 
 	if (eicr & IXGBE_EICR_LSC)
-- 
1.8.1.2

