Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3FYIqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:46:54 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58208 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab3FYIqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:46:52 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/6] misc: sram: fix error path in sram_probe
Date: Tue, 25 Jun 2013 10:46:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201306251046.04873.heiko@sntech.de>
In-Reply-To: <201306251046.04873.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306251046.38993.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pool is created thru devm_gen_pool_create, so the call to
gen_pool_destroy is not necessary.
Instead the sram-clock must be turned off again if it exists.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/misc/sram.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index d87cc91..afe66571 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -68,7 +68,8 @@ static int sram_probe(struct platform_device *pdev)
 	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
 				res->start, size, -1);
 	if (ret < 0) {
-		gen_pool_destroy(sram->pool);
+		if (sram->clk)
+			clk_disable_unprepare(sram->clk);
 		return ret;
 	}
 
-- 
1.7.10.4

