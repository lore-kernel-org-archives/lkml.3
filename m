Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaDRNTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:19:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19082 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaDRNTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:19:11 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c1-5351264b70c8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/6] rtc: s5m: Remove undocumented time init on first boot
Date: Fri, 18 Apr 2014 15:18:55 +0200
Message-id: <1397827139-14589-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397827139-14589-1-git-send-email-k.kozlowski@samsung.com>
References: <1397827139-14589-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4FV1vtcBgg852PYslF6+yW2ycsZ7V
	4vULQ4uzTW/YLe5/PcpocXnXHDaLGef3MVmsPXKX3WJ/ZwejxeluVouLK74wOXB77Jl4ks3j
	zrU9bB7zTgZ69G1Zxegxfd5PJo/Pm+QC2KK4bFJSczLLUov07RK4Ms5e5S3YLFDx/ukS1gbG
	SbxdjJwcEgImElN2HGODsMUkLtxbD2RzcQgJLGWUuHyhhxXC6WOS+P52DVgVm4CxxOblS8Cq
	RAR+MUp8W7aIBcRhFjjKKDG99y0TSJWwgK/ExXkvGUFsFgFViX8ff7KA2LwC7hLHp3xjhtin
	ILHsy1owm1PAQ2LH1nYwWwioZuPWh8wTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/d
	xAgJwi87GBcfszrEKMDBqMTDq/HDP1iINbGsuDL3EKMEB7OSCO/uvwHBQrwpiZVVqUX58UWl
	OanFhxiZODilGhgNVOamFMxX/7379oaWyPoXzbPsRabPZLrfcWqJ3vdun2/5f6uT4r79TQxZ
	dMLj74rVvhK8W9WYH+h2Gj34LfpFad7C3+slFGYcC9qQqmqeEd/sx/R6l8rc+poFGdJ2c0L1
	rk2x22VhILDt2hKVyiVBNUx9Ew5qP0qtFepa9KqJceelRk/mgCQlluKMREMt5qLiRAClubkD
	IAIAAA==
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
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b37df8c790f2..22137d4dbadf 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -517,16 +517,7 @@ static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
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
@@ -540,27 +531,6 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
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
1.8.3.2

