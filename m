Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaKTPL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:11:59 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:59702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaKTPL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:11:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Roger Pao <rpao@paonet.org>,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [PATCH 1/2] net/am2150: fix nmclan_cs.c shared interrupt handling
Date: Thu, 20 Nov 2014 16:11:14 +0100
Message-ID: <4353896.15JnC91eLO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FdYYUsJjAByDpKX6GnwXgyYEbmccgXPdEGa0Y5kwkhp
 71DWvfF1m+c+CloW31l/3VYdQE5/eJoTsm+isckGO435dY3M5R
 exaGSSF9wb77n4hEo5nKEhDW4p+BNhOVUc8WHXxvBikUqV1CS7
 koeCR5u/4uY874Ho+dYgHE4fbmvPLYJvUD9NmJFFzz/kxrTfcq
 o+epDZ2Ertoh8kC6td3rLvJwfnzE8eLmplMl+DrVNw9Szx93ao
 MG7RExCZ06NRU4aevDJBljVTlRpCk653laULaGhCxYqQMOfYjG
 08tKPGgSTRpce/A+BvW5VzmfSLYq5HUijNqgCH+EaZfqLap4F/
 8HyFv9uHtRlqlbu6g470=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch tried to work around a valid warning for the use of a
deprecated interface by blindly changing from the old
pcmcia_request_exclusive_irq() interface to pcmcia_request_irq().

This driver has an interrupt handler that is not currently aware
of shared interrupts, but can be easily converted to be.
At the moment, the driver reads the interrupt status register
repeatedly until it contains only zeroes in the interesting bits,
and handles each bit individually.

This patch adds the missing part of returning IRQ_NONE in case none
of the bits are set to start with, so we can move on to the next
interrupt source.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 5f5316fcd08ef7 ("am2150: Update nmclan_cs.c to use update PCMCIA API")
---
I had this patch in my queue of things to submit and noticed that
the warning had gone away upstream but my patch was still there.

For all I can tell, the driver is broken without this, although it
would rarely be a problem.

diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 5b22764ba88d..27245efe9f50 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -952,6 +952,8 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
   do {
     /* WARNING: MACE_IR is a READ/CLEAR port! */
     status = inb(ioaddr + AM2150_MACE_BASE + MACE_IR);
+    if (!(status & ~MACE_IMR_DEFAULT) && IntrCnt == MACE_MAX_IR_ITERATIONS)
+      return IRQ_NONE;
 
     pr_debug("mace_interrupt: irq 0x%X status 0x%X.\n", irq, status);
 

