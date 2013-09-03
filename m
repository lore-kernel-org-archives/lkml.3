Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3ICPDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:03:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3ICPDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:03:35 -0400
Message-ID: <5225FA16.5000100@ti.com>
Date: Tue, 3 Sep 2013 10:02:46 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Dan Williams <djbw@fb.com>, Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>
Subject: Re: [PATCH v4 2/6] dma: edma: Write out and handle MAX_NR_SG at a
 given time
References: <1377817545-18015-1-git-send-email-joelf@ti.com> <1377817545-18015-3-git-send-email-joelf@ti.com> <20130903040815.GC15824@intel.com>
In-Reply-To: <20130903040815.GC15824@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 11:08 PM, Vinod Koul wrote:
> On Thu, Aug 29, 2013 at 06:05:41PM -0500, Joel Fernandes wrote:
>> Process SG-elements in batches of MAX_NR_SG if they are greater
>> than MAX_NR_SG. Due to this, at any given time only those many
>> slots will be used in the given channel no matter how long the
>> scatter list is. We keep track of how much has been written
>> inorder to process the next batch of elements in the scatter-list
>> and detect completion.
>>
>> For such intermediate transfer completions (one batch of MAX_NR_SG),
>> make use of pause and resume functions instead of start and stop
>> when such intermediate transfer is in progress or completed as we
>> donot want to clear any pending events.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  drivers/dma/edma.c | 79 ++++++++++++++++++++++++++++++++++++------------------
>>  1 file changed, 53 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>> index e522ad5..732829b 100644
>> --- a/drivers/dma/edma.c
>> +++ b/drivers/dma/edma.c
>> @@ -56,6 +56,7 @@ struct edma_desc {
>>  	struct list_head		node;
>>  	int				absync;
>>  	int				pset_nr;
>> +	int				processed;
>>  	struct edmacc_param		pset[0];
>>  };
>>  
>> @@ -104,22 +105,34 @@ static void edma_desc_free(struct virt_dma_desc *vdesc)
>>  /* Dispatch a queued descriptor to the controller (caller holds lock) */
>>  static void edma_execute(struct edma_chan *echan)
>>  {
>> -	struct virt_dma_desc *vdesc = vchan_next_desc(&echan->vchan);
>> +	struct virt_dma_desc *vdesc;
>>  	struct edma_desc *edesc;
>> -	int i;
>> -
>> -	if (!vdesc) {
>> -		echan->edesc = NULL;
>> -		return;
>> +	struct device *dev = echan->vchan.chan.device->dev;
>> +	int i, j, left, nslots;
>> +
>> +	/* If either we processed all psets or we're still not started */
>> +	if (!echan->edesc ||
>> +	    echan->edesc->pset_nr == echan->edesc->processed) {
>> +		/* Get next vdesc */
>> +		vdesc = vchan_next_desc(&echan->vchan);
>> +		if (!vdesc) {
>> +			echan->edesc = NULL;
>> +			return;
>> +		}
>> +		list_del(&vdesc->node);
>> +		echan->edesc = to_edma_desc(&vdesc->tx);
>>  	}
>>  
>> -	list_del(&vdesc->node);
>> +	edesc = echan->edesc;
>>  
>> -	echan->edesc = edesc = to_edma_desc(&vdesc->tx);
>> +	/* Find out how many left */
>> +	left = edesc->pset_nr - edesc->processed;
>> +	nslots = min(MAX_NR_SG, left);
>>  
>>  	/* Write descriptor PaRAM set(s) */
>> -	for (i = 0; i < edesc->pset_nr; i++) {
>> -		edma_write_slot(echan->slot[i], &edesc->pset[i]);
>> +	for (i = 0; i < nslots; i++) {
>> +		j = i + edesc->processed;
>> +		edma_write_slot(echan->slot[i], &edesc->pset[j]);
>>  		dev_dbg(echan->vchan.chan.device->dev,
>>  			"\n pset[%d]:\n"
>>  			"  chnum\t%d\n"
>> @@ -132,24 +145,31 @@ static void edma_execute(struct edma_chan *echan)
>>  			"  bidx\t%08x\n"
>>  			"  cidx\t%08x\n"
>>  			"  lkrld\t%08x\n",
>> -			i, echan->ch_num, echan->slot[i],
>> -			edesc->pset[i].opt,
>> -			edesc->pset[i].src,
>> -			edesc->pset[i].dst,
>> -			edesc->pset[i].a_b_cnt,
>> -			edesc->pset[i].ccnt,
>> -			edesc->pset[i].src_dst_bidx,
>> -			edesc->pset[i].src_dst_cidx,
>> -			edesc->pset[i].link_bcntrld);
>> +			j, echan->ch_num, echan->slot[i],
>> +			edesc->pset[j].opt,
>> +			edesc->pset[j].src,
>> +			edesc->pset[j].dst,
>> +			edesc->pset[j].a_b_cnt,
>> +			edesc->pset[j].ccnt,
>> +			edesc->pset[j].src_dst_bidx,
>> +			edesc->pset[j].src_dst_cidx,
>> +			edesc->pset[j].link_bcntrld);
>>  		/* Link to the previous slot if not the last set */
>> -		if (i != (edesc->pset_nr - 1))
>> +		if (i != (nslots - 1))
>>  			edma_link(echan->slot[i], echan->slot[i+1]);
>>  		/* Final pset links to the dummy pset */
>>  		else
>>  			edma_link(echan->slot[i], echan->ecc->dummy_slot);
>>  	}
>>  
>> -	edma_start(echan->ch_num);
>> +	edesc->processed += nslots;
>> +
>> +	edma_resume(echan->ch_num);
>> +
>> +	if (edesc->processed <= MAX_NR_SG) {
>> +		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
>> +		edma_start(echan->ch_num);
>> +	}
>>  }
>>  
>>  static int edma_terminate_all(struct edma_chan *echan)
>> @@ -368,19 +388,26 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
>>  	struct edma_desc *edesc;
>>  	unsigned long flags;
>>  
>> -	/* Stop the channel */
>> -	edma_stop(echan->ch_num);
>> +	/* Pause the channel */
>> +	edma_pause(echan->ch_num);
>>  
>>  	switch (ch_status) {
>>  	case DMA_COMPLETE:
>> -		dev_dbg(dev, "transfer complete on channel %d\n", ch_num);
>> -
>>  		spin_lock_irqsave(&echan->vchan.lock, flags);
>>  
>>  		edesc = echan->edesc;
>>  		if (edesc) {
>> +			if (edesc->processed == edesc->pset_nr) {
>> +				dev_dbg(dev, "transfer complete." \
>> +					" stopping channel %d\n", ch_num);
>> +				edma_stop(echan->ch_num);
>> +				vchan_cookie_complete(&edesc->vdesc);
>> +			} else {
>> +				dev_dbg(dev, "Intermediate transfer complete" \
>> +					" on channel %d\n", ch_num);
> No, these two not right... Consider someone seeing this message will try to
> grep "transfer complete stopping channel" and will fail miserable to find the
> offending line. And this makes it uglier...
> 
> Also I believe checkpatch has this check, don't you run that before sending
> patches?

Sorry I did run checkpatch but the >80 char warnings were still there. Thanks
for pointing out that user-visible strings should not be split.

> 
> Quoting CodingStyle:
> 
>                 Chapter 2: Breaking long lines and strings
> 
> Coding style is all about readability and maintainability using commonly
> available tools.
> 
> The limit on the length of lines is 80 columns and this is a strongly
> preferred limit.
> 
> Statements longer than 80 columns will be broken into sensible chunks, unless
> exceeding 80 columns significantly increases readability and does not hide
> information. Descendants are always substantially shorter than the parent and
> are placed substantially to the right. The same applies to function headers
> with a long argument list. However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.
>                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sure, I removed the string split and a generate a new patch below, Thanks.

---8<---
From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v4 2/6] dma: edma: Write out and handle MAX_NR_SG at a given
 time

Process SG-elements in batches of MAX_NR_SG if they are greater
than MAX_NR_SG. Due to this, at any given time only those many
slots will be used in the given channel no matter how long the
scatter list is. We keep track of how much has been written
inorder to process the next batch of elements in the scatter-list
and detect completion.

For such intermediate transfer completions (one batch of MAX_NR_SG),
make use of pause and resume functions instead of start and stop
when such intermediate transfer is in progress or completed as we
donot want to clear any pending events.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 77 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index e522ad5..f5232bc 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -56,6 +56,7 @@ struct edma_desc {
 	struct list_head		node;
 	int				absync;
 	int				pset_nr;
+	int				processed;
 	struct edmacc_param		pset[0];
 };

@@ -104,22 +105,34 @@ static void edma_desc_free(struct virt_dma_desc *vdesc)
 /* Dispatch a queued descriptor to the controller (caller holds lock) */
 static void edma_execute(struct edma_chan *echan)
 {
-	struct virt_dma_desc *vdesc = vchan_next_desc(&echan->vchan);
+	struct virt_dma_desc *vdesc;
 	struct edma_desc *edesc;
-	int i;
-
-	if (!vdesc) {
-		echan->edesc = NULL;
-		return;
+	struct device *dev = echan->vchan.chan.device->dev;
+	int i, j, left, nslots;
+
+	/* If either we processed all psets or we're still not started */
+	if (!echan->edesc ||
+	    echan->edesc->pset_nr == echan->edesc->processed) {
+		/* Get next vdesc */
+		vdesc = vchan_next_desc(&echan->vchan);
+		if (!vdesc) {
+			echan->edesc = NULL;
+			return;
+		}
+		list_del(&vdesc->node);
+		echan->edesc = to_edma_desc(&vdesc->tx);
 	}

-	list_del(&vdesc->node);
+	edesc = echan->edesc;

-	echan->edesc = edesc = to_edma_desc(&vdesc->tx);
+	/* Find out how many left */
+	left = edesc->pset_nr - edesc->processed;
+	nslots = min(MAX_NR_SG, left);

 	/* Write descriptor PaRAM set(s) */
-	for (i = 0; i < edesc->pset_nr; i++) {
-		edma_write_slot(echan->slot[i], &edesc->pset[i]);
+	for (i = 0; i < nslots; i++) {
+		j = i + edesc->processed;
+		edma_write_slot(echan->slot[i], &edesc->pset[j]);
 		dev_dbg(echan->vchan.chan.device->dev,
 			"\n pset[%d]:\n"
 			"  chnum\t%d\n"
@@ -132,24 +145,31 @@ static void edma_execute(struct edma_chan *echan)
 			"  bidx\t%08x\n"
 			"  cidx\t%08x\n"
 			"  lkrld\t%08x\n",
-			i, echan->ch_num, echan->slot[i],
-			edesc->pset[i].opt,
-			edesc->pset[i].src,
-			edesc->pset[i].dst,
-			edesc->pset[i].a_b_cnt,
-			edesc->pset[i].ccnt,
-			edesc->pset[i].src_dst_bidx,
-			edesc->pset[i].src_dst_cidx,
-			edesc->pset[i].link_bcntrld);
+			j, echan->ch_num, echan->slot[i],
+			edesc->pset[j].opt,
+			edesc->pset[j].src,
+			edesc->pset[j].dst,
+			edesc->pset[j].a_b_cnt,
+			edesc->pset[j].ccnt,
+			edesc->pset[j].src_dst_bidx,
+			edesc->pset[j].src_dst_cidx,
+			edesc->pset[j].link_bcntrld);
 		/* Link to the previous slot if not the last set */
-		if (i != (edesc->pset_nr - 1))
+		if (i != (nslots - 1))
 			edma_link(echan->slot[i], echan->slot[i+1]);
 		/* Final pset links to the dummy pset */
 		else
 			edma_link(echan->slot[i], echan->ecc->dummy_slot);
 	}

-	edma_start(echan->ch_num);
+	edesc->processed += nslots;
+
+	edma_resume(echan->ch_num);
+
+	if (edesc->processed <= MAX_NR_SG) {
+		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
+		edma_start(echan->ch_num);
+	}
 }

 static int edma_terminate_all(struct edma_chan *echan)
@@ -368,19 +388,24 @@ static void edma_callback(unsigned ch_num, u16 ch_status,
void *data)
 	struct edma_desc *edesc;
 	unsigned long flags;

-	/* Stop the channel */
-	edma_stop(echan->ch_num);
+	/* Pause the channel */
+	edma_pause(echan->ch_num);

 	switch (ch_status) {
 	case DMA_COMPLETE:
-		dev_dbg(dev, "transfer complete on channel %d\n", ch_num);
-
 		spin_lock_irqsave(&echan->vchan.lock, flags);

 		edesc = echan->edesc;
 		if (edesc) {
+			if (edesc->processed == edesc->pset_nr) {
+				dev_dbg(dev, "Transfer complete, stopping channel %d\n", ch_num);
+				edma_stop(echan->ch_num);
+				vchan_cookie_complete(&edesc->vdesc);
+			} else {
+				dev_dbg(dev, "Intermediate transfer complete on channel %d\n", ch_num);
+			}
+
 			edma_execute(echan);
-			vchan_cookie_complete(&edesc->vdesc);
 		}

 		spin_unlock_irqrestore(&echan->vchan.lock, flags);
-- 
1.8.1.2



