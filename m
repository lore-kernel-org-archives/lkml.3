Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3DMOOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:14:15 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59746 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3DMOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:14:13 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] backports: add support for voltage / current regulator drivers
Date: Sat, 13 Apr 2013 07:13:42 -0700
Message-Id: <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This backports the latest regulator drivers for kernels >= 3.4.
We enable the regulator only on kernels >= 3.4 given that
it relies on the new probe deferral mechanism which would
otherwise mean having to support drivers that do not probe
correctly. Note that 3.2 had a base regulator implementation
but that was just stubs.

I did look into a way to upgrade the core kernel regulator
but given that it relies on late_initcall() and core_initcall()
we can't update this part of the kernel. I even looked at
using ksplice for this but it seems ksplice can't be used to
update init sections on the vmlinux ELF. I also haven't much
updates to these routines since 3.4 except for 86f5fcfc.

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

real    39m35.615s
user    1068m47.428s
sys     155m55.657s

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/Kconfig                                   |    2 +
 backport/Makefile.kernel                           |    1 +
 backport/defconfigs/regulator                      |   63 ++++++++++++++++++
 copy-list                                          |   33 ++++++++++
 dependencies                                       |   27 ++++++++
 .../regulator/0001-bt8xx-rename-dst-ops.patch      |   67 ++++++++++++++++++++
 6 files changed, 193 insertions(+)
 create mode 100644 backport/defconfigs/regulator
 create mode 100644 patches/collateral-evolutions/regulator/0001-bt8xx-rename-dst-ops.patch

diff --git a/backport/Kconfig b/backport/Kconfig
index 6ab0991..6088bfe 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -38,3 +38,5 @@ source drivers/bcma/Kconfig
 source drivers/gpu/drm/Kconfig
 
 source net/nfc/Kconfig
+
+source drivers/regulator/Kconfig
diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index 59e95ef..2741cc9 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -31,3 +31,4 @@ obj-$(CPTCFG_ETHERNET) += drivers/net/ethernet/
 obj-$(CPTCFG_DRM) += drivers/gpu/drm/
 obj-$(CPTCFG_NFC) += net/nfc/
 obj-$(CPTCFG_NFC) += drivers/nfc/
+obj-$(CPTCFG_REGULATOR) += drivers/regulator/
diff --git a/backport/defconfigs/regulator b/backport/defconfigs/regulator
new file mode 100644
index 0000000..c080747
--- /dev/null
+++ b/backport/defconfigs/regulator
@@ -0,0 +1,63 @@
+CPTCFG_REGULATOR=y
+CPTCFG_REGULATOR_88PM8607=y
+CPTCFG_REGULATOR_AAT2870=y
+CPTCFG_REGULATOR_AB3100=y
+CPTCFG_REGULATOR_AB8500=y
+CPTCFG_REGULATOR_AD5398=y
+CPTCFG_REGULATOR_ANATOP=y
+CPTCFG_REGULATOR_ARIZONA=y
+CPTCFG_REGULATOR_AS3711=y
+CPTCFG_REGULATOR_DA903X=y
+CPTCFG_REGULATOR_DA9052=y
+CPTCFG_REGULATOR_DA9055=y
+CPTCFG_REGULATOR_DB8500_PRCMU=y
+CPTCFG_REGULATOR_DBX500_PRCMU=y
+CPTCFG_REGULATOR_DEBUG=y
+CPTCFG_REGULATOR_FAN53555=y
+CPTCFG_REGULATOR_FIXED_VOLTAGE=y
+CPTCFG_REGULATOR_GPIO=y
+CPTCFG_REGULATOR_ISL6271A=y
+CPTCFG_REGULATOR_LP3971=y
+CPTCFG_REGULATOR_LP3972=y
+CPTCFG_REGULATOR_LP872X=y
+CPTCFG_REGULATOR_LP8755=y
+CPTCFG_REGULATOR_LP8788=y
+CPTCFG_REGULATOR_MAX1586=y
+CPTCFG_REGULATOR_MAX77686=y
+CPTCFG_REGULATOR_MAX8649=y
+CPTCFG_REGULATOR_MAX8660=y
+CPTCFG_REGULATOR_MAX8907=y
+CPTCFG_REGULATOR_MAX8925=y
+CPTCFG_REGULATOR_MAX8952=y
+CPTCFG_REGULATOR_MAX8973=y
+CPTCFG_REGULATOR_MAX8997=y
+CPTCFG_REGULATOR_MAX8998=y
+CPTCFG_REGULATOR_MC13783=y
+CPTCFG_REGULATOR_MC13892=y
+CPTCFG_REGULATOR_MC13XXX_CORE=y
+CPTCFG_REGULATOR_PALMAS=y
+CPTCFG_REGULATOR_PCAP=y
+CPTCFG_REGULATOR_PCF50633=y
+CPTCFG_REGULATOR_RC5T583=y
+CPTCFG_REGULATOR_S2MPS11=y
+CPTCFG_REGULATOR_S5M8767=y
+CPTCFG_REGULATOR_TPS51632=y
+CPTCFG_REGULATOR_TPS6105X=y
+CPTCFG_REGULATOR_TPS62360=y
+CPTCFG_REGULATOR_TPS65023=y
+CPTCFG_REGULATOR_TPS6507X=y
+CPTCFG_REGULATOR_TPS65090=y
+CPTCFG_REGULATOR_TPS65217=y
+CPTCFG_REGULATOR_TPS6524X=y
+CPTCFG_REGULATOR_TPS6586X=y
+CPTCFG_REGULATOR_TPS65910=y
+CPTCFG_REGULATOR_TPS65912=y
+CPTCFG_REGULATOR_TPS80031=y
+CPTCFG_REGULATOR_TWL4030=y
+CPTCFG_REGULATOR_USERSPACE_CONSUMER=y
+CPTCFG_REGULATOR_VEXPRESS=y
+CPTCFG_REGULATOR_VIRTUAL_CONSUMER=y
+CPTCFG_REGULATOR_WM831X=y
+CPTCFG_REGULATOR_WM8350=y
+CPTCFG_REGULATOR_WM8400=y
+CPTCFG_REGULATOR_WM8994=y
diff --git a/copy-list b/copy-list
index e8b1241..9771c43 100644
--- a/copy-list
+++ b/copy-list
@@ -135,3 +135,36 @@ drivers/nfc/
 drivers/nfc/microread/
 drivers/nfc/pn544/
 include/linux/platform_data/pn544.h
