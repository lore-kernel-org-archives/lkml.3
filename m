Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3EYXMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 19:12:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45023 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab3EYXMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 19:12:48 -0400
Date: Sat, 25 May 2013 15:23:54 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20130525222354.GA29486@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to get a few one-liners: wrong kfree
usage fix, module alias fixup and kconfig adjustments. The patches really
small, so for convenience I inline them here.

Thanks!

Anton

The following changes since commit 6b170807cd5cac8dc6353f47a88ccb14bbf76c4f:

  pm2301-charger: Fix suspend/resume (2013-04-16 19:00:01 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.10-fixes

for you to fetch changes up to dccab6092d3c25bf943d12fb658e63fd88bf8b4a:

  pm2301_charger: Fix module alias prefix (2013-05-10 11:57:14 -0700)

----------------------------------------------------------------
Axel Lin (2):
      wm831x_backup: Fix wrong kfree call for devdata->backup.name
      pm2301_charger: Fix module alias prefix

Randy Dunlap (1):
      lp8788-charger: Fix kconfig dependency

Xiong Zhou (1):
      bq27x00: Fix I2C dependency in KConfig

 drivers/power/Kconfig          | 2 ++
 drivers/power/pm2301_charger.c | 2 +-
 drivers/power/wm831x_backup.c  | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)


commit dccab6092d3c25bf943d12fb658e63fd88bf8b4a
Author: Axel Lin <axel.lin@ingics.com>
Date:   Sat May 4 18:51:09 2013 +0800

    pm2301_charger: Fix module alias prefix
    
    This driver is a i2c driver, use "i2c" rather than "platform" prefix for
    module alias.
    
    Signed-off-by: Axel Lin <axel.lin@ingics.com>
    Signed-off-by: Anton Vorontsov <anton@enomsg.org>

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index f123f3c..e9c6ba0 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1269,5 +1269,5 @@ module_exit(pm2xxx_charger_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Rajkumar kasirajan, Olivier Launay");
-MODULE_ALIAS("platform:pm2xxx-charger");
+MODULE_ALIAS("i2c:pm2xxx-charger");
 MODULE_DESCRIPTION("PM2xxx charger management driver");

commit c909fc8573af3cff9184551e79cf37784b5ddc24
Author: Axel Lin <axel.lin@ingics.com>
Date:   Sat May 4 13:57:55 2013 +0800

    wm831x_backup: Fix wrong kfree call for devdata->backup.name
    
    devdata->backup.name points to devdata->name, the memory for devdata->name
    is part of struct wm831x_backup. Thus remove kfree call for
    devdata->backup.name.
    
    Signed-off-by: Axel Lin <axel.lin@ingics.com>
    Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Anton Vorontsov <anton@enomsg.org>

diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index 58cbb00..56fb509 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -207,7 +207,6 @@ static int wm831x_backup_remove(struct platform_device *pdev)
 	struct wm831x_backup *devdata = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&devdata->backup);
-	kfree(devdata->backup.name);
 
 	return 0;
 }

commit a2d0dbb4b55681874c5f288538ae55ae69baeaff
Author: Xiong Zhou <jencce.kernel@gmail.com>
Date:   Tue May 7 10:15:56 2013 +0800

    bq27x00: Fix I2C dependency in KConfig
    
    This patch fixes build failure(randconfig) of next-20130501. When config
    I2C as m, BATTERY_BQ27x00 as y, here comes the failure. The driver depends
    on I2C only if I2C is not disabled, as Lars commented. Last version of
    this patch make the driver depend on I2C unconditionally.
    
    Failure message:
    drivers/built-in.o: In function `bq27x00_read_i2c':
    bq27x00_battery.c:(.text+0x1082a7): undefined reference to `i2c_transfer'
    drivers/built-in.o: In function `bq27x00_battery_init':
    bq27x00_battery.c:(.init.text+0x6085): undefined reference to `i2c_register_driver'
    bq27x00_battery.c:(.init.text+0x60c7): undefined reference to `i2c_del_driver'
    drivers/built-in.o: In function `bq27x00_battery_exit':
    bq27x00_battery.c:(.exit.text+0xbf0): undefined reference to `i2c_del_driver'
    make: *** [vmlinux] Error 1
    
    Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
    Cc: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Anton Vorontsov <anton@enomsg.org>

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 814bcb9..674e633 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -152,6 +152,7 @@ config BATTERY_SBS
 
 config BATTERY_BQ27x00
 	tristate "BQ27x00 battery driver"
+	depends on I2C || I2C=n
 	help
 	  Say Y here to enable support for batteries with BQ27x00 (I2C/HDQ) chips.
 

commit 237a1b01fdb29df6a28d50d6dbe7a988c4fb3625
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Wed May 1 12:18:43 2013 -0700

    lp8788-charger: Fix kconfig dependency
    
    Fix build errors in lp8788-charger by making it depend on IIO.
    Fixes errors when CONFIG_IIO=m and CHARGER_LP8788=y.
    
    lp8788-charger.c:(.text+0x2146b5): undefined reference to `iio_channel_get'
    lp8788-charger.c:(.text+0x2146ce): undefined reference to `iio_channel_get'
    lp8788-charger.c:(.text+0x214a86): undefined reference to `iio_read_channel_processed'
    lp8788-charger.c:(.text+0x214b51): undefined reference to `iio_read_channel_processed'
    lp8788-charger.c:(.text+0x214c30): undefined reference to `iio_read_channel_processed'
    lp8788-charger.c:(.text+0x214d93): undefined reference to `iio_channel_release'
    lp8788-charger.c:(.text+0x214dac): undefined reference to `iio_channel_release'
    
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Acked-by: Milo Kim <milo.kim@ti.com>
    Signed-off-by: Anton Vorontsov <anton@enomsg.org>

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 339f802..814bcb9 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -284,6 +284,7 @@ config CHARGER_LP8788
 	tristate "TI LP8788 charger driver"
 	depends on MFD_LP8788
 	depends on LP8788_ADC
+	depends on IIO
 	help
 	  Say Y to enable support for the LP8788 linear charger.
 
