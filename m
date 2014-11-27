Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbaK0GWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:22:12 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36193
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaK0GWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:22:10 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        vkuznets@redhat.com
Cc: haiyangz@microsoft.com
Subject: [PATCH v2] hv: hv_fcopy: drop the obsolete message on transfer failure
Date: Wed, 26 Nov 2014 23:31:31 -0800
Message-Id: <1417073491-19388-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case the user-space daemon crashes, hangs or is killed, we
need to down the semaphore, otherwise, after the daemon starts next
time, the obsolete data in fcopy_transaction.message or
fcopy_transaction.fcopy_msg will be used immediately.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

v2: I removed the "FCP" prefix as Greg asked.

    I also updated the output message a little:
    "FCP: failed to acquire the semaphore" --> 
    "can not acquire the semaphore: it is benign"

 drivers/hv/hv_fcopy.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 23b2ce2..c518ad9 100644
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
+		pr_debug("can not acquire the semaphore: it is benign\n");
+
 }
 
 static int fcopy_handle_handshake(u32 version)
-- 
1.9.1

