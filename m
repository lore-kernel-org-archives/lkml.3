Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaEFEDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:03:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39569 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbaEFEDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:35 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 7/7] staging: slicoss: fix use-after-free bug in slic_entry_remove
Date: Mon,  5 May 2014 21:02:37 -0700
Message-Id: <1399348957-16663-8-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a use-after-free bug that causes a null pointer
dereference in slic_entry_halt.

Since unregister_netdev() will ultimately call slic_entry_halt (the
net_device ndo_stop() virtual function for this device), we should
call it before freeing the memory used by slic_entry_halt.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slicoss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 55afe0d..96b29ec 100644
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

