Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbaKTRko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:40:44 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:36849
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757946AbaKTRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:39:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,425,1413237600"; 
   d="scan'208";a="89679750"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] host: ehci-w90x900: fix error return code
Date: Thu, 20 Nov 2014 18:34:01 +0100
Message-Id: <1416504842-18548-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416504842-18548-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416504842-18548-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series are independent of each other.

 drivers/usb/host/ehci-w90x900.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index 93d9cd6..e42a29e 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -75,8 +75,10 @@ static int usb_w90x900_probe(const struct hc_driver *driver,
 	__raw_writel(val, ehci->regs+PHY1_CTR);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
+	if (irq < 0) {
+		retval = irq;
 		goto err2;
+	}
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval != 0)

