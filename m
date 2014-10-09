Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaJIVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJIVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/163] uwb: init beacon cache entry before registering uwb device
Date: Thu,  9 Oct 2014 14:01:08 -0700
Message-Id: <1412888588-26755-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 675f0ab2fe5a0f7325208e60b617a5f32b86d72c upstream.

Make sure the uwb_dev->bce entry is set before calling uwb_dev_add in
uwbd_dev_onair so that usermode will only see the device after it is
properly initialized.  This fixes a kernel panic that can occur if
usermode tries to access the IEs sysfs attribute of a UWB device before
the driver has had a chance to set the beacon cache entry.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/uwb/lc-dev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index 80079b8..d0303f0 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -431,16 +431,19 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_e *bce)
 	uwb_dev->mac_addr = *bce->mac_addr;
 	uwb_dev->dev_addr = bce->dev_addr;
 	dev_set_name(&uwb_dev->dev, "%s", macbuf);
+
+	/* plug the beacon cache */
+	bce->uwb_dev = uwb_dev;
+	uwb_dev->bce = bce;
+	uwb_bce_get(bce);		/* released in uwb_dev_sys_release() */
+
 	result = uwb_dev_add(uwb_dev, &rc->uwb_dev.dev, rc);
 	if (result < 0) {
 		dev_err(dev, "new device %s: cannot instantiate device\n",
 			macbuf);
 		goto error_dev_add;
 	}
-	/* plug the beacon cache */
-	bce->uwb_dev = uwb_dev;
-	uwb_dev->bce = bce;
-	uwb_bce_get(bce);		/* released in uwb_dev_sys_release() */
+
 	dev_info(dev, "uwb device (mac %s dev %s) connected to %s %s\n",
 		 macbuf, devbuf, rc->uwb_dev.dev.parent->bus->name,
 		 dev_name(rc->uwb_dev.dev.parent));
@@ -448,6 +451,8 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_e *bce)
 	return;
 
 error_dev_add:
+	bce->uwb_dev = NULL;
+	uwb_bce_put(bce);
 	kfree(uwb_dev);
 	return;
 }
-- 
1.9.1

