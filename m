Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaK0JO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:14:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:41526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbaK0IrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:05 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 27/91] uwb: init beacon cache entry before registering uwb device
Date: Thu, 27 Nov 2014 16:42:10 +0800
Message-Id: <1417077794-9299-27-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Pugliese <thomas.pugliese@gmail.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 675f0ab2fe5a0f7325208e60b617a5f32b86d72c upstream.

Make sure the uwb_dev->bce entry is set before calling uwb_dev_add in
uwbd_dev_onair so that usermode will only see the device after it is
properly initialized.  This fixes a kernel panic that can occur if
usermode tries to access the IEs sysfs attribute of a UWB device before
the driver has had a chance to set the beacon cache entry.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/uwb/lc-dev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index 5241f1d..3c9e929 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -441,16 +441,19 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_e *bce)
 	uwb_dev->mac_addr = *bce->mac_addr;
 	uwb_dev->dev_addr = bce->dev_addr;
 	dev_set_name(&uwb_dev->dev, macbuf);
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
@@ -458,6 +461,8 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_e *bce)
 	return;
 
 error_dev_add:
+	bce->uwb_dev = NULL;
+	uwb_bce_put(bce);
 	kfree(uwb_dev);
 	return;
 }
-- 
1.9.1

