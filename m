Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaLSVVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:21:33 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41751 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaLSVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:21:31 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v3 2/3] vfio: platform: access device property as a list of strings
Date: Fri, 19 Dec 2014 22:20:30 +0100
Message-Id: <1419024032-1269-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain device properties (e.g. the device node name, the compatible
string), are available as a list of strings (separated by the null
terminating character). Let the VFIO user query this type of properties.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/properties.c | 43 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
index 8b90465..39c6342 100644
--- a/drivers/vfio/platform/properties.c
+++ b/drivers/vfio/platform/properties.c
@@ -7,7 +7,48 @@ static int dev_property_get_strings(struct device *dev,
 				    char *name, unsigned *lenp,
 				    void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	const char **val;
+	int n, i, ret;
+
+	*lenp = 0;
+
+	n = device_property_read_string_array(dev, name, NULL, 0);
+	if (n < 0)
+		return n;
+
+	val = kcalloc(n, sizeof(char*), GFP_KERNEL);
+	if (!val)
+		return -ENOMEM;
+
+	ret = device_property_read_string_array(dev, name, val, n);
+	if (ret < 0)
+		goto out;
+
+	ret = 0;
+
+	for (i = 0; i < n; i++) {
+		size_t len = strlen(val[i]) + 1;
+
+		if (datasz < len) {
+			ret = -EOVERFLOW;
+			while (i < n)
+				*lenp += strlen(val[i++]) + 1;
+			goto out;
+		}
+
+		if (copy_to_user(datap, val[i], len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		*lenp += len;
+		datap += len;
+		datasz -= len;
+	}
+
+out:
+	kfree(val);
+	return ret;
 }
 
 static int dev_property_get_uint(struct device *dev, char *name,
-- 
2.1.3

