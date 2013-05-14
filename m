Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3ENVuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:50:46 -0400
Received: from mailout.micron.com ([137.201.242.129]:43651 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab3ENVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:50:45 -0400
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 17:50:45 EDT
Message-ID: <5192B209.1010301@micron.com>
Date: Tue, 14 May 2013 14:52:09 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <asamymuthupa@micron.com>,
        <sbradshaw@micron.com>
Subject: [PATCH][TRIVIAL] mtip32xx: Fix NULL pointer dereference during module
 unload
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19866.002
X-TM-AS-Result: No-9.190000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An open file-handle to one or more of the driver exported debugfs
nodes causes raciness in recursive removal during module unload;
sometimes a stale parent dentry is dereferenced when more than 1
pci device is present.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
diff --git a/drivers/block/mtip32xx/mtip32xx.c
b/drivers/block/mtip32xx/mtip32xx.c
index 847107e..e366c74 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3002,7 +3002,8 @@ static int mtip_hw_debugfs_init(struct driver_data
*dd)

 static void mtip_hw_debugfs_exit(struct driver_data *dd)
 {
-	debugfs_remove_recursive(dd->dfs_node);
+	if (dd->dfs_node)
+		debugfs_remove_recursive(dd->dfs_node);
 }



