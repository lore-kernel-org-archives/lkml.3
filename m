Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3KQPHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:07:03 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:37742 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3KQPG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:06:56 -0500
Message-ID: <5288DB85.8060105@hauke-m.de>
Date: Sun, 17 Nov 2013 16:06:45 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: broonie@kernel.org, lgirdwood@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: build error with CONFIG_REGMAP=m and CONFIG_REGULATOR=y
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In OpenWrt we are seeing some build errors when CONFIG_REGMAP=m and
CONFIG_REGULATOR=y are set.

/drivers/regulator/core.c accesses some regmap functions, but they are
compiled into a module and not into a kernel. When CONFIG_REGMAP is not
set the header file replaces the functions with empty static inline
functions.

With kernel 3.10.18 I see the following build error:

drivers/built-in.o: In function `regulator_get_bypass_regmap':
/drivers/regulator/core.c:2989: undefined reference to `regmap_read'
drivers/built-in.o: In function `regulator_get_voltage_sel_regmap':
/drivers/regulator/core.c:2199: undefined reference to `regmap_read'
drivers/built-in.o: In function `regulator_is_enabled_regmap':
/drivers/regulator/core.c:1916: undefined reference to `regmap_read'
drivers/built-in.o: In function `regulator_set_bypass_regmap':
/drivers/regulator/core.c:2973: undefined reference to `regmap_update_bits'
drivers/built-in.o: In function `regulator_set_voltage_sel_regmap':
/drivers/regulator/core.c:2226: undefined reference to `regmap_update_bits'
/drivers/regulator/core.c:2232: undefined reference to `regmap_update_bits'
drivers/built-in.o: In function `regulator_disable_regmap':
/drivers/regulator/core.c:1968: undefined reference to `regmap_update_bits'
drivers/built-in.o: In function `regulator_enable_regmap':
/drivers/regulator/core.c:1945: undefined reference to `regmap_update_bits'
drivers/built-in.o: In function `regulator_register':
/drivers/regulator/core.c:3581: undefined reference to `dev_get_regmap'
/drivers/regulator/core.c:3582: undefined reference to `dev_get_regmap'
/drivers/regulator/core.c:3584: undefined reference to `dev_get_regmap'
make[4]: *** [vmlinux] Error 1


The following patch would be a solution, but it causes a recursive
dependency:

--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -1,5 +1,6 @@
 menuconfig REGULATOR
 	bool "Voltage and Current Regulator Support"
+	depends on REGMAP || REGMAP = n
 	help
 	  Generic Voltage and Current Regulator support.


drivers/regulator/Kconfig:1:error: recursive dependency detected!
drivers/regulator/Kconfig:1:	symbol REGULATOR depends on REGMAP
drivers/base/regmap/Kconfig:5:	symbol REGMAP is selected by REGMAP_I2C
drivers/base/regmap/Kconfig:11:	symbol REGMAP_I2C is selected by
REGULATOR_FAN53555
drivers/regulator/Kconfig:124:	symbol REGULATOR_FAN53555 depends on
REGULATOR

I am not familiar with the regmap and the regulator framework, but I
would suggest to make REGULATOR depend on REGMAP.

Hauke
