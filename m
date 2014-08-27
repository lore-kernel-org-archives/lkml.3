Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaH0OGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:06:20 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:59623 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508AbaH0OGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:06:19 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] regmap: Make sure regmap_init() returns non-NULL on failure
Date: Wed, 27 Aug 2014 16:06:16 +0200
Message-Id: <1409148376-12206-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d647c199510c2c12 ("regmap: add DT endianness binding support.")
added two extra users of the "ret" variable in regmap_init(), to store
the error code returned by of_regmap_get_endian().  Thus from this point
on, "ret" is zero in case of success.

However, most failure paths after that rely on "ret" being
pre-initialized to -EINVAL. If any of the format checks fails,
regmap_init() will return a NULL pointer instead of an error code
wrapped in an ERR_PTR().

As a typical regmap_init*() error check looks like:

	wm8978->regmap = devm_regmap_init_i2c(i2c, &wm8978_regmap_config);
	if (IS_ERR(wm8978->regmap)) {
		...
	}

failures are no longer caught, and the code will crash later.  This is
the real reason behind the NULL pointer dereference reported by Javier
Martinez Canillas.

While his commit ba1b53feb8cacbd8 ("regmap: Fix DT endianess parsing
logic") fixed the mis-initialization of regmap parameters, the NULL
pointer dereference will still happen in case of a legitimate error.

Add a catch-all rule at the end of the failure path to fix this.

Fixes: commit d647c199510c2c12 ("regmap: add DT endianness binding
support.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 44c2df8284d7..ab3238327d0a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -912,6 +912,8 @@ err_range:
 err_map:
 	kfree(map);
 err:
+	if (!ret)
+		ret = -EINVAL;
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(regmap_init);
-- 
1.9.1

