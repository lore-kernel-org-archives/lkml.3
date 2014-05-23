Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaEWE0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:26:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38289 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaEWE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:22 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: fix use-after-free bug in slic_entry_remove
Date: Thu, 22 May 2014 21:25:45 -0700
Message-Id: <1400819147-14236-6-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a use-after-free bug that causes a null pointer dereference in
slic_entry_halt().

Since unregister_netdev() will ultimately call slic_entry_halt() (the
net_device ndo_stop() virtual function for this device), we should
call it before freeing the memory that is used by slic_entry_halt().
Specifically, slic_unmap_mmio_space() frees adapter->slic_regs, but
those registers are used in slic_entry_halt().

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
This patch was originally sent here https://lkml.org/lkml/2014/5/6/5 with
my google.com email address. But due to Google's recent change in DMARC
policies, that patchset was silently dropped for at least some users
(including my personal gmail account). So I'm sending it out now with
my gmail.com account. Let me know if this is an issue. Thanks.

 drivers/staging/slicoss/slicoss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d670490..b8eeb3b 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2526,9 +2526,10 @@ static void slic_entry_remove(struct pci_dev *pcidev)
 	struct sliccard *card;
 	struct mcast_address *mcaddr, *mlist;
 
+	unregister_netdev(dev);
+
 	slic_adapter_freeresources(adapter);
 	slic_unmap_mmio_space(adapter);
-	unregister_netdev(dev);
 
 	/* free multicast addresses */
 	mlist = adapter->mcastaddrs;
-- 
1.9.2

