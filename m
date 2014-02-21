Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaBUHye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:54:34 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34374
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbaBUHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:54:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.carpenter@oracle.com>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCH] dma: fsl-edma: fix static checker warning of NULL dereference
Date: Fri, 21 Feb 2014 14:50:06 +0800
Message-ID: <1392965406-10112-1-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The static checker reports following warning:
	drivers/dma/fsl-edma.c:732 fsl_edma_xlate()
	error: we previously assumed 'chan' could be null (see line 737)
The changes of the loop cursor in the iteration may result in
NULL dereference when dma_get_slave_channel failed but loop
will continue. So use list_for_each_entry_safe() instead of
list_for_each_entry() to against this.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
 drivers/dma/fsl-edma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 9025300..381e793 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -723,13 +723,13 @@ static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
 		struct of_dma *ofdma)
 {
 	struct fsl_edma_engine *fsl_edma = ofdma->of_dma_data;
-	struct dma_chan *chan;
+	struct dma_chan *chan, *_chan;
 
 	if (dma_spec->args_count != 2)
 		return NULL;
 
 	mutex_lock(&fsl_edma->fsl_edma_mutex);
-	list_for_each_entry(chan, &fsl_edma->dma_dev.channels, device_node) {
+	list_for_each_entry_safe(chan, _chan, &fsl_edma->dma_dev.channels, device_node) {
 		if (chan->client_count)
 			continue;
 		if ((chan->chan_id / DMAMUX_NR) == dma_spec->args[0]) {
-- 
1.8.0


