Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaBZKdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:33:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBZKdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:33:46 -0500
From: Ales Novak <alnovak@suse.cz>
To: a.zummo@towertech.it, akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        Ales Novak <alnovak@suse.cz>
Subject: [PATCH] rtc: fix chardev initialization races
Date: Wed, 26 Feb 2014 11:33:13 +0100
Message-Id: <1393410793-7315-1-git-send-email-alnovak@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many rtc modules, the chardevice file in rtc module probe is
being created prematurely. If the probe fails after the chardevice
file has been created (e.g. after rtc_device_register), it's possible
for a program to open() it, which subsequently can cause memory
corruption.

The race looks like that (thanks Jiri):

CPU0:                                CPU1:
sys_load_module()
 do_init_module()
  do_one_initcall()
   cmos_do_probe()
    rtc_device_register()
     __register_chrdev()
     cdev->owner = struct module*
                                     open("/dev/rtc0")
    rtc_device_unregister()
  module_put()
  free_module()
   module_free(mod->module_core)
   /* struct module *module is now
      freed */
                                      chrdev_open()
                                       spin_lock(cdev_lock)
                                       cdev_get()
                                        try_module_get()
                                         module_is_live()
                                         /* dereferences already
                                            freed struct module* */

This patch is proposing a solution, splitting the function
{devm_,}rtc_device_register into {devm_,}rtc_device_register{_fs,}.
The {devm_}rtc_device_register_fs which is creating the files, should
be called after it is clear that the probe will pass. It will set the
RTC_DEV_FILES_EXIST into rtc_device->flags.

In case of probe not passing, the rtc_device_unregister will try to
delete the files only if RTC_DEV_FILES_EXIST is set in rtc_device->flags.

Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 drivers/rtc/class.c        | 47 ++++++++++++++++++++++++++++++++--------------
 drivers/rtc/rtc-ab8500.c   |  1 +
 drivers/rtc/rtc-at91sam9.c |  2 ++
 drivers/rtc/rtc-bfin.c     |  2 ++
 drivers/rtc/rtc-cmos.c     |  2 ++
 drivers/rtc/rtc-davinci.c  |  2 ++
 drivers/rtc/rtc-ds1305.c   |  2 ++
 drivers/rtc/rtc-ds1307.c   |  2 ++
 drivers/rtc/rtc-ds1511.c   |  2 ++
 drivers/rtc/rtc-ds1553.c   |  2 ++
 drivers/rtc/rtc-ds1672.c   |  2 ++
 drivers/rtc/rtc-ds1742.c   |  2 ++
 drivers/rtc/rtc-ds3232.c   |  2 ++
 drivers/rtc/rtc-ep93xx.c   |  2 ++
 drivers/rtc/rtc-isl1208.c  |  2 ++
 drivers/rtc/rtc-jz4740.c   |  2 ++
 drivers/rtc/rtc-m41t80.c   |  2 ++
 drivers/rtc/rtc-m48t59.c   |  2 ++
 drivers/rtc/rtc-max8998.c  |  1 +
 drivers/rtc/rtc-mrst.c     |  2 ++
 drivers/rtc/rtc-nuc900.c   |  2 ++
 drivers/rtc/rtc-omap.c     |  2 ++
 drivers/rtc/rtc-pcap.c     |  2 ++
 drivers/rtc/rtc-pcf2123.c  |  1 +
 drivers/rtc/rtc-pl031.c    |  2 ++
 drivers/rtc/rtc-r9701.c    |  2 ++
 drivers/rtc/rtc-rp5c01.c   |  2 ++
 drivers/rtc/rtc-rs5c372.c  |  2 ++
 drivers/rtc/rtc-rv3029c2.c |  1 +
 drivers/rtc/rtc-rx8025.c   |  2 ++
 drivers/rtc/rtc-spear.c    |  2 ++
 drivers/rtc/rtc-stk17ta8.c |  2 ++
 drivers/rtc/rtc-stmp3xxx.c |  2 ++
 drivers/rtc/rtc-tegra.c    |  2 ++
 drivers/rtc/rtc-test.c     |  2 ++
 drivers/rtc/rtc-twl.c      |  3 +++
 drivers/rtc/rtc-tx4939.c   |  3 +++
 drivers/rtc/rtc-vr41xx.c   |  2 ++
 drivers/rtc/rtc-vt8500.c   |  2 ++
 drivers/rtc/rtc-x1205.c    |  2 ++
 include/linux/rtc.h        |  7 ++++++-
 41 files changed, 115 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..6af8355 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -230,13 +230,6 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 		goto exit_kfree;
 	}
 
