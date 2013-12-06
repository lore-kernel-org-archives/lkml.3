Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3LFXZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:25:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162428Ab3LFXUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gwendal Grignou <gwendal@google.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 025/152] libata: Fix display of sata speed
Date: Fri,  6 Dec 2013 15:09:09 -0800
Message-Id: <1386371476-2477-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-transport.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index c04d393..08e6728 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -319,25 +319,25 @@ int ata_tport_add(struct device *parent,
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
-- 
1.8.3.2

