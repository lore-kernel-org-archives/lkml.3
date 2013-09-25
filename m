Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3IYWbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:31:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58967 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3IYWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:31:34 -0400
To: vinod.koul@intel.com, dan.j.williams@intel.com
Subject: [PATCH 2/2] rcar-hpbdma: add parameter to set_slave() method
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Date: Thu, 26 Sep 2013 02:31:37 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201309260231.37773.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4981c4dc194efb18f0e9a02f1b43e926f2f0d2bb (DMA: shdma: switch DT mode to
use configuration data from a match table) added a new parameter to set_slave()
method but unfortunately got merged later than commit c4f6c41ba790bbbfcebb4c47a
(dma: add driver for R-Car HPB-DMAC), so that the HPB-DMAC driver retained the
old prototype which caused this warning:

drivers/dma/sh/rcar-hpbdma.c:485: warning: initialization from incompatible
pointer type

The newly added parameter  is used to override DMA slave address from 'struct
hpb_dmae_slave_config', so we have to add the 'slave_addr' field to 'struct
hpb_dmae_chan', conditionally assign it in set_slave() method, and return in
slave_addr() method.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against 'fixes-3.12' branch of Vinod Koul's 'slave-dma.git' repo.
 
 drivers/dma/sh/rcar-hpbdma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
===================================================================
--- slave-dma.orig/drivers/dma/sh/rcar-hpbdma.c
+++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
@@ -93,6 +93,7 @@ struct hpb_dmae_chan {
 	void __iomem *base;
 	const struct hpb_dmae_slave_config *cfg;
 	char dev_id[16];		/* unique name per DMAC of channel */
+	dma_addr_t slave_addr;
 };
 
 struct hpb_dmae_device {
@@ -445,7 +446,8 @@ hpb_dmae_alloc_chan_resources(struct hpb
 	return 0;
 }
 
-static int hpb_dmae_set_slave(struct shdma_chan *schan, int slave_id, bool try)
+static int hpb_dmae_set_slave(struct shdma_chan *schan, int slave_id,
+			      dma_addr_t slave_addr, bool try)
 {
 	struct hpb_dmae_chan *chan = to_chan(schan);
 	const struct hpb_dmae_slave_config *sc =
@@ -456,6 +458,7 @@ static int hpb_dmae_set_slave(struct shd
 	if (try)
 		return 0;
 	chan->cfg = sc;
+	chan->slave_addr = slave_addr ? : sc->addr;
 	return hpb_dmae_alloc_chan_resources(chan, sc);
 }
 
@@ -467,7 +470,7 @@ static dma_addr_t hpb_dmae_slave_addr(st
 {
 	struct hpb_dmae_chan *chan = to_chan(schan);
 
-	return chan->cfg->addr;
+	return chan->slave_addr;
 }
 
 static struct shdma_desc *hpb_dmae_embedded_desc(void *buf, int i)
