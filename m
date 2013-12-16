Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3LPKmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:42:06 -0500
Received: from multi.imgtec.com ([194.200.65.239]:13776 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3LPKmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:42:04 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Rajendra Nayak <rnayak@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] clk: clk-divider: fix divisor > 255 bug
Date: Mon, 16 Dec 2013 10:41:38 +0000
Message-ID: <1387190498-15392-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_16_10_41_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6d9252bd9a4bb (clk: Add support for power of two type dividers)
merged in v3.6 added the _get_val function to convert a divisor value to
a register field value depending on the flags. However it used the type
u8 for the div field, causing divisors larger than 255 to be masked
and the resultant clock rate to be too high.

E.g. in my case an 11bit divider was supposed to divide 24.576 MHz down
to 32.768KHz. The divisor was correctly calculated as 750 (0x2ee). This
was masked to 238 (0xee) resulting in a frequency of 103.26KHz.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
---
Since this bug was introduced in 3.6, it probably should by applied to
stable 3.10 and 3.12.
---
 drivers/clk/clk-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8d3009e44fba..5543b7df8e16 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -87,7 +87,7 @@ static unsigned int _get_table_val(const struct clk_div_table *table,
 	return 0;
 }
 
-static unsigned int _get_val(struct clk_divider *divider, u8 div)
+static unsigned int _get_val(struct clk_divider *divider, unsigned int div)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
 		return div;
-- 
1.8.1.2


