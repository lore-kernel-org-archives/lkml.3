Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaFDXXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaFDXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 008/103] pata_at91: fix ata_host_activate() failure handling
Date: Wed,  4 Jun 2014 16:24:31 -0700
Message-Id: <20140604232547.100840737@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/pata_at91.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -408,12 +408,13 @@ static int pata_at91_probe(struct platfo
 
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


