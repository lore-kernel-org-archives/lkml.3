Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222Ab3AXVcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:32:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:40223 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab3AXVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tony Lindgren <tony@atomide.com>, Luciano Coelho <coelho@ti.com>
Subject: [ 25/46] Revert "drivers/misc/ti-st: remove gpio handling"
Date: Thu, 24 Jan 2013 13:13:03 -0800
Message-Id: <20130124211145.167972363@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit a7e2ca17039edb5f782be519eaf9d8ea500ba7cc upstream.

This reverts commit eccf2979b2c034b516e01b8a104c3739f7ef07d1.

The reason is that it broke TI WiLink shared transport on Panda.
Also, callback functions should not be added to board files anymore,
so revert to implementing the power functions in the driver itself.

Additionally, changed a variable name ('status' to 'err') so that this
revert compiles properly.

Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
[changed "err" back to "status" to get it to build in 3.7 - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/ti-st/st_kim.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -468,6 +468,11 @@ long st_kim_start(void *kim_data)
 		if (pdata->chip_enable)
 			pdata->chip_enable(kim_gdata);
 
+		/* Configure BT nShutdown to HIGH state */
+		gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
+		mdelay(5);	/* FIXME: a proper toggle */
+		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
+		mdelay(100);
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
 		/* send notification to UIM */
@@ -509,7 +514,8 @@ long st_kim_start(void *kim_data)
  *	(b) upon failure to either install ldisc or download firmware.
  *	The function is responsible to (a) notify UIM about un-installation,
  *	(b) flush UART if the ldisc was installed.
- *	(c) invoke platform's chip disabling routine.
+ *	(c) reset BT_EN - pull down nshutdown at the end.
+ *	(d) invoke platform's chip disabling routine.
  */
 long st_kim_stop(void *kim_data)
 {
@@ -541,6 +547,13 @@ long st_kim_stop(void *kim_data)
 		err = -ETIMEDOUT;
 	}
 
+	/* By default configure BT nShutdown to LOW state */
+	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
+	mdelay(1);
+	gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
+	mdelay(1);
+	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
+
 	/* platform specific disable */
 	if (pdata->chip_disable)
 		pdata->chip_disable(kim_gdata);
@@ -732,6 +745,20 @@ static int kim_probe(struct platform_dev
 	/* refer to itself */
 	kim_gdata->core_data->kim_data = kim_gdata;
 
+	/* Claim the chip enable nShutdown gpio from the system */
+	kim_gdata->nshutdown = pdata->nshutdown_gpio;
+	status = gpio_request(kim_gdata->nshutdown, "kim");
+	if (unlikely(status)) {
+		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
+		return status;
+	}
+
+	/* Configure nShutdown GPIO as output=0 */
+	status = gpio_direction_output(kim_gdata->nshutdown, 0);
+	if (unlikely(status)) {
+		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
+		return status;
+	}
 	/* get reference of pdev for request_firmware
 	 */
 	kim_gdata->kim_pdev = pdev;
@@ -767,10 +794,18 @@ static int kim_probe(struct platform_dev
 
 static int kim_remove(struct platform_device *pdev)
 {
+	/* free the GPIOs requested */
+	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
 	struct kim_data_s	*kim_gdata;
 
 	kim_gdata = dev_get_drvdata(&pdev->dev);
 
+	/* Free the Bluetooth/FM/GPIO
+	 * nShutdown gpio from the system
+	 */
+	gpio_free(pdata->nshutdown_gpio);
+	pr_info("nshutdown GPIO Freed");
+
 	debugfs_remove_recursive(kim_debugfs_dir);
 	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
 	pr_info("sysfs entries removed");


