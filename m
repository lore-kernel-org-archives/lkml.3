Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbaKLDzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:55:08 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33413
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaKLDzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:55:04 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, vkuznets@redhat.com
Subject: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer failure
Date: Tue, 11 Nov 2014 21:03:26 -0800
Message-Id: <1415768606-28538-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case the user-space daemon crashes, hangs or is killed, we
need to down the semaphore, otherwise, after the daemon starts next
time, the obsolete data in fcopy_transaction.message or
fcopy_transaction.fcopy_msg will be used immediately.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/hv/hv_fcopy.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 23b2ce2..177122a 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct *dummy)
 	 * process the pending transaction.
 	 */
 	fcopy_respond_to_host(HV_E_FAIL);
+
+	/* In the case the user-space daemon crashes, hangs or is killed, we
+	 * need to down the semaphore, otherwise, after the daemon starts next
+	 * time, the obsolete data in fcopy_transaction.message or
+	 * fcopy_transaction.fcopy_msg will be used immediately.
+	 */
+	if (down_trylock(&fcopy_transaction.read_sema))
+		pr_debug("FCP: failed to acquire the semaphore\n");
+
 }
 
 static int fcopy_handle_handshake(u32 version)
-- 
1.9.1

