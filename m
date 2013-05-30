Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3E3P4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:56:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab3E3P41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:56:27 -0400
From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
To: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/1] i2c: omap: correct usage of the interrupt enable register
Date: Thu, 30 May 2013 18:56:18 +0300
Message-ID: <1369929379-19165-1-git-send-email-oleksandr.dmytryshyn@ti.com>
X-Mailer: git-send-email 1.8.2.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just added a detailed description of the problem that is being solved
to the cover letter and commit message in the patch.

If the i2c controller during suspend will generate an interrupt, it
can lead to unpredictable behaviour in the kernel.

Based on the logic of the kernel code interrupts from i2c should be
prohibited during suspend. Kernel writes 0 to the I2C_IE register in
the omap_i2c_runtime_suspend() function. In the other side kernel
writes saved interrupt flags to the I2C_IE register in
omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
during suspend.

This works for chips with version1 registers scheme. Interrupts are
disabled during suspend. For chips with version2 scheme registers
writting 0 to the I2C_IE register does nothing (because now the
I2C_IRQENABLE_SET register is located at this address). This register
is used to enable interrupts. For disabling interrupts
I2C_IRQENABLE_CLR register should be used.

Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
addresses, the interrupt enabling procedure is unchanged.

I've checked that interrupts in the i2c controller are still enabled
after writting 0 to the I2C_IE register. But with my patch interrupts
are disabled in the omap_i2c_runtime_suspend() function. 

Next patch fixes it.

Patch is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
tag: v3.10-rc2

Verified on OMAP4430.

Oleksandr Dmytryshyn (1):
  i2c: omap: correct usage of the interrupt enable register

 drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.8.2.rc2

