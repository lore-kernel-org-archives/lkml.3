Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3H3TVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:21:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16049 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3H3TU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:20:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 Aug 2013 12:18:20 -0700
Message-ID: <5220F099.1020002@nvidia.com>
Date: Fri, 30 Aug 2013 12:20:57 -0700
From: Arjun Gopalan <agopalan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: <ohad@wizery.com>, <swetland@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: permission to move definition of struct rpmsg_channel_info
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad/Brian,

I have been working on rpmsg and I need to be able to create static rpmsg channels. Channel information needs to be specified by other drivers and for this, the drivers need access to struct rpmsg_channel_info.

So, can I move the definition of struct rpmsg_channel_info from drivers/rpmsg/virtio_rpmsg_bus.c to include/linux/rpmsg.h ?

I have a patch (enclosed inline) for the same. Please let me know if you have any thoughts on this.
Thanks.


commit 6b6ddce3bbf89f0e0ae42aae799f7ff9b5c4a05b
Author: Arjun Gopalan <agopalan@nvidia.com>
Date:   Mon Jul 8 17:34:52 2013 -0700

    rpmsg: Create static rpmsg channels
   
    Adds support for creating static channels when rpmsg_probe()
    is called.
   
    NOTE:
    -----
    This patch also moves the definition of struct rpmsg_channel_info
    from virtio_rpmsg_bus.c to linux/rpmsg.h because hardcoded static
    channels need to be used by other drivers.
   
    Change-Id: I9f86d19538c75f2361287a136e4aa7e3351189e7
    Signed-off-by: Arjun Gopalan <agopalan@nvidia.com>

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f56c8ba..7b006e5 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -3,10 +3,14 @@
  *
  * Copyright (C) 2011 Texas Instruments, Inc.
  * Copyright (C) 2011 Google, Inc.
+ * Copyright (c) 2013, NVIDIA CORPORATION. All rights reserved.
  *
  * Ohad Ben-Cohen <ohad@wizery.com>
  * Brian Swetland <swetland@google.com>
  *
+ * Supporting static rpmsg channels derived from TI's kernel
+ * Arjun Gopalan <agopalan@nvidia.com>
+ *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
  * may be copied, distributed, and modified under those terms.
@@ -70,18 +74,6 @@ struct virtproc_info {
     struct rpmsg_endpoint *ns_ept;
 };
 
-/**
- * struct rpmsg_channel_info - internal channel info representation
- * @name: name of service
- * @src: local address
- * @dst: destination address
- */
-struct rpmsg_channel_info {
-    char name[RPMSG_NAME_SIZE];
-    u32 src;
-    u32 dst;
-};
-
 #define to_rpmsg_channel(d) container_of(d, struct rpmsg_channel, dev)
 #define to_rpmsg_driver(d) container_of(d, struct rpmsg_driver, drv)
 
@@ -935,6 +927,7 @@ static int rpmsg_probe(struct virtio_device *vdev)
     struct virtproc_info *vrp;
     void *bufs_va;
     int err = 0, i;
+    struct rpmsg_channel_info *ch;
 
     vrp = kzalloc(sizeof(*vrp), GFP_KERNEL);
     if (!vrp)
@@ -1004,6 +997,11 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
     dev_info(&vdev->dev, "rpmsg host is online\n");
 
+    vdev->config->get(vdev, VPROC_STATIC_CHANNELS, &ch, sizeof(ch));
+
+    for (i = 0; ch && ch[i].name[0]; i++)
+        rpmsg_create_channel(vrp, &ch[i]);
+
     return 0;
 
 free_coherent:
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 82a6739..9780784 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -95,6 +95,11 @@ enum rpmsg_ns_flags {
 
 #define RPMSG_ADDR_ANY        0xFFFFFFFF
 
+/* driver requests */
+enum {
+    VPROC_STATIC_CHANNELS,
+};
+
 struct virtproc_info;
 
 /**
@@ -117,6 +122,18 @@ struct rpmsg_channel {
     bool announce;
 };
 
+/**
+ * struct rpmsg_channel_info - internal channel info representation
+ * @name: name of service
+ * @src: local address
+ * @dst: destination address
+ */
+struct rpmsg_channel_info {
+    char name[RPMSG_NAME_SIZE];
+    u32 src;
+    u32 dst;
+};
+
 typedef void (*rpmsg_rx_cb_t)(struct rpmsg_channel *, void *, int, void *, u32);
 
 /**
