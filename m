Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3GKUea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:34:30 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54376 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756598Ab3GKUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:34:27 -0400
Date: Thu, 11 Jul 2013 22:34:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v3.11-rc1
Message-ID: <20130711203424.GE14258@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It contains:
* lot's of devm_ conversions and cleanup
* platform_set_drvdata cleanups
* s3c2410: dev_err/dev_info + dev_pm_ops
* watchdog_core: don't try to stop device if not running fix
* wdrtas: use print_hex_dump
* xilinx cleanups
* orion_wdt fixes
* softdog cleanup
* hpwdt: check on UEFI bits
* deletion of mpcore_wdt driver
* Addition of broadcom BCM2835 watchdog timer driver
* Addition of MEN A21 watcdog devices

This will update the following files:

 b/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt             |   25 
 b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt |    5 
 b/Documentation/watchdog/watchdog-parameters.txt                      |    7 
 b/MAINTAINERS                                                         |    6 
 b/arch/arm/configs/spear13xx_defconfig                                |    1 
 b/arch/arm/mach-dove/include/mach/bridge-regs.h                       |    1 
 b/arch/arm/mach-kirkwood/include/mach/bridge-regs.h                   |    2 
 b/arch/arm/mach-orion5x/include/mach/bridge-regs.h                    |    3 
 b/drivers/watchdog/Kconfig                                            |   34 
 b/drivers/watchdog/Makefile                                           |    3 
 b/drivers/watchdog/at32ap700x_wdt.c                                   |   17 
 b/drivers/watchdog/bcm2835_wdt.c                                      |  189 ++++
 b/drivers/watchdog/bcm63xx_wdt.c                                      |    9 
 b/drivers/watchdog/cpwd.c                                             |    4 
 b/drivers/watchdog/da9052_wdt.c                                       |    4 
 b/drivers/watchdog/da9055_wdt.c                                       |    4 
 b/drivers/watchdog/dw_wdt.c                                           |   11 
 b/drivers/watchdog/hpwdt.c                                            |   11 
 b/drivers/watchdog/imx2_wdt.c                                         |    6 
 b/drivers/watchdog/jz4740_wdt.c                                       |    2 
 b/drivers/watchdog/mena21_wdt.c                                       |  270 +++++
 b/drivers/watchdog/mtx-1_wdt.c                                        |    3 
 b/drivers/watchdog/mv64x60_wdt.c                                      |    4 
 b/drivers/watchdog/nuc900_wdt.c                                       |   50 -
 b/drivers/watchdog/of_xilinx_wdt.c                                    |   31 
 b/drivers/watchdog/orion_wdt.c                                        |    7 
 b/drivers/watchdog/pnx4008_wdt.c                                      |    7 
 b/drivers/watchdog/rc32434_wdt.c                                      |   10 
 b/drivers/watchdog/riowd.c                                            |   12 
 b/drivers/watchdog/s3c2410_wdt.c                                      |   20 
 b/drivers/watchdog/shwdt.c                                            |   18 
 b/drivers/watchdog/softdog.c                                          |    1 
 b/drivers/watchdog/sp805_wdt.c                                        |    7 
 b/drivers/watchdog/ts72xx_wdt.c                                       |   67 -
 b/drivers/watchdog/twl4030_wdt.c                                      |    5 
 b/drivers/watchdog/watchdog_dev.c                                     |    6 
 b/drivers/watchdog/wdrtas.c                                           |   29 
 b/drivers/watchdog/wm831x_wdt.c                                       |   21 
 drivers/watchdog/mpcore_wdt.c                                         |  456 ----------
 39 files changed, 629 insertions(+), 739 deletions(-)

with these Changes:

commit cce78da76601b64305c050f602767bf58cebcf5d
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Tue Jul 9 23:04:55 2013 +0000

    watchdog: hpwdt: Add check for UEFI bits
    
    This patch is being created to use the UEFI bits in the type 219 SMBIOS
    record in order to decide whether or not to execute BIOS code. This is a
    better solution than to depend on the iCRU bit since not all future servers
    will use iCRU.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    ----
    drivers/watchdog/hpwdt.c |    9 ++++++---
     1 files changed, 6 insertions(+), 3 deletions(-)

commit 086f3ec187a18e29f8f36ebd4ae9eb8d48d9fd03
Author: Kim, Milo <Milo.Kim@ti.com>
Date:   Tue Mar 26 07:26:49 2013 +0000

    watchdog: softdog: remove replaceable ping operation
    
    In watchdog_ping(), 'start' is called automatically when 'ping' function call
    is not configured.
    Softdog driver has same handling in both cases - start and ping, so 'ping' OPS
    can be removed.
    
    Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 26c57ef1ea35f2e7b73db5fad3c81c388d6d056a
Author: Johannes Thumshirn <johannes.thumshirn@men.de>
Date:   Tue Jun 18 17:19:45 2013 +0200

    watchdog: New watchdog driver for MEN A21 watchdogs
    
    This patch adds the driver for the watchdog devices found on MEN Mikro
    Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
    watchdog framework.
    
    Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6910ceb5cababfefffc4ddc58a085a71c0ab9f22
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Tue Jun 18 17:20:32 2013 +0100

    Watchdog: fix clearing of the watchdog interrupt
    
    The bits in BRIDGE_CAUSE are documented as RW0C - read, write 0 to
    clear.  If we read the register, mask off the watchdog bit, and
    write it back, we're actually clearing every interrupt which wasn't
    pending at the time we read the register - and that is racy.
    
    Fix this to only write ~WATCHDOG_BIT to the register, which means
    we write as zero only the watchdog bit.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fa142ff5b3f67fab01f3d02a501b041b4266afdd
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Tue Jun 18 17:19:32 2013 +0100

    Watchdog: allow orion_wdt to be built for Dove
    
    The watchdog infrastructure in Dove is no different from that in
    Orion5x or Kirkwood, so let's enable it for Dove.  The only things
    missing are a few register settings in Dove's bridge-regs.h.
    
    Rather than duplicating the same register bit masks for the RSTOUTn_MASK
    and BRIDGE_CAUSE registers, move the definitions into the watchdog
    driver itself.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 938d0a840d0f97b627111fd038a735f3924fd987
Author: Lubomir Rintel <lkundrak@v3.sk>
Date:   Tue Jun 18 19:44:48 2013 +0200

    watchdog: Add Broadcom BCM2835 watchdog timer driver
    
    This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
    used in Raspberry Pi and Roku 2 devices.
    
    Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
    Tested-by: Stephen Warren <swarren@wwwdotorg.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-rpi-kernel@lists.infradead.org
    Cc: linux-watchdog@vger.kernel.org
    Cc: devicetree-discuss@lists.ozlabs.org

