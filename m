Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788Ab3FWGk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 02:40:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:58746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab3FWGjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 02:39:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="358108642"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/4] mei: do not override a client writing state when buffering
Date: Sun, 23 Jun 2013 09:37:00 +0300
Message-Id: <1371969422-16530-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371969422-16530-1-git-send-email-tomas.winkler@intel.com>
References: <1371969422-16530-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when we buffer write request we should not switch to
MEI_WRITING since this will override MEI_WRITE_COMPLETE
state of preceding write

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 788f647..11a465a 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -731,7 +731,9 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
 	}
 
 	cl->status = 0;
+	cl->writing_state = MEI_WRITING;
 	cb->buf_idx += mei_hdr.length;
+
 	if (mei_hdr.msg_complete) {
 		if (mei_cl_flow_ctrl_reduce(cl))
 			return -ENODEV;
@@ -783,7 +785,6 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 		cb->buf_idx = 0;
 		/* unseting complete will enqueue the cb for write */
 		mei_hdr.msg_complete = 0;
-		cl->writing_state = MEI_WRITING;
 		rets = buf->size;
 		goto out;
 	}
-- 
1.8.1.2

