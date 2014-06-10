Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaFJUGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:06:03 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:36997 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753361AbaFJUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:05:57 -0400
Date: Tue, 10 Jun 2014 22:05:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>, Anatolij Gustschin <agust@denx.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, Gabor Juhos <juhosg@openwrt.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        gundberg <per.gundberg@icomera.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jean Delvare <jdelvare@suse.de>
Subject: [GIT PULL REQUEST] watchdog - v3.16 merge window
Message-ID: <20140610200549.GW22347@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It contains:
* Addition of the Intel MID watchdog
* Removal of W83697HF and W83697UG drivers (code was merged into w83627hf_wdt driver)
* Addition of Armada 375/380 SoC support
* Conversion of imx2_wdt to regmap API and to watchdog core API
* lots of other small improvements and fixes

This will update the following files:

 b/Documentation/devicetree/bindings/watchdog/marvel.txt  |    7 
 b/arch/powerpc/kernel/setup-common.c                     |   27 
 b/arch/x86/platform/intel-mid/device_libs/Makefile       |    1 
 b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c |   72 ++
 b/drivers/watchdog/Kconfig                               |   49 -
 b/drivers/watchdog/Makefile                              |    3 
 b/drivers/watchdog/ath79_wdt.c                           |   16 
 b/drivers/watchdog/booke_wdt.c                           |   51 +
 b/drivers/watchdog/imx2_wdt.c                            |  320 ++++------
 b/drivers/watchdog/intel-mid_wdt.c                       |  184 ++++++
 b/drivers/watchdog/kempld_wdt.c                          |    2 
 b/drivers/watchdog/of_xilinx_wdt.c                       |    2 
 b/drivers/watchdog/orion_wdt.c                           |  213 ++++++
 b/drivers/watchdog/shwdt.c                               |    2 
 b/drivers/watchdog/sp805_wdt.c                           |    4 
 b/drivers/watchdog/sunxi_wdt.c                           |   22 
 b/drivers/watchdog/via_wdt.c                             |    2 
 b/drivers/watchdog/w83627hf_wdt.c                        |   15 
 b/include/linux/platform_data/intel-mid_wdt.h            |   22 
 drivers/watchdog/w83697hf_wdt.c                          |  460 ---------------
 drivers/watchdog/w83697ug_wdt.c                          |  397 ------------
 21 files changed, 710 insertions(+), 1161 deletions(-)

with these Changes:

commit 78a3bb9e408be6aadcd4a609d14a05038f2a132a
Author: David Cohen <david.a.cohen@linux.intel.com>
Date:   Tue Apr 15 15:20:32 2014 -0700

    x86: intel-mid: add watchdog platform code for Merrifield
    
    This patch adds platform code for Intel Merrifield.
    Since the watchdog is not part of SFI table, we have no other option but
    to manually register watchdog's platform device (argh!).
    
    Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 87a1ef8058d9ab26bc289ea4f27bc3c11ce9acb8
Author: David Cohen <david.a.cohen@linux.intel.com>
Date:   Tue Apr 15 13:06:05 2014 -0700

    watchdog: add Intel MID watchdog driver support
    
    Add initial Intel MID watchdog driver support.
    
    This driver is an initial implementation of generic Intel MID watchdog
    driver. Currently it supports Intel Merrifield platform.
    
    Signed-off-by: Eric Ernst <eric.ernst@intel.com>
    Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 938626d96a3ffb9eb54552bb0d3a4f2b30ffdeb0
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu May 15 10:01:59 2014 +0530

    watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()
    
    Implementation of ->set_timeout() is supposed to set 'timeout' field of 'struct
    watchdog_device' passed to it. sp805 was rather setting this in a local
    variable. Fix it.
    
    Reported-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: <stable@vger.kernel.org> # 2.6.36+

commit d2deebabaeedccf7cee943c1f7f6fdb44afd4e3d
Author: Tang Yuantian <yuantian.tang@freescale.com>
Date:   Thu May 8 10:04:26 2014 +0800

    booke/watchdog: refine and clean up the codes
    
    Basically, this patch does the following:
    1. Move the codes of parsing boot parameters from setup-common.c
       to driver. In this way, code reader can know directly that
       there are boot parameters that can change the timeout.
    2. Make boot parameter 'booke_wdt_period' effective.
       currently, when driver is loaded, default timeout is always
       being used in stead of booke_wdt_period.
    3. Wrap up the watchdog timeout in device struct and clean up
       unnecessary codes.
    
    Signed-off-by: Tang Yuantian <yuantian.tang@freescale.com>
    Acked-by: Scott Wood <scottwood@freescale.com>
    Reviewed-by: Li Yang <leoli@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ec2e32ca661e7f2fe6c23efe202013f6ab5bf021
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 8 16:56:19 2014 +0200

    watchdog: iop_wdt only builds for mach-iop13xx
    
    All three iop variants we support in Linux (iop32x, iop33x and
    iop13xx) seem to have support for the watchdog hardware, but this
    driver fails to build for the first two of these because it
    uses the IOP13XX_WDTCR_IB_RESET macro that is only defined for
    iop13xx.
    
    This clarifies the dependency in Kconfig to avoid randconfig
    build errors. It is unlikely that anyone will ever miss support
    for this driver on the ancient iop3xx platforms, so we don't
    need to bother trying to fix it properly.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: linux-watchdog@vger.kernel.org

commit 7285fae9345e030c6e215a9a4e5fe69b8db92bb5
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Apr 5 11:27:37 2014 -0700

    watchdog: Remove drivers for W83697HF and W83697UG
    
    Since both chips are now supported by the w83627hf watchdog driver,
    the chip specific drivers are no longer needed and can be removed.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit be281588d0bb21ccb07b1747939e0c919c2203fc
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sat Apr 5 11:27:36 2014 -0700

    watchdog: w83627hf_wdt: Add early_disable module parameter
    
    Add early_disable module parameter to match functionality previously
    available in the w83697hf_wdt driver.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ebc5e336077aa2ea595f8ab5f989601e7e443332
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:18:04 2014 -0300

    ARM: mvebu: Add A375/A380 watchdog binding documentation
    
    This commit documents the new support for "marvell,armada-{375,380}-wdt"
    compatible strings and the extra 'reg' entry requirement.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b483642fc399c0c79a90aef25c956f37e29e6b27
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:18:01 2014 -0300

    watchdog: orion: Add Armada 375/380 SoC support
    
    This commit adds support for the Armada 375 and Armada 380 SoCs.
    
    This SoC variant has a second RSTOUT register, in addition to the already
    existent, which is shared with the system-controller. To handle this RSTOUT,
    we introduce a new MMIO register 'rstout_mask' to be required on
    'armada-{375,380}-watchdog' new compatible string.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1b0ea574ac90c9c3da8e903f205848bd4724b1cf
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:18:00 2014 -0300

    watchdog: orion: Introduce per-SoC enabled() function
    
    In order to support other SoCs, it's needed to have a different enabled()
    implementation for each SoC. This commit adds no functionality, and it
    consists of preparation work.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ebf5cf7628f04b6988b9ad08d919728748ecbce0
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:17:59 2014 -0300

    watchdog: orion: Introduce per-SoC stop() function
    
    In order to support other SoCs, it's needed to have a different stop()
    implementation for each SoC. This commit adds no functionality, and it
    consists of preparation work.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit eba985e20c70d99a278c04ff5c492d90d53a20dd
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:17:58 2014 -0300

    watchdog: orion: Remove unneeded atomic access
    
    The RSTOUT register on the Armada 370 SoC variant is a dedicated register
    (not shared across orthogonal subsystems) and so it's not needed to write
    it atomically.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 92d4fc1a1f56a12fa09c92d8c89873509a8012c9
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:17:57 2014 -0300

    watchdog: orion: Introduce a SoC-specific RSTOUT mapping
    
    Separate the RSTOUT register mapping for the different compatible strings
    supported by the driver. This allows to use devm_ioremap on SoC variants that
    share the RSTOUT register, and devm_ioremap_resource (which requests the MMIO
    region) on SoCs that have a dedicated RSTOUT register.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit aaaac9ec79b7c4e21741df35d2247a1187836129
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sat Mar 15 15:17:56 2014 -0300

    watchdog: orion: Move the register ioremap'ing to its own function
    
    Follow-up patches will extend the registers ioremap and request
    to handle SoC-specific quirks on the RSTOUT register. Therefore,
    in order to keep the code readable, this commit introduces a special
    function for this.
    
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9ebf1855dbe0a170e45a2000d6f8e16d88b5fd7c
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Wed May 7 17:42:22 2014 +0900

    watchdog: xilinx: Make of_device_id array const
    
    Make of_device_id array const, because all OF functions
    handle it as const.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Michal Simek <monstr@monstr.eu>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit faad5de0b10484d3dc2ed2a803b2b82f6b1b81ee
