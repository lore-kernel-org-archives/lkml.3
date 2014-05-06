Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaEFEEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:04:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39196 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaEFEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:33 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 5/7] staging: slicoss: fix dma memory leak
Date: Mon,  5 May 2014 21:02:35 -0700
Message-Id: <1399348957-16663-6-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak in slic_card_init. If the driver fails
to poll for an interrupt after requesting config data from the device
the dma memory is never freed.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slicoss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 39e6489..01401e0 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2852,6 +2852,9 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 						&slic_regs->slic_isp, 0,
 						&slic_regs->slic_addr_upper,
 						0, FLUSH);
+					pci_free_consistent(adapter->pcidev,
+						sizeof(struct slic_eeprom),
+						peeprom, phys_config);
 					return -EINVAL;
 				}
 			}
-- 
1.9.2

