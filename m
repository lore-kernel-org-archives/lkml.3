Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbaEFEEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:04:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54041 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933767AbaEFEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:34 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 6/7] staging: slicoss: fix 64-bit isr address bug
Date: Mon,  5 May 2014 21:02:36 -0700
Message-Id: <1399348957-16663-7-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug that only manifests when the physical address of
the interrupt status register is >4GB. Specifically, the driver was only
telling the device about the lower 32 bits of the ISR. This patch adds
the upper 32 bits.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slicoss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 01401e0..55afe0d 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2815,7 +2815,8 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 
 		spin_lock_irqsave(&adapter->bit64reglock.lock,
 					adapter->bit64reglock.flags);
-		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
+		slic_reg32_write(&slic_regs->slic_addr_upper,
+				 SLIC_GET_ADDR_HIGH(&pshmem->isr), DONT_FLUSH);
 		slic_reg32_write(&slic_regs->slic_isp,
 				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
 		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
-- 
1.9.2

