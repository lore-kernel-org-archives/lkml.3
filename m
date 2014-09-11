Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaIKESS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:18:18 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58247 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIKESP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:18:15 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>, "cpw@sgi.com" <cpw@sgi.com>,
        "robinmholt@gmail.com" <robinmholt@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] sgi-xp: Do not use BUG_ON(!spin_is_locked())
Thread-Topic: [PATCH v2] sgi-xp: Do not use BUG_ON(!spin_is_locked())
Thread-Index: AQHPvDbRiPjNFn0RrUezFzhXDH8k0pv7dhnw
Date: Thu, 11 Sep 2014 04:18:12 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF4E4A5@EU-MBX-02.mgc.mentorg.com>
References: <1408512947-12916-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1408512947-12916-1-git-send-email-sanjeev_sharma@mentor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Sanjeev Sharma [mailto:sanjeev_sharma@mentor.com] 
Sent: Wednesday, August 20, 2014 11:06 AM
To: cpw@sgi.com; robinmholt@gmail.com
Cc: linux-kernel@vger.kernel.org; Sharma, Sanjeev; Sharma, Sanjeev
Subject: [PATCH v2] sgi-xp: Do not use BUG_ON(!spin_is_locked())

on some architecture spin_is_locked() always return false in uniprocessor configuration and can therefore not be used with BUG_ON.it would be advise to replace with lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
Changes in v2:
  - corrected the typo

 drivers/misc/sgi-xp/xpc_channel.c | 6 +++---
 drivers/misc/sgi-xp/xpc_sn2.c     | 2 +-
 drivers/misc/sgi-xp/xpc_uv.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
index 128d561..611d34f 100644
--- a/drivers/misc/sgi-xp/xpc_channel.c
+++ b/drivers/misc/sgi-xp/xpc_channel.c
@@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)  {
 	enum xp_retval ret;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_OPENREQUEST) ||
 	    !(ch->flags & XPC_C_ROPENREQUEST)) { @@ -82,7 +82,7 @@ xpc_process_disconnect(struct xpc_channel *ch, unsigned long *irq_flags)
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	u32 channel_was_connected = (ch->flags & XPC_C_WASCONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_DISCONNECTING))
 		return;
@@ -758,7 +758,7 @@ xpc_disconnect_channel(const int line, struct xpc_channel *ch,  {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
 		return;
diff --git a/drivers/misc/sgi-xp/xpc_sn2.c b/drivers/misc/sgi-xp/xpc_sn2.c index 7d71c04..9d3b113 100644
--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1674,7 +1674,7 @@ xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)  {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	ch_sn2->remote_msgqueue_pa = 0;
 
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c index 95c8944..828733c 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1183,7 +1183,7 @@ xpc_teardown_msg_structures_uv(struct xpc_channel *ch)  {
 	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	kfree(ch_uv->cached_notify_gru_mq_desc);
 	ch_uv->cached_notify_gru_mq_desc = NULL;
--
1.7.11.7

Any update on this patch because it's been quite long time .


Regards
Sanjeev Sharma
