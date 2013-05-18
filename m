Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3ERDDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:03:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3ERDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:31 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OQXfZYwYD-oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=efqM4xsJ7vsA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021653.393881444@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 072/136 ] ixgbe: fix EICR write in ixgbe_msix_other
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0072-ixgbe-fix-EICR-write-in-ixgbe_msix_other.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit d87d830720a1446403ed38bfc2da268be0d356d1 ]

Previously, the ixgbe_msix_other was writing the full 32bits of the set
interrupts, instead of only the ones which the ixgbe_msix_other is
handling. This resulted in a loss of performance when the X540's PPS feature is
enabled due to sometimes clearing queue interrupts which resulted in the driver
not getting the interrupt for cleaning the q_vector rings often enough. The fix
is to simply mask the lower 16bits off so that this handler does not write them
in the EICR, which causes them to remain high and be properly handled by the
clean_rings interrupt routine as normal.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1fff36d..926f0d0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2283,6 +2283,16 @@ static irqreturn_t ixgbe_msix_other(int irq, void *data)
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
1.7.10.4


