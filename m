Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKQRCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:02:07 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61681 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaKQRCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:02:04 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
Date: Mon, 17 Nov 2014 20:01:57 +0300
Cc: Alexander Kochetkov <al.kochet@gmail.com>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0BF04865-FCD6-4220-94BF-A0BFC83F0F4B@gmail.com>
References: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's RESEND

Previous one patch was:
i2c: omap: fix NACK and Arbitration Lost irq handling
http://www.spinics.net/lists/linux-i2c/msg17490.html

I'll made more testing of current (linux/master) i2c driver (without my patch) and here I
send test results.

For traces I used custom patch attached to the e-mail.

For simulating I2C bus conditions, I used simple MCU connected to Beagleboard 
using I2C bus. MCU can act as slave and as master, and Beagleboard can instruct MCU
to setup special conditions on the bus.

I used oscilloscope to control signals on wire.

The results indicates what:
1. current i2c driver actually doesn't cause controller hang and client code segfaults.
   (my previous patch incorrectly blame that)

2. it looks, that current i2c, doesn't strictly follow TI specs (AM-DM37x Multimedia Device 
   Silicon Revision 1.x  - sprugn4r, Figure 17-31. HS I2C Master Transmitter Mode ... and
   Figure 17-32. HS I2C Master Receiver Mode ..., note 1)
   
3. current i2c driver keeps processing interrupts after it call omap_i2c_complete_cmd.
4. in NACK case current driver call omap_i2c_complete_cmd two times.

The patch fixes 2, 3, 4.

Here how spotted problems looks like.

i2c controller initiate master write transfer to slave device what doesn't exist on the i2c bus.
(isr thread keeps processing interrupts (ARDY) after it signaled transfer completion, and call complete second time)
=========================
[ 2481.152770] omap_i2c omap_i2c.2: addr: 0x0068, len: 4, flags: 0x0, stop: 1
[ 2481.152801] omap_i2c omap_i2c.2: Pre submit: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:584)
[ 2481.152832] omap_i2c omap_i2c.2: Hard ISR: STAT=0x1110; IE=0x601f; CON=0x8602 (omap_i2c_isr:911)
[ 2481.152862] omap_i2c omap_i2c.2: Post submit: STAT=0x1110; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:586)
[ 2481.152893] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1110; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:615)
[ 2481.152923] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1112; IE=0x601f; CON=0x8602 (omap_i2c_isr_thread:936)
[ 2481.152954] omap_i2c omap_i2c.2: IRQ (ISR = 0x0012)
[ 2481.152954] omap_i2c omap_i2c.2: Complete: STAT=0x0114; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 2481.152984] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0114; IE=0x601f; CON=0x8200 (omap_i2c_isr:911)
[ 2481.153015] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0114; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 2481.153015] omap_i2c omap_i2c.2: IRQ (ISR = 0x0014)
[ 2481.153045] omap_i2c omap_i2c.2: Complete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 2481.153106] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:618)
[ 2481.153106] omap_i2c omap_i2c.2: Got NACK - send STP: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:642)

i2c controller initiate master read transfer to slave device what doesn't exist on the i2c bus.
(isr thread keeps processing interrupts (ARDY) after it signaled transfer completion, and call complete second time)
=========================
[ 3201.693603] omap_i2c omap_i2c.2: addr: 0x0068, len: 4, flags: 0x1, stop: 1
[ 3201.693603] omap_i2c omap_i2c.2: Pre submit: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:584)
[ 3201.693634] omap_i2c omap_i2c.2: Post submit: STAT=0x0100; IE=0x601f; CON=0x8403 (omap_i2c_xfer_msg:586)
[ 3201.693634] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1100; IE=0x601f; CON=0x8402 (omap_i2c_xfer_msg:615)
[ 3201.693756] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0106; IE=0x601f; CON=0x8000 (omap_i2c_isr:911)
[ 3201.693847] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0106; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:936)
[ 3201.693847] omap_i2c omap_i2c.2: IRQ (ISR = 0x0006)
[ 3201.693878] omap_i2c omap_i2c.2: Complete: STAT=0x0104; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:1055)
[ 3201.693908] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0104; IE=0x601f; CON=0x8000 (omap_i2c_isr:911)
[ 3201.693908] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0104; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:936)
[ 3201.693939] omap_i2c omap_i2c.2: IRQ (ISR = 0x0004)
[ 3201.693939] omap_i2c omap_i2c.2: Complete: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:1055)
[ 3201.693969] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:618)
[ 3201.694000] omap_i2c omap_i2c.2: Got NACK - send STP: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:642)

