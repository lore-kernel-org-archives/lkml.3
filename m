Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaEGQY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:24:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60034 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaEGQYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:24:23 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-ba-536a5e3169f7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Maxime COQUELIN <maxime.coquelin@st.com>, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] clk: divider: Fix overflow in clk_divider_bestdiv
Date: Wed, 07 May 2014 18:24:10 +0200
Message-id: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsVy+t/xy7qGcVnBBnvWaFlsenyN1eLyrjls
	Fo9OL2azeDrhIpvF+hmvWRxYPe5c28PmsXlJvUffllWMHk9/7GX2+LxJLoA1issmJTUnsyy1
	SN8ugSvj9OVe9oJvnBWnvt9kbWCcxtHFyMkhIWAi0X7/GQuELSZx4d56ti5GLg4hgaWMEv/f
	7WUGSQgJ9DFJ/J3iAWKzCahJfG54xAZiiwhoSEzpeswO0sAsMINRouH4A7CEsICTxIppyxhB
	bBYBVYnPTXfA4rxA8YNTHzNDbJOT+P9yBdMERu4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS
	83M3MUIC4ssOxsXHrA4xCnAwKvHwvojOCBZiTSwrrsw9xCjBwawkwmsclRUsxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgVF1idVvluoZ1kr8v+bcZX21VeGqzZ/1GZaLcu+W2q4SXnxZsnBOP+fH
	c9xT2qP5Pdfx2GhrBGjHmsYrsKQ/+LI1oW5+yZ+kxcrL3V13TfjYcMRu6reyDSuKi2tNnlRE
	3baSm+xoVu5U6PTDYonHK6eEyeIXr97rrmIsDb6saPsup8ZDce2JWCWW4oxEQy3mouJEAKp4
	gJbmAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c686078 ("clk: divider: Add round to closest divider") introduced
a helper function to check whether given divisor is the best one instead
of direct check. However due to int type used instead of unsigned long
for passing calculated rates to this function in certain cases an
overflow could occur, for example when trying to obtain maximum possible
clock rate by calling clk_round_rate(..., UINT_MAX).

This patch fixes this issue by changing the type of rate, now and best
arguments of the function to unsigned long, which is the type that
should be used for clock rates.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/clk/clk-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c572945..e0b360a 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -232,7 +232,7 @@ static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
 }
 
 static bool _is_best_div(struct clk_divider *divider,
-		int rate, int now, int best)
+		unsigned long rate, unsigned long now, unsigned long best)
 {
 	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
 		return abs(rate - now) < abs(rate - best);
-- 
1.9.2

