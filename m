Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaKAWos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:44:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60306 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbaKAWjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Thomas Pugliese" <thomas.pugliese@gmail.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.932811909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/102] uwb: init beacon cache entry before
 registering uwb device
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/uwb/lc-dev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -441,16 +441,19 @@ void uwbd_dev_onair(struct uwb_rc *rc, s
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
@@ -458,6 +461,8 @@ void uwbd_dev_onair(struct uwb_rc *rc, s
 	return;
 
 error_dev_add:
+	bce->uwb_dev = NULL;
+	uwb_bce_put(bce);
 	kfree(uwb_dev);
 	return;
 }

