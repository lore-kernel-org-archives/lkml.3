Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3KKLgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:36:23 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:11856 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3KKLgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:36:06 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>,
        Levente Kurusa <levex@linux.com>
Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Topic: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Index: Ac7e0i0Zg4F83zl0Qvm24piUvn3iEw==
Date: Mon, 11 Nov 2013 11:35:52 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B5D7@szxeml512-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Mon, 11 Nov 2013 19:26:14 +0800
Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value

 - Fix 'ret' would return an uninitialized value.
 - Add a warning avoid invalid 'num_regs' value passed in.

When the num_regs parameter is zero and krealloc doesn't fail,
then the code would return an uninitialized value. However,
calling this function with num_regs == 0, would be a waste as it
essentially does nothing.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/base/regmap/regmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..7b5c28a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2170,9 +2170,15 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
 	struct reg_default *p;
-	int i, ret;
+	int i;
+	int ret = 0;
 	bool bypass;
 
+	if (num_regs <= 0) {
+		WARN_ONCE(1, "Call regmap_register_patch with num_regs <= 0.");
+		return 0;
+	}
+
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
-- 
1.8.1.5