i2c controller initiate master write transfer to slave device and get NACK on the second data byte (address and first data bytes
transmit successfully).
(isr thread keeps processing interrupts (ARDY) after it signaled transfer completion, and call complete second time)
=========================
[ 3457.679901] omap_i2c omap_i2c.2: addr: 0x0058, len: 4, flags: 0x0, stop: 1
[ 3457.679931] omap_i2c omap_i2c.2: Pre submit: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:584)
[ 3457.679962] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0110; IE=0x601f; CON=0x8602 (omap_i2c_isr:911)
[ 3457.679992] omap_i2c omap_i2c.2: Post submit: STAT=0x1110; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:586)
[ 3457.680175] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1510; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:615)
[ 3457.680236] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1510; IE=0x601f; CON=0x8602 (omap_i2c_isr_thread:936)
[ 3457.680267] omap_i2c omap_i2c.2: IRQ (ISR = 0x0010)
[ 3457.680267] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1100; IE=0x601f; CON=0x8602 (omap_i2c_isr_thread:936)
[ 3457.680480] omap_i2c omap_i2c.2: Hard ISR: STAT=0x1102; IE=0x601f; CON=0x8602 (omap_i2c_isr:911)
[ 3457.680603] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0106; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 3457.680603] omap_i2c omap_i2c.2: IRQ (ISR = 0x0006)
[ 3457.680633] omap_i2c omap_i2c.2: Complete: STAT=0x0104; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 3457.680664] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0104; IE=0x601f; CON=0x8200 (omap_i2c_isr:911)
[ 3457.680694] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0104; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 3457.680694] omap_i2c omap_i2c.2: IRQ (ISR = 0x0004)
[ 3457.680694] omap_i2c omap_i2c.2: Complete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 3457.683288] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:618)
[ 3457.683319] omap_i2c omap_i2c.2: Got NACK - send STP: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:642)

i2c controller initiate master write transfer to slave device and get AL during address phase
(isr thread keeps processing interrupts (XRDY) after it signaled transfer completion)
=========================
[ 3969.863067] omap_i2c omap_i2c.2: addr: 0x0058, len: 4, flags: 0x0, stop: 1
[ 3969.863067] omap_i2c omap_i2c.2: Pre submit: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:584)
[ 3969.863098] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0110; IE=0x601f; CON=0x8602 (omap_i2c_isr:911)
[ 3969.863128] omap_i2c omap_i2c.2: Post submit: STAT=0x1111; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:586)
[ 3969.863128] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1111; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:615)
[ 3969.863159] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1111; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 3969.863189] omap_i2c omap_i2c.2: IRQ (ISR = 0x0011)
[ 3969.863189] omap_i2c omap_i2c.2: Arbitration lost
[ 3969.868103] omap_i2c omap_i2c.2: Complete: STAT=0x0110; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 3969.868316] omap_i2c omap_i2c.2: Hard ISR: STAT=0x0110; IE=0x601f; CON=0x8200 (omap_i2c_isr:911)
[ 3969.868347] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0110; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 3969.868347] omap_i2c omap_i2c.2: IRQ (ISR = 0x0010)
[ 3969.868377] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 3969.875518] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:618)
[ 3969.875549] omap_i2c omap_i2c.2: Got AL - i2c reset: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:632)

i2c controller initiate master read transfer to slave device and get AL during address phase.
(that case works as expected)
=========================
[ 4136.002380] omap_i2c omap_i2c.2: addr: 0x0058, len: 4, flags: 0x1, stop: 1
[ 4136.002380] omap_i2c omap_i2c.2: Pre submit: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:584)
[ 4136.002410] omap_i2c omap_i2c.2: Post submit: STAT=0x0100; IE=0x601f; CON=0x8403 (omap_i2c_xfer_msg:586)
[ 4136.002410] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1100; IE=0x601f; CON=0x8402 (omap_i2c_xfer_msg:615)
[ 4136.002593] omap_i2c omap_i2c.2: Hard ISR: STAT=0x1101; IE=0x601f; CON=0x8000 (omap_i2c_isr:911)
[ 4136.002655] omap_i2c omap_i2c.2: Thread ISR: STAT=0x0101; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:936)
[ 4136.002655] omap_i2c omap_i2c.2: IRQ (ISR = 0x0001)
[ 4136.002655] omap_i2c omap_i2c.2: Arbitration lost
[ 4136.007598] omap_i2c omap_i2c.2: Complete: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_isr_thread:1055)
[ 4136.009674] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:618)
[ 4136.009704] omap_i2c omap_i2c.2: Got AL - i2c reset: STAT=0x0100; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:632)

