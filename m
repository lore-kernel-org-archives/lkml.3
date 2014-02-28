Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaB1NBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:01:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27415 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaB1NAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:00:19 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-55-531088609e06
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/5] rtc: s5m: Remove undocumented time init on first boot
Date: Fri, 28 Feb 2014 14:00:05 +0100
Message-id: <1393592408-27181-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Vd2EDoFgg9P9FhZLLl5lt9g4Yz2r
	xesXhhZnm96wW9z/epTR4vKuOWwWa4/cZbfY39nBaHG6m9Xi4oovTBbrZ7xmceD22DPxJJvH
	nWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEVx2aSk5mSWpRbp2yVwZezY18Fe0CZQcWbuFvYG
	xhc8XYycHBICJhLXO/6yQthiEhfurWfrYuTiEBJYyijxe/NSZginj0nieHMXWBWbgLHE5uVL
	wKpEBK4ySkxcspgdJMEs8JxR4un3cBBbWMBL4lzrX7A4i4CqxKmdN4GaOTh4BdwlpjSWgJgS
	AgoScybZgFRwCnhInHw+BWy8EFDFvdVbmScw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpec
	n7uJERKAX3YwLj5mdYhRgINRiYd3gid/sBBrYllxZe4hRgkOZiUR3idNAsFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGMPVJx2aq3Zo4e1V7aKR0yKbbs4+rPvr+oXwSw8trq6eeybNJOoa1yq5
	a6GPGuqMT9mbWrLLln6YrVrDqa97n2POvNfKn1/tvez4yvXlla4D5jnMGU93Kgjmz88/P49Z
	QGLTvy1Bx2VeShq359kb9J771yJ2jvWxyYQOrqs/i3dVhLIXrj7SN0WJpTgj0VCLuag4EQDj
	W7WRHgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the code for initializing time if this is first boot.

The code for detecting first boot uses undocumented field RTC_TCON in
RTC_UDR_CON register. According to S5M8767's datasheet this field is
reserved. On S2MPS14 it is not documented at all. On device first boot
the registers will be initialized with reset value (2000-01-01
00:00:00).

The code might work on S5M8763 but still this does not look like a task
for RTC driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-s5m.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index d26e2480f8b3..b1627e9ab8f0 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -502,16 +502,7 @@ static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 {
 	u8 data[2];
-	unsigned int tp_read;
 	int ret;
-	struct rtc_time tm;
-
-	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &tp_read);
-	if (ret < 0) {
-		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
-			__func__, ret);
-		return ret;
-	}
 
 	/* Set RTC control register : Binary mode, 24hour mode */
 	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
@@ -525,27 +516,6 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	/* In first boot time, Set rtc time to 1/1/2012 00:00:00(SUN) */
-	if ((tp_read & RTC_TCON_MASK) == 0) {
-		dev_dbg(info->dev, "rtc init\n");
-		tm.tm_sec = 0;
-		tm.tm_min = 0;
-		tm.tm_hour = 0;
-		tm.tm_wday = 0;
-		tm.tm_mday = 1;
-		tm.tm_mon = 0;
-		tm.tm_year = 112;
-		tm.tm_yday = 0;
-		tm.tm_isdst = 0;
-		ret = s5m_rtc_set_time(info->dev, &tm);
-	}
-
-	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
-				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
-			__func__, ret);
-
 	return ret;
 }
 
-- 
1.7.9.5

