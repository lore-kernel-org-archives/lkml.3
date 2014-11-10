Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaKJBrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:47:37 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39250 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaKJBpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:45:05 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alexander Graf <agraf@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
        Alistair Popple <alistair@popple.id.au>,
        Anatolij Gustschin <agust@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        cbe-oss-dev@lists.ozlabs.org, Geoff Levand <geoff@infradead.org>,
        Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>
Subject: [PATCH v6 41/48] powerpc: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:58 -0800
Message-Id: <1415583785-6980-42-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.546018A0.020A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 245
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly.

If there is an indication that there can be more than one power-off handler,
use register_power_off_handler, otherwise use register_power_off_handler_simple
to register the power-off handler.

If the power-off handler only resets or stops the system, select the fallback
priority to indicate that the power-off handler is one of last resort.
If the power-off handler powers off the system, select the default priority,
unless the power-off handler installation code suggests that there can be
more than one power-off handler and the new handler is only installed
conditionally. In this case, install the handler with low priority.

Cc: Alexander Graf <agraf@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- New patch

 arch/powerpc/platforms/44x/ppc476.c              |  3 ++-
 arch/powerpc/platforms/52xx/efika.c              |  3 ++-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c   | 30 ++++++++++++++++--------
 arch/powerpc/platforms/85xx/corenet_generic.c    |  3 ++-
 arch/powerpc/platforms/85xx/sgy_cts1000.c        | 16 +++++++++++--
 arch/powerpc/platforms/cell/celleb_setup.c       |  6 +++--
 arch/powerpc/platforms/cell/qpace_setup.c        |  3 ++-
 arch/powerpc/platforms/cell/setup.c              |  3 ++-
 arch/powerpc/platforms/chrp/setup.c              |  3 ++-
 arch/powerpc/platforms/embedded6xx/gamecube.c    |  3 ++-
 arch/powerpc/platforms/embedded6xx/linkstation.c |  3 ++-
 arch/powerpc/platforms/embedded6xx/wii.c         |  3 ++-
 arch/powerpc/platforms/maple/setup.c             |  6 +++--
 arch/powerpc/platforms/powermac/setup.c          |  3 ++-
 arch/powerpc/platforms/powernv/setup.c           |  6 +++--
 arch/powerpc/platforms/ps3/setup.c               |  3 ++-
 arch/powerpc/platforms/pseries/setup.c           |  3 ++-
 arch/powerpc/sysdev/fsl_soc.c                    |  6 ++---
 18 files changed, 73 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/platforms/44x/ppc476.c b/arch/powerpc/platforms/44x/ppc476.c
