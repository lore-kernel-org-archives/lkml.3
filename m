Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaDNWsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:48:22 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:27288 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaDNWsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:48:20 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-11-534c65b093bc
Message-id: <534C65AD.20404@samsung.com>
Date: Mon, 14 Apr 2014 16:48:13 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
 <20140410083841.488f9c43@samsung.com>
 <20140410124653.64aeb06d@alan.etchedpixels.co.uk>
 <20140410113949.7de1312b@samsung.com>
In-reply-to: <20140410113949.7de1312b@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+wr+6GVJ9gg0cf5CwmTfnLZtG8eD2b
	xeVdc9gsejZsZbV4svAMk8XjFW/ZLb7+dLD4tfwoo8W2WwtZHDg9ds66y+6xa9tOJo/Fe14y
	eWxa1cnmsX/uGnaP1pObWD12fm9g9/i8SS6AI4rLJiU1J7MstUjfLoEr4+XEFSwFMzUrjk/d
	wNbA+EGhi5GTQ0LARGLno1OMELaYxIV769m6GLk4hASWMUrsvtLBDOH0Mkl09L1gh3A2MEr8
	O7WQDaSFV0BD4vyTXmYQm0VAVWLl7S6wUWwC6hKfX+9gB7GFBOQkmpasBqsRFYiQeHV2IgtE
	r6DEj8n3gGwODhGBFInrf8NB5jMLfGaU2DZvF1i9sICNxP5rV1ggFm9mkng9q50VJMEpYCRx
	rmcD2BHMAtYSKydtY4Sw5SU2r3nLDLFYWeLP5VNMEL8pSNxYuIx1AqPILCS7ZyFpn4WkfQEj
	8ypGsdLi5ILipPTUCiO94sTc4tK8dL3k/NxNjJDoq97BePerzSFGAQ5GJR5eizfewUKsiWXF
	lbmHGCU4mJVEeF8n+wQL8aYkVlalFuXHF5XmpBYfYmTi4JRqYJS95NOTw8ujsHtb+KWP4RX/
	kzhOTPntp/Cu1uaRnHxCiQXzjtnZD2ryRPmmB/qrrbjOljZVs/1uS9LBuXXX3H6uZpCeKmtl
	Mu15x/6LLBrM5y/6Oqq4xoa9Wu18tv3fYWWmbrs61ifbr/14ub7OWFPqm+nErzWKHzzFngV8
	4L4++chKTma1FCWW4oxEQy3mouJEAIQpYV2cAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 08:39 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 10 Apr 2014 12:46:53 +0100
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> escreveu:
>
>>> For example, some devices provide standard USB Audio Class, handled by
>>> snd-usb-audio for the audio stream, while the video stream is handled
>>> via a separate driver, like some em28xx devices.
>>
>> Which is what mfd is designed to handle.
>>
>>> There are even more complex devices that provide 3G modem, storage
>>> and digital TV, whose USB ID changes when either the 3G modem starts
>>> or when the digital TV firmware is loaded.
>>
>> But presumably you only have one driver at a time then ?
>
>> The MFD device provides subdevices for all the functions. That is the
>> whole underlying concept.
>
> I'll take a look on how it works, and how it locks resources on
> other drivers. What drivers outside drivers/mfd use shared resources
> that require locks controlled by mfd?
>

One question that came up during the RFC review is:

Can media drivers use mfd framework for sharing functions across drivers?

I looked into the mfd framework and see if it helps the problem at hand 
hand. My conclusions as follows:

1. device presentation
- media devices appear as a group of devices that can be clearly
   identified as independent devices. Each device implements a
   function which could be shared by one or more functions.

- mfd devices appear as a single device. mfd framework helps present
   them as discrete platform devices. This model seems to be similar
   to a multi-function I/O card.

This above is an important difference between these two device types.

Media devices could benefit from using mfd framework in grouping
the device to make it easier to treat these devices as a group. mfd
framework could handle adding and removing devices. Something that
could be looked into in detail to see if it makes sense to use mfd
framework.

2. function sharing
- each media device supports a function and one or more functions share
   another function. For example, tuner is shared by analog and digital
   TV functions.

- mfd devices don't seem to work this way. Each function seems to be
   independent. Sharing is limited to the attach point. It works more
   like a bus, where sub-devices attach. I couldn't find any examples
   of a device/function being shared by other functions like in the case
   of media devices.

3. drivers
-  mfd/viperboard uses mfd to group gpio, i2c and does load viperboard
    i2c and viperboard gpio drivers. These drivers seem to have anything
    in common during run-time. i.e once mfd framework is used to carve
    the device up to appear as discrete devices, each device can function
    independently.

-  media drivers that drive one single media TV stick are a diversified
    group. In general, Analog and digital TV functions have to coordinate
    access to their shared functions.

4. Locking
    Both media and mfd drivers have mechanisms to lock/unlock hardware.
    mfd framework itself doesn't have any locking constructs.

    mfd drivers use mutex similar to the way media drivers use to protect
    access to hardware. This is a fine grain locking.

However, media drivers need a large grain media function level locking
mechanism, where a token devres will come in handy. I think this type of
locking is needed even when media drivers take advantage of the mfd 
framework to group sub-devices.

Another question to ask is:
Why add token resources to drivers/base? Why not add at drivers/media?

Some medial devices provide multiple almost-independent functions. USB
and PCI core work is to allow multiple drivers to handle those
almost-independent functions.

For instance, snd-usb-audio driver will handle USB Audio Class devices,
including some em28x devices, as it provides an independent UAC interface,
while analog and digital TV are provided via another interface.

What this means is a em28xx device could have snd-usb-audio driving the
audio function.  However, the audio stream is only available if the
video stream is working. As a result, snd-usb-audio driver has to 
coordinate with the analog and digital functions em28xx_* drivers 
control. Hence, the need for a shared managed resource interfaces such 
as the proposed token devres interfaces at drivers/base level. This will
allow a media device to be controlled by drivers that don't necessarily
fall under drivers/media as in this above example.

Webcams with microphone on the other hand have completely independent
devices for audio and video. They don't need a shared devres type 
feature, as the USB core handles that properly.

Based on the above, I think, the mfd framework will not help address the 
media driver problem at hand. However, I do think media drivers can 
benefit from using the mfd framework for streamlined handling of 
sub-devices. I would propose going forward with adding the token devres 
to solve the issue of sharing functions across drivers that control the 
functions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
