Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3LJH7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:59:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3LJH7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.4 06/25] SCSI: enclosure: fix WARN_ON in dual path device removing
Date: Tue, 10 Dec 2013 00:00:14 -0800
Message-Id: <20131210075931.273322099@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/enclosure.c |    7 +++++++
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