i2c controller initiate master write transfer to slave device and get AL on the second data byte (address and first data bytes
transmit successfully).
(that case works as expected)
=========================
[ 4303.387481] omap_i2c omap_i2c.2: addr: 0x0058, len: 4, flags: 0x0, stop: 1
[ 4303.387512] omap_i2c omap_i2c.2: Pre submit: STAT=0x0000; IE=0x601f; CON=0x8000 (omap_i2c_xfer_msg:584)
[ 4303.387542] omap_i2c omap_i2c.2: Hard ISR: STAT=0x1010; IE=0x601f; CON=0x8602 (omap_i2c_isr:911)
[ 4303.387573] omap_i2c omap_i2c.2: Post submit: STAT=0x1010; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:586)
[ 4303.387603] omap_i2c omap_i2c.2: Wait comlete: STAT=0x1010; IE=0x601f; CON=0x8602 (omap_i2c_xfer_msg:615)
[ 4303.387664] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1410; IE=0x601f; CON=0x8602 (omap_i2c_isr_thread:936)
[ 4303.387664] omap_i2c omap_i2c.2: IRQ (ISR = 0x0010)
[ 4303.387695] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1400; IE=0x601f; CON=0x8602 (omap_i2c_isr_thread:936)
[ 4303.388031] omap_i2c omap_i2c.2: Hard ISR: STAT=0x1001; IE=0x601f; CON=0x8200 (omap_i2c_isr:911)
[ 4303.388122] omap_i2c omap_i2c.2: Thread ISR: STAT=0x1001; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:936)
[ 4303.388122] omap_i2c omap_i2c.2: IRQ (ISR = 0x0001)
[ 4303.388153] omap_i2c omap_i2c.2: Arbitration lost
[ 4303.393066] omap_i2c omap_i2c.2: Complete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_isr_thread:1055)
[ 4303.395141] omap_i2c omap_i2c.2: Got comlete: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:618)
[ 4303.395172] omap_i2c omap_i2c.2: Got AL - i2c reset: STAT=0x0100; IE=0x601f; CON=0x8200 (omap_i2c_xfer_msg:632)

The patch for tracing.
=========================
>From aefaa3642eae0b4fd9c1e8dc10665c55d04bad53 Mon Sep 17 00:00:00 2001
From: Alexander Kochetkov <al.kochet@gmail.com>
Date: Mon, 17 Nov 2014 18:35:00 +0400
Subject: i2c: omap: enable traces for debug NACK and AL transfers

Just for testing. Not for Upstream.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
 drivers/i2c/busses/i2c-omap.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 9cfadf3..7b62cf1 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define DEBUG 1
+
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
@@ -277,6 +279,22 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
+#ifdef DEBUG
+static inline void
+omap_i2c_dump_state(const char *func, int line, struct omap_i2c_dev *dev, const char *msg)
+{
+       dev_dbg(dev->dev, "%s: STAT=0x%04x; IE=0x%04x; CON=0x%04x (%s:%d)\n",
+               msg,
+               omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG),
+               omap_i2c_read_reg(dev, OMAP_I2C_IE_REG),
+               omap_i2c_read_reg(dev, OMAP_I2C_CON_REG),
+               func, line);
+}
+#define OMAP_I2C_DUMP_STATE(dev, msg) omap_i2c_dump_state(__func__, __LINE__, (dev), (msg))
+#else
+#define OMAP_I2C_DUMP_STATE(dev, msg)
+#endif
+
 static void __omap_i2c_init(struct omap_i2c_dev *dev)
 {
 
@@ -563,7 +581,9 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (!dev->b_hw && stop)
 		w |= OMAP_I2C_CON_STP;
 
+	OMAP_I2C_DUMP_STATE(dev, "Pre submit");
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
+	OMAP_I2C_DUMP_STATE(dev, "Post submit");
 
 	/*
 	 * Don't write stt and stp together on some hardware.
@@ -592,8 +612,10 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	 * REVISIT: We should abort the transfer on signals, but the bus goes
 	 * into arbitration and we're currently unable to recover from it.
 	 */
+	OMAP_I2C_DUMP_STATE(dev, "Wait comlete");
 	timeout = wait_for_completion_timeout(&dev->cmd_complete,
 						OMAP_I2C_TIMEOUT);
+	OMAP_I2C_DUMP_STATE(dev, "Got comlete");
 	if (timeout == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		omap_i2c_reset(dev);
@@ -607,6 +629,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	/* We have an error */
 	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
 			    OMAP_I2C_STAT_XUDF)) {
+		OMAP_I2C_DUMP_STATE(dev, "Got AL - i2c reset");
 		omap_i2c_reset(dev);
 		__omap_i2c_init(dev);
 		return -EIO;
@@ -616,6 +639,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
 
+		OMAP_I2C_DUMP_STATE(dev, "Got NACK - send STP");
 		w = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
 		w |= OMAP_I2C_CON_STP;
 		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
@@ -884,6 +908,8 @@ omap_i2c_isr(int irq, void *dev_id)
 	mask = omap_i2c_read_reg(dev, OMAP_I2C_IE_REG);
 	stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 
+	OMAP_I2C_DUMP_STATE(dev, "Hard ISR");
+
 	if (stat & mask)
 		ret = IRQ_WAKE_THREAD;
 
@@ -907,6 +933,8 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 		stat &= bits;
 
+		OMAP_I2C_DUMP_STATE(dev, "Thread ISR");
+
 		/* If we're in receiver mode, ignore XDR/XRDY */
 		if (dev->receiver)
 			stat &= ~(OMAP_I2C_STAT_XDR | OMAP_I2C_STAT_XRDY);
@@ -1024,6 +1052,7 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		}
 	} while (stat);
 
+	OMAP_I2C_DUMP_STATE(dev, "Complete");
 	omap_i2c_complete_cmd(dev, err);
 
 out:
-- 
1.7.9.5