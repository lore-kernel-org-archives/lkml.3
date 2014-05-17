Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaEQF02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 01:26:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61436 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaEQF01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 01:26:27 -0400
Message-ID: <5376F2F8.3010603@gmail.com>
Date: Sat, 17 May 2014 13:26:16 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, matanb@mellanox.com,
        davem@davemloft.net, ogerlitz@mellanox.com, eyalpe@mellanox.com,
        amirv@mellanox.com, sbohrer@rgmadvisors.com,
        linux-rdma@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH] drivers: net: ethernet: mellanox: mlx4: let mlx4 depend on
 SMP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct irq_affinity_notify' and the related functions are only defined
when SMP enabled, so at present, mlx4 has to only run under SMP.

The related error (allmodconfig under unicore32):

    CC [M]  drivers/net/ethernet/mellanox/mlx4/eq.o
  drivers/net/ethernet/mellanox/mlx4/eq.c:58: error: field ‘notify’ has incomplete type
  drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_irq_notifier_notify’:
  drivers/net/ethernet/mellanox/mlx4/eq.c:1094: error: type defaults to ‘int’ in declaration of ‘__mptr’
  drivers/net/ethernet/mellanox/mlx4/eq.c:1094: warning: initialization from incompatible pointer type
  drivers/net/ethernet/mellanox/mlx4/eq.c:1104: error: dereferencing pointer to incomplete type
  drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_release_irq_notifier’:
  drivers/net/ethernet/mellanox/mlx4/eq.c:1111: error: type defaults to ‘int’ in declaration of ‘__mptr’
  drivers/net/ethernet/mellanox/mlx4/eq.c:1111: warning: initialization from incompatible pointer type
  drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_assign_irq_notifier’:
  drivers/net/ethernet/mellanox/mlx4/eq.c:1133: error: implicit declaration of function ‘irq_set_affinity_notifier’
  make[5]: *** [drivers/net/ethernet/mellanox/mlx4/eq.o] Error 1
  make[4]: *** [drivers/net/ethernet/mellanox/mlx4] Error 2
  make[3]: *** [drivers/net/ethernet/mellanox] Error 2
  make[2]: *** [drivers/net/ethernet] Error 2
  make[1]: *** [drivers/net] Error 2
  make: *** [drivers] Error 2

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/infiniband/hw/mlx4/Kconfig         | 2 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
index fc01dea..e31e400 100644
--- a/drivers/infiniband/hw/mlx4/Kconfig
+++ b/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,6 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
-	depends on NETDEVICES && ETHERNET && PCI && INET
+	depends on NETDEVICES && ETHERNET && PCI && INET && SMP
 	select NET_VENDOR_MELLANOX
 	select MLX4_CORE
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlx4/Kconfig b/drivers/net/ethernet/mellanox/mlx4/Kconfig
index 1486ce9..a1f2380 100644
--- a/drivers/net/ethernet/mellanox/mlx4/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx4/Kconfig
@@ -4,7 +4,7 @@
 
 config MLX4_EN
 	tristate "Mellanox Technologies 1/10/40Gbit Ethernet support"
-	depends on PCI
+	depends on PCI && SMP
 	select MLX4_CORE
 	select PTP_1588_CLOCK
 	---help---
-- 
1.9.2.459.g68773ac