commit 6e63a3a294fdf91eaaac1061a9c7a5f53d16ac25
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Jun 19 20:38:58 2013 +0530

    watchdog: delete mpcore_wdt driver
    
    Interrupt request doesn't use the right API: The TWD watchdog uses a per-cpu
    interrupt (usually interrupt #30), and the GIC configuration should flag it as
    such. With this setup, request_irq() should fail, and the right API is
    request_percpu_irq(), together with enable_percpu_irq()/disable_percpu_irq().
    
    Nothing ensures the userspace ioctl() will end-up kicking the watchdog on the
    right CPU.
    
    There are no users of this driver since a long time and it makes more sense to
    get rid of it as nobody is looking to fix it.
    
    In case somebody wakes up after this has been removed and needs it, please
    revert this driver and pick these updates (These were never pushed to mainline):
    
    http://comments.gmane.org/gmane.linux.ports.arm.kernel/245998
    
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8fce9b367d672332d2d101175b10737ee5c18b59
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Fri May 31 07:56:34 2013 +0200

    watchdog: xilinx: Setup the origin compatible string
    
    Watchdog 1.01.a is also compatible with 1.00.a.
    Add the origin version to compatible list.
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9419c07ccebf6080159b4440dab9b3e484c96d7a
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Fri May 31 07:56:33 2013 +0200

    watchdog: xilinx: Fix driver header
    
    - Remove reference for IP version
    - Fix header coding style
    - Remove notes which are visible from the code
    - Fix driver license according to header
    
    Signed-off-by: Michal Simek <michal.simek@xilinx.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 48388069bd6736065ed5143cb42d22a16b1744a5
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Tue May 28 12:25:49 2013 +0300

    watchdog: wdrtas: don't use custom version of print_hex_dump
    
    Kernel has nice helpers to dump buffers.
    
    Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit fcf95670fd29359a382e0755e573b36076d6283e
Author: Hector Palacios <hector.palacios@digi.com>
Date:   Mon Apr 8 17:06:32 2013 +0200

    watchdog: core: don't try to stop device if not running
    
    A watchdog device may be stopped from userspace using WDIOC_SETOPTIONS
    ioctl and flag WDIOS_DISABLECARD. If the device is closed after this
    operation, watchdog_release() is called and status bits checked for
    stopping it. Besides, if the device has not been unregistered a critical
    message "watchdog did not stop!" is printed, although the ioctl may have
    successfully stopped it already.
    
    Without the patch a user application sample code like this will successfully
    stop the watchdog, but the kernel will output the message
    "watchdog did not stop!":
    
    	wd_fd = open("/dev/watchdog", O_RDWR);
    
    	flags = WDIOS_DISABLECARD;
    	ioctl(wd_fd, WDIOC_SETOPTIONS, &flags);
    
    	close(wd_fd);
    
    Signed-off-by: Hector Palacios <hector.palacios@digi.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5f314970b25a6960dd056b0038ffc7b88dc2973e
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Sun May 12 20:04:03 2013 +0200

    watchdog: jz4740: Pass device to clk_get
    
    In preparation to switching the jz4740 clk driver to the common clk framework
    make sure to pass the device to clk_get().
    
    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6638f4e5e5114fcb0c9dcec05cb3e33454f4a9ac
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Sat May 4 01:41:18 2013 +0530

    watchdog: twl4030: Remove redundant platform_set_drvdata()
    
    Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
    driver is bound) removes the need to set driver data field to
    NULL.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Cc: Timo Kokkonen <timo.t.kokkonen@nokia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6697dbd27b6507c11815725ab31473ba74c49f06
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Sat May 4 01:41:15 2013 +0530

    watchdog: mpcore: Remove redundant platform_set_drvdata()
    
    Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
    driver is bound) removes the need to set driver data field to
    NULL.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 76692c944cd8e85d833dc30d7346463e18b6d30e
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 23 19:44:23 2013 +0900

    watchdog: da9055: use platform_{get,set}_drvdata()
    
    Use the wrapper functions for getting and setting the driver data using
    platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
    so we can directly pass a struct platform_device.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 552a96415ff297475c20a05d384398ef1c729794
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 23 19:44:09 2013 +0900

    watchdog: da9052: use platform_{get,set}_drvdata()
    
    Use the wrapper functions for getting and setting the driver data using
    platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
    so we can directly pass a struct platform_device.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 26556b6e0bf044622a5d3dcade0ac6657b23c2a7
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 23 19:43:43 2013 +0900

    watchdog: cpwd: use platform_{get,set}_drvdata()
    
    Use the wrapper functions for getting and setting the driver data using
    platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
    so we can directly pass a struct platform_device.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0183984c61fdd298dde717ff1c5c2f6ce2ef3f73
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Mar 14 10:31:21 2013 +0900

    watchdog: s3c2410_wdt: convert s3c2410wdt to dev_pm_ops
    
    Instead of using legacy suspend/resume methods, using newer
    dev_pm_ops structure allows better control over power management.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3828924af2e24a615b302fe1da69527d58474cdc
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu Mar 14 10:30:21 2013 +0900

    watchdog: s3c2410_wdt: use dev_err()/dev_info() instead of pr_err()/pr_info()
    
    dev_err()/dev_info() are more preferred than pr_err()/pr_info().
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1ae995dca9da3a5671aa471e1c355e47437a1056
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 23 19:44:53 2013 +0900

    watchdog: wm831x: use platform_{get,set}_drvdata()
    
    Use the wrapper functions for getting and setting the driver data using
    platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
    so we can directly pass a struct platform_device.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7a5da030c6ecdd6229f079902a17e641c7f2fbd6
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:31:20 2013 +0900

    watchdog: wm831x_wdt: use devm_gpio_request_one()
    
    Use devm_gpio_request_one() to make cleanup paths simpler.
    Also, GPIOF_DIR_OUT | GPIOF_INIT_LOW is replaced with
    GPIOF_OUT_INIT_LOW.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d3a33a9500f262a40fcf3a9b9b9c3e03890b14dd
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:30:43 2013 +0900

    watchdog: mtx1-wdt: use devm_gpio_request_one()
    
    Use devm_gpio_request_one() to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 07bf971a38427e2659603468e5947c39754edb13
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:16:49 2013 +0900

    watchdog: sp805_wdt: use devm_clk_get()
    
    Use devm_clk_get() to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4d2327ca9d44dbf5b4ead443f380ad58baa8c201
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Sat May 4 01:41:16 2013 +0530

    watchdog: shwdt: Remove redundant platform_set_drvdata()
    
    Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
    driver is bound) removes the need to set driver data field to
    NULL.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2f7b9b4883f4d67821bbd80f8fdfb8630d24cc60
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:16:33 2013 +0900

    watchdog: shwdt: use devm_clk_get()
    
    Use devm_clk_get() to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 259181feb003e3244d4ba15256735ca259be217a
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:16:14 2013 +0900

    watchdog: pnx4008_wdt: use devm_clk_get()
    
    Use devm_clk_get() to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bdf495742716211259dba644e0950129db6f2641
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:15:53 2013 +0900

    watchdog: imx2_wdt: use devm_clk_get()
    
    Use devm_clk_get() to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0b9302619963e46931c64693fd24d467c39bbb4c
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue May 14 12:11:03 2013 +0530

    watchdog: dw_wdt: Staticize local symbol
    
    'dw_wdt_write' is used only in this file. Make it static.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit cf3cc8c252cbd8d50ed61ef5e176bc577f38cf71
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Apr 29 18:15:26 2013 +0900

    watchdog: dw_wdt: use devm_clk_get()
    
    Use devm_clk_get() to make cleanup paths more simple.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9d8a7f16f47fca776b60ab63901dc8481ceb6e1f
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 2 14:52:16 2013 +0900

    watchdog: ts72xx_wdt: use devm_*() functions
    
    Use devm_*() functions to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b94828ffb2261a9803948ccd74f2b75105b1bf87
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Thu May 23 19:44:38 2013 +0900

    watchdog: riowd: use platform_{get,set}_drvdata()
    
    Use the wrapper functions for getting and setting the driver data using
    platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
    so we can directly pass a struct platform_device.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a508e2e634f9ea462c3beb56e12aa50ba9e8b0a9
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 14:01:59 2013 +0900

    watchdog: riowd: use devm_kzalloc()
    
    Use devm_kzalloc() to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 52ccc5aca4c9cf35974c1ea3b53fc43044b29361
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 14:01:41 2013 +0900

    watchdog: rc32434_wdt: use devm_ioremap_nocache() functions
    
    Use devm_ioremap_nocache() functions to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3666eb028827c3a9df942cbc0a16388898c5a686
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 14:01:25 2013 +0900

    watchdog: nuc900_wdt: use devm_*() functions
    
    Use devm_*() functions to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ac1bb694c05302a0552c5a34ba701f246004bc03
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 14:00:49 2013 +0900

    watchdog: mv64x60_wdt: use devm_ioremap()
    
    Use devm_ioremap() to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 626d65aa5255fdd98e62f74cf43d3166e9832fb2
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 14:00:33 2013 +0900

    watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
    
    Use devm_ioremap_nocache() to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 321e31231d781aa91e94e8e3974db1edb428b6a4
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Sat May 4 01:41:14 2013 +0530

    watchdog: at32ap700x: Remove redundant platform_set_drvdata()
    
    Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
    driver is bound) removes the need to set driver data field to
    NULL.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a7960784e9ddd526e4fb791bc23e4fe6f039c28e
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Tue Apr 30 13:59:48 2013 +0900

    watchdog: at32ap700x_wdt: use devm_*() functions
    
    Use devm_*() functions to make cleanup paths simpler.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt b/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
