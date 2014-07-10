Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaGJISK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:18:10 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62232 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaGJISE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:18:04 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>
Subject: [PATCH v7 02/33] net: set name assign type for renamed devices
Date: Thu, 10 Jul 2014 10:17:07 +0200
Message-Id: <1404980258-30853-3-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a patch from David Herrmann.

This is the only place devices can be renamed.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
---
 net/core/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 30eedf6..7765ec5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1083,6 +1083,7 @@ static int dev_get_valid_name(struct net *net,
 int dev_change_name(struct net_device *dev, const char *newname)
 {
 	char oldname[IFNAMSIZ];
+	unsigned char old_assign_type;
 	int err = 0;
 	int ret;
 	struct net *net;
@@ -1109,10 +1110,14 @@ int dev_change_name(struct net_device *dev, const char *newname)
 		return err;
 	}
 
+	old_assign_type = dev->name_assign_type;
+	dev->name_assign_type = NET_NAME_RENAMED;
+
 rollback:
 	ret = device_rename(&dev->dev, dev->name);
 	if (ret) {
 		memcpy(dev->name, oldname, IFNAMSIZ);
+		dev->name_assign_type = old_assign_type;
 		write_seqcount_end(&devnet_rename_seq);
 		return ret;
 	}
@@ -1141,6 +1146,8 @@ rollback:
 			write_seqcount_begin(&devnet_rename_seq);
 			memcpy(dev->name, oldname, IFNAMSIZ);
 			memcpy(oldname, newname, IFNAMSIZ);
+			dev->name_assign_type = old_assign_type;
+			old_assign_type = NET_NAME_RENAMED;
 			goto rollback;
 		} else {
 			pr_err("%s: name change rollback failed: %d\n",
-- 
1.9.3

