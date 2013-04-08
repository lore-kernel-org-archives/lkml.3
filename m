Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936097Ab3DHN6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:58:23 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.110]:48434 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935482Ab3DHN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:58:22 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-16.tower-201.messagelabs.com!1365429498!7189187!4
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5162CCED.4070707@digi.com>
Date: Mon, 8 Apr 2013 15:58:05 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "marex@denx.de" <marex@denx.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH RFC] ARM: dts: mxs: leave card detect out of common mmc
 pins config
References: <1365415940-11609-1-git-send-email-hector.palacios@digi.com> <20130408124810.GC5044@S2101-09.ap.freescale.net>
In-Reply-To: <20130408124810.GC5044@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 02:48 PM, Shawn Guo wrote:
> On Mon, Apr 08, 2013 at 12:12:20PM +0200, Hector Palacios wrote:
>> MicroSD card sockets don't usually have card detect line. This pin
>> is actually not needed for the MMC to work and it is more of a
>> platform design decission to have it.
>> The card detect pin already has a configuration entry of its own:
>> 'mmc0_cd_cfg' so we complete the iomux configuration here and let
>> platforms to include it or not depending on whether the card detect
>> line is routed to the SD socket.
>>
> Sounds sensible.
>
>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>> ---
>>
>> Hello,
>>
>> All imx28 based platforms except 'bluegiga,apx4devkit' and
>> 'schulercontrol,imx28-sps1', use 'mmc0_cd_cfg' in their mmc configuration
>> so please check whether this patch would break these platforms.
>>
> I just tested the patch on imx28-evk and card-detection still works.  So
> patches applied, thanks.

The EVK and most platforms will work because they are using 'mmc0_cd_cfg' so actually 
this patch does not change anything on them.
Platforms 'bluegiga,apx4devkit' and 'schulercontrol,imx28-sps1' however are not 
referencing 'mmc0_cd_cfg' so after applying this patch they will have unconfigured CD 
line and they may break.
The driver will call get_cd() upon probing, which returns the status of the CD line.
Please check these two platforms before applying.

In fact I was looking now at how to skip the calling of get_cd() hook when you specify 
'non-removable' in the Device Tree. According to the bindings document:

   - non-removable: non-removable slot (like eMMC); *assume always present.*

This property is not handled in mxs-mmc.c but even if I add the code to handle it and 
set MMC_CAP_NONREMOVABLE flag, the get_cd() is called at least once and returning with 
the status of CD line. I think this is wrong because it should assume the card is 
present. The CD line may not be connected at all and may have any value.

Regards,
-- 
Héctor Palacios
