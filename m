Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3GHNT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:19:29 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64981 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3GHNTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:19:24 -0400
Message-ID: <51DABC58.5070503@cogentembedded.com>
Date: Mon, 08 Jul 2013 17:19:20 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] usb/musb dma: add cppi41 dma driver
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de> <1373040764-3711-2-git-send-email-bigeasy@linutronix.de> <51D9817B.6080209@cogentembedded.com> <51DA7DD5.9060700@linutronix.de> <51DAAD86.2060102@cogentembedded.com> <51DAB2C3.6060303@linutronix.de>
In-Reply-To: <51DAB2C3.6060303@linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-07-2013 16:38, Sebastian Andrzej Siewior wrote:

>>> not using dmaengine and the network driver (cpsw) which is also using
>>> cppi 3.1 is having its own implementation of the cppi-dma part. So I
>>> think dma enggine implementation is a must here.

>>     Not at all. I'm not familiar with CPSW but DaVinci EMAC uses CPPI 3.0
>> too but it's completely regisyter incompatible with USB. CPPI 3.0
>> doesn't seem to be universal DMA engine, hence drivers/dma/ driver
>> doesn't seem feasible.

> So you suggest to avoid drivers/dma and create drivers/usb
> /musb/cpp41-dma.c instead?

    Where I was suggesting that? I was replying about CPPI 3.0 only.

> cpsw is using davinci_cpdma.c and you say it is completely different
> from what musb is using? I just browsed over the spec it looked very
> familiar.

    Yes, the register interface is incompatible -- I too compared it 
some time ago. The only things compatible are the DMA descriptors.

>>> I will shorten them for the range conflict. usbss is only used for
>>> interrupt mask on/off. If there are different, a different compatible
>>> string will carry the difference.

>>     You don't quite understand. CPPI 4.1 specification as such (which I
>> guess you haven't seen) doesn't include any interrupt registers.

> Yes but you do have them somewhere. So all its needs is just the SoC
> type which brings the register specification.

    Well, it can be viewed this way...

>>> I think I will also add the usb
>>> string to it since a possible network engine will look different in
>>> terms of the queue used (which I plan to move away from DT).

>>     There are out of tree platform which uses CPPI 4.1 not only for USB
>> but e.g. for Ethernet.

> So what? The binding will be different, you get a different register
> for interrupt. I'm still not buying that part where you want skip the
> dmaengine framework and introduce custom callbacks for this kind of
> things.

    I'm just not sure drivers/dma/ needs IRQs. To be honest, I'm not 
very familiar with its APIs.

>>>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>>>>> new file mode 100644
>>>>> index 0000000..80dcb56
>>>>> --- /dev/null
>>>>> +++ b/drivers/dma/cppi41.c
>>>>> @@ -0,0 +1,777 @@
>> [...]

>>>>> +static u32 get_host_pd2(struct cppi41_channel *c)
>>>>> +{
>>>>> +    u32 reg;
>>>>> +
>>>>> +    reg = 5 << 26; /* USB TYPE */

>>>>      The driver shouldn't be tied to USB at all.

>>> For now it is USB only. Once we git different types we will have
>>> different compatible strings for that. But that shift could by hidden
>>> behind a define so to comment could vanish as well.

>>     I repeat: CPPI 4.1 is universal DMA engine. It's a pity that it's
>> implemented as a part of USB peripheral on all in-tree platforms but
>> it's implemented as an autonomous module on out-of-tree platforms.

> It can be still extended to use normal/generic memcpy() operation if
> this is supported somewhere.

     No, it can't. CPPI 4.1 spec simply has no support for such thing.
It can't be implemented "somewhare" because then that hardware stops to 
be CPPI 4.1 compatible.

> That one here tight to USB and can't do
> anything else. I do not start to include a bunch of function pointer if
> there is no need it for it. I didn't do anything that it made
> impossible to do so, right?

    I'd like to see universal driver in the end, not tied to USB in any 
way.

>>>> [...]
>>>>> +static const struct of_device_id cppi41_dma_ids[] = {
>>>>> +    { .compatible = "ti,am3359-cppi41", },

>>>>       CPPI 4.1 driver should be generic, not SoC specific.

>>> So you want another driver around it to handle the SoC specific stuff?

>>     This can be handled as part of MUSB DMA driver in our case.

> The glue layer you say. Okay. This does not look that bad. I will
> try to push it there. But then I need to pass pointers somehow between
> cppi41 which is behind dma-engine and this glue layer.

    I think that's enough to export a output queue polling function from 
the DMA engine.

>>> Sebastian

>> PS: Are you aware that TI has written CPPI 4.2 DMA engine driver in
>> their Arago project?

    They actually had plans to write CPPI 4.1 DMA engine support too but 
that seems to have lead nowhere so far. They seem still content with 
what I wrote based on their CPPI 4.1 code back in 2008 (only moved it 
into drivers/usb/musb/).

>> http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-February/026345.html

> No I wasn't. They could bring their code upstream…

    Oh, they are usually in no hurry to do so. BTW, if you read the 
mail, they weren't quite content with the DMA engine framework, and 
developed 2 alternate solutions as far as I could understand.

> Sebastian

WBR, Sergei