new file mode 100644
index 0000000..370dee3
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
@@ -0,0 +1,25 @@
+Bindings for MEN A21 Watchdog device connected to GPIO lines
+
+Required properties:
+- compatible: "men,a021-wdt"
+- gpios: Specifies the pins that control the Watchdog, order:
+  1: Watchdog enable
+  2: Watchdog fast-mode
+  3: Watchdog trigger
+  4: Watchdog reset cause bit 0
+  5: Watchdog reset cause bit 1
+  6: Watchdog reset cause bit 2
+
+Optional properties:
+- None
+
+Example:
+	watchdog {
+		compatible ="men,a021-wdt";
+		gpios = <&gpio3 9  1	/* WD_EN */
+			 &gpio3 10 1	/* WD_FAST */
+			 &gpio3 11 1	/* WD_TRIG */
+			 &gpio3 6  1	/* RST_CAUSE[0] */
+			 &gpio3 7  1	/* RST_CAUSE[1] */
+			 &gpio3 8  1>;	/* RST_CAUSE[2] */
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
index d209366..f801d71 100644
--- a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
+++ b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
@@ -5,9 +5,14 @@ Required properties:
 - compatible : should be "brcm,bcm2835-pm-wdt"
 - reg : Specifies base physical address and size of the registers.
 
+Optional properties:
+
+- timeout-sec   : Contains the watchdog timeout in seconds
+
 Example:
 
 watchdog {
 	compatible = "brcm,bcm2835-pm-wdt";
 	reg = <0x7e100000 0x28>;
+	timeout-sec = <10>;
 };
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 04fddba..f9492fe 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -194,14 +194,6 @@ reset: Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
 -------------------------------------------------
-mpcore_wdt:
-mpcore_margin: MPcore timer margin in seconds.
-	(0 < mpcore_margin < 65536, default=60)
-nowayout: Watchdog cannot be stopped once started
-	(default=kernel config parameter)
-mpcore_noboot: MPcore watchdog action, set to 1 to ignore reboots,
-	0 to reboot (default=0
--------------------------------------------------
 mv64x60_wdt:
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
diff --git a/MAINTAINERS b/MAINTAINERS
index cbd4f66..c66b165 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5394,6 +5394,12 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
+MEN A21 WATCHDOG DRIVER
+M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+L:	linux-watchdog@vger.kernel.org
+S:	Supported
+F:	drivers/watchdog/mena21_wdt.c
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 S:	Supported
diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 1fdb826..82eaa55 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -61,7 +61,6 @@ CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_PL061=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
-CONFIG_MPCORE_WATCHDOG=y
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
 # CONFIG_USB_DEVICE_CLASS is not set
diff --git a/arch/arm/mach-dove/include/mach/bridge-regs.h b/arch/arm/mach-dove/include/mach/bridge-regs.h
index 99f259e..5362df3 100644
--- a/arch/arm/mach-dove/include/mach/bridge-regs.h
+++ b/arch/arm/mach-dove/include/mach/bridge-regs.h
@@ -26,6 +26,7 @@
 #define SYSTEM_SOFT_RESET	(BRIDGE_VIRT_BASE + 0x010c)
 #define  SOFT_RESET		0x00000001
 
+#define BRIDGE_CAUSE		(BRIDGE_VIRT_BASE + 0x0110)
 #define  BRIDGE_INT_TIMER1_CLR	(~0x0004)
 
 #define IRQ_VIRT_BASE		(BRIDGE_VIRT_BASE + 0x0200)
diff --git a/arch/arm/mach-kirkwood/include/mach/bridge-regs.h b/arch/arm/mach-kirkwood/include/mach/bridge-regs.h
index d4cbe5e..91242c9 100644
--- a/arch/arm/mach-kirkwood/include/mach/bridge-regs.h
+++ b/arch/arm/mach-kirkwood/include/mach/bridge-regs.h
@@ -21,14 +21,12 @@
 #define CPU_RESET		0x00000002
 
 #define RSTOUTn_MASK		(BRIDGE_VIRT_BASE + 0x0108)
-#define WDT_RESET_OUT_EN	0x00000002
 #define SOFT_RESET_OUT_EN	0x00000004
 
 #define SYSTEM_SOFT_RESET	(BRIDGE_VIRT_BASE + 0x010c)
 #define SOFT_RESET		0x00000001
 
 #define BRIDGE_CAUSE		(BRIDGE_VIRT_BASE + 0x0110)
-#define WDT_INT_REQ		0x0008
 
 #define BRIDGE_INT_TIMER1_CLR	(~0x0004)
 
diff --git a/arch/arm/mach-orion5x/include/mach/bridge-regs.h b/arch/arm/mach-orion5x/include/mach/bridge-regs.h
index 461fd69..f727d03 100644
--- a/arch/arm/mach-orion5x/include/mach/bridge-regs.h
+++ b/arch/arm/mach-orion5x/include/mach/bridge-regs.h
@@ -18,7 +18,6 @@
 #define CPU_CTRL		(ORION5X_BRIDGE_VIRT_BASE + 0x104)
 
 #define RSTOUTn_MASK		(ORION5X_BRIDGE_VIRT_BASE + 0x108)
-#define WDT_RESET_OUT_EN	0x0002
 
 #define CPU_SOFT_RESET		(ORION5X_BRIDGE_VIRT_BASE + 0x10c)
 
@@ -26,8 +25,6 @@
 
 #define POWER_MNG_CTRL_REG	(ORION5X_BRIDGE_VIRT_BASE + 0x11C)
 
-#define WDT_INT_REQ		0x0008
-
 #define BRIDGE_INT_TIMER1_CLR	(~0x0004)
 
 #define MAIN_IRQ_CAUSE		(ORION5X_BRIDGE_VIRT_BASE + 0x200)
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 7460d34..8519bc6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -221,15 +221,6 @@ config DW_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called dw_wdt.
 
-config MPCORE_WATCHDOG
-	tristate "MPcore watchdog"
-	depends on HAVE_ARM_TWD
-	help
-	  Watchdog timer embedded into the MPcore system.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mpcore_wdt.
-
 config EP93XX_WATCHDOG
 	tristate "EP93xx Watchdog"
 	depends on ARCH_EP93XX
@@ -291,7 +282,7 @@ config DAVINCI_WATCHDOG
 
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
-	depends on ARCH_ORION5X || ARCH_KIRKWOOD
+	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE
 	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
@@ -1109,6 +1100,17 @@ config BCM63XX_WDT
 	  To compile this driver as a loadable module, choose M here.
 	  The module will be called bcm63xx_wdt.
 
+config BCM2835_WDT
+	tristate "Broadcom BCM2835 hardware watchdog"
+	depends on ARCH_BCM2835
+	select WATCHDOG_CORE
+	help
+	  Watchdog driver for the built in watchdog hardware in Broadcom
+	  BCM2835 SoC.
+
+	  To compile this driver as a loadable module, choose M here.
+	  The module will be called bcm2835_wdt.
+
 config LANTIQ_WDT
 	tristate "Lantiq SoC watchdog"
 	depends on LANTIQ
@@ -1183,6 +1185,18 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
 
 	  The value can be overridden by the wdt_period command-line parameter.
 
+config MEN_A21_WDT
+       tristate "MEN A21 VME CPU Carrier Board Watchdog Timer"
+       select WATCHDOG_CORE
+       depends on GPIOLIB
+       help
+        Watchdog driver for MEN A21 VMEbus CPU Carrier Boards.
+
+	The driver can also be built as a module. If so, the module will be
+	called mena21_wdt.
+
+	If unsure select N here.
+
 # PPC64 Architecture
 
 config WATCHDOG_RTAS
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ec26899..2f26a0b 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
 obj-$(CONFIG_SA1100_WATCHDOG) += sa1100_wdt.o
 obj-$(CONFIG_DW_WATCHDOG) += dw_wdt.o
-obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
@@ -54,6 +53,7 @@ obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
 obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
 obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
+obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -144,6 +144,7 @@ obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
+obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
 
 # PPC64 Architecture
 obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 7a715e3..b178e71 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -321,13 +321,14 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
+			GFP_KERNEL);
 	if (!wdt) {
 		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
 		return -ENOMEM;
 	}
 
-	wdt->regs = ioremap(regs->start, resource_size(regs));
+	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!wdt->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
@@ -342,7 +343,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "CPU must be reset with external "
 				"reset or POR due to silicon errata.\n");
 		ret = -EIO;
-		goto err_iounmap;
+		goto err_free;
 	} else {
 		wdt->users = 0;
 	}
@@ -364,7 +365,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 	ret = misc_register(&wdt->miscdev);
 	if (ret) {
 		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
-		goto err_register;
+		goto err_free;
 	}
 
 	dev_info(&pdev->dev,
@@ -373,12 +374,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_register:
-	platform_set_drvdata(pdev, NULL);
-err_iounmap:
-	iounmap(wdt->regs);
 err_free:
-	kfree(wdt);
 	wdt = NULL;
 	return ret;
 }
@@ -391,10 +387,7 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 			at32_wdt_stop();
 
 		misc_deregister(&wdt->miscdev);
-		iounmap(wdt->regs);
-		kfree(wdt);
 		wdt = NULL;
-		platform_set_drvdata(pdev, NULL);
 	}
 	return 0;
 }
diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
new file mode 100644
index 0000000..61566fc
--- /dev/null
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -0,0 +1,189 @@
+/*
+ * Watchdog driver for Broadcom BCM2835
+ *
+ * "bcm2708_wdog" driver written by Luke Diamand that was obtained from
+ * branch "rpi-3.6.y" of git://github.com/raspberrypi/linux.git was used
+ * as a hardware reference for the Broadcom BCM2835 watchdog timer.
+ *
+ * Copyright (C) 2013 Lubomir Rintel <lkundrak@v3.sk>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/of_address.h>
+#include <linux/miscdevice.h>
+
+#define PM_RSTC				0x1c
+#define PM_WDOG				0x24
+
+#define PM_PASSWORD			0x5a000000
+
+#define PM_WDOG_TIME_SET		0x000fffff
+#define PM_RSTC_WRCFG_CLR		0xffffffcf
+#define PM_RSTC_WRCFG_SET		0x00000030
+#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
+#define PM_RSTC_RESET			0x00000102
+
+#define SECS_TO_WDOG_TICKS(x) ((x) << 16)
+#define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
+
+struct bcm2835_wdt {
+	void __iomem		*base;
+	spinlock_t		lock;
+};
+
+static unsigned int heartbeat;
+static bool nowayout = WATCHDOG_NOWAYOUT;
+
+static int bcm2835_wdt_start(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t cur;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	writel_relaxed(PM_PASSWORD | (SECS_TO_WDOG_TICKS(wdog->timeout) &
+				PM_WDOG_TIME_SET), wdt->base + PM_WDOG);
+	cur = readl_relaxed(wdt->base + PM_RSTC);
+	writel_relaxed(PM_PASSWORD | (cur & PM_RSTC_WRCFG_CLR) |
+		  PM_RSTC_WRCFG_FULL_RESET, wdt->base + PM_RSTC);
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	return 0;
+}
+
+static int bcm2835_wdt_stop(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	writel_relaxed(PM_PASSWORD | PM_RSTC_RESET, wdt->base + PM_RSTC);
+	dev_info(wdog->dev, "Watchdog timer stopped");
+	return 0;
+}
+
+static int bcm2835_wdt_set_timeout(struct watchdog_device *wdog, unsigned int t)
+{
+	wdog->timeout = t;
+	return 0;
+}
+
+static unsigned int bcm2835_wdt_get_timeleft(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	uint32_t ret = readl_relaxed(wdt->base + PM_WDOG);
+	return WDOG_TICKS_TO_SECS(ret & PM_WDOG_TIME_SET);
+}
+
+static struct watchdog_ops bcm2835_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	bcm2835_wdt_start,
+	.stop =		bcm2835_wdt_stop,
+	.set_timeout =	bcm2835_wdt_set_timeout,
+	.get_timeleft =	bcm2835_wdt_get_timeleft,
+};
+
+static struct watchdog_info bcm2835_wdt_info = {
+	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+	.identity =	"Broadcom BCM2835 Watchdog timer",
+};
+
+static struct watchdog_device bcm2835_wdt_wdd = {
+	.info =		&bcm2835_wdt_info,
+	.ops =		&bcm2835_wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+	.timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+};
+
+static int bcm2835_wdt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct bcm2835_wdt *wdt;
+	int err;
+
+	wdt = devm_kzalloc(dev, sizeof(struct bcm2835_wdt), GFP_KERNEL);
+	if (!wdt) {
+		dev_err(dev, "Failed to allocate memory for watchdog device");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, wdt);
+
+	spin_lock_init(&wdt->lock);
+
+	wdt->base = of_iomap(np, 0);
+	if (!wdt->base) {
+		dev_err(dev, "Failed to remap watchdog regs");
+		return -ENODEV;
+	}
+
+	watchdog_set_drvdata(&bcm2835_wdt_wdd, wdt);
+	watchdog_init_timeout(&bcm2835_wdt_wdd, heartbeat, dev);
+	watchdog_set_nowayout(&bcm2835_wdt_wdd, nowayout);
+	err = watchdog_register_device(&bcm2835_wdt_wdd);
+	if (err) {
+		dev_err(dev, "Failed to register watchdog device");
+		iounmap(wdt->base);
+		return err;
+	}
+
+	dev_info(dev, "Broadcom BCM2835 watchdog timer");
+	return 0;
+}
+
+static int bcm2835_wdt_remove(struct platform_device *pdev)
+{
+	struct bcm2835_wdt *wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&bcm2835_wdt_wdd);
+	iounmap(wdt->base);
+
+	return 0;
+}
+
+static void bcm2835_wdt_shutdown(struct platform_device *pdev)
+{
+	bcm2835_wdt_stop(&bcm2835_wdt_wdd);
+}
+
+static const struct of_device_id bcm2835_wdt_of_match[] = {
+	{ .compatible = "brcm,bcm2835-pm-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm2835_wdt_of_match);
+
+static struct platform_driver bcm2835_wdt_driver = {
+	.probe		= bcm2835_wdt_probe,
+	.remove		= bcm2835_wdt_remove,
+	.shutdown	= bcm2835_wdt_shutdown,
+	.driver = {
+		.name =		"bcm2835-wdt",
+		.owner =	THIS_MODULE,
+		.of_match_table = bcm2835_wdt_of_match,
+	},
+};
+module_platform_driver(bcm2835_wdt_driver);
+
+module_param(heartbeat, uint, 0);
+MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
+MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index b2b80d4..a14a58d 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -249,7 +250,8 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, resource_size(r));
+	bcm63xx_wdt_device.regs = devm_ioremap_nocache(&pdev->dev, r->start,
+							resource_size(r));
 	if (!bcm63xx_wdt_device.regs) {
 		dev_err(&pdev->dev, "failed to remap I/O resources\n");
 		return -ENXIO;
@@ -258,7 +260,7 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 	ret = bcm63xx_timer_register(TIMER_WDT_ID, bcm63xx_wdt_isr, NULL);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register wdt timer isr\n");
-		goto unmap;
+		return ret;
 	}
 
 	if (bcm63xx_wdt_settimeout(wdt_time)) {
@@ -281,8 +283,6 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 
 unregister_timer:
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-unmap:
-	iounmap(bcm63xx_wdt_device.regs);
 	return ret;
 }
 
@@ -293,7 +293,6 @@ static int bcm63xx_wdt_remove(struct platform_device *pdev)
 
 	misc_deregister(&bcm63xx_wdt_miscdev);
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-	iounmap(bcm63xx_wdt_device.regs);
 	return 0;
 }
 
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 7038758..213225e 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -621,7 +621,7 @@ static int cpwd_probe(struct platform_device *op)
 			WD_BADMODEL);
 	}
 
-	dev_set_drvdata(&op->dev, p);
+	platform_set_drvdata(op, p);
 	cpwd_device = p;
 	err = 0;
 
@@ -642,7 +642,7 @@ out_free:
 
 static int cpwd_remove(struct platform_device *op)
 {
-	struct cpwd *p = dev_get_drvdata(&op->dev);
+	struct cpwd *p = platform_get_drvdata(op);
 	int i;
 
 	for (i = 0; i < WD_NUMDEVS; i++) {
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index 3674450..f09c54e 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -215,14 +215,14 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 err:
 	return ret;
 }
 
 static int da9052_wdt_remove(struct platform_device *pdev)
 {
-	struct da9052_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+	struct da9052_wdt_data *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 	kref_put(&driver_data->kref, da9052_wdt_release_resources);
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
index f5ad105..575f37a 100644
--- a/drivers/watchdog/da9055_wdt.c
+++ b/drivers/watchdog/da9055_wdt.c
@@ -174,7 +174,7 @@ static int da9055_wdt_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 
 	ret = watchdog_register_device(&driver_data->wdt);
 	if (ret != 0)
@@ -187,7 +187,7 @@ err:
 
 static int da9055_wdt_remove(struct platform_device *pdev)
 {
-	struct da9055_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+	struct da9055_wdt_data *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 	kref_put(&driver_data->kref, da9055_wdt_release_resources);
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 2037669..e621098 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -154,8 +154,8 @@ static int dw_wdt_open(struct inode *inode, struct file *filp)
 	return nonseekable_open(inode, filp);
 }
 
-ssize_t dw_wdt_write(struct file *filp, const char __user *buf, size_t len,
-		     loff_t *offset)
+static ssize_t dw_wdt_write(struct file *filp, const char __user *buf,
+			    size_t len, loff_t *offset)
 {
 	if (!len)
 		return 0;
@@ -305,13 +305,13 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	if (IS_ERR(dw_wdt.regs))
 		return PTR_ERR(dw_wdt.regs);
 
-	dw_wdt.clk = clk_get(&pdev->dev, NULL);
+	dw_wdt.clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dw_wdt.clk))
 		return PTR_ERR(dw_wdt.clk);
 
 	ret = clk_enable(dw_wdt.clk);
 	if (ret)
-		goto out_put_clk;
+		return ret;
 
 	spin_lock_init(&dw_wdt.lock);
 
@@ -327,8 +327,6 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 
 out_disable_clk:
 	clk_disable(dw_wdt.clk);
-out_put_clk:
-	clk_put(dw_wdt.clk);
 
 	return ret;
 }
@@ -338,7 +336,6 @@ static int dw_wdt_drv_remove(struct platform_device *pdev)
 	misc_deregister(&dw_wdt_miscdev);
 
 	clk_disable(dw_wdt.clk);
-	clk_put(dw_wdt.clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 11796b9..de7e4f4 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,7 +39,7 @@
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
 
-#define HPWDT_VERSION			"1.3.1"
+#define HPWDT_VERSION			"1.3.2"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
 #define TICKS_TO_SECS(ticks)		((ticks) * 128 / 1000)
 #define HPWDT_MAX_TIMER			TICKS_TO_SECS(65535)
@@ -148,6 +148,7 @@ struct cmn_registers {
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump = 1;
 static unsigned int is_icru;
+static unsigned int is_uefi;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
 static struct cmn_registers cmn_regs;
@@ -484,7 +485,7 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 		goto out;
 
 	spin_lock_irqsave(&rom_lock, rom_pl);
-	if (!die_nmi_called && !is_icru)
+	if (!die_nmi_called && !is_icru && !is_uefi)
 		asminline_call(&cmn_regs, cru_rom_addr);
 	die_nmi_called = 1;
 	spin_unlock_irqrestore(&rom_lock, rom_pl);
@@ -492,7 +493,7 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 	if (allow_kdump)
 		hpwdt_stop();
 
-	if (!is_icru) {
+	if (!is_icru && !is_uefi) {
 		if (cmn_regs.u1.ral == 0) {
 			panic("An NMI occurred, "
 				"but unable to determine source.\n");
@@ -679,6 +680,8 @@ static void dmi_find_icru(const struct dmi_header *dm, void *dummy)
 		smbios_proliant_ptr = (struct smbios_proliant_info *) dm;
 		if (smbios_proliant_ptr->misc_features & 0x01)
 			is_icru = 1;
+		if (smbios_proliant_ptr->misc_features & 0x408)
+			is_uefi = 1;
 	}
 }
 
@@ -697,7 +700,7 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * the old cru detect code.
 	 */
 	dmi_walk(dmi_find_icru, NULL);
