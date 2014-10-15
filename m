Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaJOUVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:21:39 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40765 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaJOUVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:21:37 -0400
Message-ID: <543ED74E.1060500@osg.samsung.com>
Date: Wed, 15 Oct 2014 14:21:34 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] media token resource framework
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <s5ha94xwa7r.wl-tiwai@suse.de>
In-Reply-To: <s5ha94xwa7r.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 10:48 AM, Takashi Iwai wrote:
> At Tue, 14 Oct 2014 08:58:36 -0600,
> Shuah Khan wrote:
>>
>> Add media token device resource framework to allow sharing
>> resources such as tuner, dma, audio etc. across media drivers
>> and non-media sound drivers that control media hardware. The
>> Media token resource is created at the main struct device that
>> is common to all drivers that claim various pieces of the main
>> media device, which allows them to find the resource using the
>> main struct device. As an example, digital, analog, and
>> snd-usb-audio drivers can use the media token resource API
>> using the main struct device for the interface the media device
>> is attached to.
>>
>> This patch series consists of media token resource framework
>> and changes to use it in dvb-core, v4l2-core, au0828 driver,
>> and snd-usb-audio driver.
>>
>> With these changes dvb and v4l2 can share the tuner without
>> disrupting each other. Used tvtime, xawtv, kaffeine, and vlc,
>> vlc audio capture option, arecord/aplay during development to
>> identify v4l2 vb2 and vb1 ioctls and file operations that
>> disrupt the digital stream and would require changes to check
>> tuner ownership prior to changing the tuner configuration.
>> vb2 changes are made in the v4l2-core and vb1 changes are made
>> in the au0828 driver to encourage porting drivers to vb2 to
>> advantage of the new media token resource framework with changes
>> in the core.
>>
>> In this patch v2 series, fixed problems identified in the
>> patch v1 series. Important ones are changing snd-usb-audio
>> to use media tokens, holding tuner lock in VIDIOC_ENUMINPUT,
>> and VIDIOC_QUERYSTD.
> 
> Just took a quick glance over the patches, and my first concern is why
> this has to be lib/*.  This means it's always built-in as long as this
> config is enabled (and will be so on distro kernel) even if it's not
> used at all.
> 

Right this module gets built when CONFIG_MEDIA_SUPPORT is enabled
and stubs are in place when it is not enabled. The intent is for
this feature to be enabled by default when media support is enabled.
When a driver doesn't create the resource, it will simply not find it
and for drivers like snd-usb-audio that aren't tried to media support,
the stubs are in place and feature is essentially disabled.

I picked lib so this module can be included in non-media drivers
e.g: snd-usb-audio.

Does this help explain the design? I didn't want to introduce a new
config for this feature. If lib isn't right place, could you recommend
another one that makes this modules available to non-media drivers?
moving isn't a problem.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
