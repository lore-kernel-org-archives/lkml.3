Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3HMBBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:01:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44015 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab3HMBBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:01:48 -0400
Message-ID: <52098549.7070505@ti.com>
Date: Mon, 12 Aug 2013 20:00:57 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 09/12] dma: edma: Implement multiple linked sets for
 continuity
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-10-git-send-email-joelf@ti.com> <52092FF7.7040508@ti.com>
In-Reply-To: <52092FF7.7040508@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 01:56 PM, Sekhar Nori wrote:
> On Monday 05 August 2013 04:14 PM, Joel Fernandes wrote:
>> Here we implement splitting up of the total MAX number of slots
>> available for a channel into 2 cyclically linked sets. Transfer
>> completion Interrupts are enabled on both linked sets and respective
>> handler recycles them on completion to process the next linked set.
>> Both linked sets are cyclically linked to each other to ensure
>> continuity of DMA operations. Interrupt handlers execute asynchronously
>> to the EDMA events and recycles the linked sets at the right time,
>> as a result EDMA is not blocked or dependent on interrupts and DMA
>> continues till the end of the SG-lists without any interruption.
>>
>> Suggested-by: Sekhar Nori <nsekhar@ti.com>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  drivers/dma/edma.c |  157 +++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 118 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>> index df50a04..70923a2 100644
>> --- a/drivers/dma/edma.c
>> +++ b/drivers/dma/edma.c
>> @@ -48,6 +48,7 @@
>>  
>>  /* Max of 16 segments per channel to conserve PaRAM slots */
>>  #define MAX_NR_SG		16
>> +#define MAX_NR_LS		(MAX_NR_SG >> 1)
>>  #define EDMA_MAX_SLOTS		(MAX_NR_SG+1)
>>  #define EDMA_DESCRIPTORS	16
>>  
>> @@ -57,6 +58,7 @@ struct edma_desc {
>>  	int				absync;
>>  	int				pset_nr;
>>  	int				total_processed;
>> +	int				next_setup_linkset;
>>  	struct edmacc_param		pset[0];
>>  };
>>  
>> @@ -140,7 +142,9 @@ static void edma_execute(struct edma_chan *echan)
>>  	struct edma_desc *edesc;
>>  	struct device *dev = echan->vchan.chan.device->dev;
>>  
>> -	int i, j, total_left, total_process;
>> +	int i, total_left, total_link_set;
>> +	int ls_cur_off, ls_next_off, slot_off;
>> +	struct edmacc_param tmp_param;
>>  
>>  	/* If either we processed all psets or we're still not started */
>>  	if (!echan->edesc ||
>> @@ -159,48 +163,121 @@ static void edma_execute(struct edma_chan *echan)
>>  
>>  	/* Find out how many left */
>>  	total_left = edesc->pset_nr - edesc->total_processed;
>> -	total_process = total_left > MAX_NR_SG ? MAX_NR_SG : total_left;
>> -
>> -
>> -	/* Write descriptor PaRAM set(s) */
>> -	for (i = 0; i < total_process; i++) {
>> -		j = i + edesc->total_processed;
>> -		edma_write_slot(echan->slot[i], &edesc->pset[j]);
>> -		dev_dbg(echan->vchan.chan.device->dev,
>> -			"\n pset[%d]:\n"
>> -			"  chnum\t%d\n"
>> -			"  slot\t%d\n"
>> -			"  opt\t%08x\n"
>> -			"  src\t%08x\n"
>> -			"  dst\t%08x\n"
>> -			"  abcnt\t%08x\n"
>> -			"  ccnt\t%08x\n"
>> -			"  bidx\t%08x\n"
>> -			"  cidx\t%08x\n"
>> -			"  lkrld\t%08x\n",
>> -			j, echan->ch_num, echan->slot[i],
>> -			edesc->pset[j].opt,
>> -			edesc->pset[j].src,
>> -			edesc->pset[j].dst,
>> -			edesc->pset[j].a_b_cnt,
>> -			edesc->pset[j].ccnt,
>> -			edesc->pset[j].src_dst_bidx,
>> -			edesc->pset[j].src_dst_cidx,
>> -			edesc->pset[j].link_bcntrld);
>> -		/* Link to the previous slot if not the last set */
>> -		if (i != (total_process - 1))
> 
>> +	total_link_set = total_left > MAX_NR_LS ? MAX_NR_LS : total_left;
> 
> The name you gave here sounds like this is defining total number of
> linked PaRAM sets. Rather this is actually tracking the number of PaRAM
> sets (slots) in current linked set, correct? Then may be just call it
> 'nslots' or even 'num_slots'? There are just too many variables with
> "total" prefix to keep track of in this function!

I would rather just leave this naming alone. The code is quite self
documenting: total_link_set means "Calculate what's the total size of a
Linkset, or total no.of slots in a linkset we need". This naming is fine
in my opinion and doesn't hurt line size at all, instead improving code
readability. I could dump the _ between link and set to make it:
total_linkset if that makes it any easier.

I agree there are too many variables in this function, but they each
serve a different purpose and required to implement the algorithm, which
is precisely I made them naming a bit more descriptive.

> 
>> +
>> +	/* First time, setup 2 cyclically linked sets, each containing half
>> +	   the slots allocated for this channel */
>> +	if (edesc->total_processed == 0) {
> 
> We dont need to check for this case for every DMA_COMPLETE interrupt.
> May be move the initial setup to another function called from
> edma_issue_pending()?

But how? That would only change the code to (?):

        if (edesc->total_processed == 0) {
		issue_pending();
	}

Further it maybe appear that this case is uncommon, but it is a very
common case. Most SG transfers are within the SG limit, though at times
the else case can execute a lot too.

>> +		for (i = 0; i < total_link_set; i++) {
>> +			edma_write_slot(echan->slot[i+1], &edesc->pset[i]);
>> +
>> +			if (i != total_link_set - 1) {
>> +				edma_link(echan->slot[i+1], echan->slot[i+2]);
>> +				dump_pset(echan, echan->slot[i+1],
>> +					  edesc->pset, i);
>> +			}
>> +		}
>> +
>> +		edesc->total_processed += total_link_set;
>> +
>> +		total_left = edesc->pset_nr - edesc->total_processed;
>> +
>> +		total_link_set = total_left > MAX_NR_LS ?
>> +				 MAX_NR_LS : total_left;
>> +
>> +		if (total_link_set) {
>> +			/* Don't setup interrupt for first linked set for cases
>> +			   where total pset_nr is strictly within MAX_NR size */
> 
> See Documentation/CodingStyle for multi-line commenting style.

Ok thanks, changed accordingly.

>> +			if (total_left > total_link_set)
>> +				edma_enable_interrupt(echan->slot[i]);
>> +
>> +			/* Setup link between linked set 0 to set 1 */
>>  			edma_link(echan->slot[i], echan->slot[i+1]);
>> -		/* Final pset links to the dummy pset */
>> -		else
>> +
>> +			dump_pset(echan, echan->slot[i], edesc->pset, i-1);
>> +
>> +			/* Write out linked set 1 */
>> +			for (; i < total_link_set + MAX_NR_LS; i++) {
>> +				edma_write_slot(echan->slot[i+1],
>> +						&edesc->pset[i]);
>> +
>> +				if (i != total_link_set + MAX_NR_LS - 1) {
>> +					edma_link(echan->slot[i+1],
>> +						  echan->slot[i+2]);
>> +					dump_pset(echan, echan->slot[i+1],
>> +						  edesc->pset, i);
>> +				}
>> +			}
>> +
>> +			edesc->total_processed += total_link_set;
>> +			total_left = edesc->pset_nr - edesc->total_processed;
> 
> There is way too much duplication of code here mainly because you
> decided not to loop twice in the course of setting up the two linked
> sets. Can you use a loop instead?

I tried to do this in a loop, its not possible without making the code
more unreadable and introducing more variables.

Further the follow 3 conditions have to be incorporated into the loop
some how which kind of makes it messy.. right now it is linearly
determined which case to execute.

/* Setup a link from linked set 1 to set 0 */

/* Setup a link between linked set 1 to dummy */

/* First linked set was enough, simply link to dummy */

Since it is just a couple of lines more, I am more to the favor of
keeping the code readable than saving a few lines (for a loop of only 2
iterations) introducing more variables and making it look hackish. There
is a good chance in future that if implemented in such a way that I have
to spend quite a bit of time deciphering it.

>> +
>> +			if (total_left)
>> +				/* Setup a link from linked set 1 to set 0 */
>> +				edma_link(echan->slot[i], echan->slot[1]);
> 
> If you have more SGs to service at the end of setting up the two linked
> sets, you should stop right there and wait for CPU to recycle the linked
> sets. Right now you are setup for re-DMAing old data.

The above linking you're quoting is done in advance _but_, before the
link is traversed, it is _guaranteed_ that the linkset being traversed
into will be recycled. This is the basis of the whole algorithm and
making sure that we never stall. There never ever will be a case where
we re-DMA old data because of the guarantee that the recycling will take
place before the traversal.

Further FWIW, interrupt takes few 100s microseconds to execute, where as
DMA is seen to take milliseconds from 1 SG entry to another in my testing.

> You wont hit this issue in testing because you have setup an interrupt
> for LS0 and that will most likely service before LS1 completes but we
> cannot rely on that timing.

This goes back to my first patch series where we stall. That doesn't
make any sense. In this patch series, we don't want DMA to stall at any
cost.

> Just link to dummy at end of LS1 to stall the DMA and wait for the
> completion handler to come-in and restart the DMA after recycling LS0.

Nope! Linking to dummy will absorb the events and the events will never
get triggered again. Trust me I have already done what you are saying
and it doesn't work.

> I haven't reviewed rest of the patch. Lets make sure we have a common
> understanding here.

Sure, thanks.

-Joel