-	if (!is_icru) {
+	if (!is_icru && !is_uefi) {
 
 		/*
 		* We need to map the ROM to get the CRU service.
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 62946c2..693ac3f 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -261,7 +261,7 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(imx2_wdt.base))
 		return PTR_ERR(imx2_wdt.base);
 
-	imx2_wdt.clk = clk_get(&pdev->dev, NULL);
+	imx2_wdt.clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imx2_wdt.clk)) {
 		dev_err(&pdev->dev, "can't get Watchdog clock\n");
 		return PTR_ERR(imx2_wdt.clk);
@@ -286,7 +286,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 
 fail:
 	imx2_wdt_miscdev.parent = NULL;
-	clk_put(imx2_wdt.clk);
 	return ret;
 }
 
@@ -299,8 +298,7 @@ static int __exit imx2_wdt_remove(struct platform_device *pdev)
 
 		dev_crit(imx2_wdt_miscdev.parent,
 			"Device removed: Expect reboot!\n");
-	} else
-		clk_put(imx2_wdt.clk);
+	}
 
 	imx2_wdt_miscdev.parent = NULL;
 	return 0;
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 1cb25f6..d1afdf6 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -177,7 +177,7 @@ static int jz4740_wdt_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	drvdata->rtc_clk = clk_get(NULL, "rtc");
+	drvdata->rtc_clk = clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(drvdata->rtc_clk)) {
 		dev_err(&pdev->dev, "cannot find RTC clock\n");
 		ret = PTR_ERR(drvdata->rtc_clk);
diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
new file mode 100644
index 0000000..96dbba9
--- /dev/null
+++ b/drivers/watchdog/mena21_wdt.c
@@ -0,0 +1,270 @@
+/*
+ * Watchdog driver for the A21 VME CPU Boards
+ *
+ * Copyright (C) 2013 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/delay.h>
+#include <linux/bitops.h>
+
+#define NUM_GPIOS 6
+
+enum a21_wdt_gpios {
+	GPIO_WD_ENAB,
+	GPIO_WD_FAST,
+	GPIO_WD_TRIG,
+	GPIO_WD_RST0,
+	GPIO_WD_RST1,
+	GPIO_WD_RST2,
+};
+
+struct a21_wdt_drv {
+	struct watchdog_device wdt;
+	struct mutex lock;
+	unsigned gpios[NUM_GPIOS];
+};
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static unsigned int a21_wdt_get_bootstatus(struct a21_wdt_drv *drv)
+{
+	int reset = 0;
+
+	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST0]) ? (1 << 0) : 0;
+	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST1]) ? (1 << 1) : 0;
+	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST2]) ? (1 << 2) : 0;
+
+	return reset;
+}
+
+static int a21_wdt_start(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 1);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_stop(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 0);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_ping(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(drv->gpios[GPIO_WD_TRIG], 0);
+	ndelay(10);
+	gpio_set_value(drv->gpios[GPIO_WD_TRIG], 1);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_set_timeout(struct watchdog_device *wdt,
+			       unsigned int timeout)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	if (timeout != 1 && timeout != 30) {
+		dev_err(wdt->dev, "Only 1 and 30 allowed as timeout\n");
+		return -EINVAL;
+	}
+
+	if (timeout == 30 && wdt->timeout == 1) {
+		dev_err(wdt->dev,
+			"Transition from fast to slow mode not allowed\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&drv->lock);
+
+	if (timeout == 1)
+		gpio_set_value(drv->gpios[GPIO_WD_FAST], 1);
+	else
+		gpio_set_value(drv->gpios[GPIO_WD_FAST], 0);
+
+	wdt->timeout = timeout;
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static const struct watchdog_info a21_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "MEN A21 Watchdog",
+};
+
+static const struct watchdog_ops a21_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = a21_wdt_start,
+	.stop = a21_wdt_stop,
+	.ping = a21_wdt_ping,
+	.set_timeout = a21_wdt_set_timeout,
+};
+
+static struct watchdog_device a21_wdt = {
+	.info = &a21_wdt_info,
+	.ops = &a21_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = 30,
+};
+
+static int a21_wdt_probe(struct platform_device *pdev)
+{
+	struct device_node *node;
+	struct a21_wdt_drv *drv;
+	unsigned int reset = 0;
+	int num_gpios;
+	int ret;
+	int i;
+
+	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
+	if (!drv)
+		return -ENOMEM;
+
+	/* Fill GPIO pin array */
+	node = pdev->dev.of_node;
+
+	num_gpios = of_gpio_count(node);
+	if (num_gpios != NUM_GPIOS) {
+		dev_err(&pdev->dev, "gpios DT property wrong, got %d want %d",
+			num_gpios, NUM_GPIOS);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < num_gpios; i++) {
+		int val;
+
+		val = of_get_gpio(node, i);
+		if (val < 0)
+			return val;
+
+		drv->gpios[i] = val;
+	}
+
+	/* Request the used GPIOs */
+	for (i = 0; i < num_gpios; i++) {
+		ret = devm_gpio_request(&pdev->dev, drv->gpios[i],
+					"MEN A21 Watchdog");
+		if (ret)
+			return ret;
+
+		if (i < GPIO_WD_RST0)
+			ret = gpio_direction_output(drv->gpios[i],
+						gpio_get_value(drv->gpios[i]));
+		else		/* GPIO_WD_RST[0..2] are inputs */
+			ret = gpio_direction_input(drv->gpios[i]);
+		if (ret)
+			return ret;
+	}
+
+	mutex_init(&drv->lock);
+	watchdog_init_timeout(&a21_wdt, 30, &pdev->dev);
+	watchdog_set_nowayout(&a21_wdt, nowayout);
+	watchdog_set_drvdata(&a21_wdt, drv);
+
+	reset = a21_wdt_get_bootstatus(drv);
+	if (reset == 2)
+		a21_wdt.bootstatus |= WDIOF_EXTERN1;
+	else if (reset == 4)
+		a21_wdt.bootstatus |= WDIOF_CARDRESET;
+	else if (reset == 5)
+		a21_wdt.bootstatus |= WDIOF_POWERUNDER;
+	else if (reset == 7)
+		a21_wdt.bootstatus |= WDIOF_EXTERN2;
+
+	ret = watchdog_register_device(&a21_wdt);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot register watchdog device\n");
+		goto err_register_wd;
+	}
+
+	dev_set_drvdata(&pdev->dev, drv);
+
+	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");
+
+	return 0;
+
+err_register_wd:
+	mutex_destroy(&drv->lock);
+
+	return ret;
+}
+
+static int a21_wdt_remove(struct platform_device *pdev)
+{
+	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
+
+	dev_warn(&pdev->dev,
+		"Unregistering A21 watchdog driver, board may reboot\n");
+
+	watchdog_unregister_device(&drv->wdt);
+
+	mutex_destroy(&drv->lock);
+
+	return 0;
+}
+
+static void a21_wdt_shutdown(struct platform_device *pdev)
+{
+	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
+
+	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 0);
+}
+
+static const struct of_device_id a21_wdt_ids[] = {
+	{ .compatible = "men,a021-wdt" },
+	{ },
+};
+
+static struct platform_driver a21_wdt_driver = {
+	.probe = a21_wdt_probe,
+	.remove = a21_wdt_remove,
+	.shutdown = a21_wdt_shutdown,
+	.driver = {
+		.name = "a21-watchdog",
+		.of_match_table = a21_wdt_ids,
+	},
+};
+
+module_platform_driver(a21_wdt_driver);
+
+MODULE_AUTHOR("MEN Mikro Elektronik");
+MODULE_DESCRIPTION("MEN A21 Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:a21-watchdog");
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
deleted file mode 100644
index 233cfad..0000000
--- a/drivers/watchdog/mpcore_wdt.c
+++ /dev/null
@@ -1,456 +0,0 @@
-/*
- *	Watchdog driver for the mpcore watchdog timer
- *
- *	(c) Copyright 2004 ARM Limited
- *
- *	Based on the SoftDog driver:
- *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
- *						All Rights Reserved.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither Alan Cox nor CymruNet Ltd. admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
- *
- *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
- *
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/fs.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-#include <linux/io.h>
-
-#include <asm/smp_twd.h>
-
-struct mpcore_wdt {
-	unsigned long	timer_alive;
-	struct device	*dev;
-	void __iomem	*base;
-	int		irq;
-	unsigned int	perturb;
-	char		expect_close;
-};
-
-static struct platform_device *mpcore_wdt_pdev;
-static DEFINE_SPINLOCK(wdt_lock);
-
-#define TIMER_MARGIN	60
-static int mpcore_margin = TIMER_MARGIN;
-module_param(mpcore_margin, int, 0);
-MODULE_PARM_DESC(mpcore_margin,
-	"MPcore timer margin in seconds. (0 < mpcore_margin < 65536, default="
-				__MODULE_STRING(TIMER_MARGIN) ")");
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-	"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-#define ONLY_TESTING	0
-static int mpcore_noboot = ONLY_TESTING;
-module_param(mpcore_noboot, int, 0);
-MODULE_PARM_DESC(mpcore_noboot, "MPcore watchdog action, "
-	"set to 1 to ignore reboots, 0 to reboot (default="
-					__MODULE_STRING(ONLY_TESTING) ")");
-
-/*
- *	This is the interrupt handler.  Note that we only use this
- *	in testing mode, so don't actually do a reboot here.
- */
-static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
-{
-	struct mpcore_wdt *wdt = arg;
-
-	/* Check it really was our interrupt */
-	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_crit(wdt->dev, "Triggered - Reboot ignored\n");
-		/* Clear the interrupt on the watchdog */
-		writel(1, wdt->base + TWD_WDOG_INTSTAT);
-		return IRQ_HANDLED;
-	}
-	return IRQ_NONE;
-}
-
-/*
- *	mpcore_wdt_keepalive - reload the timer
- *
- *	Note that the spec says a DIFFERENT value must be written to the reload
- *	register each time.  The "perturb" variable deals with this by adding 1
- *	to the count every other time the function is called.
- */
-static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
-{
-	unsigned long count;
-
-	spin_lock(&wdt_lock);
-	/* Assume prescale is set to 256 */
-	count =  __raw_readl(wdt->base + TWD_WDOG_COUNTER);
-	count = (0xFFFFFFFFU - count) * (HZ / 5);
-	count = (count / 256) * mpcore_margin;
-
-	/* Reload the counter */
-	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
-	wdt->perturb = wdt->perturb ? 0 : 1;
-	spin_unlock(&wdt_lock);
-}
-
-static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
-{
-	spin_lock(&wdt_lock);
-	writel(0x12345678, wdt->base + TWD_WDOG_DISABLE);
-	writel(0x87654321, wdt->base + TWD_WDOG_DISABLE);
-	writel(0x0, wdt->base + TWD_WDOG_CONTROL);
-	spin_unlock(&wdt_lock);
-}
-
-static void mpcore_wdt_start(struct mpcore_wdt *wdt)
-{
-	dev_info(wdt->dev, "enabling watchdog\n");
-
-	/* This loads the count register but does NOT start the count yet */
-	mpcore_wdt_keepalive(wdt);
-
-	if (mpcore_noboot) {
-		/* Enable watchdog - prescale=256, watchdog mode=0, enable=1 */
-		writel(0x0000FF01, wdt->base + TWD_WDOG_CONTROL);
-	} else {
-		/* Enable watchdog - prescale=256, watchdog mode=1, enable=1 */
-		writel(0x0000FF09, wdt->base + TWD_WDOG_CONTROL);
-	}
-}
-
-static int mpcore_wdt_set_heartbeat(int t)
-{
-	if (t < 0x0001 || t > 0xFFFF)
-		return -EINVAL;
-
-	mpcore_margin = t;
-	return 0;
-}
-
-/*
- *	/dev/watchdog handling
- */
-static int mpcore_wdt_open(struct inode *inode, struct file *file)
-{
-	struct mpcore_wdt *wdt = platform_get_drvdata(mpcore_wdt_pdev);
-
-	if (test_and_set_bit(0, &wdt->timer_alive))
-		return -EBUSY;
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	file->private_data = wdt;
-
-	/*
-	 *	Activate timer
-	 */
-	mpcore_wdt_start(wdt);
-
-	return nonseekable_open(inode, file);
-}
-
-static int mpcore_wdt_release(struct inode *inode, struct file *file)
-{
-	struct mpcore_wdt *wdt = file->private_data;
-
-	/*
-	 *	Shut off the timer.
-	 *	Lock it in if it's a module and we set nowayout
-	 */
-	if (wdt->expect_close == 42)
-		mpcore_wdt_stop(wdt);
-	else {
-		dev_crit(wdt->dev,
-			 "unexpected close, not stopping watchdog!\n");
-		mpcore_wdt_keepalive(wdt);
-	}
-	clear_bit(0, &wdt->timer_alive);
-	wdt->expect_close = 0;
-	return 0;
-}
-
-static ssize_t mpcore_wdt_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
-{
-	struct mpcore_wdt *wdt = file->private_data;
-
-	/*
-	 *	Refresh the timer.
-	 */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			wdt->expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					wdt->expect_close = 42;
-			}
-		}
-		mpcore_wdt_keepalive(wdt);
-	}
-	return len;
-}
-
-static const struct watchdog_info ident = {
-	.options		= WDIOF_SETTIMEOUT |
-				  WDIOF_KEEPALIVEPING |
-				  WDIOF_MAGICCLOSE,
-	.identity		= "MPcore Watchdog",
-};
-
-static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	struct mpcore_wdt *wdt = file->private_data;
-	int ret;
-	union {
-		struct watchdog_info ident;
-		int i;
-	} uarg;
-
-	if (_IOC_DIR(cmd) && _IOC_SIZE(cmd) > sizeof(uarg))
-		return -ENOTTY;
-
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		ret = copy_from_user(&uarg, (void __user *)arg, _IOC_SIZE(cmd));
-		if (ret)
-			return -EFAULT;
-	}
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		uarg.ident = ident;
-		ret = 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		uarg.i = 0;
-		ret = 0;
-		break;
-
-	case WDIOC_SETOPTIONS:
-		ret = -EINVAL;
-		if (uarg.i & WDIOS_DISABLECARD) {
-			mpcore_wdt_stop(wdt);
-			ret = 0;
-		}
-		if (uarg.i & WDIOS_ENABLECARD) {
-			mpcore_wdt_start(wdt);
-			ret = 0;
-		}
-		break;
-
-	case WDIOC_KEEPALIVE:
-		mpcore_wdt_keepalive(wdt);
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = mpcore_wdt_set_heartbeat(uarg.i);
-		if (ret)
-			break;
-
-		mpcore_wdt_keepalive(wdt);
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		uarg.i = mpcore_margin;
-		ret = 0;
-		break;
-
-	default:
-		return -ENOTTY;
-	}
-
-	if (ret == 0 && _IOC_DIR(cmd) & _IOC_READ) {
-		ret = copy_to_user((void __user *)arg, &uarg, _IOC_SIZE(cmd));
-		if (ret)
-			ret = -EFAULT;
-	}
-	return ret;
-}
-
-/*
- *	System shutdown handler.  Turn off the watchdog if we're
- *	restarting or halting the system.
- */
-static void mpcore_wdt_shutdown(struct platform_device *pdev)
-{
-	struct mpcore_wdt *wdt = platform_get_drvdata(pdev);
-
-	if (system_state == SYSTEM_RESTART || system_state == SYSTEM_HALT)
-		mpcore_wdt_stop(wdt);
-}
-
-/*
- *	Kernel Interfaces
- */
-static const struct file_operations mpcore_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= mpcore_wdt_write,
-	.unlocked_ioctl	= mpcore_wdt_ioctl,
-	.open		= mpcore_wdt_open,
-	.release	= mpcore_wdt_release,
-};
-
-static struct miscdevice mpcore_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &mpcore_wdt_fops,
-};
-
-static int mpcore_wdt_probe(struct platform_device *pdev)
-{
-	struct mpcore_wdt *wdt;
-	struct resource *res;
-	int ret;
-
-	/* We only accept one device, and it must have an id of -1 */
-	if (pdev->id != -1)
-		return -ENODEV;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-	wdt = devm_kzalloc(&pdev->dev, sizeof(struct mpcore_wdt), GFP_KERNEL);
-	if (!wdt)
-		return -ENOMEM;
-
-	wdt->dev = &pdev->dev;
-	wdt->irq = platform_get_irq(pdev, 0);
-	if (wdt->irq >= 0) {
-		ret = devm_request_irq(wdt->dev, wdt->irq, mpcore_wdt_fire, 0,
-				"mpcore_wdt", wdt);
-		if (ret) {
-			dev_err(wdt->dev,
-				"cannot register IRQ%d for watchdog\n",
-				wdt->irq);
-			return ret;
-		}
-	}
-
-	wdt->base = devm_ioremap(wdt->dev, res->start, resource_size(res));
-	if (!wdt->base)
-		return -ENOMEM;
-
-	mpcore_wdt_miscdev.parent = &pdev->dev;
-	ret = misc_register(&mpcore_wdt_miscdev);
-	if (ret) {
-		dev_err(wdt->dev,
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		return ret;
-	}
-
-	mpcore_wdt_stop(wdt);
-	platform_set_drvdata(pdev, wdt);
-	mpcore_wdt_pdev = pdev;
-
-	return 0;
-}
-
-static int mpcore_wdt_remove(struct platform_device *pdev)
-{
-	platform_set_drvdata(pdev, NULL);
-
-	misc_deregister(&mpcore_wdt_miscdev);
-
-	mpcore_wdt_pdev = NULL;
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int mpcore_wdt_suspend(struct platform_device *pdev, pm_message_t msg)
-{
-	struct mpcore_wdt *wdt = platform_get_drvdata(pdev);
-	mpcore_wdt_stop(wdt);		/* Turn the WDT off */
-	return 0;
-}
-
-static int mpcore_wdt_resume(struct platform_device *pdev)
-{
-	struct mpcore_wdt *wdt = platform_get_drvdata(pdev);
-	/* re-activate timer */
-	if (test_bit(0, &wdt->timer_alive))
-		mpcore_wdt_start(wdt);
-	return 0;
-}
-#else
-#define mpcore_wdt_suspend	NULL
-#define mpcore_wdt_resume	NULL
-#endif
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:mpcore_wdt");
-
-static struct platform_driver mpcore_wdt_driver = {
-	.probe		= mpcore_wdt_probe,
-	.remove		= mpcore_wdt_remove,
-	.suspend	= mpcore_wdt_suspend,
-	.resume		= mpcore_wdt_resume,
-	.shutdown	= mpcore_wdt_shutdown,
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "mpcore_wdt",
-	},
-};
-
-static int __init mpcore_wdt_init(void)
-{
-	/*
-	 * Check that the margin value is within it's range;
-	 * if not reset to the default
-	 */
-	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
-		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		pr_info("mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
-			TIMER_MARGIN);
-	}
-
-	pr_info("MPcore Watchdog Timer: 0.1. mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n",
-		mpcore_noboot, mpcore_margin, nowayout);
-
-	return platform_driver_register(&mpcore_wdt_driver);
-}
-
-static void __exit mpcore_wdt_exit(void)
-{
-	platform_driver_unregister(&mpcore_wdt_driver);
-}
-
-module_init(mpcore_wdt_init);
-module_exit(mpcore_wdt_exit);
-
-MODULE_AUTHOR("ARM Limited");
-MODULE_DESCRIPTION("MPcore Watchdog Device Driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 14dab6f..b434111 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -209,7 +209,7 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
-	ret = gpio_request_one(mtx1_wdt_device.gpio,
+	ret = devm_gpio_request_one(&pdev->dev, mtx1_wdt_device.gpio,
 				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request gpio");
@@ -241,7 +241,6 @@ static int mtx1_wdt_remove(struct platform_device *pdev)
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
 
-	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index c7fb878..e4cf980 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -276,7 +276,7 @@ static int mv64x60_wdt_probe(struct platform_device *dev)
 	if (!r)
 		return -ENODEV;
 
-	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
+	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
 
@@ -293,8 +293,6 @@ static int mv64x60_wdt_remove(struct platform_device *dev)
 
 	mv64x60_wdt_handler_disable();
 
-	iounmap(mv64x60_wdt_regs);
-
 	return 0;
 }
 
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 04c45a1..e2b6d2c 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -61,7 +61,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 struct nuc900_wdt {
-	struct resource  *res;
 	struct clk	 *wdt_clock;
 	struct platform_device *pdev;
 	void __iomem	 *wdt_base;
@@ -244,9 +243,11 @@ static struct miscdevice nuc900wdt_miscdev = {
 
 static int nuc900wdt_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	int ret = 0;
 
-	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
+	nuc900_wdt = devm_kzalloc(&pdev->dev, sizeof(*nuc900_wdt),
+				GFP_KERNEL);
 	if (!nuc900_wdt)
 		return -ENOMEM;
 
@@ -254,33 +255,20 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 
 	spin_lock_init(&nuc900_wdt->wdt_lock);
 
-	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (nuc900_wdt->res == NULL) {
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource specified\n");
-		ret = -ENOENT;
-		goto err_get;
+		return -ENOENT;
 	}
 
-	if (!request_mem_region(nuc900_wdt->res->start,
-				resource_size(nuc900_wdt->res), pdev->name)) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_get;
-	}
-
-	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-	if (nuc900_wdt->wdt_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() region\n");
-		ret = -EINVAL;
-		goto err_req;
-	}
+	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(nuc900_wdt->wdt_base))
+		return PTR_ERR(nuc900_wdt->wdt_base);
 
-	nuc900_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	nuc900_wdt->wdt_clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(nuc900_wdt->wdt_clock)) {
 		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
-		ret = PTR_ERR(nuc900_wdt->wdt_clock);
-		goto err_map;
+		return PTR_ERR(nuc900_wdt->wdt_clock);
 	}
 
 	clk_enable(nuc900_wdt->wdt_clock);
@@ -298,14 +286,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 
 err_clk:
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-err_map:
-	iounmap(nuc900_wdt->wdt_base);
-err_req:
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-err_get:
-	kfree(nuc900_wdt);
 	return ret;
 }
 
