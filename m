Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaIXM0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:26:44 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4043 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbaIXM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:26:43 -0400
Message-ID: <5422B857.9020007@xs4all.nl>
Date: Wed, 24 Sep 2014 14:25:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sakari.ailus@linux.intel.com, ramakrmu@cisco.com,
        Devin Heitmueller <dheitmueller@kernellabs.co>, olebowle@gmx.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token
 api
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com> <CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com> <54208A03.2010101@osg.samsung.com> <CAGoCfix8BH0coq2q-ndvBvDHGJ6f28mVE0CzAnMZYgCaPg+yrw@mail.gmail.com> <5421DC1A.4030509@osg.samsung.com>
In-Reply-To: <5421DC1A.4030509@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On 09/23/2014 10:46 PM, Shuah Khan wrote:
> Hi Devin/Mauro/Hans,
>
> Summarizing the discussion on v4l to keep others on this
> thread in the loop. Please see below:
>
> Hans! Could you please take a look and see if it raises
> any red flags for you.
>
> On 09/23/2014 08:17 AM, Devin Heitmueller wrote:
>
>>
>> We can always start with coarse locking on open/close, and do finer
>> grained locking down the road if needed - or simply change the
>> currently undefined behavior in the spec to say that you have to close
>> the device handle before attempting to open the other side of the
>> device.
>>
>
> I share the same concerns about fine grain locking approach that
> requires changes to various v4l2 ioctls to hold the token. My
> concern with the current approach is that we won't be able to find
> all the v4l paths to secure. During my testing, it is clear that
> several applications don't seem to check ioctls return codes and
> even if one of the ioctls returns -EBUSY, applications keep calling
> other ioctls instead of exiting with device busy condition.

Let's be realistic: if an application doesn't test for error codes,
then that's the problem of the application. Also, EBUSY will only be
returned if someone else is holding the tuner in a different mode.
And that didn't work anyway (and probably in worse ways too if the
driver would forcefully change the tuner mode).

So I really don't see a problem with this.

>
> Compared to the current approach, holding lock in open and releasing
> it in close is cleaner with predictable failure conditions. It is lot
> easier to maintain. In addition, this approach keeps it same as the
> dvb core token hold approach as outlined below.

Absolutely not an option for v4l2. You should always be able to open
a v4l2 device, regardless of the tuner mode or any other mode.

The only exception is a radio tuner device: that should take the tuner
on open. I think this is a very unfortunate design and I wish that that
could be dropped.

One thing that we haven't looked at at all is what should be done if
the current input is not a tuner but a composite or S-Video input.

It is likely (I would have to test this to be sure) that you can capture
from a DVB tuner and at the same time from an S-Video input without any
problems. By taking the tuner token unconditionally this would become
impossible. But doing this right will require more work.

BTW, what happens if the analog video part of a hybrid board doesn't have
a tuner but only S-Video/Composite inputs? I think I've seen such boards
actually. I would have to dig through my collection though.

>
> dvb on the other hand is easier with its clean entry and exit points.
> In the case of dvb, the lock is held when the device is opened in
> read/write mode before dvb front-end thread gets started and released
> when thread exits.
>
> I discussed this a couple of times in the past during development
> for this current patch series. The concern has been that a number of
> currently supported use-cases will break with the simpler approach
> to lock when v4l device is opened and unlock when it is closed.
>
> As we discussed this morning and agreed on giving the simpler
> approach a try first keeping the finer grain locking option
> open for revisit. This would be acceptable provided the token
> code is tested on existing apps, including mythtv, kradio,
> gnome-radio.

Nack from me. Taking a tuner token should only happen when the device
actually needs the tuner. For DVB that's easy, since whenever you open
the frontend you *know* you want the tuner.

But that's much more difficult for V4L2 since there are so many combinations,
including many that don't need a tuner at all such as HDMI, Composite etc.
inputs.

>
> In addition to releasing the token at device close, release the token
> if an app decides to use S_PRIORITY to release the streaming ownership
> e. g. V4L2_PRIORITY_BACKGROUND

S_PRIORITY has nothing to do with tuner ownership. If there is a real need
to release the token at another time than on close (and I don't see
such a need), then make a new ioctl. Let's not overload S_PRIO with an
unrelated action.

>
> Devin recommended testing on devices that have an encoder to cover
> the cases where there are multiple /dev/videoX nodes tied to the
> same tuner.

Good examples are cx23885 (already vb2) and cx88 (the vb2 patches have
been posted, but not yet merged). It shouldn't be too hard to find
hardware based on those chipsets.

>
> Please check if I captured it correctly. I can get started on the
> simpler approach and see where it takes us. I have to change the
> v4l2 and driver v4l2 patches. dvb and the rest can stay the same.

As mentioned, Nack for the simpler approach from me. That's simply
too simple :-)

Note: I'm travelling and attending a conference, so my availability for
the rest of the week will probably be limited.

Regards,

	Hans