Author: Anatolij Gustschin <agust@denx.de>
Date:   Fri Apr 11 08:57:14 2014 +0200

    watchdog: imx2_wdt: convert to watchdog core api
    
    Convert the imx2_wdt driver to the new watchdog core api.
    
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Cc: Wolfram Sang <wsa@the-dreams.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a7977003293ed0c13e62d95fc8cd1d20e22b7282
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Fri Apr 4 09:33:25 2014 +0800

    watchdog: imx2_wdt: convert to use regmap API.
    
    This watchdog driver will be working on IMX2+, Vybrid, LS1, LS2+
    platforms, and will be in different endianness mode in those SoCs:
    
    SoCs         CPU endian mode      WDT endian mode
    ------------------------------------------------
    IMX2+            LE                    LE
    Vybird           LE                    LE
    LS1              LE                    BE
    LS2              LE                    LE
    
    Other possible SoCs:
    SoCs         CPU endian mode      WDT endian mode
    ------------------------------------------------
    Soc1             BE                    BE
    Soc2             BE                    LE
    
    And also the watchdog's registers will be 32-bits for some versions,
    and though it is 16-bits in IMX2+, Vybird and LS+.
    
    Using the regmap APIs, could be more easy to support different
    endianness and also more easy to support 32-bits version...
    
    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 30cb042a846353929042d93d13c9f8e1e5227aa7
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Fri Apr 4 09:33:24 2014 +0800

    watchdog: imx2_wdt: Sort the header files alphabetically
    
    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b4e62d9467cc5c69d7a23ebc50382c01b769e933
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Wed Apr 16 11:35:50 2014 +0200

    watchdog: ath79_wdt: switch to clk_prepare/clk_disable
    
    Replace clk_enable() and clk_disable() calls with
    clk_prepare_enable() and clk_disable_unprepare()
    to get ready for the migration to the common clock
    framework.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 23afeb613ec0e10aecfae7838a14d485db62ac52
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Wed Apr 16 11:34:41 2014 +0200

    watchdog: ath79_wdt: avoid spurious restarts on AR934x
    
    On some AR934x based systems, where the frequency of
    the AHB bus is relatively high, the built-in watchdog
    causes a spurious restart when it gets enabled.
    
    The possible cause of these restarts is that the timeout
    value written into the TIMER register does not reaches
    the hardware in time.
    
    Add an explicit delay into the ath79_wdt_enable function
    to avoid the spurious restarts.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: <stable@vger.kernel.org>

commit ff4e0ae5feaffd69ecf115555c6437cf4f71f806
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Sat Mar 29 14:29:00 2014 +0400

    watchdog: shwdt: Remove unused platform_set_drvdata()
    
    This patch removes platform_set_drvdata() which is not used in
    the driver.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit a9e0436b303e94ba57d3bd4b1fcbeaa744b7ebeb
Author: gundberg <per.gundberg@icomera.com>
Date:   Thu Apr 24 15:49:19 2014 +0200

    watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog
    
    Use the prescaler index, rather than its value, to configure the watchdog.
    This will prevent a mismatch with the prescaler used to calculate the cycles.
    
    Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
    Tested-by: Michael Brunner <michael.brunner@kontron.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

commit 51ee34ab583a602e35817c020bcc5c437da4a1ee
Author: Emilio López <emilio@elopez.com.ar>
Date:   Fri Apr 4 14:24:25 2014 -0300

    watchdog: sunxi: Fix compilation with C=2
    
    When compiling sunxi_defconfig while using C=2, the following error
    causes the compilation to fail:
    
        drivers/watchdog/sunxi_wdt.c:60:15: error: constant 0b0001 is not a valid number
    
    Fix it by using hex notation instead of the non-standard binary one
    
    Signed-off-by: Emilio Lopez <emilio@elopez.com.ar>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3813ff8b38b265b6c25f3946d5850273deba03a3
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Tue Apr 1 15:49:19 2014 +0200

    watchdog: via_wdt: replace del_timer by del_timer_sync
    
    Use del_timer_sync to ensure that the timer is stopped on all CPUs before
    the driver exits.
    
    This change was suggested by Thomas Gleixner.
    
    The semantic patch that makes this change is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r@
    identifier i,t,ex;
    @@
    struct t i = { .remove = ex, };
    
    @@
    identifier r.ex;
    @@
    ex(...) {
      <...
    - del_timer
    + del_timer_sync
        (...)
      ...>
    }
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1e8c8a5b484f99d82bd961d10705896385cafc06
Author: Jean Delvare <jdelvare@suse.de>
Date:   Wed Mar 26 16:00:01 2014 +0100

    watchdog: Fix SBC8360 dependencies
    
    According to its Kconfig help text, the sbc8360 watchdog driver is
    only used on the Axiomtek SBC8360 single-board computer. This piece of
    hardware is 32-bit x86 so the driver is useless beyond X86_32.
    
    Signed-off-by: Jean Delvare <jdelvare@suse.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/marvel.txt b/Documentation/devicetree/bindings/watchdog/marvel.txt
index de11eb4..97223fd 100644
--- a/Documentation/devicetree/bindings/watchdog/marvel.txt
+++ b/Documentation/devicetree/bindings/watchdog/marvel.txt
@@ -5,11 +5,18 @@ Required Properties:
 - Compatibility : "marvell,orion-wdt"
 		  "marvell,armada-370-wdt"
 		  "marvell,armada-xp-wdt"
+		  "marvell,armada-375-wdt"
+		  "marvell,armada-380-wdt"
 
 - reg		: Should contain two entries: first one with the
 		  timer control address, second one with the
 		  rstout enable address.
 
+For "marvell,armada-375-wdt" and "marvell,armada-380-wdt":
+
+- reg		: A third entry is mandatory and should contain the
+                  shared mask/unmask RSTOUT address.
+
 Optional properties:
 
 - interrupts	: Contains the IRQ for watchdog expiration
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 79b7612..fb87e4a 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -718,33 +718,6 @@ static int powerpc_debugfs_init(void)
 arch_initcall(powerpc_debugfs_init);
 #endif
 
-#ifdef CONFIG_BOOKE_WDT
-extern u32 booke_wdt_enabled;
-extern u32 booke_wdt_period;
-
-/* Checks wdt=x and wdt_period=xx command-line option */
-notrace int __init early_parse_wdt(char *p)
-{
-	if (p && strncmp(p, "0", 1) != 0)
-		booke_wdt_enabled = 1;
-
-	return 0;
-}
-early_param("wdt", early_parse_wdt);
-
-int __init early_parse_wdt_period(char *p)
-{
-	unsigned long ret;
-	if (p) {
-		if (!kstrtol(p, 0, &ret))
-			booke_wdt_period = ret;
-	}
-
-	return 0;
-}
-early_param("wdt_period", early_parse_wdt_period);
-#endif	/* CONFIG_BOOKE_WDT */
-
 void ppc_printk_progress(char *s, unsigned short hex)
 {
 	pr_info("%s\n", s);
diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
index 097e7a7..af9307f 100644
--- a/arch/x86/platform/intel-mid/device_libs/Makefile
+++ b/arch/x86/platform/intel-mid/device_libs/Makefile
@@ -20,3 +20,4 @@ obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
 obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
 # MISC Devices
 obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
+obj-$(subst m,y,$(CONFIG_INTEL_MID_WATCHDOG)) += platform_wdt.o
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
new file mode 100644
index 0000000..973cf3b
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -0,0 +1,72 @@
+/*
+ * platform_wdt.c: Watchdog platform library file
+ *
+ * (C) Copyright 2014 Intel Corporation
+ * Author: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/intel-mid_wdt.h>
+#include <asm/intel-mid.h>
+#include <asm/io_apic.h>
+
+#define TANGIER_EXT_TIMER0_MSI 15
+
+static struct platform_device wdt_dev = {
+	.name = "intel_mid_wdt",
+	.id = -1,
+};
+
+static int tangier_probe(struct platform_device *pdev)
+{
+	int ioapic;
+	int irq;
+	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
+	struct io_apic_irq_attr irq_attr = { 0 };
+
+	if (!pdata)
+		return -EINVAL;
+
+	irq = pdata->irq;
+	ioapic = mp_find_ioapic(irq);
+	if (ioapic >= 0) {
+		int ret;
+		irq_attr.ioapic = ioapic;
+		irq_attr.ioapic_pin = irq;
+		irq_attr.trigger = 1;
+		/* irq_attr.polarity = 0; -> Active high */
+		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
+		if (ret)
+			return ret;
+	} else {
+		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
+			 irq);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct intel_mid_wdt_pdata tangier_pdata = {
+	.irq = TANGIER_EXT_TIMER0_MSI,
+	.probe = tangier_probe,
+};
+
+static int __init register_mid_wdt(void)
+{
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER) {
+		wdt_dev.dev.platform_data = &tangier_pdata;
+		return platform_device_register(&wdt_dev);
+	}
+
+	return -ENODEV;
+}
+
+rootfs_initcall(register_mid_wdt);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 74ec8fc..c845527 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -272,7 +272,7 @@ config PNX4008_WATCHDOG
 
 config IOP_WATCHDOG
 	tristate "IOP Watchdog"
-	depends on PLAT_IOP
+	depends on ARCH_IOP13XX
 	select WATCHDOG_NOWAYOUT if (ARCH_IOP32X || ARCH_IOP33X)
 	help
 	  Say Y here if to include support for the watchdog timer
@@ -378,6 +378,8 @@ config MAX63XX_WATCHDOG
 config IMX2_WDT
 	tristate "IMX2+ Watchdog"
 	depends on ARCH_MXC
+	select REGMAP_MMIO
+	select WATCHDOG_CORE
 	help
 	  This is the driver for the hardware watchdog
 	  on the Freescale IMX2 and later processors.
@@ -663,6 +665,19 @@ config INTEL_SCU_WATCHDOG
 
 	  To compile this driver as a module, choose M here.
 
+config INTEL_MID_WATCHDOG
+	tristate "Intel MID Watchdog Timer"
+	depends on X86_INTEL_MID
+	select WATCHDOG_CORE
+	---help---
+	  Watchdog timer driver built into the Intel SCU for Intel MID
+	  Platforms.
+
+	  This driver currently supports only the watchdog evolution
+	  implementation in SCU, available for Merrifield generation.
+
+	  To compile this driver as a module, choose M here.
+
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
@@ -835,7 +850,7 @@ config 60XX_WDT
 
 config SBC8360_WDT
 	tristate "SBC8360 Watchdog Timer"
-	depends on X86
+	depends on X86_32
 	---help---
 
 	  This is the driver for the hardware watchdog on the SBC8360 Single
@@ -938,36 +953,6 @@ config W83627HF_WDT
 
 	  Most people will say N.
 
