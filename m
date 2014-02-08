Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbaBHFCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 00:02:34 -0500
Received: from nm4-vm5.bullet.mail.gq1.yahoo.com ([98.136.218.164]:40981 "EHLO
	nm4-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaBHFCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 00:02:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=l0nRgGyGRsLpTj7O0Ufj4seHrKF+lKHGdoyFWXI44xMTA5BixfTmGh4Oi9PKvorJcwaA3djQNkNwyuZhxDiyYGbKNSZOHckoHDi5CTDTHP3Z5sUfLN79YYGJViunqXF5h8LYWJYKkEvOEEVKEUyICoA/ao+ngD3p7hbWow/ty8Q=;
X-Yahoo-Newman-Id: 225290.3987.bm@smtp223.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dVqKtQIVM1kzBbTu5H7SE6GNei77ho9HGlQPO4x47j8L83E
 JiIgvo4FqyMWEJZOZ5PmaumTT246Mvg6ttxLF0p5LldlFnoXL5HFZoQS4lhs
 T9x1aThu6hJFWQNyT.Rq0suqX8u4lXU6vo7qmKSN56J_zb_O8zxbpPFEuyVA
 15Y13eQllvUvomJfmByvEKtGYV3k8oU010TQ0VEkdgplVjZkWxI2Pwsowbwv
 IhR6YiIoLNLzr4baBU71XO6h7m7b.NK04yPGlJR9B2LZqmQT4pxx9HGSLERt
 w.An2X5DJpsQvCjPrPT0a.reRZDkAFOyiAu6hI0eWLls.IIftMo4WUPQoF1K
 uOu.CWIneF7TpvSywHnRV59Zncp2AdCyTW.6b7G75Z9TDprBjLxxf6EPqnsM
 1ISxLU4yhZN84bPgULIiHgaekwmppGtpRJs2oHuo2wjxJ3BDi3V3ZlEpPKMe
 KvkGz19net6X6fk59am55Z1a7wlulPau_pGd1KqHrlsgcUqw3FJFAYxAKCpr
 9awE8IzKJcSuk7QxU5UsVO4TiGo7RNGulKHgJZUH40bsT1HJH0g--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp223.mail.gq1.yahoo.com with SMTP; 08 Feb 2014 05:02:32 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: fix memory leak in comedi_bond.c
Date: Fri,  7 Feb 2014 23:02:27 -0600
Message-Id: <1391835747-3714-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate bdev and then krealloc the devs pointer in order to add bdev
at the end of the devpriv->devs array list.  But if for some reason this
krealloc fails, we need to free bdev before returning an error otherwise
this memory is leaked.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 51a59e5..406aedb 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -254,6 +254,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			if (!devs) {
 				dev_err(dev->class_dev,
 					"Could not allocate memory. Out of memory?\n");
+				kfree(bdev);
 				return -ENOMEM;
 			}
 			devpriv->devs = devs;
-- 
1.8.5.3

