Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaGDMxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:53:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61848 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaGDMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:52:40 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-aa-53b6a395cc57
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/3] extcon: max77693: Fix bug related to MAX77693 irq when set
 ADC debounce time
Date: Fri, 04 Jul 2014 15:51:24 +0300
Message-id: <618ae4634565cbafffbf5d7fde5ee80686e7aac6.1404478227.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xy7pTF28LNtj5wMji+pfnrBadZ58w
	W1zeNYfNgdmjb8sqRo/Pm+QCmKK4bFJSczLLUov07RK4MvpmbWAr+MRZsbz5GksD40KOLkZO
	DgkBE4nZW7ayQNhiEhfurWfrYuTiEBJYyihx8OBkRgink0ni4c5edpAqNgE9iQ3NP4BsDg4R
	AUmJln1mIGFmAQ+JW12/wEqEBZIlbnX8ZASxWQRUJR6efgIW5xWIk7i79zA7xDI5iZPHJrOC
	2JwCVhI7P34CiwsJWEo8/tzMiEt8AiP/AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	4fN1B+PSY1aHGAU4GJV4eBtatgULsSaWFVfmHmKU4GBWEuHVmgMU4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwHh5c9+79k3lO6QdlwvMfX4tOjPu9OtvH848l7rEsWv6p/OqzptzNs7KrefwcDur
	31z+yve9KX8O/+OV+utF2xtaZ8czd+R0bjIWWf7/xv1F3GWtJnuDL36+xh/8gVN+o7bkUaHD
	CqGvQvfL/d2vffBsWfwCDcmVvszqB4VEPTkMdUoufzDc46zEUpyRaKjFXFScCADWUElu/QEA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2c7c3e1..0e9f734 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -288,6 +288,14 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 	int ret = 0;
 	u8 ctrl1, ctrl2 = 0;
 
+	/* Set open state to path before changing hw path */
+	ret = max77693_update_reg(info->max77693->regmap_muic,
+		MAX77693_MUIC_REG_CTRL1, CONTROL1_SW_OPEN, COMP_SW_MASK);
+	if (ret < 0) {
+		dev_err(info->dev, "failed to update MUIC register\n");
+		return ret;
+	}
+
 	if (attached)
 		ctrl1 = val;
 	else
@@ -1259,7 +1267,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Set initial path for UART */
-	 max77693_muic_set_path(info, info->path_uart, true);
+	max77693_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
 	ret = max77693_read_reg(info->max77693->regmap_muic,
-- 
1.9.1

