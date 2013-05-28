Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab3E1Vdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:33:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab3E1VZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Whitehead <tedheadster@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 63/78] 3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)
Date: Tue, 28 May 2013 14:20:12 -0700
Message-Id: <1369776027-17859-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Whitehead <tedheadster@gmail.com>

[ Upstream commit 3b54912f9cd167641b91d4a697bd742f70e534fe ]

The venerable 3c509 driver only sets its device parent in one case, the ISAPnP one.
It does this with the SET_NETDEV_DEV function. It should register with the device
hierarchy in two additional cases: standard (non-PnP) ISA and EISA.

- Currently they appear here:
/sys/devices/virtual/net/eth0 (standard ISA)
/sys/devices/virtual/net/eth1 (EISA)

- Rather, they should instead be here:
/sys/devices/isa/3c509.0/net/eth0 (standard ISA)
/sys/devices/pci0000:00/0000:00:07.0/00:04/net/eth1 (EISA)

Tested on ISA and EISA boards.

Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/3com/3c509.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 633c709..d446bb4 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -306,6 +306,7 @@ static int el3_isa_match(struct device *pdev, unsigned int ndev)
 	if (!dev)
 		return -ENOMEM;
 
+	SET_NETDEV_DEV(dev, pdev);
 	netdev_boot_setup_check(dev);
 
 	if (!request_region(ioaddr, EL3_IO_EXTENT, "3c509-isa")) {
@@ -595,6 +596,7 @@ static int __init el3_eisa_probe (struct device *device)
 		return -ENOMEM;
 	}
 
+	SET_NETDEV_DEV(dev, device);
 	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_EISA);
-- 
1.8.1.2

