Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaAMEEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:04:31 -0500
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:21040
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbaAMEE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:04:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 14
X-BigFish: VS14(z3335sz853kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] of: Fix __of_device_is_available check
Date: Mon, 13 Jan 2014 11:07:28 +0800
Message-ID: <1389582448-7489-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From IEEE 1275, there defined a standard 'status' property indicating the
operational status of one device. The 'status' property has four possible
values: 'okay/ok', 'disabled', 'fail' and 'fail-xxx'.

If it is absent, that means the status of the device is unknown or okay.

The __of_device_is_available checks the state of the 'status' property of
a device. If the property is absent or set to 'okay/ok', it returns 1.
Otherwise it returns 0.

While in __of_device_is_available:
 >	status = of_get_property(device, "status", &statlen);
 >	if (status == NULL)
 >		return 1;
The status value returned from 'of_get_property()' will be NULL in two cases:
Firstly: the 'device' value (device node) is NULL.
Secondly: the 'status' property is actaully not exist.

If the device node is NULL, the __of_device_is_available will return true,
that will mean the absent state of the 'status' property.

So this add the device node check before checking the 'status' property's
state, and if the device node is not exist, 0 will be returned.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/of/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..ba195fb 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -415,6 +415,9 @@ static int __of_device_is_available(const struct device_node *device)
 	const char *status;
 	int statlen;
 
+	if (!device)
+		return 0;
+
 	status = __of_get_property(device, "status", &statlen);
 	if (status == NULL)
 		return 1;
-- 
1.8.4


