Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaLBT7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:59:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaLBTUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 002/121] [3.13-stable only] regmap: fix kernel hang on regmap_bulk_write with zero val_count.
Date: Tue,  2 Dec 2014 11:18:01 -0800
Message-Id: <1417548000-1794-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

If val_count is zero we return -EINVAL with map->lock_arg locked, which
will deadlock the kernel next time we try to acquire this lock.

This was introduced by 6ae8fcd ("regmap: fix possible ZERO_SIZE_PTR pointer
dereferencing error.") which improperly back-ported d6b41cb0.

This issue was found during review of Ubuntu Trusty 3.13.0-40.68 kernel to
prepare Ksplice rebootless updates.

Fixes: [3.13-stable] 6ae8fcd ("regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.")
Fixes: [Ubuntu Trusty] f5942dd ("regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.")
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ebe332c..9e885cf 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1529,8 +1529,10 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (val_bytes == 1) {
 		wval = (void *)val;
 	} else {
-		if (!val_count)
-			return -EINVAL;
+		if (!val_count) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
-- 
1.9.1

