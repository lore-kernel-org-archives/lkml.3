Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaCHXJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:09:15 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaCHXJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:09:14 -0500
From: Richard Weinberger <richard@nod.at>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] w1: Fix refcount leak in netlink connector
Date: Sun,  9 Mar 2014 00:08:48 +0100
Message-Id: <1394320128-26505-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If userspace sends a w1 message of length 0 we leak
the refcount.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/w1/w1_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 40788c9..7131777 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -355,7 +355,7 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 		err = 0;
 		if (!mlen)
-			goto out_cont;
+			goto out_dec;
 
 		mutex_lock(&dev->mutex);
 
@@ -384,10 +384,11 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
 		}
 out_up:
+		mutex_unlock(&dev->mutex);
+out_dec:
 		atomic_dec(&dev->refcnt);
 		if (sl)
 			atomic_dec(&sl->refcnt);
-		mutex_unlock(&dev->mutex);
 out_cont:
 		if (!cmd || err)
 			w1_netlink_send_error(msg, m, cmd, err);
-- 
1.8.4.2

