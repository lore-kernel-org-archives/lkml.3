Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaEWE01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:26:27 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46219 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaEWE0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:21 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: fix 64-bit isr address bug
Date: Thu, 22 May 2014 21:25:44 -0700
Message-Id: <1400819147-14236-5-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug that only manifests when the physical address of the
interrupt status register is >4GB. Specifically, the driver was only
telling the device about the lower 32 bits of the ISR. This patch adds
the upper 32 bits.

Without this patch, polling the ISR times out whenever the physical
address of the ISR is >4GB. This causes the driver to think it failed
to fetch config data from the device when it really didn't.

Note: The way 64-bit addresses are handled in this driver needs a
rework. There is an entry in the TODO file for this. That will be
a rather large patch set which will change a lot of the driver. So
for the time being, this patch will at least let the driver run
correctly on 64-bit machines with >4GB of physical memory.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
This patch was originally sent here https://lkml.org/lkml/2014/5/6/6 with
my google.com email address. But due to Google's recent change in DMARC
policies, that patchset was silently dropped for at least some users
(including my personal gmail account). So I'm sending it out now with
my gmail.com account. Let me know if this is an issue. Thanks.

 drivers/staging/slicoss/slicoss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 39e6489..d670490 100644
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

