Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3DMCHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:07:17 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:5076 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3DMCHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:07:16 -0400
X-MDAV-Processed: mail.digidescorp.com, Fri, 12 Apr 2013 21:07:15 -0500
X-Spam-Processed: mail.digidescorp.com, Fri, 12 Apr 2013 21:07:14 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.135.161.176
X-Return-Path: smagnani@iscandar.digidescorp.com
X-Envelope-From: smagnani@iscandar.digidescorp.com
From: Steve Magnani <smagnani@iscandar.digidescorp.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH, resend] sd: fix infinite kernel/udev loop on non-removable Medium Not Present
Date: Fri, 12 Apr 2013 21:06:47 -0500
Message-Id: <1365818807-12292-1-git-send-email-smagnani@iscandar.digidescorp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
set_media_not_present() in a way that prevents the sd driver from
remembering that a non-removable device has reported "Medium Not Present".
This condition can occur on hotplug of a (i.e.) USB Mass Storage device
whose medium is offline due to an unrecoverable controller error,
but which is otherwise capable of SCSI communication (to download new 
microcode, etc.).

Under these conditions, the changed code results in an infinite loop
between the kernel and udevd. When udevd attempts to open the device
in response to a change notification, a SCSI "Medium Not Present" error
occurs which causes the kernel to signal another change. The cycle
repeats until the device is unplugged, resulting in udevd consuming ever-
increasing amounts of CPU and virtual memory.

Resolve this by remembering "media not present" whether the device has
declared itself "removable" or not.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
--- a/drivers/scsi/sd.c	2013-04-12 14:16:12.252531097 -0500
+++ b/drivers/scsi/sd.c	2013-04-12 14:21:55.197216521 -0500
@@ -1298,10 +1298,8 @@ out:
 
 static void set_media_not_present(struct scsi_disk *sdkp)
 {
-	if (sdkp->media_present)
+	if (sdkp->media_present) {
 		sdkp->device->changed = 1;
-
-	if (sdkp->device->removable) {
 		sdkp->media_present = 0;
 		sdkp->capacity = 0;
 	}

