Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaK0L7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:59:47 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:33726
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbaK0L7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:59:45 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        vkuznets@redhat.com
Cc: haiyangz@microsoft.com
Subject: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer failure
Date: Thu, 27 Nov 2014 05:09:07 -0800
Message-Id: <1417093747-21073-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case the user-space daemon crashes, hangs or is killed, we
need to down the semaphore, otherwise, after the daemon starts next
time, the obsolete data in fcopy_transaction.message or
fcopy_transaction.fcopy_msg will be used immediately.

Cc: Jason Wang <jasowang@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

v2: I removed the "FCP" prefix as Greg asked.

    I also updated the output message a little:
    "FCP: failed to acquire the semaphore" --> 
    "can not acquire the semaphore: it is benign"

v3: I added the code in fcopy_release() as Jason Wang suggested.
    I removed the pr_debug (it isn't so meaningful)and added a comment instead.

 drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 23b2ce2..faa6ba6 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -86,6 +86,18 @@ static void fcopy_work_func(struct work_struct *dummy)
 	 * process the pending transaction.
 	 */
 	fcopy_respond_to_host(HV_E_FAIL);
+
+	/* In the case the user-space daemon crashes, hangs or is killed, we
+	 * need to down the semaphore, otherwise, after the daemon starts next
+	 * time, the obsolete data in fcopy_transaction.message or
+	 * fcopy_transaction.fcopy_msg will be used immediately.
+	 *
+	 * NOTE: fcopy_read() happens to get the semaphore (very rare)? We're
+	 * still OK, because we've reported the failure to the host.
+	 */
+	if (down_trylock(&fcopy_transaction.read_sema))
+		;
+
 }
 
 static int fcopy_handle_handshake(u32 version)
@@ -351,6 +363,13 @@ static int fcopy_release(struct inode *inode, struct file *f)
 	 */
 	in_hand_shake = true;
 	opened = false;
+
+	if (cancel_delayed_work_sync(&fcopy_work)) {
+		/* We haven't up()-ed the semaphore(very rare)? */
+		if (down_trylock(&fcopy_transaction.read_sema))
+			;
+		fcopy_respond_to_host(HV_E_FAIL);
+	}
 	return 0;
 }
 
-- 
1.9.1

