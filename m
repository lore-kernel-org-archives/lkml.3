Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaAMQFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:05:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53702 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaAMQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nat Gurumoorthy <natg@google.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/208] tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0
Date: Mon, 13 Jan 2014 16:00:17 +0000
Message-Id: <1389628849-1614-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nat Gurumoorthy <natg@google.com>

commit 388d3335575f4c056dcf7138a30f1454e2145cd8 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e7af885..f9aec90 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -16436,6 +16436,9 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	/* Clear this out for sanity. */
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
+	/* Clear TG3PCI_REG_BASE_ADDR to prevent hangs. */
+	tw32(TG3PCI_REG_BASE_ADDR, 0);
+
 	pci_read_config_dword(tp->pdev, TG3PCI_PCISTATE,
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&
-- 
1.8.3.2