-config W83697HF_WDT
-	tristate "W83697HF/W83697HG Watchdog Timer"
-	depends on X86
-	---help---
-	  This is the driver for the hardware watchdog on the W83697HF/HG
-	  chipset as used in Dedibox/VIA motherboards (and likely others).
-	  This watchdog simply watches your kernel to make sure it doesn't
-	  freeze, and if it does, it reboots your computer after a certain
-	  amount of time.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called w83697hf_wdt.
-
-	  Most people will say N.
-
-config W83697UG_WDT
-	tristate "W83697UG/W83697UF Watchdog Timer"
-	depends on X86
-	---help---
-	  This is the driver for the hardware watchdog on the W83697UG/UF
-	  chipset as used in MSI Fuzzy CX700 VIA motherboards (and likely others).
-	  This watchdog simply watches your kernel to make sure it doesn't
-	  freeze, and if it does, it reboots your computer after a certain
-	  amount of time.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called w83697ug_wdt.
-
-	  Most people will say N.
-
 config W83877F_WDT
 	tristate "W83877F (EMACS) Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 1b5f3d5..7b8a91e 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -107,13 +107,12 @@ obj-$(CONFIG_SMSC_SCH311X_WDT) += sch311x_wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
 obj-$(CONFIG_VIA_WDT) += via_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
-obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
-obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
 obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
+obj-$(CONFIG_INTEL_MID_WATCHDOG) += intel-mid_wdt.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 399c3fd..41ac466 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -20,6 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/io.h>
@@ -90,6 +91,15 @@ static inline void ath79_wdt_keepalive(void)
 static inline void ath79_wdt_enable(void)
 {
 	ath79_wdt_keepalive();
+
+	/*
+	 * Updating the TIMER register requires a few microseconds
+	 * on the AR934x SoCs at least. Use a small delay to ensure
+	 * that the TIMER register is updated within the hardware
+	 * before enabling the watchdog.
+	 */
+	udelay(2);
+
 	ath79_wdt_wr(WDOG_REG_CTRL, WDOG_CTRL_ACTION_FCR);
 	/* flush write */
 	ath79_wdt_rr(WDOG_REG_CTRL);
@@ -255,7 +265,7 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(wdt_clk))
 		return PTR_ERR(wdt_clk);
 
-	err = clk_enable(wdt_clk);
+	err = clk_prepare_enable(wdt_clk);
 	if (err)
 		return err;
 
@@ -286,14 +296,14 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_disable:
-	clk_disable(wdt_clk);
+	clk_disable_unprepare(wdt_clk);
 	return err;
 }
 
 static int ath79_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ath79_wdt_miscdev);
-	clk_disable(wdt_clk);
+	clk_disable_unprepare(wdt_clk);
 	return 0;
 }
 
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index a8dbceb..08a7853 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -41,6 +41,28 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
 #define WDTP_MASK	(TCR_WP_MASK)
 #endif
 
+/* Checks wdt=x and wdt_period=xx command-line option */
+notrace int __init early_parse_wdt(char *p)
+{
+	if (p && strncmp(p, "0", 1) != 0)
+		booke_wdt_enabled = 1;
+
+	return 0;
+}
+early_param("wdt", early_parse_wdt);
+
+int __init early_parse_wdt_period(char *p)
+{
+	unsigned long ret;
+	if (p) {
+		if (!kstrtol(p, 0, &ret))
+			booke_wdt_period = ret;
+	}
+
+	return 0;
+}
+early_param("wdt_period", early_parse_wdt_period);
+
 #ifdef CONFIG_PPC_FSL_BOOK3E
 
 /* For the specified period, determine the number of seconds
@@ -103,17 +125,18 @@ static unsigned int sec_to_period(unsigned int secs)
 static void __booke_wdt_set(void *data)
 {
 	u32 val;
+	struct watchdog_device *wdog = data;
 
 	val = mfspr(SPRN_TCR);
 	val &= ~WDTP_MASK;
-	val |= WDTP(booke_wdt_period);
+	val |= WDTP(sec_to_period(wdog->timeout));
 
 	mtspr(SPRN_TCR, val);
 }
 
-static void booke_wdt_set(void)
+static void booke_wdt_set(void *data)
 {
-	on_each_cpu(__booke_wdt_set, NULL, 0);
+	on_each_cpu(__booke_wdt_set, data, 0);
 }
 
 static void __booke_wdt_ping(void *data)
@@ -131,12 +154,13 @@ static int booke_wdt_ping(struct watchdog_device *wdog)
 static void __booke_wdt_enable(void *data)
 {
 	u32 val;
+	struct watchdog_device *wdog = data;
 
 	/* clear status before enabling watchdog */
 	__booke_wdt_ping(NULL);
 	val = mfspr(SPRN_TCR);
 	val &= ~WDTP_MASK;
-	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
+	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(sec_to_period(wdog->timeout)));
 
 	mtspr(SPRN_TCR, val);
 }
@@ -162,25 +186,17 @@ static void __booke_wdt_disable(void *data)
 
 }
 
-static void __booke_wdt_start(struct watchdog_device *wdog)
+static int booke_wdt_start(struct watchdog_device *wdog)
 {
-	on_each_cpu(__booke_wdt_enable, NULL, 0);
+	on_each_cpu(__booke_wdt_enable, wdog, 0);
 	pr_debug("watchdog enabled (timeout = %u sec)\n", wdog->timeout);
-}
 
-static int booke_wdt_start(struct watchdog_device *wdog)
-{
-	if (booke_wdt_enabled == 0) {
-		booke_wdt_enabled = 1;
-		__booke_wdt_start(wdog);
-	}
 	return 0;
 }
 
 static int booke_wdt_stop(struct watchdog_device *wdog)
 {
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
-	booke_wdt_enabled = 0;
 	pr_debug("watchdog disabled\n");
 
 	return 0;
@@ -191,9 +207,8 @@ static int booke_wdt_set_timeout(struct watchdog_device *wdt_dev,
 {
 	if (timeout > MAX_WDT_TIMEOUT)
 		return -EINVAL;
-	booke_wdt_period = sec_to_period(timeout);
 	wdt_dev->timeout = timeout;
-	booke_wdt_set();
+	booke_wdt_set(wdt_dev);
 
 	return 0;
 }
@@ -231,10 +246,10 @@ static int __init booke_wdt_init(void)
 	pr_info("powerpc book-e watchdog driver loaded\n");
 	booke_wdt_info.firmware_version = cur_cpu_spec->pvr_value;
 	booke_wdt_set_timeout(&booke_wdt_dev,
-			      period_to_sec(CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT));
+			      period_to_sec(booke_wdt_period));
 	watchdog_set_nowayout(&booke_wdt_dev, nowayout);
 	if (booke_wdt_enabled)
-		__booke_wdt_start(&booke_wdt_dev);
+		booke_wdt_start(&booke_wdt_dev);
 
 	ret = watchdog_register_device(&booke_wdt_dev);
 
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index dd51d95..9d4874f 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -21,19 +21,17 @@
  * Halt on suspend:	Manual		Can be automatic
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
-#include <linux/watchdog.h>
-#include <linux/clk.h>
-#include <linux/fs.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
+#include <linux/regmap.h>
 #include <linux/timer.h>
-#include <linux/jiffies.h>
+#include <linux/watchdog.h>
 
 #define DRIVER_NAME "imx2-wdt"
 
@@ -55,19 +53,12 @@
 
 #define WDOG_SEC_TO_COUNT(s)	((s * 2 - 1) << 8)
 
-#define IMX2_WDT_STATUS_OPEN	0
-#define IMX2_WDT_STATUS_STARTED	1
-#define IMX2_WDT_EXPECT_CLOSE	2
-
-static struct {
+struct imx2_wdt_device {
 	struct clk *clk;
-	void __iomem *base;
-	unsigned timeout;
-	unsigned long status;
+	struct regmap *regmap;
 	struct timer_list timer;	/* Pings the watchdog when closed */
-} imx2_wdt;
-
-static struct miscdevice imx2_wdt_miscdev;
+	struct watchdog_device wdog;
+};
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
@@ -85,9 +76,12 @@ static const struct watchdog_info imx2_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
 };
 
-static inline void imx2_wdt_setup(void)
+static inline void imx2_wdt_setup(struct watchdog_device *wdog)
 {
-	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+	u32 val;
+
+	regmap_read(wdev->regmap, IMX2_WDT_WCR, &val);
 
 	/* Suspend timer in low power mode, write once-only */
 	val |= IMX2_WDT_WCR_WDZST;
@@ -98,227 +92,199 @@ static inline void imx2_wdt_setup(void)
 	/* Keep Watchdog Disabled */
 	val &= ~IMX2_WDT_WCR_WDE;
 	/* Set the watchdog's Time-Out value */
-	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
+	val |= WDOG_SEC_TO_COUNT(wdog->timeout);
 
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	regmap_write(wdev->regmap, IMX2_WDT_WCR, val);
 
 	/* enable the watchdog */
 	val |= IMX2_WDT_WCR_WDE;
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	regmap_write(wdev->regmap, IMX2_WDT_WCR, val);
 }
 
-static inline void imx2_wdt_ping(void)
+static inline bool imx2_wdt_is_running(struct imx2_wdt_device *wdev)
 {
-	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
-	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
-}
+	u32 val;
 
-static void imx2_wdt_timer_ping(unsigned long arg)
-{
-	/* ping it every imx2_wdt.timeout / 2 seconds to prevent reboot */
-	imx2_wdt_ping();
-	mod_timer(&imx2_wdt.timer, jiffies + imx2_wdt.timeout * HZ / 2);
+	regmap_read(wdev->regmap, IMX2_WDT_WCR, &val);
+
+	return val & IMX2_WDT_WCR_WDE;
 }
 
-static void imx2_wdt_start(void)
+static int imx2_wdt_ping(struct watchdog_device *wdog)
 {
-	if (!test_and_set_bit(IMX2_WDT_STATUS_STARTED, &imx2_wdt.status)) {
-		/* at our first start we enable clock and do initialisations */
-		clk_prepare_enable(imx2_wdt.clk);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
-		imx2_wdt_setup();
-	} else	/* delete the timer that pings the watchdog after close */
-		del_timer_sync(&imx2_wdt.timer);
-
-	/* Watchdog is enabled - time to reload the timeout value */
-	imx2_wdt_ping();
+	regmap_write(wdev->regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ1);
+	regmap_write(wdev->regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ2);
+	return 0;
 }
 
