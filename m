Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaJ0TB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:01:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaJ0TBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:01:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/105] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Mon, 27 Oct 2014 11:56:33 -0700
Message-Id: <1414436240-13879-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <Li.Xiubo@freescale.com>

commit d6b41cb06044a7d895db82bdd54f6e4219970510 upstream.

Since we cannot make sure the 'val_count' will always be none zero
here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1ac3c9a..ebe332c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1529,6 +1529,9 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (val_bytes == 1) {
 		wval = (void *)val;
 	} else {
+		if (!val_count)
+			return -EINVAL;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
-- 
1.9.1

