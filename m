Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3LISnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:43:45 -0500
Received: from mail-oa0-f73.google.com ([209.85.219.73]:56931 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3LISnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:43:43 -0500
From: Nat Gurumoorthy <natg@google.com>
To: nsujir@broadcom.com, mchan@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0
Date: Mon,  9 Dec 2013 10:43:21 -0800
Message-Id: <1386614601-9453-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new tg3 driver leaves REG_BASE_ADDR (PCI config offset 120)
uninitialized. From power on reset this register may have garbage in it. The
Register Base Address register defines the device local address of a
register. The data pointed to by this location is read or written using
the Register Data register (PCI config offset 128). When REG_BASE_ADDR has
garbage any read or write of Register Data Register (PCI 128) will cause the
PCI bus to lock up. The TCO watchdog will fire and bring down the system.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 369b736..9a904fd 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -16499,6 +16499,9 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	/* Clear this out for sanity. */
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
+	/* Clear TG3PCI_REG_BASE_ADDR to prevent hangs. */
+	tw32(TG3PCI_REG_BASE_ADDR, 0);
+
 	pci_read_config_dword(tp->pdev, TG3PCI_PCISTATE,
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&
-- 
1.8.5.1

