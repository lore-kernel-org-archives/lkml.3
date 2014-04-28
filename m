Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaD1Bbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42886 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Linus Walleij" <linus.walleij@linaro.org>,
        "Shawn Guo" <shawn.guo@linaro.org>, "Marek Vasut" <marex@denx.de>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.275567771@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 59/94] gpio: mxs: Allow for recursive enable_irq_wake()
 call
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit a585f87c863e4e1d496459d382b802bf5ebe3717 upstream.

The scenario here is that someone calls enable_irq_wake() from somewhere
in the code. This will result in the lockdep producing a backtrace as can
be seen below. In my case, this problem is triggered when using the wl1271
(TI WlCore) driver found in drivers/net/wireless/ti/ .

The problem cause is rather obvious from the backtrace, but let's outline
the dependency. enable_irq_wake() grabs the IRQ buslock in irq_set_irq_wake(),
which in turns calls mxs_gpio_set_wake_irq() . But mxs_gpio_set_wake_irq()
calls enable_irq_wake() again on the one-level-higher IRQ , thus it tries to
grab the IRQ buslock again in irq_set_irq_wake() . Because the spinlock in
irq_set_irq_wake()->irq_get_desc_buslock()->__irq_get_desc_lock() is not
marked as recursive, lockdep will spew the stuff below.

We know we can safely re-enter the lock, so use IRQ_GC_INIT_NESTED_LOCK to
fix the spew.

 =============================================
 [ INFO: possible recursive locking detected ]
 3.10.33-00012-gf06b763-dirty #61 Not tainted
 ---------------------------------------------
 kworker/0:1/18 is trying to acquire lock:
  (&irq_desc_lock_class){-.-...}, at: [<c00685f0>] __irq_get_desc_lock+0x48/0x88

 but task is already holding lock:
  (&irq_desc_lock_class){-.-...}, at: [<c00685f0>] __irq_get_desc_lock+0x48/0x88

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&irq_desc_lock_class);
   lock(&irq_desc_lock_class);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 3 locks held by kworker/0:1/18:
  #0:  (events){.+.+.+}, at: [<c0036308>] process_one_work+0x134/0x4a4
  #1:  ((&fw_work->work)){+.+.+.}, at: [<c0036308>] process_one_work+0x134/0x4a4
  #2:  (&irq_desc_lock_class){-.-...}, at: [<c00685f0>] __irq_get_desc_lock+0x48/0x88

 stack backtrace:
 CPU: 0 PID: 18 Comm: kworker/0:1 Not tainted 3.10.33-00012-gf06b763-dirty #61
 Workqueue: events request_firmware_work_func
 [<c0013eb4>] (unwind_backtrace+0x0/0xf0) from [<c0011c74>] (show_stack+0x10/0x14)
 [<c0011c74>] (show_stack+0x10/0x14) from [<c005bb08>] (__lock_acquire+0x140c/0x1a64)
 [<c005bb08>] (__lock_acquire+0x140c/0x1a64) from [<c005c6a8>] (lock_acquire+0x9c/0x104)
 [<c005c6a8>] (lock_acquire+0x9c/0x104) from [<c051d5a4>] (_raw_spin_lock_irqsave+0x44/0x58)
 [<c051d5a4>] (_raw_spin_lock_irqsave+0x44/0x58) from [<c00685f0>] (__irq_get_desc_lock+0x48/0x88)
 [<c00685f0>] (__irq_get_desc_lock+0x48/0x88) from [<c0068e78>] (irq_set_irq_wake+0x20/0xf4)
 [<c0068e78>] (irq_set_irq_wake+0x20/0xf4) from [<c027260c>] (mxs_gpio_set_wake_irq+0x1c/0x24)
 [<c027260c>] (mxs_gpio_set_wake_irq+0x1c/0x24) from [<c0068cf4>] (set_irq_wake_real+0x30/0x44)
 [<c0068cf4>] (set_irq_wake_real+0x30/0x44) from [<c0068ee4>] (irq_set_irq_wake+0x8c/0xf4)
 [<c0068ee4>] (irq_set_irq_wake+0x8c/0xf4) from [<c0310748>] (wlcore_nvs_cb+0x10c/0x97c)
 [<c0310748>] (wlcore_nvs_cb+0x10c/0x97c) from [<c02be5e8>] (request_firmware_work_func+0x38/0x58)
 [<c02be5e8>] (request_firmware_work_func+0x38/0x58) from [<c0036394>] (process_one_work+0x1c0/0x4a4)
 [<c0036394>] (process_one_work+0x1c0/0x4a4) from [<c0036a4c>] (worker_thread+0x138/0x394)
 [<c0036a4c>] (worker_thread+0x138/0x394) from [<c003cb74>] (kthread+0xa4/0xb0)
 [<c003cb74>] (kthread+0xa4/0xb0) from [<c000ee00>] (ret_from_fork+0x14/0x34)
 wlcore: loaded

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-mxs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -167,7 +167,8 @@ static void __init mxs_gpio_init_gc(stru
 	ct->regs.ack = PINCTRL_IRQSTAT(port->id) + MXS_CLR;
 	ct->regs.mask = PINCTRL_IRQEN(port->id);
 
-	irq_setup_generic_chip(gc, IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
+	irq_setup_generic_chip(gc, IRQ_MSK(32), IRQ_GC_INIT_NESTED_LOCK,
+			       IRQ_NOREQUEST, 0);
 }
 
 static int mxs_gpio_to_irq(struct gpio_chip *gc, unsigned offset)

