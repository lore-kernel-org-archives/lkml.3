Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaGKVFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:05:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:38263 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGKVFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,645,1400050800"; 
   d="scan'208";a="456056338"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next v3 1/8] misc: mic: Add mic bus and dma driver documentation
Date: Fri, 11 Jul 2014 14:04:19 -0700
Message-Id: <08bf1c664c614d35ac4d6ce06576d6ff5dc7ac5d.1405109402.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1405109401.git.sudeep.dutt@intel.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1405109401.git.sudeep.dutt@intel.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Siva Yerramreddy <yshivakrishna@gmail.com>

Added an overview of mic bus and dma driver.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
---
 Documentation/mic/mic_overview.txt | 67 +++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/Documentation/mic/mic_overview.txt b/Documentation/mic/mic_overview.txt
index b419292..77c5418 100644
--- a/Documentation/mic/mic_overview.txt
+++ b/Documentation/mic/mic_overview.txt
@@ -17,35 +17,50 @@ for applications. A key benefit of our solution is that it leverages
 the standard virtio framework for network, disk and console devices,
 though in our case the virtio framework is used across a PCIe bus.
 
+MIC PCIe card has a dma controller with 8 channels. These channels are
+shared between the host s/w and the card s/w. 0 to 3 are used by host
+and 4 to 7 by card. As the dma device doesn't show up as PCIe device,
+a virtual bus called mic bus is created and virtual dma devices are
+created on it by the host/card drivers. On host the channels are private
+and used only by the host driver to transfer data for the virtio devices.
+
 Here is a block diagram of the various components described above. The
 virtio backends are situated on the host rather than the card given better
 single threaded performance for the host compared to MIC, the ability of
 the host to initiate DMA's to/from the card using the MIC DMA engine and
 the fact that the virtio block storage backend can only be on the host.
 
-                              |
-       +----------+           |             +----------+
-       | Card OS  |           |             | Host OS  |
-       +----------+           |             +----------+
-                              |
-+-------+ +--------+ +------+ | +---------+  +--------+ +--------+
-| Virtio| |Virtio  | |Virtio| | |Virtio   |  |Virtio  | |Virtio  |
-| Net   | |Console | |Block | | |Net      |  |Console | |Block   |
-| Driver| |Driver  | |Driver| | |backend  |  |backend | |backend |
-+-------+ +--------+ +------+ | +---------+  +--------+ +--------+
-    |         |         |     |      |            |         |
-    |         |         |     |User  |            |         |
-    |         |         |     |------|------------|---------|-------
-    +-------------------+     |Kernel +--------------------------+
-              |               |       | Virtio over PCIe IOCTLs  |
-              |               |       +--------------------------+
-      +--------------+        |                   |
-      |Intel MIC     |        |            +---------------+
-      |Card Driver   |        |            |Intel MIC      |
-      +--------------+        |            |Host Driver    |
-              |               |            +---------------+
-              |               |                   |
-     +-------------------------------------------------------------+
-     |                                                             |
-     |                    PCIe Bus                                 |
-     +-------------------------------------------------------------+
+                                      |
+               +----------+           |             +----------+
+               | Card OS  |           |             | Host OS  |
+               +----------+           |             +----------+
+                                      |
+        +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
+        | Virtio| |Virtio  | |Virtio| | |Virtio   |  |Virtio  | |Virtio  |
+        | Net   | |Console | |Block | | |Net      |  |Console | |Block   |
+        | Driver| |Driver  | |Driver| | |backend  |  |backend | |backend |
+        +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
+            |         |         |     |      |            |         |
+            |         |         |     |User  |            |         |
+            |         |         |     |------|------------|---------|-------
+            +-------------------+     |Kernel +--------------------------+
+                      |               |       | Virtio over PCIe IOCTLs  |
+                      |               |       +--------------------------+
++-----------+         |               |                   |  +-----------+
+| MIC DMA   |         |               |                   |  | MIC DMA   |
+| Driver    |         |               |                   |  | Driver    |
++-----------+         |               |                   |  +-----------+
+      |               |               |                   |        |
++---------------+     |               |                   |  +----------------+
+|MIC virtual Bus|     |               |                   |  |MIC virtual Bus |
++---------------+     |               |                   |  +----------------+
+      |               |               |                   |              |
+      |   +--------------+            |            +---------------+     |
+      |   |Intel MIC     |            |            |Intel MIC      |     |
+      +---|Card Driver   |            |            |Host Driver    |     |
+          +--------------+            |            +---------------+-----+
+                      |               |                   |
+             +-------------------------------------------------------------+
+             |                                                             |
+             |                    PCIe Bus                                 |
+             +-------------------------------------------------------------+
-- 
1.8.2.1

