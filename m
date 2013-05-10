Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3EJOVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314Ab3EJOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "Jacob Keller" <jacob.e.keller@intel.com>,
        "Phil Schmitt" <phillip.j.schmitt@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.364383786@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [059/118] ixgbe: fix EICR write in ixgbe_msix_other
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1937,6 +1937,16 @@ static irqreturn_t ixgbe_msix_other(int
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

