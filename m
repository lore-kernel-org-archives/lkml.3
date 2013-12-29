Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3L2Cjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:39:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab3L2CKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, wenxiong@linux.vnet.ibm.com,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.875668723@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 114/185] [SCSI] enclosure: fix WARN_ON in dual path
 device removing
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit a1470c7bf3a4676e62e4c0fb204e339399eb5c59 upstream.

Bug report from: wenxiong@linux.vnet.ibm.com

The issue is happened in dual controller configuration. We got the
sysfs warnings when rmmod the ipr module.

enclosure_unregister() in drivers/msic/enclosure.c, call device_unregister()
for each componment deivce, device_unregister() ->device_del()->kobject_del()
->sysfs_remove_dir(). In sysfs_remove_dir(), set kobj->sd = NULL.

For each componment device,
enclosure_component_release()->enclosure_remove_links()->sysfs_remove_link()
in which checking kobj->sd again, it has been set as NULL when doing
device_unregister. So we saw all these sysfs WARNING.

Tested-by: wenxiong@linux.vnet.ibm.com
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/misc/enclosure.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -198,6 +198,13 @@ static void enclosure_remove_links(struc
 {
 	char name[ENCLOSURE_NAME_SIZE];
 
+	/*
+	 * In odd circumstances, like multipath devices, something else may
+	 * already have removed the links, so check for this condition first.
+	 */
+	if (!cdev->dev->kobj.sd)
+		return;
+
 	enclosure_link_name(cdev, name);
 	sysfs_remove_link(&cdev->dev->kobj, name);
 	sysfs_remove_link(&cdev->cdev.kobj, "device");

