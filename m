Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaCFVzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:55:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:45765 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbaCFVyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:54:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,603,1389772800"; 
   d="scan'208";a="493743502"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix regressions caused by removing ext_msg
Date: Thu,  6 Mar 2014 23:53:53 +0200
Message-Id: <1394142833-15724-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

1. Delete cb from list before freeing it
2. Fix missed break that leads to
switch case fall-through and BUG invocation.

Regression from:
commit 6bb948c9e500d24321c36c67c81daf8d1a7e561e
mei: get rid of ext_msg

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 5aab335..2fbf0c0 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -187,6 +187,7 @@ static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
 
 	cl->state = MEI_FILE_DISCONNECTED;
 	cl->status = 0;
+	list_del(&cb->list);
 	mei_io_cb_free(cb);
 
 	return ret;
@@ -522,6 +523,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 			ret = mei_cl_irq_disconnect_rsp(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
+			break;
 		default:
 			BUG();
 		}
-- 
1.8.5.3

