Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3C2OFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:05:24 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47368
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab3C2OFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:05:21 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: balloon: Permit Linux to specify hot-add alignment requirements
Date: Fri, 29 Mar 2013 07:36:11 -0700
Message-Id: <1364567771-11724-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Windows hosts permit the guest to specify memory hot-add alignment
requirements (if any). Linux currently requires a 128MB alignment on memory
segments that can be hot-added. Specify this alignment requirement to the
host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 4cc1d10..e598c67 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -117,7 +117,14 @@ union dm_caps {
 	struct {
 		__u64 balloon:1;
 		__u64 hot_add:1;
-		__u64 reservedz:62;
+		/*
+		 * To support guests that may have alignment
+		 * limitations on hot-add, the guest can specify
+		 * its alignment requirements; a value of n
+		 * represents an alignment of 2^n in mega bytes.
+		 */
+		__u64 hot_add_alignment:4;
+		__u64 reservedz:58;
 	} cap_bits;
 	__u64 caps;
 } __packed;
@@ -784,7 +791,7 @@ static unsigned long process_hot_add(unsigned long pg_start,
 	 * If the host has specified a hot-add range; deal with it first.
 	 */
 
-	if ((rg_size != 0) && (!dm_device.host_specified_ha_region)) {
+	if (rg_size != 0) {
 		ha_region = kzalloc(sizeof(struct hv_hotadd_state), GFP_KERNEL);
 		if (!ha_region)
 			return 0;
@@ -1410,6 +1417,12 @@ static int balloon_probe(struct hv_device *dev,
 	cap_msg.caps.cap_bits.hot_add = 1;
 
 	/*
+	 * Specify our alignment requirements as it relates
+	 * memory hot-add. Specify 128MB alignment.
+	 */
+	cap_msg.caps.cap_bits.hot_add_alignment = 7;
+
+	/*
 	 * Currently the host does not use these
 	 * values and we set them to what is done in the
 	 * Windows driver.
-- 
1.7.4.1

