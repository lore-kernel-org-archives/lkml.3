Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaEUOdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:33:11 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:61593 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaEUOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:33:10 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 1/3] xen-blkfront: remove type check from blkfront_setup_discard
Date: Wed, 21 May 2014 16:32:40 +0200
Message-Id: <1400682762-17429-2-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
References: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its initial implementation a check for "type" was added, but only phy
and file are handled. This breaks advertised discard support for other
type values such as qdisk.

Fix and simplify this function: If the backend advertises discard
support it is supposed to implement it properly, so enable
feature_discard unconditionally. If the backend advertises the need for
a certain granularity and alignment then propagate both properties to
the blocklayer. The discard-secure property is a boolean, update the code
to reflect that.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/block/xen-blkfront.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index efe1b47..25c11ad 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1635,36 +1635,24 @@ blkfront_closing(struct blkfront_info *info)
 static void blkfront_setup_discard(struct blkfront_info *info)
 {
 	int err;
-	char *type;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	unsigned int discard_secure;
 
-	type = xenbus_read(XBT_NIL, info->xbdev->otherend, "type", NULL);
-	if (IS_ERR(type))
-		return;
-
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
-
-	kfree(type);
+	info->feature_discard = 1;
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+		"discard-granularity", "%u", &discard_granularity,
+		"discard-alignment", "%u", &discard_alignment,
+		NULL);
+	if (!err) {
+		info->discard_granularity = discard_granularity;
+		info->discard_alignment = discard_alignment;
+	}
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+		    "discard-secure", "%d", &discard_secure,
+		    NULL);
+	if (!err)
+		info->feature_secdiscard = !!discard_secure;
 }
 
 static int blkfront_setup_indirect(struct blkfront_info *info)
