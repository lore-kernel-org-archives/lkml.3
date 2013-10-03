Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3JCSdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:33:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:19943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3JCSdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:33:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1027,1371106800"; 
   d="scan'208";a="387470020"
From: David Cohen <david.a.cohen@linux.intel.com>
To: ohad@wizery.com
Cc: linux-kernel@vger.kernel.org, Jocelyn Falempe <jocelyn.falempe@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] rpmsg: reduce rpmsg_virtio verbosity
Date: Thu,  3 Oct 2013 11:36:55 -0700
Message-Id: <1380825415-20481-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jocelyn Falempe <jocelyn.falempe@intel.com>

rpmsg_virtio TX/RX messages are very verbose, overflowing kernel printk
buffer. This patch makes the guilty print_hex_dump()'s to act as
dev_dbg() and do nothing in case neither DEBUG nor CONFIG_DYNAMIC_DEBUG
are defined.

Signed-off-by: Jocelyn Falempe <jocelyn.falempe@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index b6135d4..e7c5927 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -749,8 +749,10 @@ int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
 	dev_dbg(dev, "TX From 0x%x, To 0x%x, Len %d, Flags %d, Reserved %d\n",
 					msg->src, msg->dst, msg->len,
 					msg->flags, msg->reserved);
-	print_hex_dump(KERN_DEBUG, "rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
+#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
+	print_hex_dump_debug("rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
 					msg, sizeof(*msg) + msg->len, true);
+#endif
 
 	sg_init_one(&sg, msg, sizeof(*msg) + len);
 
@@ -786,8 +788,10 @@ static int rpmsg_recv_single(struct virtproc_info *vrp, struct device *dev,
 	dev_dbg(dev, "From: 0x%x, To: 0x%x, Len: %d, Flags: %d, Reserved: %d\n",
 					msg->src, msg->dst, msg->len,
 					msg->flags, msg->reserved);
-	print_hex_dump(KERN_DEBUG, "rpmsg_virtio RX: ", DUMP_PREFIX_NONE, 16, 1,
+#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
+	print_hex_dump_debug("rpmsg_virtio RX: ", DUMP_PREFIX_NONE, 16, 1,
 					msg, sizeof(*msg) + msg->len, true);
+#endif
 
 	/*
 	 * We currently use fixed-sized buffers, so trivially sanitize
-- 
1.8.4.rc3

