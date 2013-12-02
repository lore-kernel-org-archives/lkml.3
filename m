Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3LBUSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:18:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3LBTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gwendal Grignou <gwendal@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 045/212] libata: Fix display of sata speed
Date: Mon,  2 Dec 2013 11:13:56 -0800
Message-Id: <20131202191253.344812740@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwendal Grignou <gwendal@google.com>

commit 3e85c3ecbc520751324a191d23bb94873ed01b10 upstream.

6.0 Gbps link speed was not decoded properly:
speed was reported at 3.0 Gbps only.

Tested: On a machine where libata reports 6.0 Gbps in
        /var/log/messages:
    ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)

    Before:
    	cat /sys/class/ata_link/link1/sata_spd
    	3.0 Gbps
    After:
    	cat /sys/class/ata_link/link1/sata_spd
    	6.0 Gbps

Signed-off-by: Gwendal Grignou <gwendal@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-transport.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -321,25 +321,25 @@ int ata_tport_add(struct device *parent,
 /*
  * ATA link attributes
  */
+static int noop(int x) { return x; }
 
-
-#define ata_link_show_linkspeed(field)					\
+#define ata_link_show_linkspeed(field, format)			        \
 static ssize_t								\
 show_ata_link_##field(struct device *dev,				\
 		      struct device_attribute *attr, char *buf)		\
 {									\
 	struct ata_link *link = transport_class_to_link(dev);		\
 									\
-	return sprintf(buf,"%s\n", sata_spd_string(fls(link->field)));	\
+	return sprintf(buf, "%s\n", sata_spd_string(format(link->field))); \
 }
 
-#define ata_link_linkspeed_attr(field)					\
-	ata_link_show_linkspeed(field)					\
+#define ata_link_linkspeed_attr(field, format)				\
+	ata_link_show_linkspeed(field, format)				\
 static DEVICE_ATTR(field, S_IRUGO, show_ata_link_##field, NULL)
 
-ata_link_linkspeed_attr(hw_sata_spd_limit);
-ata_link_linkspeed_attr(sata_spd_limit);
-ata_link_linkspeed_attr(sata_spd);
+ata_link_linkspeed_attr(hw_sata_spd_limit, fls);
+ata_link_linkspeed_attr(sata_spd_limit, fls);
+ata_link_linkspeed_attr(sata_spd, noop);
 
 
 static DECLARE_TRANSPORT_CLASS(ata_link_class,


