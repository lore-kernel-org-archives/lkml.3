Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaABRKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:10:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaABRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:10:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 85/91] [SCSI] enclosure: fix WARN_ON in dual path device removing
Date: Thu,  2 Jan 2014 09:05:00 -0800
Message-Id: <1388682306-30859-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/enclosure.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fcac8..cbee842 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -198,6 +198,13 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
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
-- 
1.8.3.2

