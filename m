Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJPPzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:55:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63341 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaJPPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:55:43 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org,
        eric.auger@linaro.org, kim.phillips@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v2 2/4] vfio: platform: devtree: return available property names
Date: Thu, 16 Oct 2014 17:54:34 +0200
Message-Id: <1413474876-28544-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The available properties of a device are not indexed numerically,
instead they are accessible by property name.
Passing type = VFIO_DEVTREE_PROP_LIST to VFIO_DEVICE_GET_DEVTREE_INFO,
returns a list of strings with the available properties that the VFIO
user can access.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/devtree.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
index c057be3..032ee16 100644
--- a/drivers/vfio/platform/devtree.c
+++ b/drivers/vfio/platform/devtree.c
@@ -7,7 +7,42 @@
 static int devtree_get_prop_list(struct device_node *np, unsigned *lenp,
 				 void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	struct property *prop;
+	int len = 0, sz;
+	int ret = 0;
+
+	for_each_property_of_node(np, prop) {
+		sz = strlen(prop->name) + 1;
+
+		if (datasz < sz) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		if (copy_to_user(datap, prop->name, sz))
+			return -EFAULT;
+
+		datap += sz;
+		datasz -= sz;
+		len += sz;
+	}
+
+	/* if overflow occurs, calculate remaining length */
+	while (prop) {
+		len += strlen(prop->name) + 1;
+		prop = prop->next;
+	}
+
+	/* we expose the full_name in addition to the usual properties */
+	len += sz = strlen("full_name") + 1;
+	if (datasz < sz) {
+		ret = -EAGAIN;
+	} else if (copy_to_user(datap, "full_name", sz))
+		return -EFAULT;
+
+	*lenp = len;
+
+	return ret;
 }
 
 static int devtree_get_strings(struct device_node *np,
-- 
2.1.1

