Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaCMNih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:38:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37622 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaCMNif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:38:35 -0400
Message-ID: <5321B4B4.30602@ti.com>
Date: Thu, 13 Mar 2014 15:37:56 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "joelf@ti.com" <joelf@ti.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "nsekhar@ti.com" <nsekhar@ti.com>, Jyri Sarha <jsarha@ti.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 10/18] dma: edma: Reduce debug print verbosity for non
 verbose debugging
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>	 <1394702320-21743-11-git-send-email-peter.ujfalusi@ti.com> <1394715211.28803.239.camel@smile.fi.intel.com>
In-Reply-To: <1394715211.28803.239.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 02:53 PM, Shevchenko, Andriy wrote:
> On Thu, 2014-03-13 at 11:18 +0200, Peter Ujfalusi wrote:
>> Do not print the paRAM information when verbose debugging is not asked and
>> also reduce the number of lines printed in edma_prep_dma_cyclic()
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/dma/edma.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>> index e4f4a0cef58c..e2aa42b8342f 100644
>> --- a/drivers/dma/edma.c
>> +++ b/drivers/dma/edma.c
>> @@ -141,7 +141,7 @@ static void edma_execute(struct edma_chan *echan)
>>  	for (i = 0; i < nslots; i++) {
>>  		j = i + edesc->processed;
>>  		edma_write_slot(echan->slot[i], &edesc->pset[j]);
>> -		dev_dbg(echan->vchan.chan.device->dev,
>> +		dev_vdbg(echan->vchan.chan.device->dev,
>>  			"\n pset[%d]:\n"
>>  			"  chnum\t%d\n"
>>  			"  slot\t%d\n"
> 
> I believe you may move this code to separate function and reuse it
> later.

As the per patch description, I only changed the debug level in this patch.

> Moreover %d is not good specifier for unsigned types, maybe %u?

You are right for unsigned type %u is the correct. This is why we have %d
since j, echan->ch_num and echan->slot[i] are integer.

> 
>> @@ -554,9 +554,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>>  	edesc->cyclic = 1;
>>  	edesc->pset_nr = nslots;
>>  
>> -	dev_dbg(dev, "%s: nslots=%d\n", __func__, nslots);
>> -	dev_dbg(dev, "%s: period_len=%d\n", __func__, period_len);
>> -	dev_dbg(dev, "%s: buf_len=%d\n", __func__, buf_len);
>> +	dev_dbg(dev, "%s: channel=%d nslots=%d period_len=%d buf_len=%d\n",
>> +		__func__, echan->ch_num, nslots, period_len, buf_len);
> 
> Consider to use proper specifiers for size_t types, namely %zd.

I just collapsed the three line of dev_dbg into one and have not really
checked the formats.
For size_t the correct format should be %zu.
I'll fix this up for the next version.

>>  
>>  	for (i = 0; i < nslots; i++) {
>>  		/* Allocate a PaRAM slot, if needed */
>> @@ -590,8 +589,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>>  		else
>>  			src_addr += period_len;
>>  
>> -		dev_dbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
>> -		dev_dbg(dev,
>> +		dev_vdbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
>> +		dev_vdbg(dev,
> 
> See the first comment.

As the per patch description, I only changed the debug level in this patch.
This can be done as a separate patch later IMO as part of a bigger debug cleanup.

-- 
Péter
