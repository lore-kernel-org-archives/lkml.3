Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaA1Ups (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:45:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaA1Upq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:45:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: dmaengine@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Joe Perches <joe@perches.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Mack <zonque@gmail.com>, Xiang Wang <wangx@marvell.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>
Subject: [PATCH] dmaengine: mmp_pdma: fix mismerge
Date: Tue, 28 Jan 2014 21:45:38 +0100
Message-ID: <3546714.4OTE6dW34L@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PSX+okaYWkh5bIqMhVFTYR2dql1eNqWS7YGRj/dtuk1
 R4udZ7NmPUh19o4NimI8pQDP9RrqzhzYttq6xZI+WPvxL3GR0Y
 noLiGl7JqjXBtF3g/idh/WV3uJFBLKx21PA/Y6t4mRtRh40oaE
 T/UXV81yMIw0XVspyvfvGH5moJwOAGNr3F25+boSpanLvDkLRu
 YYyOUQ+IC/20OsZ8D0lElxuim9F39yxMZ/bSy8dE1dccc/YQck
 jprmN0u8NcfO7nDqeUt6UscTeIhKQmVp+L7gjxIW80Ysa25N6g
 TBQrIXwmlZO5b0eBAdrItcmO3sTCHpMa3Z4qXpeIny5UvUB+vm
 RxGhreBmxmpjbuJNo04A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The merge between 2b7f65b11d87f "mmp_pdma: Style neatening" and
8010dad55a0ab0 "dma: add dma_get_any_slave_channel(), for use in of_xlate()"
caused a build error by leaving obsolete code in place:

  mmp_pdma.c: In function 'mmp_pdma_dma_xlate':
  mmp_pdma.c:909:31: error: 'candidate' undeclared
  mmp_pdma.c:912:3: error: label 'retry' used but not defined
  mmp_pdma.c:901:24: warning: unused variable 'c' [-Wunused-variable]

This removes the extraneous lines.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 32e58ee..69c6a12 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -898,19 +898,11 @@ static struct dma_chan *mmp_pdma_dma_xlate(struct of_phandle_args *dma_spec,
 {
 	struct mmp_pdma_device *d = ofdma->of_dma_data;
 	struct dma_chan *chan;
-	struct mmp_pdma_chan *c;
 
 	chan = dma_get_any_slave_channel(&d->device);
 	if (!chan)
 		return NULL;
 
-	/* dma_get_slave_channel will return NULL if we lost a race between
-	 * the lookup and the reservation */
-	chan = dma_get_slave_channel(candidate);
-
-	if (!chan)
-		goto retry;
-
 	to_mmp_pdma_chan(chan)->drcmr = dma_spec->args[0];
 
 	return chan;

