Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBLIjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:39:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbaBLINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Chan" <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nat Gurumoorthy" <natg@google.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.906308457@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/79] tg3: Initialize REG_BASE_ADDR at PCI config
 offset 120  to 0
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nat Gurumoorthy <natg@google.com>

[ Upstream commit 388d3335575f4c056dcf7138a30f1454e2145cd8 ]

The new tg3 driver leaves REG_BASE_ADDR (PCI config offset 120)
uninitialized. From power on reset this register may have garbage in it. The
Register Base Address register defines the device local address of a
register. The data pointed to by this location is read or written using
the Register Data register (PCI config offset 128). When REG_BASE_ADDR has
garbage any read or write of Register Data Register (PCI 128) will cause the
PCI bus to lock up. The TCO watchdog will fire and bring down the system.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 1bc927a..d5793d3 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14537,6 +14537,9 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 	/* Clear this out for sanity. */
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
+	/* Clear TG3PCI_REG_BASE_ADDR to prevent hangs. */
+	tw32(TG3PCI_REG_BASE_ADDR, 0);
+
 	pci_read_config_dword(tp->pdev, TG3PCI_PCISTATE,
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&

