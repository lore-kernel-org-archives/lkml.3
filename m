Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3LTMjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:39:41 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38632 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3LTMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:26 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/26] drbd: Describe the future high-level structure of DRBD
Date: Fri, 20 Dec 2013 13:29:00 +0100
Message-Id: <1387542563-6833-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The following commits will successively transform DRBD into the structure
described here.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 Documentation/blockdev/drbd/data-structure-v9.txt |   38 +++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/blockdev/drbd/data-structure-v9.txt

diff --git a/Documentation/blockdev/drbd/data-structure-v9.txt b/Documentation/blockdev/drbd/data-structure-v9.txt
new file mode 100644
index 0000000..1e52a0e
--- /dev/null
+++ b/Documentation/blockdev/drbd/data-structure-v9.txt
@@ -0,0 +1,38 @@
+This describes the in kernel data structure for DRBD-9. Starting with
+Linux v3.14 we are reorganizing DRBD to use this data structure.
+
+Basic Data Structure
+====================
+
+A node has a number of DRBD resources.  Each such resource has a number of
+devices (aka volumes) and connections to other nodes ("peer nodes"). Each DRBD
+device is represented by a block device locally.
+
+The DRBD objects are interconnected to form a matrix as depicted below; a
+drbd_peer_device object sits at each intersection between a drbd_device and a
+drbd_connection:
+
+  /--------------+---------------+.....+---------------\
+  |   resource   |    device     |     |    device     |
+  +--------------+---------------+.....+---------------+
+  |  connection  |  peer_device  |     |  peer_device  |
+  +--------------+---------------+.....+---------------+
+  :              :               :     :               :
+  :              :               :     :               :
+  +--------------+---------------+.....+---------------+
+  |  connection  |  peer_device  |     |  peer_device  |
+  \--------------+---------------+.....+---------------/
+
+In this table, horizontally, devices can be accessed from resources by their
+volume number.  Likewise, peer_devices can be accessed from connections by
+their volume number.  Objects in the vertical direction are connected by double
+linked lists.  There are back pointers from peer_devices to their connections a
+devices, and from connections and devices to their resource.
+
+All resources are in the drbd_resources double-linked list.  In addition, all
+devices can be accessed by their minor device number via the drbd_devices idr.
+
+The drbd_resource, drbd_connection, and drbd_device objects are reference
+counted.  The peer_device objects only serve to establish the links between
+devices and connections; their lifetime is determined by the lifetime of the
+device and connection which they reference.
-- 
1.7.9.5

