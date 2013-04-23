Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab3DWQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:37:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3DWQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Buesch <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 10/21] ssb: fix alignment of struct bcma_device_id
Date: Tue, 23 Apr 2013 18:30:42 +0200
Message-Id: <1366734653-488286-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:saeHJCTJ21Jxs6230BRkDH4heLmNX7lgF3Yk659mD+3
 6ZYUBqxGH27Wu7t39FKJOhYvnzaoa5GtgiDdTt5vkpzZWGnAqF
 WBmK34KjhxTNavvjKlT3qN17NXi+wZvL/GEy/F8k91DB2v4KP8
 bk9M71FjXPasp7tnOlO4+oz2nHm/tTaqsSxICyPsOf8GtdczNu
 vKiDbCPvN7IN5PUGRoWcOCd3nsBCseEVNR3a52BGyiBJJh3lBS
 0IzG9kV33g+WmqA/2GRdr48jWvKnG0ZWGGIsEZL3/Nvl6SWtac
 ASO8fHEayziVStHTpgRIwBBZg91pIrTK80iXw5mw0v4SZwxopw
 0lG39qoXiEnkDJTd6gjir2UULmOZMT71HhMXPmXCG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM OABI and EABI disagree on the alignment of structures
with small members, so module init tools may interpret the
ssb device table incorrectly, as shown  by this warning when
building the b43 device driver in an OABI kernel:

FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
not a modulo of the size of section __mod_ssb_device_table=88.

Forcing the default (EABI) alignment on the structure makes this
problem go away. Since the ssb_device_id may have the same problem,
better fix both structures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
---
 include/linux/mod_devicetable.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 779cf7c..ce363a5 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -360,7 +360,8 @@ struct ssb_device_id {
 	__u16	vendor;
 	__u16	coreid;
 	__u8	revision;
-};
+	__u8	__pad;
+} __attribute__((packed, aligned(2)));
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
 #define SSB_DEVTABLE_END  \
@@ -376,7 +377,7 @@ struct bcma_device_id {
 	__u16	id;
 	__u8	rev;
 	__u8	class;
-};
+} __attribute__((packed,aligned(2)));
 #define BCMA_CORE(_manuf, _id, _rev, _class)  \
 	{ .manuf = _manuf, .id = _id, .rev = _rev, .class = _class, }
 #define BCMA_CORETABLE_END  \
-- 
1.8.1.2

