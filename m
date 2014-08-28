Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936580AbaH1KoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:44:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37677 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503AbaH1KoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:44:12 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH] clk: fractional-divider: cast parent_rate to u64 before multiplying
Date: Thu, 28 Aug 2014 12:46:10 +0200
Message-ID: <3033670.TV3SpkKZGq@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32bit architectures, like ARM calculating the fractional rate will
do the multiplication before converting the value to u64 when it gets
assigned to ret, which can produce overflows.

The error in question happened with a parent_rate of 386MHz, m = 3000,
n = 60000, which resulted in a wrong rate value of 15812Hz.

Therefore cast parent_rate to u64 to make sure the multiplication
happens in a 64bit space and produces the correct 192MHz in the example.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clk/clk-fractional-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index ede685c..82a59d0 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -36,7 +36,7 @@ static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
 	m = (val & fd->mmask) >> fd->mshift;
 	n = (val & fd->nmask) >> fd->nshift;
 
-	ret = parent_rate * m;
+	ret = (u64)parent_rate * m;
 	do_div(ret, n);
 
 	return ret;
-- 
2.0.1


