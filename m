Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaLDQBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:01:38 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:55625 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaLDQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:01:36 -0500
From: Dan Streetman <ddstreet@ieee.org>
To: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Foley <pefoley2@pefoley.com>,
        Seth Jennings <sjennings@variantweb.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/mic/mpssd: fix compile error on BE platforms
Date: Thu,  4 Dec 2014 11:01:15 -0500
Message-Id: <1417708875-32189-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <alpine.LNX.2.00.1411201148370.4454@pobox.suse.cz>
References: <alpine.LNX.2.00.1411201148370.4454@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change any use of htole* macro in static context to instead manually check
for endianness and use __bswap_constant_* macro instead.

The current glibc definitions of the htole* macros don't allow their use
in a static context; on big endian systems the build fails with:

  HOSTCC  Documentation/mic/mpssd/mpssd.o
In file included from /usr/include/bits/byteswap.h:34:0,
                 from /usr/include/endian.h:60,
                 from /usr/include/bits/waitstatus.h:64,
                 from /usr/include/stdlib.h:42,
                 from .../Documentation/mic/mpssd/mpssd.c:23:
.../Documentation/mic/mpssd/mpssd.c:93:10:
error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),

...and...

.../Documentation/mic/mpssd/mpssd.c:119:3:
error: initializer element is not constant
   .host_features = htole32(

I also opened a glibc bug:
https://sourceware.org/bugzilla/show_bug.cgi?id=17679

But this patch is still needed to prevent build failures with the current
glibc htole* macro definitions.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 Documentation/mic/mpssd/mpssd.c | 54 ++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 3c5c379..b6cfbf0 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -77,6 +77,33 @@ static struct mic_info mic_list;
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #endif
 
+#define VIRTNET_HOST_FEATURES			\
+	(1 << VIRTIO_NET_F_CSUM |		\
+	1 << VIRTIO_NET_F_GSO |			\
+	1 << VIRTIO_NET_F_GUEST_TSO4 |		\
+	1 << VIRTIO_NET_F_GUEST_TSO6 |		\
+	1 << VIRTIO_NET_F_GUEST_ECN |		\
+	1 << VIRTIO_NET_F_GUEST_UFO)
+
+/* Currently, glibc htole* macros don't allow use in static context,
+ * so we check and use __bswap_constant_* instead
+ */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+# define MIC_VRING_ENTRIES_LE		MIC_VRING_ENTRIES
+# define VIRTNET_HOST_FEATURES_LE	VIRTNET_HOST_FEATURES
+# define VIRTBLK_HOST_FEATURES_LE	(1<<VIRTIO_BLK_F_SEG_MAX)
+# define VIRTBLK_CONFIG_SEG_MAX_LE	(MIC_VRING_ENTRIES - 2)
+#else /* __BIG_ENDIAN */
+# define MIC_VRING_ENTRIES_LE		\
+		__bswap_constant_16(MIC_VRING_ENTRIES)
+# define VIRTNET_HOST_FEATURES_LE	\
+		__bswap_constant_32(VIRTNET_HOST_FEATURES)
+# define VIRTBLK_HOST_FEATURES_LE	\
+		__bswap_constant_32(1<<VIRTIO_BLK_F_SEG_MAX)
+# define VIRTBLK_CONFIG_SEG_MAX_LE	\
+		__bswap_constant_32(MIC_VRING_ENTRIES - 2)
+#endif
+
 static struct {
 	struct mic_device_desc dd;
 	struct mic_vqconfig vqconfig[2];
@@ -90,10 +117,10 @@ static struct {
 		.config_len = sizeof(virtcons_dev_page.cons_config),
 	},
 	.vqconfig[0] = {
-		.num = htole16(MIC_VRING_ENTRIES),
+		.num = MIC_VRING_ENTRIES_LE,
 	},
 	.vqconfig[1] = {
-		.num = htole16(MIC_VRING_ENTRIES),
+		.num = MIC_VRING_ENTRIES_LE,
 	},
 };
 
@@ -110,21 +137,15 @@ static struct {
 		.config_len = sizeof(virtnet_dev_page.net_config),
 	},
 	.vqconfig[0] = {
-		.num = htole16(MIC_VRING_ENTRIES),
+		.num = MIC_VRING_ENTRIES_LE,
 	},
 	.vqconfig[1] = {
-		.num = htole16(MIC_VRING_ENTRIES),
+		.num = MIC_VRING_ENTRIES_LE,
 	},
 #if GSO_ENABLED
-		.host_features = htole32(
-		1 << VIRTIO_NET_F_CSUM |
-		1 << VIRTIO_NET_F_GSO |
-		1 << VIRTIO_NET_F_GUEST_TSO4 |
-		1 << VIRTIO_NET_F_GUEST_TSO6 |
-		1 << VIRTIO_NET_F_GUEST_ECN |
-		1 << VIRTIO_NET_F_GUEST_UFO),
+	.host_features = VIRTNET_HOST_FEATURES_LE,
 #else
-		.host_features = 0,
+	.host_features = 0,
 #endif
 };
 
@@ -143,13 +164,12 @@ static struct {
 		.config_len = sizeof(virtblk_dev_page.blk_config),
 	},
 	.vqconfig[0] = {
-		.num = htole16(MIC_VRING_ENTRIES),
+		.num = MIC_VRING_ENTRIES_LE,
 	},
-	.host_features =
-		htole32(1<<VIRTIO_BLK_F_SEG_MAX),
+	.host_features = VIRTBLK_HOST_FEATURES_LE,
 	.blk_config = {
-		.seg_max = htole32(MIC_VRING_ENTRIES - 2),
-		.capacity = htole64(0),
+		.seg_max = VIRTBLK_CONFIG_SEG_MAX_LE,
+		.capacity = 0,
 	 }
 };
 
-- 
1.8.3.1