-static void imx2_wdt_stop(void)
+static void imx2_wdt_timer_ping(unsigned long arg)
 {
-	/* we don't need a clk_disable, it cannot be disabled once started.
-	 * We use a timer to ping the watchdog while /dev/watchdog is closed */
-	imx2_wdt_timer_ping(0);
+	struct watchdog_device *wdog = (struct watchdog_device *)arg;
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+	/* ping it every wdog->timeout / 2 seconds to prevent reboot */
+	imx2_wdt_ping(wdog);
+	mod_timer(&wdev->timer, jiffies + wdog->timeout * HZ / 2);
 }
 
-static void imx2_wdt_set_timeout(int new_timeout)
+static int imx2_wdt_set_timeout(struct watchdog_device *wdog,
+				unsigned int new_timeout)
 {
-	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
-	/* set the new timeout value in the WSR */
-	val &= ~IMX2_WDT_WCR_WT;
-	val |= WDOG_SEC_TO_COUNT(new_timeout);
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	regmap_update_bits(wdev->regmap, IMX2_WDT_WCR, IMX2_WDT_WCR_WT,
+			   WDOG_SEC_TO_COUNT(new_timeout));
+	return 0;
 }
 
-static int imx2_wdt_open(struct inode *inode, struct file *file)
+static int imx2_wdt_start(struct watchdog_device *wdog)
 {
-	if (test_and_set_bit(IMX2_WDT_STATUS_OPEN, &imx2_wdt.status))
-		return -EBUSY;
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+	if (imx2_wdt_is_running(wdev)) {
+		/* delete the timer that pings the watchdog after close */
+		del_timer_sync(&wdev->timer);
+		imx2_wdt_set_timeout(wdog, wdog->timeout);
+	} else
+		imx2_wdt_setup(wdog);
 
-	imx2_wdt_start();
-	return nonseekable_open(inode, file);
+	return imx2_wdt_ping(wdog);
 }
 
-static int imx2_wdt_close(struct inode *inode, struct file *file)
+static int imx2_wdt_stop(struct watchdog_device *wdog)
 {
-	if (test_bit(IMX2_WDT_EXPECT_CLOSE, &imx2_wdt.status) && !nowayout)
-		imx2_wdt_stop();
-	else {
-		dev_crit(imx2_wdt_miscdev.parent,
-			"Unexpected close: Expect reboot!\n");
-		imx2_wdt_ping();
-	}
-
-	clear_bit(IMX2_WDT_EXPECT_CLOSE, &imx2_wdt.status);
-	clear_bit(IMX2_WDT_STATUS_OPEN, &imx2_wdt.status);
+	/*
+	 * We don't need a clk_disable, it cannot be disabled once started.
+	 * We use a timer to ping the watchdog while /dev/watchdog is closed
+	 */
+	imx2_wdt_timer_ping((unsigned long)wdog);
 	return 0;
 }
 
-static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+static inline void imx2_wdt_ping_if_active(struct watchdog_device *wdog)
 {
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-	u16 val;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &imx2_wdt_info,
-			sizeof(struct watchdog_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_GETBOOTSTATUS:
-		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
-		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
-		return put_user(new_value, p);
-
-	case WDIOC_KEEPALIVE:
-		imx2_wdt_ping();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-		if ((new_value < 1) || (new_value > IMX2_WDT_MAX_TIME))
-			return -EINVAL;
-		imx2_wdt_set_timeout(new_value);
-		imx2_wdt.timeout = new_value;
-		imx2_wdt_ping();
-
-		/* Fallthrough to return current value */
-	case WDIOC_GETTIMEOUT:
-		return put_user(imx2_wdt.timeout, p);
-
-	default:
-		return -ENOTTY;
-	}
-}
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
-static ssize_t imx2_wdt_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
-{
-	size_t i;
-	char c;
-
-	if (len == 0)	/* Can we see this even ? */
-		return 0;
-
-	clear_bit(IMX2_WDT_EXPECT_CLOSE, &imx2_wdt.status);
-	/* scan to see whether or not we got the magic character */
-	for (i = 0; i != len; i++) {
-		if (get_user(c, data + i))
-			return -EFAULT;
-		if (c == 'V')
-			set_bit(IMX2_WDT_EXPECT_CLOSE, &imx2_wdt.status);
+	if (imx2_wdt_is_running(wdev)) {
+		imx2_wdt_set_timeout(wdog, wdog->timeout);
+		imx2_wdt_timer_ping((unsigned long)wdog);
 	}
-
-	imx2_wdt_ping();
-	return len;
 }
 
-static const struct file_operations imx2_wdt_fops = {
+static struct watchdog_ops imx2_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.unlocked_ioctl = imx2_wdt_ioctl,
-	.open = imx2_wdt_open,
-	.release = imx2_wdt_close,
-	.write = imx2_wdt_write,
+	.start = imx2_wdt_start,
+	.stop = imx2_wdt_stop,
+	.ping = imx2_wdt_ping,
+	.set_timeout = imx2_wdt_set_timeout,
 };
 
-static struct miscdevice imx2_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &imx2_wdt_fops,
+static struct regmap_config imx2_wdt_regmap_config = {
+	.reg_bits = 16,
+	.reg_stride = 2,
+	.val_bits = 16,
+	.max_register = 0x8,
 };
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct imx2_wdt_device *wdev;
+	struct watchdog_device *wdog;
 	struct resource *res;
+	void __iomem *base;
+	int ret;
+	u32 val;
+
+	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
+	if (!wdev)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(imx2_wdt.base))
-		return PTR_ERR(imx2_wdt.base);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	wdev->regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
+						 &imx2_wdt_regmap_config);
+	if (IS_ERR(wdev->regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		return PTR_ERR(wdev->regmap);
+	}
 
-	imx2_wdt.clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(imx2_wdt.clk)) {
+	wdev->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(wdev->clk)) {
 		dev_err(&pdev->dev, "can't get Watchdog clock\n");
-		return PTR_ERR(imx2_wdt.clk);
+		return PTR_ERR(wdev->clk);
 	}
 
-	imx2_wdt.timeout = clamp_t(unsigned, timeout, 1, IMX2_WDT_MAX_TIME);
-	if (imx2_wdt.timeout != timeout)
-		dev_warn(&pdev->dev, "Initial timeout out of range! "
-			"Clamped from %u to %u\n", timeout, imx2_wdt.timeout);
+	wdog			= &wdev->wdog;
+	wdog->info		= &imx2_wdt_info;
+	wdog->ops		= &imx2_wdt_ops;
+	wdog->min_timeout	= 1;
+	wdog->max_timeout	= IMX2_WDT_MAX_TIME;
 
-	setup_timer(&imx2_wdt.timer, imx2_wdt_timer_ping, 0);
+	clk_prepare_enable(wdev->clk);
 
-	imx2_wdt_miscdev.parent = &pdev->dev;
-	ret = misc_register(&imx2_wdt_miscdev);
-	if (ret)
-		goto fail;
+	regmap_read(wdev->regmap, IMX2_WDT_WRSR, &val);
+	wdog->bootstatus = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
 
-	dev_info(&pdev->dev,
-		"IMX2+ Watchdog Timer enabled. timeout=%ds (nowayout=%d)\n",
-						imx2_wdt.timeout, nowayout);
-	return 0;
+	wdog->timeout = clamp_t(unsigned, timeout, 1, IMX2_WDT_MAX_TIME);
+	if (wdog->timeout != timeout)
+		dev_warn(&pdev->dev, "Initial timeout out of range! Clamped from %u to %u\n",
+			 timeout, wdog->timeout);
+
+	platform_set_drvdata(pdev, wdog);
+	watchdog_set_drvdata(wdog, wdev);
+	watchdog_set_nowayout(wdog, nowayout);
+	watchdog_init_timeout(wdog, timeout, &pdev->dev);
+
+	setup_timer(&wdev->timer, imx2_wdt_timer_ping, (unsigned long)wdog);
+
+	imx2_wdt_ping_if_active(wdog);
 
-fail:
-	imx2_wdt_miscdev.parent = NULL;
-	return ret;
+	ret = watchdog_register_device(wdog);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register watchdog device\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "timeout %d sec (nowayout=%d)\n",
+		 wdog->timeout, nowayout);
+
+	return 0;
 }
 
 static int __exit imx2_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&imx2_wdt_miscdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
