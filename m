Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaI2O3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:29:03 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaI2O3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:29:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] pt3: remove bogus module_is_live() check
Date: Mon, 29 Sep 2014 16:28:55 +0200
Message-ID: <6460819.BmnhuA22YH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6xUkiURbxUHIhkWe8N+DauVGaHNuajb35l98JFNqPfG
 6MjIYqeNzMJJujEKwtZv6mZPNO2KzizB3e9STKbYblgPTwXaUm
 wIj1Lc3rJqBBqPdDfbzoXuSqH0FjEXt+E4zQo+GR5ZGKxSpZSv
 7ae2YCjV9nYES8/zSQovrYl8kGiJ09bkrBnMCvXxU+7M5uxk4C
 PSVFrMg+OrZ0rdEmUXatRE+5NBaBqBnnUSenYvaQoUDKL5RkPp
 di8Fo6xkJESWBClDxqbo90Z5GHxQGZ30CqvVROeCWf07UKcSxd
 H4RNWpK8x7DZIZIzmDG2sei6Kr+M2JX/T0/YATctoJRruinxHs
 76utm2BLk9KnfyzRJxrw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new pt3 driver checks the module reference for presence
before dropping it, which fails to compile when modules
are disabled:

media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]
      module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))

As far as I can tell however, this check is not needed at all, because
the module will not go away as long as pt3 is holding a reference on
it. Also the previous check for NULL pointer is not needed at all,
because module_put has the same check.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 90f86ce7a001..39305f07dc2e 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -429,14 +429,10 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 
 err_tuner:
 	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-	if (pt3->adaps[i]->i2c_tuner->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
+	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
 err_demod:
 	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
-	if (pt3->adaps[i]->i2c_demod->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_demod->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
+	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
 	return ret;
 }
 