+
+# Regulator
+# we don't include the whole directory as we need
+# rely on your core regulator implementation given that
+# it relies on late_initcall() and core_initcall() and
+# these can't be backported, as such we need to rely
+# on your base kernel regulator implementatin and can
+# only extend it with further exports. Your core
+# regulator routines are defined via the header file
+# include/linux/regulator/consumer.h and dummy.h
+include/linux/regulator/ab8500.h
+include/linux/regulator/db8500-prcmu.h
+include/linux/regulator/driver.h
+include/linux/regulator/fan53555.h
+include/linux/regulator/fixed.h
+include/linux/regulator/gpio-regulator.h
+include/linux/regulator/lp3971.h
+include/linux/regulator/lp3972.h
+include/linux/regulator/lp872x.h
+include/linux/regulator/machine.h
+include/linux/regulator/max1586.h
+include/linux/regulator/max8649.h
+include/linux/regulator/max8660.h
+include/linux/regulator/max8952.h
+include/linux/regulator/max8973-regulator.h
+include/linux/regulator/of_regulator.h
+include/linux/regulator/tps51632-regulator.h
+include/linux/regulator/tps62360.h
+include/linux/regulator/tps6507x.h
+include/linux/regulator/userspace-consumer.h
+include/linux/platform_data/lp8755.h
+
+drivers/regulator/
diff --git a/dependencies b/dependencies
index 44e23da..0ab99d4 100644
--- a/dependencies
+++ b/dependencies
@@ -46,6 +46,28 @@ HDMI 3.2
 DRM 3.2
 DRM_TTM 3.2
 
+# Regulator
+# Because of -EPROBE_DEFER see commit d1c3414c and note that
+# we can't backport the core regulator as its part of the core
+# vmlinux.
+REGULATOR 3.4
+# requires some work
+REGULATOR_ARIZONA DISABLE
+REGULATOR_MAX8973 DISABLE
+REGULATOR_MAX77686 DISABLE
+REGULATOR_MAX8997 DISABLE
+REGULATOR_RC5T583 DISABLE
+REGULATOR_TPS62360 DISABLE
+REGULATOR_TPS65910 DISABLE
+REGULATOR_TPS65090 DISABLE
+REGULATOR_TPS65217 DISABLE
+REGULATOR_TPS6586X DISABLE
+REGULATOR_WM831X DISABLE
+REGULATOR_WM8350 DISABLE
+REGULATOR_PALMAS DISABLE
+REGULATOR_DA9055 DISABLE
+REGULATOR_S5M8767 DISABLE
+
 # This requires proc_create(), and that doesn't exist before 2.6.24
 LIBIPW_DEBUG 2.6.25
 
