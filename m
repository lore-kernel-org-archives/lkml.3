Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaANA24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaANA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>, Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 18/77] tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0
Date: Mon, 13 Jan 2014 16:27:39 -0800
Message-Id: <20140114002753.020523421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -16485,6 +16485,9 @@ static int tg3_get_invariants(struct tg3
 	/* Clear this out for sanity. */
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
 
+	/* Clear TG3PCI_REG_BASE_ADDR to prevent hangs. */
+	tw32(TG3PCI_REG_BASE_ADDR, 0);
+
 	pci_read_config_dword(tp->pdev, TG3PCI_PCISTATE,
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&


