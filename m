Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaAMKOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:14:21 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:57973 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:14:18 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWMTlsoxCss+iCqhAw1vkA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH v2] xen-blkfront: remove type check from blkfront_setup_discard
Date: Mon, 13 Jan 2014 11:14:12 +0100
Message-Id: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its initial implementation a check for "type" was added, but only phy
and file are handled. This breaks advertised discard support for other
type values such as qdisk.

Fix and simplify this function: remove the check for "type" as the
frontend is not supposed to care about this backend detail. Expect
backends to provide discard-aligment, discard-granularity and
discard-secure properties because interface specification in blkif.h
does not list these properties as optional.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/block/xen-blkfront.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c4a4c90..6ef63eb 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1634,37 +1634,22 @@ blkfront_closing(struct blkfront_info *info)
 
 static void blkfront_setup_discard(struct blkfront_info *info)
 {
-	int err;
-	char *type;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	unsigned int discard_secure;
 
-	type = xenbus_read(XBT_NIL, info->xbdev->otherend, "type", NULL);
-	if (IS_ERR(type))
+	if (xenbus_gather(XBT_NIL, info->xbdev->otherend,
+		"discard-granularity", "%u", &discard_granularity,
+		"discard-alignment", "%u", &discard_alignment,
+		"discard-secure", "%u", &discard_secure,
+		NULL))
 		return;
 
-	info->feature_secdiscard = 0;
-	if (strncmp(type, "phy", 3) == 0) {
-		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			"discard-granularity", "%u", &discard_granularity,
-			"discard-alignment", "%u", &discard_alignment,
-			NULL);
-		if (!err) {
-			info->feature_discard = 1;
-			info->discard_granularity = discard_granularity;
-			info->discard_alignment = discard_alignment;
-		}
-		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "discard-secure", "%d", &discard_secure,
-			    NULL);
-		if (!err)
-			info->feature_secdiscard = discard_secure;
-
-	} else if (strncmp(type, "file", 4) == 0)
-		info->feature_discard = 1;
+	info->discard_granularity = discard_granularity;
+	info->discard_alignment = discard_alignment;
+	info->feature_secdiscard = !!discard_secure;
 
-	kfree(type);
+	info->feature_discard = 1;
 }
 
 static int blkfront_setup_indirect(struct blkfront_info *info)
