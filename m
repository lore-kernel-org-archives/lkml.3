Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaFKRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:52:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48212 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFKRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:52:26 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-bb-53989757d0fd
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/1] ima: remove unnecessary i_mutex locking
Date: Wed, 11 Jun 2014 20:51:37 +0300
Message-id: <cc7deec4d9dbd22166b34fa0dad28aed82120e4c.1402509097.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xa7rh02cEGzxtkbK49Xcvs8WXpXUW
	l3fNYbP40POIzeLTiknMDqweO2fdZfd4cGgzi0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	fLy2krVgDkdF85oGpgbGl2xdjJwcEgImEn8mdrJA2GISF+6tB4pzcQgJLGWU2PP3LpTTySQx
	4/dhVpAqNgE9iQ3NP9hBbBEBZ4mdDdfAbGaBdIlPk3rBbGEBG4nu2YeZQWwWAVWJ/WdmgNm8
	AnES61ubobbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghYfB1B+PS
	Y1aHGAU4GJV4eA38pwULsSaWFVfmHmKU4GBWEuGNaJ4RLMSbklhZlVqUH19UmpNafIiRiYNT
	qoExPq8jI7iO6TW/EJPo5ofXXT7eVL96jYPtpFOL4MPpXgcknKW9lswrWuNuoX9t+3NXl6ab
	nMuO6uoYvbocs3uJ3sPMqx87wmeKGFauzSi7xuphP3vDhk5Lzbjsh9fNjH74HOWP3XEudsHn
	MN/kCIuFb1cJcr/WOv/xdJqbvfN6+59BOiLnfR8osRRnJBpqMRcVJwIA50X2NOEBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think i_mutex locking is absolutely unnecessary here.
It is uselessly taken here even when IMA policy is empty and
IMA is effectively disabled.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 09baa33..cf1c369 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -88,8 +88,6 @@ static void ima_rdwr_violation_check(struct file *file)
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
 		return;
 
-	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
-
 	if (mode & FMODE_WRITE) {
 		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
 			struct integrity_iint_cache *iint;
@@ -104,8 +102,6 @@ static void ima_rdwr_violation_check(struct file *file)
 			send_writers = true;
 	}
 
-	mutex_unlock(&inode->i_mutex);
-
 	if (!send_tomtou && !send_writers)
 		return;
 
-- 
1.9.1

