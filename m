Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaIPNi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:38:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53529 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbaIPNi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:38:28 -0400
Message-ID: <54183D49.2070804@ti.com>
Date: Tue, 16 Sep 2014 16:38:17 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: omap-dma: Fix cyclic suspend/resume
References: <1410872785-14523-1-git-send-email-peter.ujfalusi@ti.com> <20140916132259.GE12379@n2100.arm.linux.org.uk>
In-Reply-To: <20140916132259.GE12379@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 04:22 PM, Russell King - ARM Linux wrote:
> On Tue, Sep 16, 2014 at 04:06:25PM +0300, Peter Ujfalusi wrote:
>> When the audio stream is paused or suspended we stop the sDMA and when it
>> is unpsues/resumed we start the channel without reconfiguring it.
>> The omap_dma_stop() clears the link configuration when we pause the dma, but
>> it is not setting it back on start. This will result only one audio buffer
>> to be played back and the DMA will stop, since the linking is disabled.
>> The link need to be enabled in omap_dma_start() to make sure that cyclic
>> transfer can continue.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/dma/omap-dma.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
>> index 4cf7d9a950d7..13a02ff87f28 100644
>> --- a/drivers/dma/omap-dma.c
>> +++ b/drivers/dma/omap-dma.c
>> @@ -280,6 +280,7 @@ static void omap_dma_assign(struct omap_dmadev *od, struct omap_chan *c,
>>  static void omap_dma_start(struct omap_chan *c, struct omap_desc *d)
>>  {
>>  	struct omap_dmadev *od = to_omap_dma_dev(c->vc.chan.device);
>> +	uint32_t val;
>>  
>>  	if (__dma_omap15xx(od->plat->dma_attr))
>>  		omap_dma_chan_write(c, CPC, 0);
>> @@ -288,6 +289,17 @@ static void omap_dma_start(struct omap_chan *c, struct omap_desc *d)
>>  
>>  	omap_dma_clear_csr(c);
>>  
>> +	if (!__dma_omap15xx(od->plat->dma_attr) && c->cyclic) {
>> +		val = omap_dma_chan_read(c, CLNK_CTRL);
>> +
>> +		if (dma_omap1())
>> +			val &= ~(1 << 14); /* clear the STOP_LNK bit */
>> +		else
>> +			val |= CLNK_CTRL_ENABLE_LNK;
>> +
>> +		omap_dma_chan_write(c, CLNK_CTRL, val);
>> +	}
>> +
> 
> Why is this soo complicated?  What's wrong with simply writing the
> stored value back from the omap_desc:
> 
> 	omap_dma_chan_write(c, CLNK_CTRL, d->clnk_ctrl);

Oh, I have overlooked this. Thanks.

> In fact, rather than loading up the above fast path with stuff which
> it really doesn't need, why not do this in the resume path?  The
> other thing which should be placed in the resume path is a mb() call,
> since calling omap_dma_start() won't have a barrier in that path.

Do you want it as a separate patch (adding the mb() and to restore the
CLNK_CTRL register) or is it OK if I send it as one patch?

-- 
Péter
