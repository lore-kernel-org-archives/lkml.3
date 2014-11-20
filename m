Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbaKTRjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:39:53 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7299 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921AbaKTRjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:39:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,425,1413237600"; 
   d="scan'208";a="89679748"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] serial: icom: fix error return code
Date: Thu, 20 Nov 2014 18:33:59 +0100
Message-Id: <1416504842-18548-5-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/tty/serial/icom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index d4620fe..45fc323 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1550,8 +1550,10 @@ static int icom_probe(struct pci_dev *dev,
 
 	icom_adapter->base_addr = pci_ioremap_bar(dev, 0);
 
-	if (!icom_adapter->base_addr)
+	if (!icom_adapter->base_addr) {
+		retval = -ENOMEM;
 		goto probe_exit1;
+	}
 
 	 /* save off irq and request irq line */
 	 if ( (retval = request_irq(dev->irq, icom_interrupt,

