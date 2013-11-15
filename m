Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab3KOLbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:31:20 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:57089 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3KOLbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:31:08 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>
Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Topic: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Index: Ac7h9iW7v/9w7+s6RcaZ6yoGka5jaA==
Date: Fri, 15 Nov 2013 11:30:55 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
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

This patch give a warning when calling regmap_register_patch with
parameter num_regs <= 0.

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
@@ -2170,9 +2170,12 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
 	struct reg_default *p;
 	int i, ret;
 	bool bypass;
 
+	if (WARN_ONCE(num_regs <= 0))
+		return 0;
+
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
-- 
1.8.1.5