-	if (test_bit(IMX2_WDT_STATUS_STARTED, &imx2_wdt.status)) {
-		del_timer_sync(&imx2_wdt.timer);
+	watchdog_unregister_device(wdog);
 
-		dev_crit(imx2_wdt_miscdev.parent,
-			"Device removed: Expect reboot!\n");
+	if (imx2_wdt_is_running(wdev)) {
+		del_timer_sync(&wdev->timer);
+		imx2_wdt_ping(wdog);
+		dev_crit(&pdev->dev, "Device removed: Expect reboot!\n");
 	}
-
-	imx2_wdt_miscdev.parent = NULL;
 	return 0;
 }
 
 static void imx2_wdt_shutdown(struct platform_device *pdev)
 {
-	if (test_bit(IMX2_WDT_STATUS_STARTED, &imx2_wdt.status)) {
-		/* we are running, we need to delete the timer but will give
-		 * max timeout before reboot will take place */
-		del_timer_sync(&imx2_wdt.timer);
-		imx2_wdt_set_timeout(IMX2_WDT_MAX_TIME);
-		imx2_wdt_ping();
-
-		dev_crit(imx2_wdt_miscdev.parent,
-			"Device shutdown: Expect reboot!\n");
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+	if (imx2_wdt_is_running(wdev)) {
+		/*
+		 * We are running, we need to delete the timer but will
+		 * give max timeout before reboot will take place
+		 */
+		del_timer_sync(&wdev->timer);
+		imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
+		imx2_wdt_ping(wdog);
+		dev_crit(&pdev->dev, "Device shutdown: Expect reboot!\n");
 	}
 }
 
diff --git a/drivers/watchdog/intel-mid_wdt.c b/drivers/watchdog/intel-mid_wdt.c
new file mode 100644
index 0000000..ca66e8e
--- /dev/null
+++ b/drivers/watchdog/intel-mid_wdt.c
@@ -0,0 +1,184 @@
+/*
+ *      intel-mid_wdt: generic Intel MID SCU watchdog driver
+ *
+ *      Platforms supported so far:
+ *      - Merrifield only
+ *
+ *      Copyright (C) 2014 Intel Corporation. All rights reserved.
+ *      Contact: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/platform_data/intel-mid_wdt.h>
+
+#include <asm/intel_scu_ipc.h>
+#include <asm/intel-mid.h>
+
+#define IPC_WATCHDOG 0xf8
+
+#define MID_WDT_PRETIMEOUT		15
+#define MID_WDT_TIMEOUT_MIN		(1 + MID_WDT_PRETIMEOUT)
+#define MID_WDT_TIMEOUT_MAX		170
+#define MID_WDT_DEFAULT_TIMEOUT		90
+
+/* SCU watchdog messages */
+enum {
+	SCU_WATCHDOG_START = 0,
+	SCU_WATCHDOG_STOP,
+	SCU_WATCHDOG_KEEPALIVE,
+};
+
+static inline int wdt_command(int sub, u32 *in, int inlen)
+{
+	return intel_scu_ipc_command(IPC_WATCHDOG, sub, in, inlen, NULL, 0);
+}
+
+static int wdt_start(struct watchdog_device *wd)
+{
+	int ret, in_size;
+	int timeout = wd->timeout;
+	struct ipc_wd_start {
+		u32 pretimeout;
+		u32 timeout;
+	} ipc_wd_start = { timeout - MID_WDT_PRETIMEOUT, timeout };
+
+	/*
+	 * SCU expects the input size for watchdog IPC to
+	 * be based on 4 bytes
+	 */
+	in_size = DIV_ROUND_UP(sizeof(ipc_wd_start), 4);
+
+	ret = wdt_command(SCU_WATCHDOG_START, (u32 *)&ipc_wd_start, in_size);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "error starting watchdog: %d\n", ret);
+	}
+
+	return ret;
+}
+
+static int wdt_ping(struct watchdog_device *wd)
+{
+	int ret;
+
+	ret = wdt_command(SCU_WATCHDOG_KEEPALIVE, NULL, 0);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "Error executing keepalive: 0x%x\n", ret);
+	}
+
+	return ret;
+}
+
+static int wdt_stop(struct watchdog_device *wd)
+{
+	int ret;
+
+	ret = wdt_command(SCU_WATCHDOG_STOP, NULL, 0);
+	if (ret) {
+		struct device *dev = watchdog_get_drvdata(wd);
+		dev_crit(dev, "Error stopping watchdog: 0x%x\n", ret);
+	}
+
+	return ret;
+}
+
+static irqreturn_t mid_wdt_irq(int irq, void *dev_id)
+{
+	panic("Kernel Watchdog");
+
+	/* This code should not be reached */
+	return IRQ_HANDLED;
+}
+
+static const struct watchdog_info mid_wdt_info = {
+	.identity = "Intel MID SCU watchdog",
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
+};
+
+static const struct watchdog_ops mid_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop = wdt_stop,
+	.ping = wdt_ping,
+};
+
+static int mid_wdt_probe(struct platform_device *pdev)
+{
+	struct watchdog_device *wdt_dev;
+	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -EINVAL;
+	}
+
+	if (pdata->probe) {
+		ret = pdata->probe(pdev);
+		if (ret)
+			return ret;
+	}
+
+	wdt_dev = devm_kzalloc(&pdev->dev, sizeof(*wdt_dev), GFP_KERNEL);
+	if (!wdt_dev)
+		return -ENOMEM;
+
+	wdt_dev->info = &mid_wdt_info;
+	wdt_dev->ops = &mid_wdt_ops;
+	wdt_dev->min_timeout = MID_WDT_TIMEOUT_MIN;
+	wdt_dev->max_timeout = MID_WDT_TIMEOUT_MAX;
+	wdt_dev->timeout = MID_WDT_DEFAULT_TIMEOUT;
+
+	watchdog_set_drvdata(wdt_dev, &pdev->dev);
+	platform_set_drvdata(pdev, wdt_dev);
+
+	ret = devm_request_irq(&pdev->dev, pdata->irq, mid_wdt_irq,
+			       IRQF_SHARED | IRQF_NO_SUSPEND, "watchdog",
+			       wdt_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "error requesting warning irq %d\n",
+			pdata->irq);
+		return ret;
+	}
+
+	ret = watchdog_register_device(wdt_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "error registering watchdog device\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "Intel MID watchdog device probed\n");
+
+	return 0;
+}
+
+static int mid_wdt_remove(struct platform_device *pdev)
+{
+	struct watchdog_device *wd = platform_get_drvdata(pdev);
+	watchdog_unregister_device(wd);
+	return 0;
+}
+
+static struct platform_driver mid_wdt_driver = {
+	.probe		= mid_wdt_probe,
+	.remove		= mid_wdt_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "intel_mid_wdt",
+	},
+};
+
+module_platform_driver(mid_wdt_driver);
+
+MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
+MODULE_DESCRIPTION("Watchdog Driver for Intel MID platform");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
index 20dc738..d9c1a16 100644
--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -162,7 +162,7 @@ static int kempld_wdt_set_stage_timeout(struct kempld_wdt_data *wdt_data,
 	kempld_get_mutex(pld);
 	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
 	stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
-	stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
+	stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
 	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
 	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
 			stage_timeout);
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 57ccae8..1e6e28d 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -225,7 +225,7 @@ static int xwdt_remove(struct platform_device *pdev)
 }
 
 /* Match table for of_platform binding */