-	rtc_dev_add_device(rtc);
-	rtc_sysfs_add_device(rtc);
-	rtc_proc_add_device(rtc);
-
-	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, dev_name(&rtc->dev));
-
 	return rtc;
 
 exit_kfree:
@@ -252,6 +245,21 @@ exit:
 }
 EXPORT_SYMBOL_GPL(rtc_device_register);
 
+/**
+ * rtc_device_register_fs - creates dev+sysfs+proc files
+ * for rtc device
+ */
+void rtc_device_register_fs(struct device *dev, struct rtc_device *rtc)
+{
+	rtc_dev_add_device(rtc);
+	rtc_sysfs_add_device(rtc);
+	rtc_proc_add_device(rtc);
+
+	set_bit(RTC_DEV_FILES_EXIST, &rtc->flags);
+	dev_info(dev, "rtc core: registered %s as %s\n",
+			rtc->name, dev_name(&rtc->dev));
+}
+EXPORT_SYMBOL_GPL(rtc_device_register_fs);
 
 /**
  * rtc_device_unregister - removes the previously registered RTC class device
@@ -262,13 +270,15 @@ void rtc_device_unregister(struct rtc_device *rtc)
 {
 	if (get_device(&rtc->dev) != NULL) {
 		mutex_lock(&rtc->ops_lock);
-		/* remove innards of this RTC, then disable it, before
-		 * letting any rtc_class_open() users access it again
-		 */
-		rtc_sysfs_del_device(rtc);
-		rtc_dev_del_device(rtc);
-		rtc_proc_del_device(rtc);
-		device_unregister(&rtc->dev);
+		if (test_and_clear_bit(RTC_DEV_FILES_EXIST, &rtc->flags)) {
+			/* remove innards of this RTC, then disable it, before
+			 * letting any rtc_class_open() users access it again
+			 */
+			rtc_sysfs_del_device(rtc);
+			rtc_dev_del_device(rtc);
+			rtc_proc_del_device(rtc);
+			device_unregister(&rtc->dev);
+		}
 		rtc->ops = NULL;
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
@@ -328,6 +338,15 @@ struct rtc_device *devm_rtc_device_register(struct device *dev,
 EXPORT_SYMBOL_GPL(devm_rtc_device_register);
 
 /**
+ * devm_rtc_device_register_fs - create proc&dev&sys files for the rtc device
+ */
+void devm_rtc_device_register_fs(struct device *dev, struct rtc_device *rtc)
+{
+	rtc_device_register_fs(dev, rtc);
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_register_fs);
+
+/**
  * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
  * @dev: the device to unregister
  * @rtc: the RTC class device to unregister
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 727e2f5..8e25da6 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -503,6 +503,7 @@ static int ab8500_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "sysfs RTC failed to register\n");
 		return err;
 	}
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 309b8b3..0108c6a 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -369,6 +369,8 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "%s: SET TIME!\n",
 				dev_name(&rtc->rtcdev->dev));
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 0c53f45..a7190b8 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -380,6 +380,8 @@ static int bfin_rtc_probe(struct platform_device *pdev)
 	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc->rtc_dev);
+
 	return 0;
 
 err:
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index cae212f..fff8b9d 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -784,6 +784,8 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
+	rtc_device_register_fs(dev, cmos_rtc.rtc);
+
 	dev_info(dev, "%s%s, %zd bytes nvram%s\n",
 		!is_valid_irq(rtc_irq) ? "no alarms" :
 			cmos_rtc.mon_alrm ? "alarms up to one year" :
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 24677ef8..57467ac 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -554,6 +554,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 
+	devm_rtc_device_register_fs(&pdev->dev, davinci_rtc->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 2dd586a..fb85d20 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -771,6 +771,8 @@ static int ds1305_probe(struct spi_device *spi)
 		return status;
 	}
 
+	devm_rtc_device_register_fs(&spi->dev, ds1305->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 4e75345..31cffee 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -972,6 +972,8 @@ read_rtc:
 		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
+	devm_rtc_device_register_fs(&client->dev, ds1307->rtc);
+
 	return 0;
 
 err_irq:
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index bc7b4fc..14f076d 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -534,6 +534,8 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index fd31571..735ea10 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -329,6 +329,8 @@ static int ds1553_rtc_probe(struct platform_device *pdev)
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index 18e2d84..2ad2578 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -189,6 +189,8 @@ static int ds1672_probe(struct i2c_client *client,
 	if (err)
 		goto exit_devreg;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 
  exit_devreg:
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 5a1f3b2..d4444b0 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -205,6 +205,8 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-ds3232.c b/drivers/rtc/rtc-ds3232.c
index b83bb5a5..778a9d5 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -427,6 +427,8 @@ static int ds3232_probe(struct i2c_client *client,
 		}
 	}
 
+	devm_rtc_device_register_fs(&client->dev, ds3232->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 5e4f5dc..fbe9a01 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -156,6 +156,8 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 	if (err)
 		goto exit;
 
+	devm_rtc_device_register_fs(&pdev->dev, ep93xx_rtc->rtc);
+
 	return 0;
 
 exit:
diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index c3c549d..bc25c5b 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -681,6 +681,8 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (rc)
 		return rc;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 1b126d2..925600b 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -278,6 +278,8 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index a5248aa..cd51429 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -707,6 +707,8 @@ static int m41t80_probe(struct i2c_client *client,
 		}
 	}
 #endif
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 
 st_err:
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 11880c1..027bcbd 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -489,6 +489,8 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	devm_rtc_device_register_fs(&pdev->dev, m48t59->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index f098ad8..c74020d 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -300,6 +300,7 @@ no_irq:
 		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
 				" RTC updates will be extremely slow.\n");
 	}
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index e2436d1..f61a2ef 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -374,6 +374,7 @@ static int vrtc_mrst_do_probe(struct device *dev, struct resource *iomem,
 			goto cleanup1;
 		}
 	}
+	rtc_device_register_fs(dev, mrst_rtc.rtc);
 	dev_dbg(dev, "initialised\n");
 	return 0;
 
@@ -403,6 +404,7 @@ static void rtc_mrst_do_remove(struct device *dev)
 	if (mrst->irq)
 		free_irq(mrst->irq, mrst->rtc);
 
+	rtc_device_unregister_fs(mrst->rtc);
 	rtc_device_unregister(mrst->rtc);
 	mrst->rtc = NULL;
 
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 248653c..64dd6e2 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -257,6 +257,8 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, nuc900_rtc->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 26de5f8..5fb141f 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -449,6 +449,8 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 
 fail0:
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 40b5c63..9aaac77 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -172,6 +172,8 @@ static int __init pcap_rtc_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	devm_rtc_device_register_fs(&pdev->dev, pcap_rtc->rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index d1953bb..874d85d 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -313,6 +313,7 @@ static int pcf2123_probe(struct spi_device *spi)
 			goto sysfs_exit;
 		}
 	}
+	devm_rtc_device_register_fs(&spi->dev, rtc);
 
 	return 0;
 
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 99181fff..5f04b29 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -306,6 +306,7 @@ static int pl031_remove(struct amba_device *adev)
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
 
 	free_irq(adev->irq[0], ldata);
+	rtc_device_unregister_fs(ldata->rtc);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
 	kfree(ldata);
@@ -384,6 +385,7 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		goto out_no_irq;
 	}
 
+	rtc_device_register_fs(&adev->dev, ldata->rtc);
 	return 0;
 
 out_no_irq:
diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index feeedbd..5f39f64 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -161,6 +161,8 @@ static int r9701_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, rtc);
 
+	devm_rtc_device_register_fs(&spi->dev, rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 89d0736..83d8655 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -259,6 +259,8 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 	if (error)
 		return error;
 
+	devm_rtc_device_register_fs(&dev->dev, rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index ccf54f0..a426eca 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -668,6 +668,8 @@ static int rs5c372_probe(struct i2c_client *client,
 	if (err)
 		goto exit;
 
+	devm_rtc_device_register_fs(&client->dev, rs5c372->rtc);
+
 	return 0;
 
 exit:
diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index 1a779a6..57e7d2e 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -408,6 +408,7 @@ static int rv3029c2_probe(struct i2c_client *client,
 		dev_err(&client->dev, "reading status failed\n");
 		return rc;
 	}
+	devm_rtc_device_register_fs(&client->dev, rtc);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index 8fa23ea..b07fac1 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -597,6 +597,8 @@ static int rx8025_probe(struct i2c_client *client,
 	if (err)
 		goto errout_irq;
 
+	devm_rtc_device_register_fs(&client->dev, rx8025->rtc);
+
 	return 0;
 
 errout_irq:
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c492cf0..a644636 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -414,6 +414,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	if (!device_can_wakeup(&pdev->dev))
 		device_init_wakeup(&pdev->dev, 1);
 
+	devm_rtc_device_register_fs(&pdev->dev, config->rtc);
+
 	return 0;
 
 err_disable_clock:
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index a176ba6..ec53d2a 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -338,6 +338,8 @@ static int stk17ta8_rtc_probe(struct platform_device *pdev)
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 
+	devm_rtc_device_register_fs(&pdev->dev, pdata->rtc);
+
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index ea96492..0d8c575 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -304,6 +304,8 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc_data->rtc);
+
 	stmp3xxx_wdt_register(pdev);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 76af92a..084d1ab 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -365,6 +365,8 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
 
+	devm_rtc_device_register_fs(&pdev->dev, info->rtc_dev);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 7746e65..0737eca 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -114,6 +114,8 @@ static int test_probe(struct platform_device *plat_dev)
 
 	platform_set_drvdata(plat_dev, rtc);
 
+	devm_rtc_device_register_fs(&plat_dev->dev, rtc);
+
 	return 0;
 
 err:
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 1915464..e9614e8 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -544,6 +544,9 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 4f87234..40b68f93 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -269,6 +269,9 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	pdata->rtc = rtc;
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
 
+	if (!ret)
+		devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 88c9c92..d84865b 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -355,6 +355,8 @@ static int rtc_probe(struct platform_device *pdev)
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
+	devm_rtc_device_register_fs(&pdev->dev, rtc);
+
 	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index df2ef3e..121f544 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -269,6 +269,8 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 		goto err_return;
 	}
 
+	devm_rtc_device_register_fs(&pdev->dev, vt8500_rtc->rtc);
+
 	return 0;
 
 err_return:
diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 365dc65..679df80 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -662,6 +662,8 @@ static int x1205_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
+	devm_rtc_device_register_fs(&client->dev, rtc);
+
 	return 0;
 }
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..245432a 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -81,7 +81,9 @@ struct rtc_timer {
 
 
 /* flags */
-#define RTC_DEV_BUSY 0
+#define RTC_DEV_BUSY        0
+/* flag indicating the files for the device have been created */
+#define RTC_DEV_FILES_EXIST 1
 
 struct rtc_device
 {
@@ -133,10 +135,13 @@ extern struct rtc_device *rtc_device_register(const char *name,
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+
+extern void rtc_device_register_fs(struct device *dev, struct rtc_device *rtc);
 extern struct rtc_device *devm_rtc_device_register(struct device *dev,
 					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+extern void devm_rtc_device_register_fs(struct device *dev, struct rtc_device *rtc);
 extern void rtc_device_unregister(struct rtc_device *rtc);
 extern void devm_rtc_device_unregister(struct device *dev,
 					struct rtc_device *rtc);
-- 
1.8.1.4

