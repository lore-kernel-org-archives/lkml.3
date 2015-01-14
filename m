Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbbANImt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:42:49 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36685
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbbANImr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:42:47 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, vkuznets@redhat.com
Cc: kys@microsoft.com
Subject: [PATCH v4] hv: hv_fcopy: drop the obsolete message on transfer failure
Date: Wed, 14 Jan 2015 01:55:10 -0800
Message-Id: <1421229310-15563-1-git-send-email-decui@microsoft.com>
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

v4: this is a resend of v3, plus adding a comment before
    fcopy_release().
---
 drivers/hv/hv_fcopy.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 23b2ce2..cd453e4 100644
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
@@ -344,6 +356,14 @@ static int fcopy_open(struct inode *inode, struct file *f)
 	return 0;
 }
 
+/* XXX: there are still some tricky corner cases, e.g.,
+ * 1) In a SMP guest, when fcopy_release() runs between
+ * schedule_delayed_work() and fcopy_send_data(), there is
+ * still a chance an obsolete message will be queued.
+ *
+ * 2) When the fcopy daemon is running, if we unload the driver,
+ * we'll notice a kernel oops when we kill the daemon later.
+ */
 static int fcopy_release(struct inode *inode, struct file *f)
 {
 	/*
@@ -351,6 +371,13 @@ static int fcopy_release(struct inode *inode, struct file *f)
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

