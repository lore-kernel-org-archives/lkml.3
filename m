Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbaJDAsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:48:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbaJCVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Addy Ke <addy.ke@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 051/357] i2c: rk3x: fix divisor calculation for SCL frequency
Date: Fri,  3 Oct 2014 14:27:17 -0700
Message-Id: <20141003212934.984979652@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: addy ke <addy.ke@rock-chips.com>

commit b4a7bd7a386dc6b0bb49cb47614e06e8295d495a upstream.

I2C_CLKDIV register descripted in the previous version of
RK3x chip manual is incorrect. Plus 1 is required.

The correct formula:
- T(SCL_HIGH) = T(PCLK) * (CLKDIVH + 1) * 8
- T(SCL_LOW) = T(PCLK) * (CLKDIVL + 1) * 8
- (SCL Divsor) = 8 * ((CLKDIVL + 1) + (CLKDIVH + 1))
- SCL = PCLK / (CLK Divsor)

It will be updated to the latest version of chip manual.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rk3x.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -433,12 +433,11 @@ static void rk3x_i2c_set_scl_rate(struct
 	unsigned long i2c_rate = clk_get_rate(i2c->clk);
 	unsigned int div;
 
-	/* SCL rate = (clk rate) / (8 * DIV) */
-	div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);
-
-	/* The lower and upper half of the CLKDIV reg describe the length of
-	 * SCL low & high periods. */
-	div = DIV_ROUND_UP(div, 2);
+	/* set DIV = DIVH = DIVL
+	 * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
+	 *          = (clk rate) / (16 * (DIV + 1))
+	 */
+	div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;
 
 	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
 }


