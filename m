Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3AaDvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:51:18 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49618 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3AaDvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:51:16 -0500
Message-ID: <5109EA2A.8020204@gmail.com>
Date: Thu, 31 Jan 2013 11:51:06 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com> <51098064.7030902@wwwdotorg.org>
In-Reply-To: <51098064.7030902@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 04:19 AM, Stephen Warren wrote:
> On 01/30/2013 12:20 AM, Mark Zhang wrote:
>> On 01/30/2013 11:02 AM, Alexandre Courbot wrote:
>>> Add support for the Chunghwa CLAA101WA01A display panel.
> 
>>> +static int panel_claa101_get_modes(struct display_entity *entity,
>>> +				   const struct videomode **modes)
>>> +{
>>> +	/* TODO get modes from EDID? */
>>
>> Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
>> case, you can get EDID here. I know drm has some helpers to fetch EDID
>> but I recall there are some other functions which has no drm
>> dependencies which may be suitable for you.
> 
> DDC access is a property of the display controller, not the panel
> itself. The panel might be hooked up to a display controller's DDC/I2C
> channel as the target, but it isn't the host/controller of the DDC/I2C
> channel. As such, placing the nvidia,ddc property into the display
> controller node makes sense.
> 

Yes, DC triggers the DDC access and is the host of the DDC/I2C channel.
So I think it's reasonable to put nvidia,ddc property into the display
controller node. But the video mode info in EDID which be fetched via
DDC is the property of the panel, so this info should be provided by
panel driver. Actually display controller cares about the video modes,
not the way to get these info. So I think it's better to do the whole
work like this:

1) display controller relied on CDF to call "display_entity_get_modes"
2) panel driver calls the function which is hooked to display controller
to get the video modes via DDC.
3) if the video modes can't be fetched via DDC, panel driver provides
the info(either by hard-coded or defined in DT) anyway

> Re: the other discussion in this thread: Probably the simplest is if
> tegradrm/other-CDF-users do something like:
> 
> 1) If DDC I2C channel available for this display channel, query DDC.

Just like I said above, display controller should not query DDC
directly. Since CDF already defines these for us, display controller
should call CDF's functions, like: display_entity_get_modes,
display_entity_get_size... I think this is the key difference I wanna
talk about. And also in this way, display controller doesn't need to
care about this 2 steps logics, just call "display_entity_get_modes" is OK.

Mark
> 2) If not, or perhaps also if that fails, query the panel driver for the
> mode list.
> 
> That would cover all bases very simply.
> 
