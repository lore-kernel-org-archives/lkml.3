Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaJCXnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:43:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbaJCWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: [PATCH 3.14 092/238] uwb: init beacon cache entry before registering uwb device
Date: Fri,  3 Oct 2014 14:30:07 -0700
Message-Id: <20141003212916.620886237@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/uwb/lc-dev.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -431,16 +431,19 @@ void uwbd_dev_onair(struct uwb_rc *rc, s
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
@@ -448,6 +451,8 @@ void uwbd_dev_onair(struct uwb_rc *rc, s
 	return;
 
 error_dev_add:
+	bce->uwb_dev = NULL;
+	uwb_bce_put(bce);
 	kfree(uwb_dev);
 	return;
 }


