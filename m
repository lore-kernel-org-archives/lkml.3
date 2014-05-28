Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaE1KcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:32:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36492 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaE1KcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:32:18 -0400
Message-ID: <5385BB14.9010804@ti.com>
Date: Wed, 28 May 2014 13:31:48 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>, Olof Johansson <olof@lixom.net>
CC: Dan Williams <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, Sekhar Nori <nsekhar@ti.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 01/10] platform_data: edma: Be precise with the paRAM
 struct
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>	<1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com> <CAOesGMg43jT6D_ot2tKfRXXgAgwqs5Pu_tAFKc35yxLAczrzGQ@mail.gmail.com> <53846779.4070204@ti.com> <5384A92B.4080606@ti.com>
In-Reply-To: <5384A92B.4080606@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 06:03 PM, Joel Fernandes wrote:
> On 05/27/2014 05:22 AM, Peter Ujfalusi wrote:
>> On 05/27/2014 12:32 AM, Olof Johansson wrote:
> [..]
>>>
>>> I came across this patch when I was looking at a pull request from
>>> Sekhar for EDMA cleanups, and it made me look closer at the contents
>>> of this file.
>>>
>>> The include/linux/platform_data/ directory is meant to hold
>>> platform_data definitions for drivers, and nothing more.
>>> platform_data/edma.h also contains a whole bunch of interface
>>> definitions for the driver. They do not belong there, and should be
>>> moved to a different include file.
>>>
>>> That also includes the above struct, because as far as I can tell it's
>>> a runtime state structure, not something that is passed in with
>>> platform data.
>>>
>>> Can someone please clean this up? Thanks.
>>
>> I think Joel is working on to move/merge the code from arch/arm/common/edma.c
>> to drivers/dma/edma.c
> 
> Yes, I am planning to work on that soon. But there is an issue, more on
> that discussed below..
> 
>> I'm sure within this work he is going to clean up the header file as well.
> 
> Agreed. The private API should not be expored in any header and should
> be exclusive for the EDMA dmaengine driver ideally.
> 
>> As a first step I think the non platform_data content can be moved as
>> include/linux/edma.h or probably as ti-edma.h?
>>
> 
> sound/soc/davinci/davinci-pcm.c: This still uses the EDMA private API in
> arch/arm/common/edma.c. Peter, any idea when the private usage will be
> removed fully, and we switch to dmaengine for ASoC? Before that can
> happen, we can't clean up or do any merges.

We have the edma-pcm platform driver upstream already which I'm using locally
for a long time now on AM335x/AM437x. I'm planning to send a patch to do the
same upstream after the 3.16 window closes.
But, davinci-pcm has a mode called 'ping-pong' which is not available via
dmaengine and this mode is used by several daVinci SoCs to overcome buffer
underflow/overflow issues. This mode essentially means in playback case:
      dma_ch1       dma_ch2
SDRAM -------> SRAM -------> McASP

ch1 is to move a block of samples to SRAM from where ch2 will copy the samples
word by word to McASP.

If we move all davinci SoCs to use the edma-pcm, we are going to loose this
mode. As a note: the edma-pcm is confirmed to work fine on the tested daVinci
boards.
I think what we need to do first: find a board which is using ping-pong mode,
put under stress test in:
- davinci-pcm, ping-pong mode
- davinci-pcm, no ping-pong mode
- edma-pcm

and see how edma-pcm behaves compared to the davinci-pcm. One of the issue
with davinci-pcm is that in non ping-pong mode it reconfigures the eDMA after
every period, which is a bad thing. The dmaengine implementation does not need
to do that, so we might be fine there.

> What I'd like to do is fold the private API into the dmaengine driver
> and eliminate the need to expose the private API, thus also getting rid
> of the interface declarations Olof referred to.
> 
> thanks,
> 
> -Joel
> 


-- 
Péter
