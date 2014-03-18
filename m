Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbaCRXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:07:19 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758335AbaCRXHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:07:17 -0400
From: Richard Weinberger <richard@nod.at>
To: eli.billauer@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] staging/xillybus: Handle OOM in xillybus_init()
Date: Wed, 19 Mar 2014 00:07:05 +0100
Message-Id: <1395184025-17278-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_workqueue() can fail and returns NULL in case of
OOM.
Handle this case and undo class_create().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/staging/xillybus/xillybus_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index 2ebaf16..b0a6696 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -2318,8 +2318,12 @@ static int __init xillybus_init(void)
 	}
 
 	xillybus_wq = alloc_workqueue(xillyname, 0, 0);
+	if (!xillybus_wq) {
+		class_destroy(xillybus_class);
+		rc = -ENOMEM;
+	}
 
-	return 0; /* Success */
+	return rc;
 }
 
 static void __exit xillybus_exit(void)
-- 
1.8.1.4

