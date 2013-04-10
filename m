Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936790Ab3DJI4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:56:51 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:14130 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935612Ab3DJI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:56:48 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-12.tower-46.messagelabs.com!1365584206!33486641!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5165293E.7060103@digi.com>
Date: Wed, 10 Apr 2013 10:56:30 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc
 pins config
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com> <201304091015.43472.marex@denx.de> <5163D899.6000904@digi.com> <201304091251.59359.marex@denx.de>
In-Reply-To: <201304091251.59359.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 12:51 PM, Marek Vasut wrote:
> Hi Hector,
>
>> Dear Marek Vasut,
>>
>> On 04/09/2013 10:15 AM, Marek Vasut wrote:
>>> Dear Hector Palacios,
>>>
>>>> Dear Marek Vasut,
>>>>
>>>> On 04/08/2013 06:28 PM, Marek Vasut wrote:
>>>>> Dear Shawn Guo,
>>>>>
>>>>>> On Mon, Apr 08, 2013 at 03:58:05PM +0200, Hector Palacios wrote:
>>>>>>> On 04/08/2013 02:48 PM, Shawn Guo wrote:
>>>>>>>> On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
>>>>>>>>> MicroSD card sockets don't usually have card detect line. This pin
>>>>>>>>> is actually not needed for the MMC to work and it is more of a
>>>>>>>>> platform design decission to have it.
>>>>>>>>> The card detect pin already has a configuration entry of its own:
>>>>>>>>> 'mmc0_cd_cfg' so we complete the iomux configuration here and let
>>>>>>>>> platforms to include it or not depending on whether the card detect
>>>>>>>>> line is routed to the SD socket.
>>>>>>>>
>>>>>>>> Sounds sensible.
>>>>>>>>
>>>>>>>>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>> Hello,
>>>>>>>>>
>>>>>>>>> All imx28 based platforms except 'bluegiga,apx4devkit' and
>>>>>>>>> 'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc
>>>>>>>>> configuration so please check whether this patch would break these
>>>>>>>>> platforms.
>>>>>>>>
>>>>>>>> I just tested the patch on imx28-evk and card-detection still works.
>>>>>>>> So patches applied, thanks.
>>>>>>>
>>>>>>> The EVK and most platforms will work because they are using
>>>>>>> 'mmc0_cd_cfg' so actually this patch does not change anything on
>>>>>>> them.
>>>>>>> Platforms 'bluegiga,apx4devkit' and 'schulercontrol,imx28-sps1'
>>>>>>> however are not referencing 'mmc0_cd_cfg' so after applying this
>>>>>>> patch they will have unconfigured CD line and they may break.
>>>>>>
>>>>>> Ah, yes.  I thought that any board that has CD support has to
>>>>>> reference 'mmc0_cd_cfg'.  That's not necessarily true.
>>>>>>
>>>>>>> The driver will call get_cd() upon probing, which returns the status
>>>>>>> of the CD line. Please check these two platforms before applying.
>>>>>>
>>>>>> Ok, let's wait for people owning the boards to confirm.
>>>>>
>>>>> Maybe you want to use MMC_CAP_NEEDS_POLL as was noted by someone before
>>>>> on the olinuxino -- the slot is there, it's just the CD line that's
>>>>> missing.
>>>>
>>>> I'm not sure of what you mean. The mxs-mmc.c driver already sets the
>>>> MMC_CAP_NEEDS_POLL flag by default in the probe() function. My platform
>>>> does not even route the CD line because the microSD socket does not have
>>>> it.
>>>> So what I have done is modify the driver to parse the property
>>>> 'non-removable' from the device tree in order to set the
>>>
>>>> MMC_CAP_NONREMOVABLE flag:
>>> Yes, I get it. I have two remarks still:
>>> 1) The card is removable (you can pull it out from olinuxino's slot)
>>
>> True, I misunderstood the use of 'non-removable'. So I guess I could use
>> 'broken-cd' property instead, right?
>
> Yep, seems ok.
>
>>> 2) Why is the NEEDS_POLL set by default ?
>>
>> Because the CD line cannot cause an interrupt in this controller.
>
> Ok, understood.
>
> NOTE: Here is an idea -- we can solve this the same way it's solved with the MXC
> SDHCI, configure the CD pin(s) as GPIO(s) and then they'll be able to generate
> interrupt. On the other hand, this shall definitelly be done in a separate
> patch.
>
>>> 3) Does the NEEDS_POLL not solve the issue with missing CD line?
>>
>> No. CD polling relies on the status register. The field CARD_DETECT in
>> HW_SSP_STATUS register directly reflects the state of the SSP_DETECT input
>> pin. If the pin is not connected it can have any value, so I guess we need
>> a custom flag on the driver:

Patch available in this other thread (pending resubmission):
http://comments.gmane.org/gmane.linux.kernel.mmc/19982

With this, card detection works via polling even if you don't use the Card Detect line.

Regards,
-- 
Héctor Palacios
