Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaIXP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:57:54 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37460 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaIXP5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:57:52 -0400
Message-ID: <5422E9FD.9050303@osg.samsung.com>
Date: Wed, 24 Sep 2014 09:57:49 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sakari.ailus@linux.intel.com, ramakrmu@cisco.com,
        Devin Heitmueller <dheitmueller@kernellabs.co>, olebowle@gmx.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token
 api
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com> <CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com> <54208A03.2010101@osg.samsung.com> <CAGoCfix8BH0coq2q-ndvBvDHGJ6f28mVE0CzAnMZYgCaPg+yrw@mail.gmail.com> <5421DC1A.4030509@osg.samsung.com> <5422B857.9020007@xs4all.nl>
In-Reply-To: <5422B857.9020007@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 06:25 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> 
> Let's be realistic: if an application doesn't test for error codes,
> then that's the problem of the application. Also, EBUSY will only be
> returned if someone else is holding the tuner in a different mode.
> And that didn't work anyway (and probably in worse ways too if the
> driver would forcefully change the tuner mode).
> 
> So I really don't see a problem with this.
> 

I didn't have high hopes you would agree to the simpler approach. :)

>>
>> Compared to the current approach, holding lock in open and releasing
>> it in close is cleaner with predictable failure conditions. It is lot
>> easier to maintain. In addition, this approach keeps it same as the
>> dvb core token hold approach as outlined below.
> 
> Absolutely not an option for v4l2. You should always be able to open
> a v4l2 device, regardless of the tuner mode or any other mode.
> 
> The only exception is a radio tuner device: that should take the tuner
> on open. I think this is a very unfortunate design and I wish that that
> could be dropped.

Right this is another problem that needs to be addressed in the
user-space.

> 
> One thing that we haven't looked at at all is what should be done if
> the current input is not a tuner but a composite or S-Video input.
> 
> It is likely (I would have to test this to be sure) that you can capture
> from a DVB tuner and at the same time from an S-Video input without any
> problems. By taking the tuner token unconditionally this would become
> impossible. But doing this right will require more work.
> 
> BTW, what happens if the analog video part of a hybrid board doesn't have
> a tuner but only S-Video/Composite inputs? I think I've seen such boards
> actually. I would have to dig through my collection though.
> 

I would recommend trying to bound the problems that need to be solved
for the first phase of this media token feature. If we don't we will
never be done with it. :)

I would propose the first step as addressing dvb and v4l2 conflicts
and include snd-usb-audio so there is confidence that the media token
approach can span non-media drivers.

I am currently testing with tvtime, xawtv, vlc, and kaffeine. I am
planning to add kradio for snd-usb-audio work for the next round of
patches.

> 
> S_PRIORITY has nothing to do with tuner ownership. If there is a real need
> to release the token at another time than on close (and I don't see
> such a need), then make a new ioctl. Let's not overload S_PRIO with an
> unrelated action.

This is not an issue for fine grained approach since simpler approach
is nacked. i.e Mauro suggested changing S_PRIORITY as another place
to release it if we were to go with simple appraoch (open/close).

> 
>>
>> Devin recommended testing on devices that have an encoder to cover
>> the cases where there are multiple /dev/videoX nodes tied to the
>> same tuner.
> 
> Good examples are cx23885 (already vb2) and cx88 (the vb2 patches have
> been posted, but not yet merged). It shouldn't be too hard to find
> hardware based on those chipsets.
> 

Please see my bounding the problem comment. Can these devices wait until
the second phase. We have multiple combinations with hardware features,
applications. The way I am designing the media token is if driver
doesn't create the token, no change in the dvb-core, v4l2-core behavior.
It is not required that driver must create a token to allow evolving
driver support and hardware support as we go.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
