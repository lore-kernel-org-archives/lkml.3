Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3DWEjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:39:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:63561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3DWEja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,531,1363158000"; 
   d="scan'208";a="322724401"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: reduce flow control only for completed messages
Date: Tue, 23 Apr 2013 07:38:12 +0300
Message-Id: <1366691892-11108-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes bug when only first chunk of a large message split
by hbuf_max_len is written to the hardware.
All the consequent chunks will not get a new credit.

A regression introduced by the commit
0ef319c93cebff9f82bdd0cdbb298f2dd00acda8
mei: streamline write complete flow function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7473071..5ee2f07 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -356,13 +356,14 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 		return -ENODEV;
 	}
 
-	if (mei_cl_flow_ctrl_reduce(cl))
-		return -ENODEV;
 
 	cl->status = 0;
 	cb->buf_idx += mei_hdr.length;
-	if (mei_hdr.msg_complete)
+	if (mei_hdr.msg_complete) {
+		if (mei_cl_flow_ctrl_reduce(cl))
+			return -ENODEV;
 		list_move_tail(&cb->list, &dev->write_waiting_list.list);
+	}
 
 	return 0;
 }
-- 
1.8.1.2

