Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3I3G7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:59:13 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41926 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3I3G7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:59:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Ball <cjb@laptop.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [PATCH] amba: Ensure drvdata is NULL
Date: Mon, 30 Sep 2013 08:59:06 +0200
Message-Id: <1b2479137287fa8dfda3089ca0cb9fba8c4b1f1d.1380524337.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-16497-1380524346-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-16497-1380524346-0001

This patch is inpired by the patch for drvdata
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Also it fixes all occurences in drivers.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
This patch has been sent as RFC in this thread.
http://lkml.org/lkml/2013/9/4/393

---
 arch/arm/kernel/etm.c           | 6 ------
 drivers/amba/bus.c              | 2 ++
 drivers/dma/pl330.c             | 3 ---
 drivers/input/serio/ambakmi.c   | 2 --
 drivers/mmc/host/mmci.c         | 2 --
 drivers/rtc/rtc-pl030.c         | 2 --
 drivers/rtc/rtc-pl031.c         | 2 --
 drivers/spi/spi-pl022.c         | 1 -
 drivers/tty/serial/amba-pl010.c | 3 ---
 drivers/tty/serial/amba-pl011.c | 3 ---
 drivers/video/amba-clcd.c       | 2 --
 drivers/watchdog/sp805_wdt.c    | 1 -
 12 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8ff0ecd..131a6ab 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -385,7 +385,6 @@ out:
 	return ret;

 out_unmap:
-	amba_set_drvdata(dev, NULL);
 	iounmap(t->etb_regs);

 out_release:
@@ -398,8 +397,6 @@ static int etb_remove(struct amba_device *dev)
 {
 	struct tracectx *t = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	iounmap(t->etb_regs);
 	t->etb_regs = NULL;

@@ -588,7 +585,6 @@ out:
 	return ret;

 out_unmap:
-	amba_set_drvdata(dev, NULL);
 	iounmap(t->etm_regs);

 out_release:
@@ -601,8 +597,6 @@ static int etm_remove(struct amba_device *dev)
 {
 	struct tracectx *t = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	iounmap(t->etm_regs);
 	t->etm_regs = NULL;

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index c670727..9762090 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -373,6 +373,7 @@ static int amba_probe(struct device *dev)
 		if (ret == 0)
 			break;

+		amba_set_drvdata(pcdev, NULL);
 		pm_runtime_disable(dev);
 		pm_runtime_set_suspended(dev);
 		pm_runtime_put_noidle(dev);
@@ -391,6 +392,7 @@ static int amba_remove(struct device *dev)

 	pm_runtime_get_sync(dev);
 	ret = drv->remove(pcdev);
+	amba_set_drvdata(pcdev, NULL);
 	pm_runtime_put_noidle(dev);

 	/* Undo the runtime PM settings in amba_probe() */
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a562d24..dfb2931 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -3029,8 +3029,6 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)

 	return 0;
 probe_err3:
-	amba_set_drvdata(adev, NULL);
-
 	/* Idle the DMAC */
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
 			chan.device_node) {
@@ -3064,7 +3062,6 @@ static int pl330_remove(struct amba_device *adev)
 		of_dma_controller_free(adev->dev.of_node);

 	dma_async_device_unregister(&pdmac->ddma);
-	amba_set_drvdata(adev, NULL);

 	/* Idle the DMAC */
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 4e2fd44..b7c206d 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -167,8 +167,6 @@ static int amba_kmi_remove(struct amba_device *dev)
 {
 	struct amba_kmi_port *kmi = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	serio_unregister_port(kmi->io);
 	clk_put(kmi->clk);
 	iounmap(kmi->base);
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c3785ed..07e17f1 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1678,8 +1678,6 @@ static int mmci_remove(struct amba_device *dev)
 {
 	struct mmc_host *mmc = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);

diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index 22bacdb..a804f75 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -153,8 +153,6 @@ static int pl030_remove(struct amba_device *dev)
 {
 	struct pl030_rtc *rtc = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	writel(0, rtc->base + RTC_CR);

 	free_irq(dev->irq[0], rtc);
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 0f0609b..c9ca86e 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -305,7 +305,6 @@ static int pl031_remove(struct amba_device *adev)
 {
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);

-	amba_set_drvdata(adev, NULL);
 	free_irq(adev->irq[0], ldata);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
@@ -392,7 +391,6 @@ out_no_irq:
 	rtc_device_unregister(ldata->rtc);
 out_no_rtc:
 	iounmap(ldata->base);
-	amba_set_drvdata(adev, NULL);
 out_no_remap:
 	kfree(ldata);
 out:
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 9c511a9..f661a7e 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2288,7 +2288,6 @@ pl022_remove(struct amba_device *adev)
 	amba_release_regions(adev);
 	tasklet_disable(&pl022->pump_transfers);
 	spi_unregister_master(pl022->master);
-	amba_set_drvdata(adev, NULL);
 	return 0;
 }

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 8b90f0b..33bd860 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -728,7 +728,6 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
 	amba_set_drvdata(dev, uap);
 	ret = uart_add_one_port(&amba_reg, &uap->port);
 	if (ret) {
-		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
 		clk_put(uap->clk);
  unmap:
@@ -745,8 +744,6 @@ static int pl010_remove(struct amba_device *dev)
 	struct uart_amba_port *uap = amba_get_drvdata(dev);
 	int i;

-	amba_set_drvdata(dev, NULL);
-
 	uart_remove_one_port(&amba_reg, &uap->port);

 	for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index aaa2286..7203864 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2147,7 +2147,6 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	amba_set_drvdata(dev, uap);
 	ret = uart_add_one_port(&amba_reg, &uap->port);
 	if (ret) {
-		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
 		pl011_dma_remove(uap);
 	}
@@ -2160,8 +2159,6 @@ static int pl011_remove(struct amba_device *dev)
 	struct uart_amba_port *uap = amba_get_drvdata(dev);
 	int i;

-	amba_set_drvdata(dev, NULL);
-
 	uart_remove_one_port(&amba_reg, &uap->port);

 	for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 0a2cce7..0bab6ab 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -594,8 +594,6 @@ static int clcdfb_remove(struct amba_device *dev)
 {
 	struct clcd_fb *fb = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	clcdfb_disable(fb);
 	unregister_framebuffer(&fb->fb);
 	if (fb->fb.cmap.len)
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 58df98a..3f786ce 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -268,7 +268,6 @@ static int sp805_wdt_remove(struct amba_device *adev)
 	struct sp805_wdt *wdt = amba_get_drvdata(adev);

 	watchdog_unregister_device(&wdt->wdd);
-	amba_set_drvdata(adev, NULL);
 	watchdog_set_drvdata(&wdt->wdd, NULL);

 	return 0;
--
1.8.2.3


--=_mimegpg-monstr-desktop-16497-1380524346-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJIToACgkQykllyylKDCFnpQCdF/02Cd0aMCgeja4AS/vrfh/d
vH8AoIJTuVWgJ9eFCcldawoFQOCaKQ/P
=szY6
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-16497-1380524346-0001--
