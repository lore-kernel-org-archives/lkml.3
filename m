Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3DWNVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:21:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab3DWNUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:20:54 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] OMAP: fix boot sequence
Date: Tue, 23 Apr 2013 16:19:08 +0300
Message-ID: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

There are two public discussions now related to OMAP boot and drivers
initialization issues:
"Multiple issues with omap4 panda es in linux next"
  http://www.spinics.net/lists/linux-omap/msg90241.html
"[BUG] omap: mfd/regulator: twl/core: init order"
  http://www.spinics.net/lists/linux-omap/msg89980.html

In both cases there are pinctrl-single/I2C/MFD/Regulators initailization issue:
- regulators are not initialized because of twl,
- twl is not initialized because of I2C,
- I2C is not initialized because of pinctrl-single,
- pinctrl-single is initialized at mudule/device init time.
So, most everything will be shifted at late_initcall time. 

This may cause boot delay (more over, it can broken initialization of drivers
which are not ready to use deferred probe mechanism yet, for example DSS).

Introduced pathes shift I2C and TWL iniialization to module/device init layer
instead of subsys init layer where initialization dependencies resolved
indirectly in drivers/Makefile now.

Grygorii Strashko (2):
  i2c: omap: convert to module_platform_driver()
  mfd: twl-core: convert to module_i2c_driver()

 drivers/i2c/busses/i2c-omap.c |   14 +-------------
 drivers/mfd/twl-core.c        |   12 +-----------
 2 files changed, 2 insertions(+), 24 deletions(-)

Regards,
-grygorii

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

-- 
1.7.9.5

