Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3IWUyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:54:22 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:44939 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3IWUyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:54:21 -0400
Date: Mon, 23 Sep 2013 14:54:15 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Sirrix AG <tpmdd@sirrix.com>
Subject: [PATCH] tpm: xen-tpmfront: Remove the locality sysfs attribute
Message-ID: <20130923205415.GC16345@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon deeper review it was agreed to remove the driver-unique
'locality' sysfs attribute before it is present in a released
kernel.

The attribute was introduced in e2683957fb268c6b29316fd9e7191e13239a30a5
during the 3.12 merge window, so this patch needs to go in before
3.12 is released.

The hope is to have a well defined locality API that all the other
locality aware drivers can use, perhaps in 3.13.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/xen-tpmfront.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

Daniel, if you can Ack this..

Konrad: This driver was originally merged through you, can you
pick this up?

Regards,
Jason

diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 6f2fe2b..06189e5 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -142,32 +142,6 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return length;
 }
 
-ssize_t tpm_show_locality(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct tpm_private *priv = TPM_VPRIV(chip);
-	u8 locality = priv->shr->locality;
-
-	return sprintf(buf, "%d\n", locality);
-}
-
-ssize_t tpm_store_locality(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t len)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct tpm_private *priv = TPM_VPRIV(chip);
-	u8 val;
-
-	int rv = kstrtou8(buf, 0, &val);
-	if (rv)
-		return rv;
-
-	priv->shr->locality = val;
-
-	return len;
-}
-
 static const struct file_operations vtpm_ops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
@@ -188,8 +162,6 @@ static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
 static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
 static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
 static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
-		tpm_store_locality);
 
 static struct attribute *vtpm_attrs[] = {
 	&dev_attr_pubek.attr,
@@ -202,7 +174,6 @@ static struct attribute *vtpm_attrs[] = {
 	&dev_attr_cancel.attr,
 	&dev_attr_durations.attr,
 	&dev_attr_timeouts.attr,
-	&dev_attr_locality.attr,
 	NULL,
 };
 
-- 
1.8.1.2

