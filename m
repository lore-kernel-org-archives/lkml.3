Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3EPQFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:05:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39443 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3EPQFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:05:51 -0400
Message-ID: <519503DA.5070303@iki.fi>
Date: Thu, 16 May 2013 19:05:46 +0300
From: Tomi Valkeinen <tomi.valkeinen@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
References: <1366697656-14315-1-git-send-email-kishon@ti.com> <51936946.3030507@iki.fi> <20130516155857.GV5600@atomide.com>
In-Reply-To: <20130516155857.GV5600@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/13 18:58, Tony Lindgren wrote:
> * Tomi Valkeinen <tomi.valkeinen@iki.fi> [130515 03:59]:
>> On 23/04/13 09:14, Kishon Vijay Abraham I wrote:
>>> After the device names are created using PLATFORM_DEVID_AUTO, the old
>>> device names given in usb_bind_phy are no longer valid causing the musb
>>> controller not to get the phy reference. Updated the usb_bind_phy with
>>> the new device names to get MUSB functional in omap4 panda.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>> Tested in OMAP4 PANDA.
>>>  arch/arm/mach-omap2/board-4430sdp.c    |    2 +-
>>>  arch/arm/mach-omap2/board-omap4panda.c |    2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
>>> index 00d7290..56a9a4f 100644
>>> --- a/arch/arm/mach-omap2/board-4430sdp.c
>>> +++ b/arch/arm/mach-omap2/board-4430sdp.c
>>> @@ -730,7 +730,7 @@ static void __init omap_4430sdp_init(void)
>>>  	omap4_sdp4430_wifi_init();
>>>  	omap4_twl6030_hsmmc_init(mmc);
>>>  
>>> -	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
>>> +	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
>>>  	usb_musb_init(&musb_board_data);
>>>  
>>>  	status = omap_ethernet_init();
>>
>> I'm seeing
>>
>> [    2.190155] unable to find transceiver
>> [    2.190155] HS USB OTG: no transceiver configured
>> [    2.190155] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
>> with status -517
>> [    2.207458] platform musb-hdrc.0.auto: Driver musb-hdrc requests
>> probe deferral
>>
>> on 4430sdp with v3.10-rc1. Does that mean that the musb-hdrc.0.auto was
>> indeed correct, and the new value of musb-hdrc.2.auto is not?
> 
> Just checking.. Do you have CONFIG_OMAP_OCP2SCP=y in your .config? Sounds
> like the some transceivers should depend on that for omap4.

Yes, I have OCP2SCP=y.

>> The musb-hdrc id is wrong on overo also.
> 
> Hmm has there been a fix posted for that?

I couldn't find with a quick look. We debugged and discussed this on an irc
channel with Kishon, who said he'll send a patch. Changing the musb-hdrc ID
on overo fixed the issue, and it looks very similar to the error on 4430sdp.
The overo fix was just:

diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 4ca6b68..a496774 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -472,7 +472,7 @@ static void __init overo_init(void)
                                  mt46h32m32lf6_sdrc_params);
        board_nand_init(overo_nand_partitions,
                        ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
-       usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
+       usb_bind_phy("musb-hdrc.1.auto", 0, "twl4030_usb");
        usb_musb_init(NULL);
 
        usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));


Is that ID "randomly" chosen? Doesn't that mean that it'll just get broken
every now and then?

 Tomi

