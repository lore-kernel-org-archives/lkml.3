Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3ENWCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:02:23 -0400
Received: from mailout.micron.com ([137.201.242.129]:38275 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3ENWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:02:22 -0400
Message-ID: <5192ACB6.5000302@micron.com>
Date: Tue, 14 May 2013 14:29:26 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <asamymuthupa@mcrion.com>
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


