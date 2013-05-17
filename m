Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3EQVuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab3EQVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Whitehead <tedheadster@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/33] 3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)
Date: Fri, 17 May 2013 14:50:00 -0700
Message-Id: <20130517214918.537043773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/3c509.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/3c509.c
+++ b/drivers/net/3c509.c
@@ -309,6 +309,7 @@ static int __devinit el3_isa_match(struc
 	if (!dev)
 		return -ENOMEM;
 
+	SET_NETDEV_DEV(dev, pdev);
 	netdev_boot_setup_check(dev);
 
 	if (!request_region(ioaddr, EL3_IO_EXTENT, "3c509-isa")) {
@@ -704,6 +705,7 @@ static int __init el3_eisa_probe (struct
 		return -ENOMEM;
 	}
 
+	SET_NETDEV_DEV(dev, device);
 	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_EISA);