@@ -314,14 +294,6 @@ static int nuc900wdt_remove(struct platform_device *pdev)
 	misc_deregister(&nuc900wdt_miscdev);
 
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-
-	iounmap(nuc900_wdt->wdt_base);
-
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-
-	kfree(nuc900_wdt);
 
 	return 0;
 }
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 2761ddb..4dd281f 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -1,23 +1,13 @@
 /*
-*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx xps_timebase_wdt
-*
-*   (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
-*
-*       -----------------------
-*
-*   This program is free software; you can redistribute it and/or
-*   modify it under the terms of the GNU General Public License
-*   as published by the Free Software Foundation; either version
-*   2 of the License, or (at your option) any later version.
-*
-*       -----------------------
-*	30-May-2011 Alejandro Cabrera <aldaya@gmail.com>
-*		- If "xlnx,wdt-enable-once" wasn't found on device tree the
-*		  module will use CONFIG_WATCHDOG_NOWAYOUT
-*		- If the device tree parameters ("clock-frequency" and
-*		  "xlnx,wdt-interval") wasn't found the driver won't
-*		  know the wdt reset interval
-*/
+ * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
+ *
+ * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -394,6 +384,7 @@ static int xwdt_remove(struct platform_device *dev)
 
 /* Match table for of_platform binding */
 static struct of_device_id xwdt_of_match[] = {
+	{ .compatible = "xlnx,xps-timebase-wdt-1.00.a", },
 	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
 	{},
 };