index c11ce65..590d31f 100644
--- a/arch/powerpc/platforms/44x/ppc476.c
+++ b/arch/powerpc/platforms/44x/ppc476.c
@@ -94,7 +94,8 @@ static int avr_probe(struct i2c_client *client,
 {
 	avr_i2c_client = client;
 	ppc_md.restart = avr_reset_system;
-	pm_power_off = avr_power_off_system;
+	register_power_off_handler_simple(avr_power_off_system,
+					  POWER_OFF_PRIORITY_DEFAULT);
 	return 0;
 }
 
diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
index 6af651e..321a7a7 100644
--- a/arch/powerpc/platforms/52xx/efika.c
+++ b/arch/powerpc/platforms/52xx/efika.c
@@ -212,7 +212,8 @@ static int __init efika_probe(void)
 	DMA_MODE_READ = 0x44;
 	DMA_MODE_WRITE = 0x48;
 
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 15e8021..1bf6b0e 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -19,6 +19,7 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/reboot.h>
@@ -86,7 +87,7 @@ static ssize_t show_status(struct device *d,
 }
 static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
-static void mcu_power_off(void)
+static void mcu_power_off(struct power_off_handler_block *this)
 {
 	struct mcu *mcu = glob_mcu;
 
@@ -97,6 +98,11 @@ static void mcu_power_off(void)
 	mutex_unlock(&mcu->lock);
 }
 
+static struct power_off_handler_block mcu_power_off_hb = {
+	.handler = mcu_power_off,
+	.priority = POWER_OFF_PRIORITY_LOW,
+};
+
 static void mcu_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct mcu *mcu = container_of(gc, struct mcu, gc);
@@ -167,13 +173,15 @@ static int mcu_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (ret)
 		goto err;
 
-	/* XXX: this is potentially racy, but there is no lock for pm_power_off */
-	if (!pm_power_off) {
-		glob_mcu = mcu;
-		pm_power_off = mcu_power_off;
-		dev_info(&client->dev, "will provide power-off service\n");
+	glob_mcu = mcu;
+	ret = register_power_off_handler(&mcu_power_off_hb);
+	if (ret) {
+		dev_err(&client->dev, "Failed to register power-off handler\n");
+		goto err_handler;
 	}
 
+	dev_info(&client->dev, "will provide power-off service\n");
+
 	if (device_create_file(&client->dev, &dev_attr_status))
 		dev_err(&client->dev,
 			"couldn't create device file for status\n");
@@ -182,6 +190,10 @@ static int mcu_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				      "mcu-i2c-shdn");
 
 	return 0;
+
+err_handler:
+	mcu_gpiochip_remove(mcu);
+	glob_mcu = NULL;
 err:
 	kfree(mcu);
 	return ret;
@@ -196,10 +208,8 @@ static int mcu_remove(struct i2c_client *client)
 
 	device_remove_file(&client->dev, &dev_attr_status);
 
-	if (glob_mcu == mcu) {
-		pm_power_off = NULL;
-		glob_mcu = NULL;
-	}
+	unregister_power_off_handler(&mcu_power_off_hb);
+	glob_mcu = NULL;
 
 	ret = mcu_gpiochip_remove(mcu);
 	if (ret)
diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
index 1f309cc..f0c4b51 100644
--- a/arch/powerpc/platforms/85xx/corenet_generic.c
+++ b/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -170,7 +170,8 @@ static int __init corenet_generic_probe(void)
 
 			ppc_md.get_irq = ehv_pic_get_irq;
 			ppc_md.restart = fsl_hv_restart;
-			pm_power_off = fsl_hv_halt;
+			register_power_off_handler_simple(fsl_hv_halt,
+						POWER_OFF_PRIORITY_DEFAULT);
 			ppc_md.halt = fsl_hv_halt;
 #ifdef CONFIG_SMP
 			/*
diff --git a/arch/powerpc/platforms/85xx/sgy_cts1000.c b/arch/powerpc/platforms/85xx/sgy_cts1000.c
index e149c9e..d849e8f 100644
--- a/arch/powerpc/platforms/85xx/sgy_cts1000.c
+++ b/arch/powerpc/platforms/85xx/sgy_cts1000.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
+#include <linux/pm.h>
 #include <linux/workqueue.h>
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
@@ -59,6 +60,16 @@ static void gpio_halt_cb(void)
 	gpio_set_value(gpio, trigger);
 }
 
+static void gpio_power_off_cb(struct power_off_handler_block *this)
+{
+	gpio_halt_cb();
+}
+
+static struct power_off_handler_block gpio_power_off_hb = {
+	.handler = gpio_power_off_cb,
+	.priority = POWER_OFF_PRIORITY_DEFAULT,
+};
+
 /* This IRQ means someone pressed the power button and it is waiting for us
  * to handle the shutdown/poweroff. */
 static irqreturn_t gpio_halt_irq(int irq, void *__data)
@@ -120,7 +131,8 @@ static int gpio_halt_probe(struct platform_device *pdev)
 
 	/* Register our halt function */
 	ppc_md.halt = gpio_halt_cb;
-	pm_power_off = gpio_halt_cb;
+	if (register_power_off_handler(&gpio_power_off_hb))
+		pr_warn("gpio-halt: Failed to register power-off handler\n");
 
 	printk(KERN_INFO "gpio-halt: registered GPIO %d (%d trigger, %d"
 	       " irq).\n", gpio, trigger, irq);
@@ -137,7 +149,7 @@ static int gpio_halt_remove(struct platform_device *pdev)
 		free_irq(irq, halt_node);
 
 		ppc_md.halt = NULL;
-		pm_power_off = NULL;
+		unregister_power_off_handler(&gpio_power_off_hb);
 
 		gpio_free(gpio);
 
diff --git a/arch/powerpc/platforms/cell/celleb_setup.c b/arch/powerpc/platforms/cell/celleb_setup.c
index 90be8ec..e301b1a 100644
--- a/arch/powerpc/platforms/cell/celleb_setup.c
+++ b/arch/powerpc/platforms/cell/celleb_setup.c
@@ -142,7 +142,8 @@ static int __init celleb_probe_beat(void)
 	powerpc_firmware_features |= FW_FEATURE_CELLEB_ALWAYS
 		| FW_FEATURE_BEAT | FW_FEATURE_LPAR;
 	hpte_init_beat_v3();
-	pm_power_off = beat_power_off;
+	register_power_off_handler_simple(beat_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
@@ -191,7 +192,8 @@ static int __init celleb_probe_native(void)
 
 	powerpc_firmware_features |= FW_FEATURE_CELLEB_ALWAYS;
 	hpte_init_native();
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/cell/qpace_setup.c b/arch/powerpc/platforms/cell/qpace_setup.c
index d328140..223d40a 100644
--- a/arch/powerpc/platforms/cell/qpace_setup.c
+++ b/arch/powerpc/platforms/cell/qpace_setup.c
@@ -127,7 +127,8 @@ static int __init qpace_probe(void)
 		return 0;
 
 	hpte_init_native();
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index d62aa98..ea5460c 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -259,7 +259,8 @@ static int __init cell_probe(void)
 		return 0;
 
 	hpte_init_native();
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 860a59e..0c0288e 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -585,7 +585,8 @@ static int __init chrp_probe(void)
 	DMA_MODE_READ = 0x44;
 	DMA_MODE_WRITE = 0x48;
 
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/embedded6xx/gamecube.c b/arch/powerpc/platforms/embedded6xx/gamecube.c
index fe0ed6e..af40f0f 100644
--- a/arch/powerpc/platforms/embedded6xx/gamecube.c
+++ b/arch/powerpc/platforms/embedded6xx/gamecube.c
@@ -67,7 +67,8 @@ static int __init gamecube_probe(void)
 	if (!of_flat_dt_is_compatible(dt_root, "nintendo,gamecube"))
 		return 0;
 
-	pm_power_off = gamecube_power_off;
+	register_power_off_handler_simple(gamecube_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 540eeb5..0c4dcf8 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -148,7 +148,8 @@ static int __init linkstation_probe(void)
 	if (!of_flat_dt_is_compatible(root, "linkstation"))
 		return 0;
 
-	pm_power_off = linkstation_power_off;
+	register_power_off_handler_simple(linkstation_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 352592d..eea8824 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -211,7 +211,8 @@ static int __init wii_probe(void)
 	if (!of_flat_dt_is_compatible(dt_root, "nintendo,wii"))
 		return 0;
 
-	pm_power_off = wii_power_off;
+	register_power_off_handler_simple(wii_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 56b85cd..73c3988 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -169,7 +169,8 @@ static void __init maple_use_rtas_reboot_and_halt_if_present(void)
 	if (rtas_service_present("system-reboot") &&
 	    rtas_service_present("power-off")) {
 		ppc_md.restart = rtas_restart;
-		pm_power_off = rtas_power_off;
+		register_power_off_handler_simple(rtas_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 		ppc_md.halt = rtas_halt;
 	}
 }
@@ -312,7 +313,8 @@ static int __init maple_probe(void)
 	alloc_dart_table();
 
 	hpte_init_native();
-	pm_power_off = maple_power_off;
+	register_power_off_handler_simple(maple_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 713d36d..6496ae4 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -632,7 +632,8 @@ static int __init pmac_probe(void)
 	smu_cmdbuf_abs = memblock_alloc_base(4096, 4096, 0x80000000UL);
 #endif /* CONFIG_PMAC_SMU */
 
-	pm_power_off = pmac_power_off;
+	register_power_off_handler_simple(pmac_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 1;
 }
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 941831d..a03c41b 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -268,7 +268,8 @@ static void __init pnv_setup_machdep_opal(void)
 	ppc_md.get_rtc_time = opal_get_rtc_time;
 	ppc_md.set_rtc_time = opal_set_rtc_time;
 	ppc_md.restart = pnv_restart;
-	pm_power_off = pnv_power_off;
+	register_power_off_handler_simple(pnv_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 	ppc_md.halt = pnv_halt;
 	ppc_md.machine_check_exception = opal_machine_check;
 	ppc_md.mce_check_early_recovery = opal_mce_check_early_recovery;
@@ -285,7 +286,8 @@ static void __init pnv_setup_machdep_rtas(void)
 		ppc_md.set_rtc_time = rtas_set_rtc_time;
 	}
 	ppc_md.restart = rtas_restart;
-	pm_power_off = rtas_power_off;
+	register_power_off_handler_simple(rtas_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 	ppc_md.halt = rtas_halt;
 }
 #endif /* CONFIG_PPC_POWERNV_RTAS */
diff --git a/arch/powerpc/platforms/ps3/setup.c b/arch/powerpc/platforms/ps3/setup.c
index 009a200..77e0dea 100644
--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -248,7 +248,8 @@ static int __init ps3_probe(void)
 	ps3_mm_init();
 	ps3_mm_vas_create(&htab_size);
 	ps3_hpte_init(htab_size);
-	pm_power_off = ps3_power_off;
+	register_power_off_handler_simple(ps3_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	DBG(" <- %s:%d\n", __func__, __LINE__);
 	return 1;
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index db0fc0c..b3c85bb 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -769,7 +769,8 @@ static int __init pSeries_probe(void)
 	else
 		hpte_init_native();
 
-	pm_power_off = pseries_power_off;
+	register_power_off_handler_simple(pseries_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	pr_debug("Machine is%s LPAR !\n",
 	         (powerpc_firmware_features & FW_FEATURE_LPAR) ? "" : " not");
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 1e04568..eeb075f 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -238,9 +238,9 @@ void fsl_hv_restart(char *cmd)
 /*
  * Halt the current partition
  *
- * This function should be assigned to the pm_power_off and ppc_md.halt
- * function pointers, to shut down the partition when we're running under
- * the Freescale hypervisor.
+ * This function should be registered as power-off handler and be assigned
+ * to the ppc_md.halt function pointer, to shut down the partition when
+ * we're running under the Freescale hypervisor.
  */
 void fsl_hv_halt(void)
 {
-- 
1.9.1

