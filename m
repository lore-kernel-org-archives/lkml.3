Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaHLHWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:22:20 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34158 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaHLHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:22:18 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <cpw@sgi.com>, <robinmholt@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] sgi-xp: Do not use BUG_ON(!spin_is_locked())
Date: Tue, 12 Aug 2014 13:05:13 +0530
Message-ID: <1407828913-7461-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 12 Aug 2014 07:22:17.0175 (UTC) FILETIME=[25748E70:01CFB5FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on some architecture spin_is_locked() always return false in
uniprocessor configuration and can therefore not be used
with BUG_ON.it would be advise to replace with
lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/misc/sgi-xp/xpc_channel.c | 6 +++---
 drivers/misc/sgi-xp/xpc_sn2.c     | 2 +-
 drivers/misc/sgi-xp/xpc_uv.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
index 128d561..240fe5a 100644
--- a/drivers/misc/sgi-xp/xpc_channel.c
+++ b/drivers/misc/sgi-xp/xpc_channel.c
@@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)
 {
 	enum xp_retval ret;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(!spin_is_locked(&ch->lock));
 
 	if (!(ch->flags & XPC_C_OPENREQUEST) ||
 	    !(ch->flags & XPC_C_ROPENREQUEST)) {
@@ -82,7 +82,7 @@ xpc_process_disconnect(struct xpc_channel *ch, unsigned long *irq_flags)
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	u32 channel_was_connected = (ch->flags & XPC_C_WASCONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(!spin_is_locked(&ch->lock));
 
 	if (!(ch->flags & XPC_C_DISCONNECTING))
 		return;
@@ -758,7 +758,7 @@ xpc_disconnect_channel(const int line, struct xpc_channel *ch,
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(!spin_is_locked(&ch->lock));
 
 	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
 		return;
diff --git a/drivers/misc/sgi-xp/xpc_sn2.c b/drivers/misc/sgi-xp/xpc_sn2.c
index 7d71c04..f90ee26 100644
--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1674,7 +1674,7 @@ xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(!spin_is_locked(&ch->lock));
 
 	ch_sn2->remote_msgqueue_pa = 0;
 
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 95c8944..a349940 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1183,7 +1183,7 @@ xpc_teardown_msg_structures_uv(struct xpc_channel *ch)
 {
 	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(!spin_is_locked(&ch->lock));
 
 	kfree(ch_uv->cached_notify_gru_mq_desc);
 	ch_uv->cached_notify_gru_mq_desc = NULL;
-- 
1.7.11.7

