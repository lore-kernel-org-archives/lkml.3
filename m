Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbbA1FTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:19:43 -0500
Received: from mail.kernel.org ([198.145.29.136]:37708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675AbbA1EQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:21 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 032/177] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Wed, 28 Jan 2015 12:07:11 +0800
Message-Id: <1422418236-12852-64-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiubo Li <Li.Xiubo@freescale.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d6b41cb06044a7d895db82bdd54f6e4219970510 upstream.

Since we cannot make sure the 'val_count' will always be none zero
here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[lizf: Backported to 3.4: release mutex before returning EINVAL]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/base/regmap/regmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e554542..8e81f85 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -600,6 +600,11 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (val_bytes == 1) {
 		wval = (void *)val;
 	} else {
+		if (!val_count) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
-- 
1.9.1

