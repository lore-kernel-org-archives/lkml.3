Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaB0PmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:42:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751048AbaB0PmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:42:17 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] usb: gadget: atmel_usba: fix crash when no endpoint are specified
Date: Thu, 27 Feb 2014 16:42:13 +0100
Message-Id: <1393515733-15764-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no endpoints are present in the device tree, the kernel will cras hwith the
following error:

Unable to handle kernel paging request at virtual address 00101008
[...]
[<c0222ff4>] (composite_dev_prepare) from [<c022326c>] (composite_bind+0x5c/0x190)
[<c022326c>] (composite_bind) from [<c021ff8c>] (udc_bind_to_driver+0x48/0xf0)
[<c021ff8c>] (udc_bind_to_driver) from [<c02208e0>] (usb_gadget_probe_driver+0x7c/0xa0)
[<c02208e0>] (usb_gadget_probe_driver) from [<c0008970>] (do_one_initcall+0x94/0x140)
[<c0008970>] (do_one_initcall) from [<c04b4b50>] (kernel_init_freeable+0xec/0x1b4)
[<c04b4b50>] (kernel_init_freeable) from [<c0376cc4>] (kernel_init+0x8/0xe4)
[<c0376cc4>] (kernel_init) from [<c0009590>] (ret_from_fork+0x14/0x24)
Code: e5950014 e1a04001 e5902008 e3a010d0 (e5922008)
---[ end trace 35c74bdd89b373d0 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

This checks for that case and returns an error, not allowing the driver to be
loaded with no endpoints.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 52771d4c44bc..e3e0c8ff242e 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1914,6 +1914,12 @@ static struct usba_ep * atmel_udc_of_init(struct platform_device *pdev,
 		i++;
 	}
 
+	if (i == 0) {
+		dev_err(&pdev->dev, "of_probe: no endpoint specified\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
 	return eps;
 err:
 	return ERR_PTR(ret);
-- 
1.8.3.2

