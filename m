Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaJPPzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:55:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40901 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaJPPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:55:46 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org,
        eric.auger@linaro.org, kim.phillips@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v2 3/4] vfio: platform: devtree: access property as a list of strings
Date: Thu, 16 Oct 2014 17:54:35 +0200
Message-Id: <1413474876-28544-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain device tree properties (e.g. the device node name, the compatible
string), are available as a list of strings (separated by the null
terminating character). Let the VFIO user query this type of properties.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/devtree.c | 43 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
index 032ee16..6d25f97 100644
--- a/drivers/vfio/platform/devtree.c
+++ b/drivers/vfio/platform/devtree.c
@@ -45,11 +45,52 @@ static int devtree_get_prop_list(struct device_node *np, unsigned *lenp,
 	return ret;
 }
 
+static int devtree_get_full_name(struct device_node *np, unsigned *lenp,
+				 void __user *datap, unsigned long datasz)
+{
+	int len = strlen(np->full_name) + 1;
+
+	if (lenp)
+		*lenp = len;
+
+	if (len > datasz)
+		return -EAGAIN;
+
+	if (copy_to_user(datap, np->full_name, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int devtree_get_strings(struct device_node *np,
 			       char *name, unsigned *lenp,
 			       void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	struct property *prop;
+	int len;
+
+	prop = of_find_property(np, name, &len);
+
+	if (!prop) {
+		/* special case full_name as a property that is not on the fdt,
+		 * but we wish to return to the user as it includes the full
+		 * path of the device */
+		if (!strcmp(name, "full_name"))
+			return devtree_get_full_name(np, lenp, datap, datasz);
+		else
+			return -EINVAL;
+	}
+
+	if (lenp)
+		*lenp = len;
+
+	if (len > datasz)
+		return -EAGAIN;
+
+	if (copy_to_user(datap, prop->value, len))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int devtree_get_uint(struct device_node *np, char *name,
-- 
2.1.1