@@ -413,5 +404,5 @@ module_platform_driver(xwdt_driver);
 
 MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
 MODULE_DESCRIPTION("Xilinx Watchdog driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index da57798..4ea5fcc 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -38,6 +38,9 @@
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
+#define WDT_RESET_OUT_EN	BIT(1)
+#define WDT_INT_REQ		BIT(3)
+
 static bool nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = -1;		/* module parameter (seconds) */
 static unsigned int wdt_max_duration;	/* (seconds) */
@@ -67,9 +70,7 @@ static int orion_wdt_start(struct watchdog_device *wdt_dev)
 	writel(wdt_tclk * wdt_dev->timeout, wdt_reg + WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
-	reg = readl(BRIDGE_CAUSE);
-	reg &= ~WDT_INT_REQ;
-	writel(reg, BRIDGE_CAUSE);
+	writel(~WDT_INT_REQ, BRIDGE_CAUSE);
 
 	/* Enable watchdog timer */
 	reg = readl(wdt_reg + TIMER_CTRL);
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index a3684a3..b30bd43 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -159,13 +159,13 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(wdt_base))
 		return PTR_ERR(wdt_base);
 
-	wdt_clk = clk_get(&pdev->dev, NULL);
+	wdt_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt_clk))
 		return PTR_ERR(wdt_clk);
 
 	ret = clk_enable(wdt_clk);
 	if (ret)
-		goto out;
+		return ret;
 
 	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
 			WDIOF_CARDRESET : 0;
@@ -186,8 +186,6 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 
 disable_clk:
 	clk_disable(wdt_clk);
-out:
-	clk_put(wdt_clk);
 	return ret;
 }
 
@@ -196,7 +194,6 @@ static int pnx4008_wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&pnx4008_wdd);
 
 	clk_disable(wdt_clk);
-	clk_put(wdt_clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f78bc00..9cf6bc7 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
 #include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For devm_ioremap_nocache */
 
 #include <asm/mach-rc32434/integ.h>	/* For the Watchdog registers */
 
@@ -271,7 +272,7 @@ static int rc32434_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	wdt_reg = ioremap_nocache(r->start, resource_size(r));
+	wdt_reg = devm_ioremap_nocache(&pdev->dev, r->start, resource_size(r));
 	if (!wdt_reg) {
 		pr_err("failed to remap I/O resources\n");
 		return -ENXIO;
@@ -293,23 +294,18 @@ static int rc32434_wdt_probe(struct platform_device *pdev)
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
 		pr_err("failed to register watchdog device\n");
-		goto unmap;
+		return ret;
 	}
 
 	pr_info("Watchdog Timer version " VERSION ", timer margin: %d sec\n",
 		timeout);
 
 	return 0;
-
-unmap:
-	iounmap(wdt_reg);
-	return ret;
 }
 
 static int rc32434_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&rc32434_wdt_miscdev);
-	iounmap(wdt_reg);
 	return 0;
 }
 
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 0040451..3dd8ed2 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -183,7 +183,7 @@ static int riowd_probe(struct platform_device *op)
 		goto out;
 
 	err = -ENOMEM;
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	if (!p)
 		goto out;
 
@@ -192,7 +192,7 @@ static int riowd_probe(struct platform_device *op)
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
 		pr_err("Cannot map registers\n");
-		goto out_free;
+		goto out;
 	}
 	/* Make miscdev useable right away */
 	riowd_device = p;
@@ -206,27 +206,23 @@ static int riowd_probe(struct platform_device *op)
 	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
 		riowd_timeout, p->regs);
 
-	dev_set_drvdata(&op->dev, p);
+	platform_set_drvdata(op, p);
 	return 0;
 
 out_iounmap:
 	riowd_device = NULL;
 	of_iounmap(&op->resource[0], p->regs, 2);
 
-out_free:
-	kfree(p);
-
 out:
 	return err;
 }
 
 static int riowd_remove(struct platform_device *op)
 {
-	struct riowd *p = dev_get_drvdata(&op->dev);
+	struct riowd *p = platform_get_drvdata(op);
 
 	misc_deregister(&riowd_miscdev);
 	of_iounmap(&op->resource[0], p->regs, 2);
-	kfree(p);
 
 	return 0;
 }
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 3a9f696..6a22cf5 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -358,7 +358,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	ret = s3c2410wdt_cpufreq_register();
 	if (ret < 0) {
-		pr_err("failed to register cpufreq\n");
+		dev_err(dev, "failed to register cpufreq\n");
 		goto err_clk;
 	}
 
@@ -448,12 +448,12 @@ static void s3c2410wdt_shutdown(struct platform_device *dev)
 	s3c2410wdt_stop(&s3c2410_wdd);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static unsigned long wtcon_save;
 static unsigned long wtdat_save;
 
