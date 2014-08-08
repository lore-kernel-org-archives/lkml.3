Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbaHHVtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:49:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbaHHVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:46:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 09/17] Revert "net: phy: Set the driver when registering an MDIO bus device"
Date: Fri,  8 Aug 2014 14:35:31 -0700
Message-Id: <20140808213457.895022181@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213457.511493898@linuxfoundation.org>
References: <20140808213457.511493898@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

[ Upstream commit ce7991e8198b80eb6b4441b6f6114bea4a665d66 ]

Commit a71e3c37960ce5f9 ("net: phy: Set the driver when registering an MDIO bus
device") caused the following regression on the fec driver:

root@imx6qsabresd:~# echo mem > /sys/power/state
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.003 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
Unable to handle kernel NULL pointer dereference at virtual address 0000002c
pgd = bcd14000
[0000002c] *pgd=4d9e0831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 617 Comm: sh Not tainted 3.16.0 #17
task: bc0c4e00 ti: bceb6000 task.ti: bceb6000
PC is at fec_suspend+0x10/0x70
LR is at dpm_run_callback.isra.7+0x34/0x6c
pc : [<803f8a98>]    lr : [<80361f44>]    psr: 600f0013
sp : bceb7d70  ip : bceb7d88  fp : bceb7d84
r10: 8091523c  r9 : 00000000  r8 : bd88f478
r7 : 803f8a88  r6 : 81165988  r5 : 00000000  r4 : 00000000
r3 : 00000000  r2 : 00000000  r1 : bd88f478  r0 : bd88f478
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 4cd1404a  DAC: 00000015
Process sh (pid: 617, stack limit = 0xbceb6240)
Stack: (0xbceb7d70 to 0xbceb8000)
....

The problem with the original commit is explained by Russell King:

"It has the effect (as can be seen from the oops) of attaching the MDIO bus
device (itself is a bus-less device) to the platform driver, which means
that if the platform driver supports power management, it will be called
to power manage the MDIO bus device.

Moreover, drivers do not expect to be called for power management
operations for devices which they haven't probed, and certainly not for
devices which aren't part of the same bus that the driver is registered
against."

This reverts commit a71e3c37960ce5f9c6a519bc1215e3ba9fa83e75.

Cc: <stable@vger.kernel.org> #3.16
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -255,7 +255,6 @@ int mdiobus_register(struct mii_bus *bus
 
 	bus->dev.parent = bus->parent;
 	bus->dev.class = &mdio_bus_class;
-	bus->dev.driver = bus->parent->driver;
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 


