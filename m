Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaEWEiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:38:52 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52250 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaEWEiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:38:50 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 1/2] staging: slicoss: fix dma memory leak
Date: Thu, 22 May 2014 21:38:44 -0700
Message-Id: <1400819925-19390-2-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
References: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in slic_card_init. If the driver fails to poll for an
interrupt after requesting config data from the device the dma memory
is never freed.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
This patch was originally sent here https://lkml.org/lkml/2014/5/6/7 with
my google.com email address. But due to Google's recent change in DMARC
policies, that patchset was silently dropped for at least some users
(including my personal gmail account). So I'm sending it out now with
my gmail.com account. Let me know if this is an issue. Thanks.

 drivers/staging/slicoss/slicoss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index e27b88f..5b82455 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3293,6 +3293,9 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
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