-static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
+static int s3c2410wdt_suspend(struct device *dev)
 {
 	/* Save watchdog state, and turn it off. */
 	wtcon_save = readl(wdt_base + S3C2410_WTCON);
@@ -465,7 +465,7 @@ static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int s3c2410wdt_resume(struct platform_device *dev)
+static int s3c2410wdt_resume(struct device *dev)
 {
 	/* Restore watchdog state. */
 
@@ -473,16 +473,15 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	pr_info("watchdog %sabled\n",
+	dev_info(dev, "watchdog %sabled\n",
 		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
 }
+#endif
 
-#else
-#define s3c2410wdt_suspend NULL
-#define s3c2410wdt_resume  NULL
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(s3c2410wdt_pm_ops, s3c2410wdt_suspend,
+			s3c2410wdt_resume);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c2410_wdt_match[] = {
@@ -496,11 +495,10 @@ static struct platform_driver s3c2410wdt_driver = {
 	.probe		= s3c2410wdt_probe,
 	.remove		= s3c2410wdt_remove,
 	.shutdown	= s3c2410wdt_shutdown,
-	.suspend	= s3c2410wdt_suspend,
-	.resume		= s3c2410wdt_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "s3c2410-wdt",
+		.pm	= &s3c2410wdt_pm_ops,
 		.of_match_table	= of_match_ptr(s3c2410_wdt_match),
 	},
 };
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 6185af2..5bca794 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -241,7 +241,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 
 	wdt->dev = &pdev->dev;
 
-	wdt->clk = clk_get(&pdev->dev, NULL);
+	wdt->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt->clk)) {
 		/*
 		 * Clock framework support is optional, continue on
@@ -251,10 +251,8 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	}
 
 	wdt->base = devm_ioremap_resource(wdt->dev, res);
-	if (IS_ERR(wdt->base)) {
-		rc = PTR_ERR(wdt->base);
-		goto err;
-	}
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
 
 	watchdog_set_nowayout(&sh_wdt_dev, nowayout);
 	watchdog_set_drvdata(&sh_wdt_dev, wdt);
@@ -277,7 +275,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	rc = watchdog_register_device(&sh_wdt_dev);
 	if (unlikely(rc)) {
 		dev_err(&pdev->dev, "Can't register watchdog (err=%d)\n", rc);
-		goto err;
+		return rc;
 	}
 
 	init_timer(&wdt->timer);
@@ -292,23 +290,15 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
-
-err:
-	clk_put(wdt->clk);
-
-	return rc;
 }
 
 static int sh_wdt_remove(struct platform_device *pdev)
 {
 	struct sh_wdt *wdt = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	watchdog_unregister_device(&sh_wdt_dev);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_put(wdt->clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index fe83beb..b68b1e5 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -152,7 +152,6 @@ static struct watchdog_ops softdog_ops = {
 	.owner = THIS_MODULE,
 	.start = softdog_ping,
 	.stop = softdog_stop,
-	.ping = softdog_ping,
 	.set_timeout = softdog_set_timeout,
 };
 
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 8872642..58df98a 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -231,7 +231,7 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err;
 	}
 
-	wdt->clk = clk_get(&adev->dev, NULL);
+	wdt->clk = devm_clk_get(&adev->dev, NULL);
 	if (IS_ERR(wdt->clk)) {
 		dev_warn(&adev->dev, "Clock not found\n");
 		ret = PTR_ERR(wdt->clk);
@@ -251,15 +251,13 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret) {
 		dev_err(&adev->dev, "watchdog_register_device() failed: %d\n",
 				ret);
-		goto err_register;
+		goto err;
 	}
 	amba_set_drvdata(adev, wdt);
 
 	dev_info(&adev->dev, "registration successful\n");
 	return 0;
 
-err_register:
-	clk_put(wdt->clk);
 err:
 	dev_err(&adev->dev, "Probe Failed!!!\n");
 	return ret;
@@ -272,7 +270,6 @@ static int sp805_wdt_remove(struct amba_device *adev)
 	watchdog_unregister_device(&wdt->wdd);
 	amba_set_drvdata(adev, NULL);
 	watchdog_set_drvdata(&wdt->wdd, NULL);
-	clk_put(wdt->clk);
 
 	return 0;
 }
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index b8a9245..4da59b4 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -396,7 +396,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	struct resource *r1, *r2;
 	int error = 0;
 
-	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
 	if (!wdt) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -405,44 +405,22 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r1) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail;
+		return -ENODEV;
 	}
 
-	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
-	if (!r1) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail;
-	}
-
-	wdt->control_reg = ioremap(r1->start, resource_size(r1));
-	if (!wdt->control_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_control;
-	}
+	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
+	if (IS_ERR(wdt->control_reg))
+		return PTR_ERR(wdt->control_reg);
 
 	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!r2) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail_unmap_control;
-	}
-
-	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
-	if (!r2) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail_unmap_control;
+		return -ENODEV;
 	}
 
-	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
-	if (!wdt->feed_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_feed;
-	}
+	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
+	if (IS_ERR(wdt->feed_reg))
+		return PTR_ERR(wdt->feed_reg);
 
 	platform_set_drvdata(pdev, wdt);
 	ts72xx_wdt_pdev = pdev;
@@ -455,45 +433,20 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
-		goto fail_unmap_feed;
+		return error;
 	}
 
 	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
 
 	return 0;
-
-fail_unmap_feed:
-	platform_set_drvdata(pdev, NULL);
-	iounmap(wdt->feed_reg);
-fail_free_feed:
-	release_mem_region(r2->start, resource_size(r2));
-fail_unmap_control:
-	iounmap(wdt->control_reg);
-fail_free_control:
-	release_mem_region(r1->start, resource_size(r1));
-fail:
-	kfree(wdt);
-	return error;
 }
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
-	struct resource *res;
 	int error;
 
 	error = misc_deregister(&ts72xx_wdt_miscdev);
-	platform_set_drvdata(pdev, NULL);
-
-	iounmap(wdt->feed_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, resource_size(res));
-
-	iounmap(wdt->control_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
 
-	kfree(wdt);
 	return error;
 }
 
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index 0f03106..2d4535d 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -90,10 +90,8 @@ static int twl4030_wdt_probe(struct platform_device *pdev)
 	twl4030_wdt_stop(wdt);
 
 	ret = watchdog_register_device(wdt);
-	if (ret) {
-		platform_set_drvdata(pdev, NULL);
+	if (ret)
 		return ret;
-	}
 
 	return 0;
 }
@@ -103,7 +101,6 @@ static int twl4030_wdt_remove(struct platform_device *pdev)
 	struct watchdog_device *wdt = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(wdt);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index faf4e18..6aaefba 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -469,8 +469,10 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
 	 * watchdog_stop will fail.
 	 */
-	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+	if (!test_bit(WDOG_ACTIVE, &wdd->status))
+		err = 0;
+	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+		 !(wdd->info->options & WDIOF_MAGICCLOSE))
 		err = watchdog_stop(wdd);
 
 	/* If the watchdog was not stopped, send a keepalive ping */
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 0a77655..3045deb 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -162,31 +162,6 @@ static void wdrtas_timer_stop(void)
 }
 
 /**
- * wdrtas_log_scanned_event - logs an event we received during keepalive
- *
- * wdrtas_log_scanned_event prints a message to the log buffer dumping
- * the results of the last event-scan call
- */
-static void wdrtas_log_scanned_event(void)
-{
-	int i;
-
-	for (i = 0; i < WDRTAS_LOGBUFFER_LEN; i += 16)
-		pr_info("dumping event (line %i/%i), data = "
-			"%02x %02x %02x %02x  %02x %02x %02x %02x   "
-			"%02x %02x %02x %02x  %02x %02x %02x %02x\n",
-			(i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
-			wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
-			wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
-			wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
-			wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
-			wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
-			wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
-			wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
-			wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
-}
-
-/**
  * wdrtas_timer_keepalive - resets watchdog timer to keep system alive
  *
  * wdrtas_timer_keepalive restarts the watchdog timer by calling the
@@ -205,7 +180,9 @@ static void wdrtas_timer_keepalive(void)
 		if (result < 0)
 			pr_err("event-scan failed: %li\n", result);
 		if (result == 0)
-			wdrtas_log_scanned_event();
+			print_hex_dump(KERN_INFO, "dumping event, data: ",
+				DUMP_PREFIX_OFFSET, 16, 1,
+				wdrtas_logbuffer, WDRTAS_LOGBUFFER_LEN, false);
 	} while (result == 0);
 }
 
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 9dcb6d0..d4e47ed 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -247,9 +247,10 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
 
 		if (pdata->update_gpio) {
-			ret = gpio_request_one(pdata->update_gpio,
-					       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
-					       "Watchdog update");
+			ret = devm_gpio_request_one(&pdev->dev,
+						pdata->update_gpio,
+						GPIOF_OUT_INIT_LOW,
+						"Watchdog update");
 			if (ret < 0) {
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
@@ -270,7 +271,7 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		} else {
 			dev_err(wm831x->dev,
 				"Failed to unlock security key: %d\n", ret);
-			goto err_gpio;
+			goto err;
 		}
 	}
 
@@ -278,29 +279,23 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(wm831x->dev, "watchdog_register_device() failed: %d\n",
 			ret);
-		goto err_gpio;
+		goto err;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 
 	return 0;
 
-err_gpio:
-	if (driver_data->update_gpio)
-		gpio_free(driver_data->update_gpio);
 err:
 	return ret;
 }
 
 static int wm831x_wdt_remove(struct platform_device *pdev)
 {
-	struct wm831x_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
+	struct wm831x_wdt_drvdata *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 
-	if (driver_data->update_gpio)
-		gpio_free(driver_data->update_gpio);
-
 	return 0;
 }
 
