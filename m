Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab3FEVfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937Ab3FEVfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 074/127] sata_rcar: clear STOP bit in bmdma_start() method
Date: Wed,  5 Jun 2013 14:34:01 -0700
Message-Id: <20130605213226.358880887@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit df7e131f6359f20ed8f0a37db039c4f6420a18c2 upstream.

Iff bmdma_setup() has to stop a DMA transfer before starting a new
one, then the STOP bit in the ATAPI_CONTROL1 register will remain set
(it's only cleared when setting the START bit to 1) and then
bmdma_start() method will set both START and STOP bits simultaneously
which should abort the transfer being just started.  Avoid that by
explicitly clearing the STOP bit in bmdma_start() method (in this case
it will be ignored on write).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_rcar.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -548,6 +548,7 @@ static void sata_rcar_bmdma_start(struct
 
 	/* start host DMA transaction */
 	dmactl = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	dmactl &= ~ATAPI_CONTROL1_STOP;
 	dmactl |= ATAPI_CONTROL1_START;
 	iowrite32(dmactl, priv->base + ATAPI_CONTROL1_REG);
 }