@@ -71,6 +93,11 @@ BCMA_DRIVER_GPIO 3.0
 # (rfkill-regulator.h) that we don't backport
 # right now, so make it depend on 3.0
 RFKILL_REGULATOR 3.0
+# drivers/regulator/ab3100.c and drivers/mfd/ab3100-core.c
+# both depend on include/linux/mfd/ab3100.h and we should
+# only backport REGULATOR_AB3100 if the mfd driver is
+# backported as well.
+REGULATOR_AB3100 3.9
 
 # This is a fun one ... the implementation of this
 # uses subdir-ccflags-$(CONFIG_BRCMDBG) which was
diff --git a/patches/collateral-evolutions/regulator/0001-bt8xx-rename-dst-ops.patch b/patches/collateral-evolutions/regulator/0001-bt8xx-rename-dst-ops.patch
new file mode 100644
index 0000000..2e8e1b3
--- /dev/null
+++ b/patches/collateral-evolutions/regulator/0001-bt8xx-rename-dst-ops.patch
@@ -0,0 +1,67 @@
+This will be sent upstream... there is a conflict with these
+names and another symbol from older kernels.
+
+--- a/drivers/media/pci/bt8xx/dst.c
++++ b/drivers/media/pci/bt8xx/dst.c
+@@ -1544,7 +1544,7 @@ static int dst_send_burst(struct dvb_fro
+ }
+ 
+ 
+-static int dst_init(struct dvb_frontend *fe)
++static int bt8xx_dst_init(struct dvb_frontend *fe)
+ {
+ 	struct dst_state *state = fe->demodulator_priv;
+ 
+@@ -1707,7 +1707,7 @@ static int dst_get_frontend(struct dvb_f
+ 	return 0;
+ }
+ 
+-static void dst_release(struct dvb_frontend *fe)
++static void bt8xx_dst_release(struct dvb_frontend *fe)
+ {
+ 	struct dst_state *state = fe->demodulator_priv;
+ 	if (state->dst_ca) {
+@@ -1776,8 +1776,8 @@ static struct dvb_frontend_ops dst_dvbt_
+ 			FE_CAN_GUARD_INTERVAL_AUTO
+ 	},
+ 
+-	.release = dst_release,
+-	.init = dst_init,
++	.release = bt8xx_dst_release,
++	.init = bt8xx_dst_init,
+ 	.tune = dst_tune_frontend,
+ 	.set_frontend = dst_set_frontend,
+ 	.get_frontend = dst_get_frontend,
+@@ -1801,8 +1801,8 @@ static struct dvb_frontend_ops dst_dvbs_
+ 		.caps = FE_CAN_FEC_AUTO | FE_CAN_QPSK
+ 	},
+ 
+-	.release = dst_release,
+-	.init = dst_init,
++	.release = bt8xx_dst_release,
++	.init = bt8xx_dst_init,
+ 	.tune = dst_tune_frontend,
+ 	.set_frontend = dst_set_frontend,
+ 	.get_frontend = dst_get_frontend,
+@@ -1834,8 +1834,8 @@ static struct dvb_frontend_ops dst_dvbc_
+ 			FE_CAN_QAM_256
+ 	},
+ 
+-	.release = dst_release,
+-	.init = dst_init,
++	.release = bt8xx_dst_release,
++	.init = bt8xx_dst_init,
+ 	.tune = dst_tune_frontend,
+ 	.set_frontend = dst_set_frontend,
+ 	.get_frontend = dst_get_frontend,
+@@ -1857,8 +1857,8 @@ static struct dvb_frontend_ops dst_atsc_
+ 		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+ 	},
+ 
+-	.release = dst_release,
+-	.init = dst_init,
++	.release = bt8xx_dst_release,
++	.init = bt8xx_dst_init,
+ 	.tune = dst_tune_frontend,
+ 	.set_frontend = dst_set_frontend,
+ 	.get_frontend = dst_get_frontend,
-- 
1.7.10.4