-static struct of_device_id xwdt_of_match[] = {
+static const struct of_device_id xwdt_of_match[] = {
 	{ .compatible = "xlnx,xps-timebase-wdt-1.00.a", },
 	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
 	{},
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 9b3c41d..00d0741 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -55,15 +55,19 @@ struct orion_watchdog_data {
 	int wdt_counter_offset;
 	int wdt_enable_bit;
 	int rstout_enable_bit;
+	int rstout_mask_bit;
 	int (*clock_init)(struct platform_device *,
 			  struct orion_watchdog *);
+	int (*enabled)(struct orion_watchdog *);
 	int (*start)(struct watchdog_device *);
+	int (*stop)(struct watchdog_device *);
 };
 
 struct orion_watchdog {
 	struct watchdog_device wdt;
 	void __iomem *reg;
 	void __iomem *rstout;
+	void __iomem *rstout_mask;
 	unsigned long clk_rate;
 	struct clk *clk;
 	const struct orion_watchdog_data *data;
@@ -142,9 +146,35 @@ static int orion_wdt_ping(struct watchdog_device *wdt_dev)
 	return 0;
 }
 
+static int armada375_start(struct watchdog_device *wdt_dev)
+{
+	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	/* Set watchdog duration */
+	writel(dev->clk_rate * wdt_dev->timeout,
+	       dev->reg + dev->data->wdt_counter_offset);
+
+	/* Clear the watchdog expiration bit */
+	atomic_io_modify(dev->reg + TIMER_A370_STATUS, WDT_A370_EXPIRED, 0);
+
+	/* Enable watchdog timer */
+	atomic_io_modify(dev->reg + TIMER_CTRL, dev->data->wdt_enable_bit,
+						dev->data->wdt_enable_bit);
+
+	/* Enable reset on watchdog */
+	reg = readl(dev->rstout);
+	reg |= dev->data->rstout_enable_bit;
+	writel(reg, dev->rstout);
+
+	atomic_io_modify(dev->rstout_mask, dev->data->rstout_mask_bit, 0);
+	return 0;
+}
+
 static int armada370_start(struct watchdog_device *wdt_dev)
 {
 	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
 
 	/* Set watchdog duration */
 	writel(dev->clk_rate * wdt_dev->timeout,
@@ -157,8 +187,10 @@ static int armada370_start(struct watchdog_device *wdt_dev)
 	atomic_io_modify(dev->reg + TIMER_CTRL, dev->data->wdt_enable_bit,
 						dev->data->wdt_enable_bit);
 
-	atomic_io_modify(dev->rstout, dev->data->rstout_enable_bit,
-				      dev->data->rstout_enable_bit);
+	/* Enable reset on watchdog */
+	reg = readl(dev->rstout);
+	reg |= dev->data->rstout_enable_bit;
+	writel(reg, dev->rstout);
 	return 0;
 }
 
@@ -189,7 +221,7 @@ static int orion_wdt_start(struct watchdog_device *wdt_dev)
 	return dev->data->start(wdt_dev);
 }
 
-static int orion_wdt_stop(struct watchdog_device *wdt_dev)
+static int orion_stop(struct watchdog_device *wdt_dev)
 {
 	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
 
@@ -202,7 +234,48 @@ static int orion_wdt_stop(struct watchdog_device *wdt_dev)
 	return 0;
 }
 
-static int orion_wdt_enabled(struct orion_watchdog *dev)
+static int armada375_stop(struct watchdog_device *wdt_dev)
+{
+	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	/* Disable reset on watchdog */
+	atomic_io_modify(dev->rstout_mask, dev->data->rstout_mask_bit,
+					   dev->data->rstout_mask_bit);
+	reg = readl(dev->rstout);
+	reg &= ~dev->data->rstout_enable_bit;
+	writel(reg, dev->rstout);
+
+	/* Disable watchdog timer */
+	atomic_io_modify(dev->reg + TIMER_CTRL, dev->data->wdt_enable_bit, 0);
+
+	return 0;
+}
+
+static int armada370_stop(struct watchdog_device *wdt_dev)
+{
+	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+	u32 reg;
+
+	/* Disable reset on watchdog */
+	reg = readl(dev->rstout);
+	reg &= ~dev->data->rstout_enable_bit;
+	writel(reg, dev->rstout);
+
+	/* Disable watchdog timer */
+	atomic_io_modify(dev->reg + TIMER_CTRL, dev->data->wdt_enable_bit, 0);
+
+	return 0;
+}
+
+static int orion_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+
+	return dev->data->stop(wdt_dev);
+}
+
+static int orion_enabled(struct orion_watchdog *dev)
 {
 	bool enabled, running;
 
@@ -212,6 +285,24 @@ static int orion_wdt_enabled(struct orion_watchdog *dev)
 	return enabled && running;
 }
 
+static int armada375_enabled(struct orion_watchdog *dev)
+{
+	bool masked, enabled, running;
+
+	masked = readl(dev->rstout_mask) & dev->data->rstout_mask_bit;
+	enabled = readl(dev->rstout) & dev->data->rstout_enable_bit;
+	running = readl(dev->reg + TIMER_CTRL) & dev->data->wdt_enable_bit;
+
+	return !masked && enabled && running;
+}
+
+static int orion_wdt_enabled(struct watchdog_device *wdt_dev)
+{
+	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
+
+	return dev->data->enabled(dev);
+}
+
 static unsigned int orion_wdt_get_timeleft(struct watchdog_device *wdt_dev)
 {
 	struct orion_watchdog *dev = watchdog_get_drvdata(wdt_dev);
@@ -262,10 +353,6 @@ static void __iomem *orion_wdt_ioremap_rstout(struct platform_device *pdev,
 		return devm_ioremap(&pdev->dev, res->start,
 				    resource_size(res));
 
-	/* This workaround works only for "orion-wdt", DT-enabled */
-	if (!of_device_is_compatible(pdev->dev.of_node, "marvell,orion-wdt"))
-		return NULL;
-
 	rstout = internal_regs + ORION_RSTOUT_MASK_OFFSET;
 
 	WARN(1, FW_BUG "falling back to harcoded RSTOUT reg %pa\n", &rstout);
@@ -277,7 +364,9 @@ static const struct orion_watchdog_data orion_data = {
 	.wdt_enable_bit = BIT(4),
 	.wdt_counter_offset = 0x24,
 	.clock_init = orion_wdt_clock_init,
+	.enabled = orion_enabled,
 	.start = orion_start,
+	.stop = orion_stop,
 };
 
 static const struct orion_watchdog_data armada370_data = {
@@ -285,7 +374,9 @@ static const struct orion_watchdog_data armada370_data = {
 	.wdt_enable_bit = BIT(8),
 	.wdt_counter_offset = 0x34,
 	.clock_init = armada370_wdt_clock_init,
+	.enabled = orion_enabled,
 	.start = armada370_start,
+	.stop = armada370_stop,
 };
 
 static const struct orion_watchdog_data armadaxp_data = {
@@ -293,7 +384,31 @@ static const struct orion_watchdog_data armadaxp_data = {
 	.wdt_enable_bit = BIT(8),
 	.wdt_counter_offset = 0x34,
 	.clock_init = armadaxp_wdt_clock_init,
+	.enabled = orion_enabled,
 	.start = armada370_start,
+	.stop = armada370_stop,
+};
+
+static const struct orion_watchdog_data armada375_data = {
+	.rstout_enable_bit = BIT(8),
+	.rstout_mask_bit = BIT(10),
+	.wdt_enable_bit = BIT(8),
+	.wdt_counter_offset = 0x34,
+	.clock_init = armada370_wdt_clock_init,
+	.enabled = armada375_enabled,
+	.start = armada375_start,
+	.stop = armada375_stop,
+};
+
+static const struct orion_watchdog_data armada380_data = {
+	.rstout_enable_bit = BIT(8),
+	.rstout_mask_bit = BIT(10),
+	.wdt_enable_bit = BIT(8),
+	.wdt_counter_offset = 0x34,
+	.clock_init = armadaxp_wdt_clock_init,
+	.enabled = armada375_enabled,
+	.start = armada375_start,
+	.stop = armada375_stop,
 };
 
 static const struct of_device_id orion_wdt_of_match_table[] = {
@@ -309,16 +424,78 @@ static const struct of_device_id orion_wdt_of_match_table[] = {
 		.compatible = "marvell,armada-xp-wdt",
 		.data = &armadaxp_data,
 	},
+	{
+		.compatible = "marvell,armada-375-wdt",
+		.data = &armada375_data,
+	},
+	{
+		.compatible = "marvell,armada-380-wdt",
+		.data = &armada380_data,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, orion_wdt_of_match_table);
 
+static int orion_wdt_get_regs(struct platform_device *pdev,
+			      struct orion_watchdog *dev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	dev->reg = devm_ioremap(&pdev->dev, res->start,
+				resource_size(res));
+	if (!dev->reg)
+		return -ENOMEM;
+
+	/* Each supported compatible has some RSTOUT register quirk */
+	if (of_device_is_compatible(node, "marvell,orion-wdt")) {
+
+		dev->rstout = orion_wdt_ioremap_rstout(pdev, res->start &
+						       INTERNAL_REGS_MASK);
+		if (!dev->rstout)
+			return -ENODEV;
+
+	} else if (of_device_is_compatible(node, "marvell,armada-370-wdt") ||
+		   of_device_is_compatible(node, "marvell,armada-xp-wdt")) {
+
+		/* Dedicated RSTOUT register, can be requested. */
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		dev->rstout = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(dev->rstout))
+			return PTR_ERR(dev->rstout);
+
+	} else if (of_device_is_compatible(node, "marvell,armada-375-wdt") ||
+		   of_device_is_compatible(node, "marvell,armada-380-wdt")) {
+
+		/* Dedicated RSTOUT register, can be requested. */
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		dev->rstout = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(dev->rstout))
+			return PTR_ERR(dev->rstout);
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		if (!res)
+			return -ENODEV;
+		dev->rstout_mask = devm_ioremap(&pdev->dev, res->start,
+						resource_size(res));
+		if (!dev->rstout_mask)
+			return -ENOMEM;
+
+	} else {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int orion_wdt_probe(struct platform_device *pdev)
 {
 	struct orion_watchdog *dev;
 	const struct of_device_id *match;
 	unsigned int wdt_max_duration;	/* (seconds) */
-	struct resource *res;
 	int ret, irq;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(struct orion_watchdog),
@@ -336,19 +513,9 @@ static int orion_wdt_probe(struct platform_device *pdev)
 	dev->wdt.min_timeout = 1;
 	dev->data = match->data;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-	dev->reg = devm_ioremap(&pdev->dev, res->start,
-			       resource_size(res));
-	if (!dev->reg)
-		return -ENOMEM;
-
-	dev->rstout = orion_wdt_ioremap_rstout(pdev, res->start &
-						     INTERNAL_REGS_MASK);
-	if (!dev->rstout)
-		return -ENODEV;
+	ret = orion_wdt_get_regs(pdev, dev);
+	if (ret)
+		return ret;
 
 	ret = dev->data->clock_init(pdev, dev);
 	if (ret) {
@@ -371,7 +538,7 @@ static int orion_wdt_probe(struct platform_device *pdev)
 	 * removed and re-insterted, or if the bootloader explicitly
 	 * set a running watchdog before booting the kernel.
 	 */
-	if (!orion_wdt_enabled(dev))
+	if (!orion_wdt_enabled(&dev->wdt))
 		orion_wdt_stop(&dev->wdt);
 
 	/* Request the IRQ only after the watchdog is disabled */
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index d04d02b..061756e 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -282,8 +282,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	wdt->timer.data		= (unsigned long)wdt;
 	wdt->timer.expires	= next_ping_period(clock_division_ratio);
 
-	platform_set_drvdata(pdev, wdt);
-
 	dev_info(&pdev->dev, "initialized.\n");
 
 	pm_runtime_enable(&pdev->dev);
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 47629d2..c1b03f4 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -59,7 +59,6 @@
  * @adev: amba device structure of wdt
  * @status: current status of wdt
  * @load_val: load value to be set for current timeout
- * @timeout: current programmed timeout
  */
 struct sp805_wdt {
 	struct watchdog_device		wdd;
@@ -68,7 +67,6 @@ struct sp805_wdt {
 	struct clk			*clk;
 	struct amba_device		*adev;
 	unsigned int			load_val;
-	unsigned int			timeout;
 };
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -98,7 +96,7 @@ static int wdt_setload(struct watchdog_device *wdd, unsigned int timeout)
 	spin_lock(&wdt->lock);
 	wdt->load_val = load;
 	/* roundup timeout to closest positive integer value */
-	wdt->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
+	wdd->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
 	spin_unlock(&wdt->lock);
 
 	return 0;
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index cd00a78..693b9d2 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -57,17 +57,17 @@ struct sunxi_wdt_dev {
  */
 
 static const int wdt_timeout_map[] = {
-	[1] = 0b0001,  /* 1s  */
-	[2] = 0b0010,  /* 2s  */
-	[3] = 0b0011,  /* 3s  */
-	[4] = 0b0100,  /* 4s  */
-	[5] = 0b0101,  /* 5s  */
-	[6] = 0b0110,  /* 6s  */
-	[8] = 0b0111,  /* 8s  */
-	[10] = 0b1000, /* 10s */
-	[12] = 0b1001, /* 12s */
-	[14] = 0b1010, /* 14s */
-	[16] = 0b1011, /* 16s */
+	[1] = 0x1,  /* 1s  */
+	[2] = 0x2,  /* 2s  */
+	[3] = 0x3,  /* 3s  */
+	[4] = 0x4,  /* 4s  */
+	[5] = 0x5,  /* 5s  */
+	[6] = 0x6,  /* 6s  */
+	[8] = 0x7,  /* 8s  */
+	[10] = 0x8, /* 10s */
+	[12] = 0x9, /* 12s */
+	[14] = 0xA, /* 14s */
+	[16] = 0xB, /* 16s */
 };
 
 static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index d2cd9f0..56369c4 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -232,7 +232,7 @@ err_out_disable_device:
 static void wdt_remove(struct pci_dev *pdev)
 {
 	watchdog_unregister_device(&wdt_dev);
-	del_timer(&timer);
+	del_timer_sync(&timer);
 	iounmap(wdt_mem);
 	release_mem_region(mmio, VIA_WDT_MMIO_LEN);
 	release_resource(&wdt_res);
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index b1da0c1..7165704 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -64,6 +64,10 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static int early_disable;
+module_param(early_disable, int, 0);
+MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=0)");
+
 /*
  *	Kernel methods.
  */
@@ -208,9 +212,14 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 
 	t = superio_inb(cr_wdt_timeout);
 	if (t != 0) {
-		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
-			wdog->timeout);
-		superio_outb(cr_wdt_timeout, wdog->timeout);
+		if (early_disable) {
+			pr_warn("Stopping previously enabled watchdog until userland kicks in\n");
+			superio_outb(cr_wdt_timeout, 0);
+		} else {
+			pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+				wdog->timeout);
+			superio_outb(cr_wdt_timeout, wdog->timeout);
+		}
 	}
 
 	/* set second mode & disable keyboard turning off watchdog */
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
deleted file mode 100644
index e9ea856..0000000
--- a/drivers/watchdog/w83697hf_wdt.c
+++ /dev/null
@@ -1,460 +0,0 @@
-/*
- *	w83697hf/hg WDT driver
- *
- *	(c) Copyright 2006 Samuel Tardieu <sam@rfc1149.net>
- *	(c) Copyright 2006 Marcus Junker <junker@anduras.de>
- *
- *	Based on w83627hf_wdt.c which is based on advantechwdt.c
- *	which is based on wdt.c.
- *	Original copyright messages:
- *
- *	(c) Copyright 2003 Pádraig Brady <P@draigBrady.com>
- *
- *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
- *
- *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
- *						All Rights Reserved.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	Neither Marcus Junker nor ANDURAS AG admit liability nor provide
- *	warranty for any of this software. This material is provided
- *	"AS-IS" and at no charge.
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
-#include <linux/ioport.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-
-
-#define WATCHDOG_NAME "w83697hf/hg WDT"
-#define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
-#define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
-
-static unsigned long wdt_is_open;
-static char expect_close;
-static DEFINE_SPINLOCK(io_lock);
-
-/* You must set this - there is no sane way to probe for this board. */
-static int wdt_io = 0x2e;
-module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io,
-		"w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)");
-
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
-module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in seconds. 1<= timeout <=255 (default="
-				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-	"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-static int early_disable = WATCHDOG_EARLY_DISABLE;
-module_param(early_disable, int, 0);
-MODULE_PARM_DESC(early_disable,
-	"Watchdog gets disabled at boot time (default="
-				__MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
-
-/*
- *	Kernel methods.
- */
-
-#define W83697HF_EFER (wdt_io + 0)  /* Extended Function Enable Register */
-#define W83697HF_EFIR (wdt_io + 0)  /* Extended Function Index Register
-							(same as EFER) */
-#define W83697HF_EFDR (wdt_io + 1)  /* Extended Function Data Register */
-
-static inline void w83697hf_unlock(void)
-{
-	outb_p(0x87, W83697HF_EFER);	/* Enter extended function mode */
-	outb_p(0x87, W83697HF_EFER);	/* Again according to manual */
-}
-
-static inline void w83697hf_lock(void)
-{
-	outb_p(0xAA, W83697HF_EFER);	/* Leave extended function mode */
-}
-
-/*
- *	The three functions w83697hf_get_reg(), w83697hf_set_reg() and
- *	w83697hf_write_timeout() must be called with the device unlocked.
- */
-
-static unsigned char w83697hf_get_reg(unsigned char reg)
-{
-	outb_p(reg, W83697HF_EFIR);
-	return inb_p(W83697HF_EFDR);
-}
-
-static void w83697hf_set_reg(unsigned char reg, unsigned char data)
-{
-	outb_p(reg, W83697HF_EFIR);
-	outb_p(data, W83697HF_EFDR);
-}
-
-static void w83697hf_write_timeout(int timeout)
-{
-	/* Write Timeout counter to CRF4 */
-	w83697hf_set_reg(0xF4, timeout);
-}
-
-static void w83697hf_select_wdt(void)
-{
-	w83697hf_unlock();
-	w83697hf_set_reg(0x07, 0x08);	/* Switch to logic device 8 (GPIO2) */
-}
-
-static inline void w83697hf_deselect_wdt(void)
-{
-	w83697hf_lock();
-}
-
-static void w83697hf_init(void)
-{
-	unsigned char bbuf;
-
-	w83697hf_select_wdt();
-
-	bbuf = w83697hf_get_reg(0x29);
-	bbuf &= ~0x60;
-	bbuf |= 0x20;
-
-	/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
-	w83697hf_set_reg(0x29, bbuf);
-
-	bbuf = w83697hf_get_reg(0xF3);
-	bbuf &= ~0x04;
-	w83697hf_set_reg(0xF3, bbuf);	/* Count mode is seconds */
-
-	w83697hf_deselect_wdt();
-}
-
-static void wdt_ping(void)
-{
-	spin_lock(&io_lock);
-	w83697hf_select_wdt();
-
-	w83697hf_write_timeout(timeout);
-
-	w83697hf_deselect_wdt();
-	spin_unlock(&io_lock);
-}
-
-static void wdt_enable(void)
-{
-	spin_lock(&io_lock);
-	w83697hf_select_wdt();
-
-	w83697hf_write_timeout(timeout);
-	w83697hf_set_reg(0x30, 1);	/* Enable timer */
-
-	w83697hf_deselect_wdt();
-	spin_unlock(&io_lock);
-}
-
-static void wdt_disable(void)
-{
-	spin_lock(&io_lock);
-	w83697hf_select_wdt();
-
-	w83697hf_set_reg(0x30, 0);	/* Disable timer */
-	w83697hf_write_timeout(0);
-
-	w83697hf_deselect_wdt();
-	spin_unlock(&io_lock);
-}
-
-static unsigned char wdt_running(void)
-{
-	unsigned char t;
-
-	spin_lock(&io_lock);
-	w83697hf_select_wdt();
-
-	t = w83697hf_get_reg(0xF4);	/* Read timer */
-
-	w83697hf_deselect_wdt();
-	spin_unlock(&io_lock);
-
-	return t;
-}
-
-static int wdt_set_heartbeat(int t)
-{
-	if (t < 1 || t > 255)
-		return -EINVAL;
-
-	timeout = t;
-	return 0;
-}
-
-static ssize_t wdt_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
-{
-	if (count) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		wdt_ping();
-	}
-	return count;
-}
-
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
-							| WDIOF_MAGICCLOSE,
-		.firmware_version = 1,
-		.identity = "W83697HF WDT",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_SETOPTIONS:
-	{
-		int options, retval = -EINVAL;
-
-		if (get_user(options, p))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD) {
-			wdt_disable();
-			retval = 0;
-		}
-
-		if (options & WDIOS_ENABLECARD) {
-			wdt_enable();
-			retval = 0;
-		}
-
-		return retval;
-	}
-
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if (wdt_set_heartbeat(new_timeout))
-			return -EINVAL;
-		wdt_ping();
-		/* Fall */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-
-	default:
-		return -ENOTTY;
-	}
-	return 0;
-}
-
-static int wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-	/*
-	 *	Activate
-	 */
-
-	wdt_enable();
-	return nonseekable_open(inode, file);
-}
-
-static int wdt_close(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42)
-		wdt_disable();
-	else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		wdt_ping();
-	}
-	expect_close = 0;
-	clear_bit(0, &wdt_is_open);
-	return 0;
-}
-
-/*
- *	Notifier for system down
- */
-
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_disable();	/* Turn the WDT off */
-
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= wdt_write,
-	.unlocked_ioctl	= wdt_ioctl,
-	.open		= wdt_open,
-	.release	= wdt_close,
-};
-
-static struct miscdevice wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wdt_fops,
-};
-
-/*
- *	The WDT needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
- */
-
-static struct notifier_block wdt_notifier = {
-	.notifier_call = wdt_notify_sys,
-};
-
-static int w83697hf_check_wdt(void)
-{
-	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		pr_err("I/O address 0x%x already in use\n", wdt_io);
-		return -EIO;
-	}
-
-	pr_debug("Looking for watchdog at address 0x%x\n", wdt_io);
-	w83697hf_unlock();
-	if (w83697hf_get_reg(0x20) == 0x60) {
-		pr_info("watchdog found at address 0x%x\n", wdt_io);
-		w83697hf_lock();
-		return 0;
-	}
-	/* Reprotect in case it was a compatible device */
-	w83697hf_lock();
-
-	pr_info("watchdog not found at address 0x%x\n", wdt_io);
-	release_region(wdt_io, 2);
-	return -EIO;
-}
-
-static int w83697hf_ioports[] = { 0x2e, 0x4e, 0x00 };
-
-static int __init wdt_init(void)
-{
-	int ret, i, found = 0;
-
-	pr_info("WDT driver for W83697HF/HG initializing\n");
-
-	if (wdt_io == 0) {
-		/* we will autodetect the W83697HF/HG watchdog */
-		for (i = 0; ((!found) && (w83697hf_ioports[i] != 0)); i++) {
-			wdt_io = w83697hf_ioports[i];
-			if (!w83697hf_check_wdt())
-				found++;
-		}
-	} else {
-		if (!w83697hf_check_wdt())
-			found++;
-	}
-
-	if (!found) {
-		pr_err("No W83697HF/HG could be found\n");
-		ret = -ENODEV;
-		goto out;
-	}
-
-	w83697hf_init();
-	if (early_disable) {
-		if (wdt_running())
-			pr_warn("Stopping previously enabled watchdog until userland kicks in\n");
-		wdt_disable();
-	}
-
-	if (wdt_set_heartbeat(timeout)) {
-		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
-			WATCHDOG_TIMEOUT);
-	}
-
-	ret = register_reboot_notifier(&wdt_notifier);
-	if (ret != 0) {
-		pr_err("cannot register reboot notifier (err=%d)\n", ret);
-		goto unreg_regions;
-	}
-
-	ret = misc_register(&wdt_miscdev);
-	if (ret != 0) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
-		goto unreg_reboot;
-	}
-
-	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
-
-out:
-	return ret;
-unreg_reboot:
-	unregister_reboot_notifier(&wdt_notifier);
-unreg_regions:
-	release_region(wdt_io, 2);
-	goto out;
-}
-
-static void __exit wdt_exit(void)
-{
-	misc_deregister(&wdt_miscdev);
-	unregister_reboot_notifier(&wdt_notifier);
-	release_region(wdt_io, 2);
-}
-
-module_init(wdt_init);
-module_exit(wdt_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marcus Junker <junker@anduras.de>");
-MODULE_AUTHOR("Samuel Tardieu <sam@rfc1149.net>");
-MODULE_DESCRIPTION("w83697hf/hg WDT driver");
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
deleted file mode 100644
index ff58cb7..0000000
--- a/drivers/watchdog/w83697ug_wdt.c
+++ /dev/null
@@ -1,397 +0,0 @@
-/*
- *	w83697ug/uf WDT driver
- *
- *	(c) Copyright 2008 Flemming Fransen <ff@nrvissing.net>
- *		reused original code to support w83697ug/uf.
- *
- *	Based on w83627hf_wdt.c which is based on advantechwdt.c
- *	which is based on wdt.c.
- *	Original copyright messages:
- *
- *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
- *		added support for W83627THF.
- *
- *	(c) Copyright 2003 Pádraig Brady <P@draigBrady.com>
- *
- *	(c) Copyright 2000-2001 Marek Michalkiewicz <marekm@linux.org.pl>
- *
- *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
- *				http://www.redhat.com
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
- *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
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
-#include <linux/ioport.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-
-
-#define WATCHDOG_NAME "w83697ug/uf WDT"
-#define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
-
-static unsigned long wdt_is_open;
-static char expect_close;
-static DEFINE_SPINLOCK(io_lock);
-
-static int wdt_io = 0x2e;
-module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83697ug/uf WDT io port (default 0x2e)");
-
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
-module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in seconds. 1<= timeout <=255 (default="
-				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-	"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/*
- *	Kernel methods.
- */
-
-#define WDT_EFER (wdt_io+0)   /* Extended Function Enable Registers */
-#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register
-							(same as EFER) */
-#define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
-
-static int w83697ug_select_wd_register(void)
-{
-	unsigned char c;
-	unsigned char version;
-
-	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
-	outb_p(0x87, WDT_EFER); /* Again according to manual */
-
-	outb(0x20, WDT_EFER);	/* check chip version	*/
-	version = inb(WDT_EFDR);
-
-	if (version == 0x68) {	/* W83697UG		*/
-		pr_info("Watchdog chip version 0x%02x = W83697UG/UF found at 0x%04x\n",
-			version, wdt_io);
-
-		outb_p(0x2b, WDT_EFER);
-		c = inb_p(WDT_EFDR);    /* select WDT0 */
-		c &= ~0x04;
-		outb_p(0x2b, WDT_EFER);
-		outb_p(c, WDT_EFDR);	/* set pin118 to WDT0 */
-
-	} else {
-		pr_err("No W83697UG/UF could be found\n");
-		return -ENODEV;
-	}
-
-	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
-	outb_p(0x08, WDT_EFDR); /* select logical device 8 (GPIO2) */
-	outb_p(0x30, WDT_EFER); /* select CR30 */
-	c = inb_p(WDT_EFDR);
-	outb_p(c | 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
-
-	return 0;
-}
-
-static void w83697ug_unselect_wd_register(void)
-{
-	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
-}
-
-static int w83697ug_init(void)
-{
-	int ret;
-	unsigned char t;
-
-	ret = w83697ug_select_wd_register();
-	if (ret != 0)
-		return ret;
-
-	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
-	t = inb_p(WDT_EFDR);    /* read CRF6 */
-	if (t != 0) {
-		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
-			timeout);
-		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
-	}
-	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
-	t = inb_p(WDT_EFDR);    /* read CRF5 */
-	t &= ~0x0C;             /* set second mode &
-					disable keyboard turning off watchdog */
-	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
-
-	w83697ug_unselect_wd_register();
-	return 0;
-}
-
-static void wdt_ctrl(int timeout)
-{
-	spin_lock(&io_lock);
-
-	if (w83697ug_select_wd_register() < 0) {
-		spin_unlock(&io_lock);
-		return;
-	}
-
-	outb_p(0xF4, WDT_EFER);    /* Select CRF4 */
-	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF4 */
-
-	w83697ug_unselect_wd_register();
-
-	spin_unlock(&io_lock);
-}
-
-static int wdt_ping(void)
-{
-	wdt_ctrl(timeout);
-	return 0;
-}
-
-static int wdt_disable(void)
-{
-	wdt_ctrl(0);
-	return 0;
-}
-
-static int wdt_set_heartbeat(int t)
-{
-	if (t < 1 || t > 255)
-		return -EINVAL;
-
-	timeout = t;
-	return 0;
-}
-
-static ssize_t wdt_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
-{
-	if (count) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		wdt_ping();
-	}
-	return count;
-}
-
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_KEEPALIVEPING |
-					WDIOF_SETTIMEOUT |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	1,
-		.identity =		"W83697UG WDT",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof(ident)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_SETOPTIONS:
-	{
-		int options, retval = -EINVAL;
-
-		if (get_user(options, p))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD) {
-			wdt_disable();
-			retval = 0;
-		}
-
-		if (options & WDIOS_ENABLECARD) {
-			wdt_ping();
-			retval = 0;
-		}
-
-		return retval;
-	}
-
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if (wdt_set_heartbeat(new_timeout))
-			return -EINVAL;
-		wdt_ping();
-		/* Fall */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-
-	default:
-		return -ENOTTY;
-	}
-	return 0;
-}
-
-static int wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-	/*
-	 *	Activate
-	 */
-
-	wdt_ping();
-	return nonseekable_open(inode, file);
-}
-
-static int wdt_close(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42)
-		wdt_disable();
-	else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		wdt_ping();
-	}
-	expect_close = 0;
-	clear_bit(0, &wdt_is_open);
-	return 0;
-}
-
-/*
- *	Notifier for system down
- */
-
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_disable();	/* Turn the WDT off */
-
-	return NOTIFY_DONE;
-}
-
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= wdt_write,
-	.unlocked_ioctl	= wdt_ioctl,
-	.open		= wdt_open,
-	.release	= wdt_close,
-};
-
-static struct miscdevice wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wdt_fops,
-};
-
-/*
- *	The WDT needs to learn about soft shutdowns in order to
- *	turn the timebomb registers off.
- */
-
-static struct notifier_block wdt_notifier = {
-	.notifier_call = wdt_notify_sys,
-};
-
-static int __init wdt_init(void)
-{
-	int ret;
-
-	pr_info("WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising\n");
-
-	if (wdt_set_heartbeat(timeout)) {
-		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info("timeout value must be 1<=timeout<=255, using %d\n",
-			WATCHDOG_TIMEOUT);
-	}
-
-	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		pr_err("I/O address 0x%04x already in use\n", wdt_io);
-		ret = -EIO;
-		goto out;
-	}
-
-	ret = w83697ug_init();
-	if (ret != 0)
-		goto unreg_regions;
-
-	ret = register_reboot_notifier(&wdt_notifier);
-	if (ret != 0) {
-		pr_err("cannot register reboot notifier (err=%d)\n", ret);
-		goto unreg_regions;
-	}
-
-	ret = misc_register(&wdt_miscdev);
-	if (ret != 0) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
-		goto unreg_reboot;
-	}
-
-	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
-
-out:
-	return ret;
-unreg_reboot:
-	unregister_reboot_notifier(&wdt_notifier);
-unreg_regions:
-	release_region(wdt_io, 1);
-	goto out;
-}
-
-static void __exit wdt_exit(void)
-{
-	misc_deregister(&wdt_miscdev);
-	unregister_reboot_notifier(&wdt_notifier);
-	release_region(wdt_io, 1);
-}
-
-module_init(wdt_init);
-module_exit(wdt_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Flemming Frandsen <ff@nrvissing.net>");
-MODULE_DESCRIPTION("w83697ug/uf WDT driver");
diff --git a/include/linux/platform_data/intel-mid_wdt.h b/include/linux/platform_data/intel-mid_wdt.h
new file mode 100644
index 0000000..b982534
--- /dev/null
+++ b/include/linux/platform_data/intel-mid_wdt.h
@@ -0,0 +1,22 @@
+/*
+ *      intel-mid_wdt: generic Intel MID SCU watchdog driver
+ *
+ *      Copyright (C) 2014 Intel Corporation. All rights reserved.
+ *      Contact: David Cohen <david.a.cohen@linux.intel.com>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ */
+
+#ifndef __INTEL_MID_WDT_H__
+#define __INTEL_MID_WDT_H__
+
+#include <linux/platform_device.h>
+
+struct intel_mid_wdt_pdata {
+	int irq;
+	int (*probe)(struct platform_device *pdev);
+};
+
+#endif /*__INTEL_MID_WDT_H__*/
