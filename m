Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3GXWGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3GXWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>
Subject: [PATCH 02/36] mips: convert vpe_class to use dev_groups
Date: Wed, 24 Jul 2013 15:05:05 -0700
Message-Id: <1374703539-9705-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the MIPS vpe_class code to use
the correct field.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Ralf, feel free to apply this to your tree, or ACK it and I can take it through
mine.

 arch/mips/kernel/vpe.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 1765bab0..faf84c5f 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1335,8 +1335,9 @@ static ssize_t store_kill(struct device *dev, struct device_attribute *attr,
 
 	return len;
 }
+static DEVICE_ATTR(kill, S_IWUSR, NULL, store_kill);
 
-static ssize_t show_ntcs(struct device *cd, struct device_attribute *attr,
+static ssize_t ntcs_show(struct device *cd, struct device_attribute *attr,
 			 char *buf)
 {
 	struct vpe *vpe = get_vpe(tclimit);
@@ -1344,7 +1345,7 @@ static ssize_t show_ntcs(struct device *cd, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", vpe->ntcs);
 }
 
-static ssize_t store_ntcs(struct device *dev, struct device_attribute *attr,
+static ssize_t ntcs_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct vpe *vpe = get_vpe(tclimit);
@@ -1365,12 +1366,14 @@ static ssize_t store_ntcs(struct device *dev, struct device_attribute *attr,
 out_einval:
 	return -EINVAL;
 }
+static DEVICE_ATTR_RW(ntcs);
 
-static struct device_attribute vpe_class_attributes[] = {
-	__ATTR(kill, S_IWUSR, NULL, store_kill),
-	__ATTR(ntcs, S_IRUGO | S_IWUSR, show_ntcs, store_ntcs),
-	{}
+static struct attribute vpe_attrs[] = {
+	&dev_attr_kill.attr,
+	&dev_attr_ntcs.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(vpe);
 
 static void vpe_device_release(struct device *cd)
 {
@@ -1381,7 +1384,7 @@ struct class vpe_class = {
 	.name = "vpe",
 	.owner = THIS_MODULE,
 	.dev_release = vpe_device_release,
-	.dev_attrs = vpe_class_attributes,
+	.dev_groups = vpe_groups,
 };
 
 struct device vpe_device;
-- 
1.8.3.rc0.20.gb99dd2e

