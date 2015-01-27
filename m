Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbbA0Mmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:42:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbbA0MR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnaud Ebalard <arno@natisbad.org>, Mark Rutland <mark.rutland@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 036/126] drivers/rtc/rtc-isl12057.c: fix masking of register values
Date: Tue, 27 Jan 2015 12:15:41 +0000
Message-Id: <1422361031-19364-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ebalard <arno@natisbad.org>

commit 5945b2880363ed7648e62aabba770ec57ff2a316 upstream.

When Intersil ISL12057 support was added by commit 70e123373c05 ("rtc: Add
support for Intersil ISL12057 I2C RTC chip"), two masks for time registers
values imported from the device were either wrong or omitted, leading to
additional bits from those registers to impact read values:

 - mask for hour register value when reading it in AM/PM mode. As
   AM/PM mode is not the usual mode used by the driver, this error
   would only have an impact on an externally configured RTC hour
   later read by the driver.
 - mask for month value. The lack of masking would provide an
   erroneous value if century bit is set.

This patch fixes those two masks.

Fixes: 70e123373c05 ("rtc: Add support for Intersil ISL12057 I2C RTC chip")
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Acked-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-isl12057.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-isl12057.c b/drivers/rtc/rtc-isl12057.c
index 455b601d731d..8c3f60737df8 100644
--- a/drivers/rtc/rtc-isl12057.c
+++ b/drivers/rtc/rtc-isl12057.c
@@ -88,7 +88,7 @@ static void isl12057_rtc_regs_to_tm(struct rtc_time *tm, u8 *regs)
 	tm->tm_min = bcd2bin(regs[ISL12057_REG_RTC_MN]);
 
 	if (regs[ISL12057_REG_RTC_HR] & ISL12057_REG_RTC_HR_MIL) { /* AM/PM */
-		tm->tm_hour = bcd2bin(regs[ISL12057_REG_RTC_HR] & 0x0f);
+		tm->tm_hour = bcd2bin(regs[ISL12057_REG_RTC_HR] & 0x1f);
 		if (regs[ISL12057_REG_RTC_HR] & ISL12057_REG_RTC_HR_PM)
 			tm->tm_hour += 12;
 	} else {					    /* 24 hour mode */
@@ -97,7 +97,7 @@ static void isl12057_rtc_regs_to_tm(struct rtc_time *tm, u8 *regs)
 
 	tm->tm_mday = bcd2bin(regs[ISL12057_REG_RTC_DT]);
 	tm->tm_wday = bcd2bin(regs[ISL12057_REG_RTC_DW]) - 1; /* starts at 1 */
-	tm->tm_mon  = bcd2bin(regs[ISL12057_REG_RTC_MO]) - 1; /* starts at 1 */
+	tm->tm_mon  = bcd2bin(regs[ISL12057_REG_RTC_MO] & 0x1f) - 1; /* ditto */
 	tm->tm_year = bcd2bin(regs[ISL12057_REG_RTC_YR]) + 100;
 }
 
-- 
2.1.4

