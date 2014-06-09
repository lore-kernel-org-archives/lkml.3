Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaFIJhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:37:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932771AbaFIJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/146] pata_at91: fix ata_host_activate() failure handling
Date: Mon,  9 Jun 2014 10:49:14 +0200
Message-Id: <0bba38e7d849d5cb2c58fada1d5368ead19bf147.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 27aa64b9d1bd0d23fd692c91763a48309b694311 upstream.

Add missing clk_put() call to ata_host_activate() failure path.

Sergei says,

  "Hm, I have once fixed that (see that *if* (!ret)) but looks like a
   later commit 477c87e90853d136b188c50c0e4a93d01cad872e (ARM:
   at91/pata: use gpio_is_valid to check the gpio) broke it again. :-(
   Would be good if the changelog did mention that..."

Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/pata_at91.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index d63ee8f41a4f..e3a49df958a3 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -408,12 +408,13 @@ static int pata_at91_probe(struct platform_device *pdev)
 
 	host->private_data = info;
 
-	return ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
-			gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
-			irq_flags, &pata_at91_sht);
+	ret = ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
+				gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
+				irq_flags, &pata_at91_sht);
+	if (ret)
+		goto err_put;
 
-	if (!ret)
-		return 0;
+	return 0;
 
 err_put:
 	clk_put(info->mck);
-- 
1.9.3

