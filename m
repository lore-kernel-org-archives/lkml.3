Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbaKRPPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:15:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbaKROJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/206] regmap: fix kernel hang on regmap_bulk_write with zero val_count.
Date: Tue, 18 Nov 2014 15:06:46 +0100
Message-Id: <a7a2830c5cf50217e38ffbc6797e36bc15bb4f1c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Casasnovas <quentin.casasnovas@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

If val_count is zero we return -EINVAL with map->lock_arg locked, which
will deadlock the kernel next time we try to acquire this lock.

In 3.12, this was introduced by a0b8d8d906d267987d507138003048c5fdf774
("regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.")
which improperly back-ported d6b41cb06044a7d895db82bdd54f6e4219970510.

This issue was found during review of Ubuntu Trusty 3.13.0-40.68 kernel to
prepare Ksplice rebootless updates.

Fixes: f5942dd ("regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.")
Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/base/regmap/regmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7a58be457eb5..9f7990187653 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1403,8 +1403,10 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
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
2.1.3

