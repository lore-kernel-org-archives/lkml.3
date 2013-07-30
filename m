Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3G3Elf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:41:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52317 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab3G3ElX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:41:23 -0400
Message-ID: <51F74379.3050809@ti.com>
Date: Mon, 29 Jul 2013 23:39:21 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Dan Williams <djbw@fb.com>,
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
References: <1374597804-3961-1-git-send-email-joelf@ti.com> <51EF8A52.90902@metafoo.de> <51EF8C2B.2030409@ti.com> <51EF8F4E.8080806@metafoo.de> <FB20353E-4890-4462-A671-3587A3841B4A@ti.com> <51EF92F2.3030405@metafoo.de> <51F0231C.7000401@ti.com> <20130724183329.GH18642@intel.com> <51F02CBA.5060704@ti.com> <20130725072351.GJ18642@intel.com> <20130729094557.GG29095@intel.com>
In-Reply-To: <20130729094557.GG29095@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 07/29/2013 04:45 AM, Vinod Koul wrote:
> On Thu, Jul 25, 2013 at 12:53:51PM +0530, Vinod Koul wrote:
>> On Wed, Jul 24, 2013 at 02:36:26PM -0500, Joel Fernandes wrote:
>>>> Also another point worth considering is the approach Russell suggested, I havent
>>>> gotten a chance to dig deeper but if I understood it correctly then programming
>>>> the device_dma_parameters should be the right thing to do. Again I need to look
>>>> deeper and esp wrt edma
>>>
>>> OK. I have some patches sitting in my tree too that I'm working on. With
>>> that I don't need to know about maximum number of allowed segments and
>>> can send along any number of segment. I will rework them and post them.
>>> fwiw, I will also implement caps API incase like Lars did populating the
>>> other fields though these will not be unused.
>>>
>>> For segment size, at this time I don't know any driver that uses it
>>> other than davinci-pcm. For this reason the calculations can be done as
>>> Lars suggested (for minimum of maximum). Do you know in advance if
>>> you're going to amend to drop segment size if we go with what Russell
>>> suggested, or are you going to leave the seg-size in the caps API anyway.
>> I am just back and havent really done my work on this. Let me check and as I
>> said if my understanding is right I would be inclined to remove these fields...
> Okay so the max sg_len should be done by setting the device_dma_parameters.
> 
> See the example in MXS DMA and MMC drivers

Ah, I see those examples. Thanks.

> 
> Now for second parameter why do you need that to be passed, I thought in edma the
> clients needs this value somehow to program the channel. It would be good that
> if we can delink from this and let edma derive.

Do you mean the burst width and device width parameters?

On second thought, I am thinking do we really need to set this
particular parameter if we can rearchitect the driver a bit. EDMA
theoretically can transmit very large segment sizes. There are 3
internal counters (ACNT, BCNT, CCNT) that are 16-bit, total size is
quite large (product of counters).

EDMA driver however currently assumes that ACNT is device width and BCNT
is max burst in units of device width. These parameters are again client
configured so these have to be passed to the EDMA driver by
configuration or passed through API to calculate maximum segment size.
This is required because client may be unaware that CCNT is only 16 bit,
so following calculation is being done in the SG segment size patch:

<snip>
+*edma_get_slave_sg_limits(struct dma_chan *chan,
+			enum dma_slave_buswidth addr_width,
+			u32 maxburst)
+{
[..]
+	echan->sg_limits.max_seg_len =
+		(SZ_64K - 1) * addr_width * maxburst;
</snip>


The other down side of assigning ACNT device width and BCNT as burst
size it seems to be wasteful of the range allowed by 16-bit width.
I am thinking if we can break free from these assumptions, then we can
transmit segments of literally any length and not have to set any
segment size limits at all. I'll try to work on some patches to see if
we can overcome segment size limits.

> Also there should be no such thing as max_sg, the driver should be able to
> perform any size of sg_list. Internally it can be breaking the dma
> into multiple trasnactions.

Sure, I just submitted a patch series that does exactly that:
http://marc.info/?l=linux-omap&m=137510483230005&w=2

Thanks,

-Joel

