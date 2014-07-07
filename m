Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaGHAvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:51:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaGGXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 110/122] net/mlx4_core: Keep only one driver entry release mlx4_priv
Date: Mon,  7 Jul 2014 16:57:52 -0700
Message-Id: <20140707235737.535222279@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <weiyang@linux.vnet.ibm.com>

commit da1de8dfff09d33d4a5345762c21b487028e25f5 upstream.

Following commit befdf89 "net/mlx4_core: Preserve pci_dev_data after
__mlx4_remove_one()", there are two mlx4 pci callbacks which will
attempt to release the mlx4_priv object -- .shutdown and .remove.

This leads to a use-after-free access to the already freed mlx4_priv
instance and trigger a "Kernel access of bad area" crash when both
.shutdown and .remove are called.

During reboot or kexec, .shutdown is called, with the VFs probed to
the host going through shutdown first and then the PF. Later, the PF
will trigger VFs' .remove since VFs still have driver attached.

Fix that by keeping only one driver entry which releases mlx4_priv.

Fixes: befdf89 ('net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()')
CC: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2800,7 +2800,7 @@ static struct pci_driver mlx4_driver = {
 	.name		= DRV_NAME,
 	.id_table	= mlx4_pci_table,
 	.probe		= mlx4_init_one,
-	.shutdown	= mlx4_remove_one,
+	.shutdown	= __mlx4_remove_one,
 	.remove		= mlx4_remove_one,
 	.err_handler    = &mlx4_err_handler,
 };


