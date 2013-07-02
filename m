Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab3GBJra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:47:30 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:40201
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324Ab3GBJr2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:47:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: [PATCH linux-next] i2c-designware: use div_u64 to fix link
Date: Tue, 2 Jul 2013 11:46:54 +0200
Message-ID: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following link error:

  drivers/built-in.o: In function `dw_i2c_probe':
  of_iommu.c:(.text+0x18c8f0): undefined reference to `__aeabi_uldivmod'
  make: *** [vmlinux] Error 1

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---


Hi,

Linux next-20130702 link broke for ARM config multi_v7_defconfig. This is with
gcc 4.7.2 but I am not sure it matters much here.

This patch repairs the link.

It did not break anything for me on i.MX6 sabre sd, but it does'nt have a
designware i2c, so more reviewing/testing is welcome.

Best regards,

V.


 drivers/i2c/busses/i2c-designware-platdrv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index def79b5..4c5fada 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -122,7 +122,8 @@ static int dw_i2c_probe(struct platform_device *pdev)
 
 		of_property_read_u32(pdev->dev.of_node,
 					"i2c-sda-hold-time-ns", &ht);
-		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
+		dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000,
+					     1000000);
 	}
 
 	dev->functionality =
-- 
1.7.10.4



