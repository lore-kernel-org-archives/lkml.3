Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaJUL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:59:56 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4070 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:59:55 -0400
Message-ID: <54464A83.7090706@xs4all.nl>
Date: Tue, 21 Oct 2014 13:58:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: add media token device resource framework
References: <cover.1413246370.git.shuahkh@osg.samsung.com>	<c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com>	<5446396B.9010709@xs4all.nl> <s5h1tq1ljxj.wl-tiwai@suse.de>
In-Reply-To: <s5h1tq1ljxj.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/21/2014 01:51 PM, Takashi Iwai wrote:
> At Tue, 21 Oct 2014 12:46:03 +0200,
> Hans Verkuil wrote:
>>
>> Hi Shuah,
>>
>> As promised, here is my review for this patch series.
>>
>> On 10/14/2014 04:58 PM, Shuah Khan wrote:
>>> Add media token device resource framework to allow sharing
>>> resources such as tuner, dma, audio etc. across media drivers
>>> and non-media sound drivers that control media hardware. The
>>> Media token resource is created at the main struct device that
>>> is common to all drivers that claim various pieces of the main
>>> media device, which allows them to find the resource using the
>>> main struct device. As an example, digital, analog, and
>>> snd-usb-audio drivers can use the media token resource API
>>> using the main struct device for the interface the media device
>>> is attached to.
>>>
>>> A shared media tokens resource is created using devres framework
>>> for drivers to find and lock/unlock. Creating a shared devres
>>> helps avoid creating data structure dependencies between drivers.
>>> This media token resource contains media token for tuner, and
>>> audio. When tuner token is requested, audio token is issued.
>>
>> Did you mean: 'tuner token is issued' instead of audio token?
>>
>> I also have the same question as Takashi: why do we have an audio
>> token in the first place? While you are streaming audio over alsa
>> the underlying tuner must be marked as being in use. It's all about
>> the tuner, since that's the resource that is being shared, not about
>> audio as such.
>>
>> For the remainder of my review I will ignore the audio-related code
>> and concentrate only on the tuner part.
>>
>>> Subsequent token (for tuner and audio) gets from the same task
>>> and task in the same tgid succeed. This allows applications that
>>> make multiple v4l2 ioctls to work with the first call acquiring
>>> the token and applications that create separate threads to handle
>>> video and audio functions.
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>>    MAINTAINERS                  |    2 +
>>>    include/linux/media_tknres.h |   50 +++++++++
>>>    lib/Makefile                 |    2 +
>>>    lib/media_tknres.c           |  237 ++++++++++++++++++++++++++++++++++++++++++
>>
>> I am still not convinced myself that this should be a generic API.
>> The only reason we need it today is for sharing tuners. Which is almost
>> a purely media thing with USB audio as the single non-media driver that
>> will be affected. Today I see no use case outside of tuners. I would
>> probably want to keep this inside drivers/media.
>>
>> If this is going to be expanded it can always be moved to lib later.
>
> Well, my argument is that it should be more generic if it were
> intended to be put in lib.  It'd be fine to put into drivers/media,
> but this code snippet must be a separate module.  Otherwise usb-audio
> would grab the whole media stuff even if not needed at all.

Certainly.

>
> (snip)
>> I also discovered that you are missing MODULE_AUTHOR, MODULE_DESCRIPTION
>> and above all MODULE_LICENSE. Without the MODULE_LICENSE it won't link this
>> module to the GPL devres_* functions. It took me some time to figure that
>> out.
>
> It was a code in lib, so it cannot be a module at all :)

Well, it depends on CONFIG_MEDIA_SUPPORT which is 'm' in my case, so it
compiles as a module :-)

Regards,

	Hans
