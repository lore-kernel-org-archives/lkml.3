Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3GXS4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:56:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3GXS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:56:06 -0400
Message-ID: <51F0231C.7000401@ti.com>
Date: Wed, 24 Jul 2013 13:55:24 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Matt Porter <matt@ohporter.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] dma: edma: add device_slave_caps() support
References: <1374597804-3961-1-git-send-email-joelf@ti.com> <51EF8A52.90902@metafoo.de> <51EF8C2B.2030409@ti.com>,<51EF8F4E.8080806@metafoo.de> <FB20353E-4890-4462-A671-3587A3841B4A@ti.com> <51EF92F2.3030405@metafoo.de>
In-Reply-To: <51EF92F2.3030405@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 03:40 AM, Lars-Peter Clausen wrote:
> On 07/24/2013 10:28 AM, Fernandes, Joel wrote:
>>
>> On Jul 24, 2013, at 3:23 AM, "Lars-Peter Clausen" <lars@metafoo.de> wrote:
>>
>>> On 07/24/2013 10:11 AM, Joel Fernandes wrote:
>>>> On 07/24/2013 03:03 AM, Lars-Peter Clausen wrote:
>>>>> On 07/23/2013 06:43 PM, Joel Fernandes wrote:
>>>>>> Implement device_slave_caps(). EDMA has a limited number of slots.
>>>>>> Slave drivers such as omap_hsmmc will query the driver to make
>>>>>> sure they don't pass in more than these many scatter segments.
>>>>>>
>>>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>>>>> ---
>>>>>> Vinod, or Dan- If this patch looks ok, can you please merge in for
>>>>>> -rc cycle? This patch is required to fix MMC support on AM33xx. This
>>>>>> patch is blocking 3 other patches which fix various MMC things. Thanks!
>>>>>>
>>>>>> Notes:
>>>>>> (1) this approach is temporary and only for -rc cycle to fix MMC on
>>>>>> AM335x. It will be replace by the RFC series in future kernels:
>>>>>> http://www.spinics.net/lists/arm-kernel/msg260094.html
>>>>>>
>>>>>> (2) Patch depends Vinod's patch at:
>>>>>> http://permalink.gmane.org/gmane.linux.kernel/1525112
>>>>>>
>>>>>> drivers/dma/edma.c |    9 +++++++++
>>>>>> 1 file changed, 9 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>>>>>> index 7222cbe..81d5429 100644
>>>>>> --- a/drivers/dma/edma.c
>>>>>> +++ b/drivers/dma/edma.c
>>>>>> @@ -517,6 +517,14 @@ static void edma_issue_pending(struct dma_chan *chan)
>>>>>>    spin_unlock_irqrestore(&echan->vchan.lock, flags);
>>>>>> }
>>>>>>
>>>>>> +static inline int edma_slave_caps(struct dma_chan *chan,
>>>>>> +    struct dma_slave_caps *caps)
>>>>>> +{
>>>>>> +    caps->max_sg_nr = MAX_NR_SG;
>>>>>
>>>>> Hm, what about the other fields?
>>>>
>>>> Other fields are unused, the max segment size is supposed to be
>>>> calculated "given" the address width and burst size. Since these
>>>> can't be provided to get_caps, I have left it out for now.
>>>> See: https://lkml.org/lkml/2013/3/6/464
>>>
>>> The PL330 driver is similar in this regard, the maximum segment size also
>>> depends on address width and burst width. What I did for the get_slave_caps
>>> implementation is to set it to the minimum maximum size. E.g. in you case
>>> that should be SZ_64K - 1 (burstsize and addrwidth both set to 1).
>>
>> So you're setting max to minimum maximum size? Isn't that like telling the driver that its segments can't be bigger than this... Unless I'm missing something..
> 
> Yes. This is a limitation of the current slave_caps API. The maximum needs
> to be the maximum for all possible configurations. A specific configuration
> may allow a larger maximum. So we maybe have to extend the API to be able to
> query the limits for a certain configuration. Not sure what the best way
> would be to do that, either adding a config parameter to get_slave_caps or
> to break it into two functions like you proposed one for the static
> capabilities and one for the sg limits.

I am OK with either approach as long as a decision can be made quickly
by maintainers. Right now lot of back and forth has happened and 3
different versions of the same thing have been posted since January.
Since this is such a trivial change, it doesn't make sense to spend so
much time on it IMO.... The sad part is though this change is trivial,
other drivers such as MMC are broken and cannot be enabled due to this.
We cannot afford to leave them broken.

If Vinod is not available, can Dan please respond on how to proceed on
this? We really need this trivial change to go into this -rc cycle and
not delay it by another kernel release. Thank you.

-Joel

