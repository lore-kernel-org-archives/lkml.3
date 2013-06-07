Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3FGSuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:50:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38349 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab3FGSt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:49:58 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, Nishanth Menon <nm@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 1/5] i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle
Date: Fri, 7 Jun 2013 21:46:04 +0300
Message-ID: <1370630768-4077-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

Currently, runtime PM is used to keep the device enabled only during
active transfers and for a configurable runtime PM autosuspend timout
after an xfer.

In addition to idling the device, driver's ->runtime_suspend() method
currently disables device interrupts when idle.  However, on some SoCs
(notably OMAP4+), the I2C hardware may shared with other coprocessors.
This means that the MPU will still recieve interrupts if a coprocessor
is using the I2C device.  To avoid this, also disable interrupts at
the MPU INTC when idling the device in ->runtime_suspend() (and
re-enable them in ->runtime_resume().)  This part based on an original
patch from Shubhrajyoti Datta.  NOTE: for proper sharing the I2C with
a coprocessor, this driver still needs hwspinlock support added.

More over, this patch fixes the kernel boot failure which happens when
CONFIG_SENSORS_LM75=y:

[    2.251220] WARNING: at drivers/bus/omap_l3_noc.c:113 l3_interrupt_handler+0x140/0x184()
[    2.257781] L3 custom error: MASTER:MPU TARGET:L4 PER2
[    2.264373] Modules linked in:
[    2.268463] CPU: 0 PID: 2 Comm: kthreadd Not tainted 3.10.0-rc4-00034-g042dd60-dirty #64
[    2.270385] [<c001a80c>] (unwind_backtrace+0x0/0xf0) from [<c0017238>] (show_stack+0x10/0x14)
[    2.286102] [<c0017238>] (show_stack+0x10/0x14) from [<c0040fd0>] (warn_slowpath_common+0x4c/0x68)
[    2.295593] [<c0040fd0>] (warn_slowpath_common+0x4c/0x68) from [<c0041080>] (warn_slowpath_fmt+0x30/0x40)
[    2.299987] [<c0041080>] (warn_slowpath_fmt+0x30/0x40) from [<c02c5ed0>] (l3_interrupt_handler+0x140/0x184)
[    2.315582] [<c02c5ed0>] (l3_interrupt_handler+0x140/0x184) from [<c009ffb8>] (handle_irq_event_percpu+0x58/0x258)
[    2.323364] [<c009ffb8>] (handle_irq_event_percpu+0x58/0x258) from [<c00a01f4>] (handle_irq_event+0x3c/0x5c)
[    2.327819] [<c00a01f4>] (handle_irq_event+0x3c/0x5c) from [<c00a2f7c>] (handle_fasteoi_irq+0xbc/0x164)
[    2.337829] [<c00a2f7c>] (handle_fasteoi_irq+0xbc/0x164) from [<c009f978>] (generic_handle_irq+0x20/0x30)
[    2.357513] [<c009f978>] (generic_handle_irq+0x20/0x30) from [<c0014168>] (handle_IRQ+0x4c/0xac)
[    2.366821] [<c0014168>] (handle_IRQ+0x4c/0xac) from [<c00085b4>] (gic_handle_irq+0x28/0x5c)
[    2.375762] [<c00085b4>] (gic_handle_irq+0x28/0x5c) from [<c04f08a4>] (__irq_svc+0x44/0x5c)
[    2.379821] Exception stack(0xdb085ec0 to 0xdb085f08)
[    2.389953] 5ec0: 00000001 00000001 00000000 db07ea00 40000113 db2317a8 db084000 000002f1
[    2.389953] 5ee0: db07ea00 00000000 00000000 00000000 c04fd990 db085f08 c009170c c04f03e8
[    2.405609] 5f00: 20000113 ffffffff
[    2.408355] [<c04f08a4>] (__irq_svc+0x44/0x5c) from [<c04f03e8>] (_raw_spin_unlock_irqrestore+0x34/0x44)
[    2.418304] [<c04f03e8>] (_raw_spin_unlock_irqrestore+0x34/0x44) from [<c00403c0>] (do_fork+0xa4/0x2d4)
[    2.427795] [<c00403c0>] (do_fork+0xa4/0x2d4) from [<c0040620>] (kernel_thread+0x30/0x38)
[    2.437805] [<c0040620>] (kernel_thread+0x30/0x38) from [<c0063888>] (kthreadd+0xd4/0x13c)
[    2.448364] [<c0063888>] (kthreadd+0xd4/0x13c) from [<c0013308>] (ret_from_fork+0x14/0x2c)
[    2.448364] ---[ end trace da8cf92c433d1616 ]---

The root casue of crash is race between omap_i2c_runtime_suspend()
 and omap_i2c_isr_thread()

CPU1:                                   CPU2:
|-omap_i2c_xfer                         |
  |- pm_runtime_put_autosuspend()       |
     |-timeout                          |-omap_i2c_isr()
                                          |-return IRQ_WAKE_THREAD;
     |-omap_i2c_runtime_suspend()       |
                                        |-omap_i2c_isr_thread()
                                          |- oops is here - I2C module is in idle state


Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 64c26f9..97844ff 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1290,6 +1290,8 @@ static int omap_i2c_runtime_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
 
+	disable_irq(_dev->irq);
+
 	_dev->iestate = omap_i2c_read_reg(_dev, OMAP_I2C_IE_REG);
 
 	if (_dev->scheme == OMAP_I2C_SCHEME_0)
@@ -1320,6 +1322,8 @@ static int omap_i2c_runtime_resume(struct device *dev)
 
 	__omap_i2c_init(_dev);
 
+	enable_irq(_dev->irq);
+
 	return 0;
 }
 #endif /* CONFIG_PM_RUNTIME */
-- 
1.7.9.5

