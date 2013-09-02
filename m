Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3IBRPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:15:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:3965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3IBRPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1008,1367996400"; 
   d="scan'208";a="390028080"
Date: Mon, 2 Sep 2013 21:59:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dma_slave_caps: remove sg entries
Message-ID: <20130902162907.GB15824@intel.com>
References: <1378124519-13900-1-git-send-email-vinod.koul@intel.com>
 <5224A616.2060501@metafoo.de>
 <20130902161247.GA15824@intel.com>
 <5224C69C.2090606@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224C69C.2090606@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 07:10:52PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2013 06:12 PM, Vinod Koul wrote:
> > On Mon, Sep 02, 2013 at 04:52:06PM +0200, Lars-Peter Clausen wrote:
> >> On 09/02/2013 02:21 PM, Vinod Koul wrote:
> >>> As pointed by Russell in [1], the sg properties are already availble in struct device,
> >>> so no need to duplicate here.
> >>>
> >>> [1]: http://marc.info/?l=linux-omap&m=137416733628831
> >>
> >> Hm, I guess that will work as well, but shouldn't we update the drivers that
> >> already implementing this interface first?
> > Well thats why I cced you :). I have fixed up the pl330 driver. Have you used
> > these values in any of the ASoC drivers?
> 
> Not in upstream yet, if the pl330 is fixed we are good.
Thanks for the confirmation. I had a week old Takashi's tree, didnt find
anything there, but still wanted your ack.

Now on pl330 here is the update

---

From: Vinod Koul <vinod.koul@intel.com>
Date: Mon, 2 Sep 2013 21:54:48 +0530
Subject: [PATCH] dmaengine: pl330: use dma_set_max_seg_size to set the sg limit

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
compile tested only

 drivers/dma/pl330.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 36ed301..a562d24 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2886,13 +2886,6 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	caps->cmd_pause = false;
 	caps->cmd_terminate = true;
 
-	/*
-	 * This is the limit for transfers with a buswidth of 1, larger
-	 * buswidths will have larger limits.
-	 */
-	caps->max_sg_len = 1900800;
-	caps->max_sg_nr = 0;
-
 	return 0;
 }
 
@@ -3017,6 +3010,14 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 			"unable to register DMA to the generic DT DMA helpers\n");
 		}
 	}
+	/*
+	 * This is the limit for transfers with a buswidth of 1, larger
+	 * buswidths will have larger limits.
+	 */
+	ret = dma_set_max_seg_size(&adev->dev, 1900800);
+	if (ret)
+		dev_err(&adev->dev, "unable to set the seg size\n");
+
 
 	dev_info(&adev->dev,
 		"Loaded driver for PL330 DMAC-%d\n", adev->periphid);
-- 
1.7.0.4
