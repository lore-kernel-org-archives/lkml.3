Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaIWORI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:17:08 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:49928 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaIWORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <54208A03.2010101@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
	<b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com>
	<CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com>
	<54208A03.2010101@osg.samsung.com>
Date: Tue, 23 Sep 2014 10:17:04 -0400
Message-ID: <CAGoCfix8BH0coq2q-ndvBvDHGJ6f28mVE0CzAnMZYgCaPg+yrw@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token api
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sakari.ailus@linux.intel.com, ramakrmu@cisco.com,
        Devin Heitmueller <dheitmueller@kernellabs.co>, olebowle@gmx.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shuah,

>> What about G_INPUT and G_TUNER?  Consider the following use case, which is
>> entirely legal in the V4L2 API:
>
> Did you mean G_INPUT and G_STD here? I didn't see G_TUNER mentioned
> below in the use-case.

It can be either ENUM_INPUT or G_TUNER.  Both return status
information that requires communication with the video decoder chip
and/or tuner.  It's probably worth mentioning that ENUMINPUT isn't
like the other ENUM_ calls in that it doesn't return a static list
without  talking to the driver - it contains a field (called .status)
which actually needs to talk to the hardware in order to populate it.

>> 1.  Program opens /dev/video0
>> 2.  Program calls G_INPUT/G_STD and sees that the appropriate input and
>> standard are already set, since all devices have a default input at
>> initialization
>> 3.  Program never calls S_INPUT, S_STD, or S_TUNER
>> 4.  Program goes into a loop calling ENUM_INPUT, waiting until it returns
>> the input as having signal lock
>> 5.  When signal lock is seen, program calls STREAMON.
>
> I am missing vb2 streamon change to hold the tuner in this patch set.
> Without that change vb2 work isn't complete. Unfortunately I don't
> have hybrid hardware that uses a vb2 driver.

I don't think you quite understood my concern.  The concern is that in
the use case above I'm actively using the tuner *before*
VIDIOC_STREAMON is called.  Hence from a locking standpoint you
probably don't want to allow the DVB device to take control of the
tuner.

>>
>> In the above case, you would be actively using the au8522 video decoder but
>> not holding the lock, so thr DVB device can be opened and screw everything
>> up.  Likewise if the DVB device were in use and such a program were run, it
>> wouls break.
>>
>
> I think this use-case will be covered with changes to vb2 streamon
> to check and hold tuner. I am thinking it might not be necessary to
> change g_tuner, g_std, g_input and enum_input at v4l2-core level.
> Does that sounds right??

The more I think about it, the less confident I am that you actually
can take a fine-grained locking approach without adding additional
ioctls to make it explicit.  When is the tuner unlocked?  Is it when
the filehandle is closed?  If so, then the the following script would
behave in an unexpected manner:

#!/bin/sh

while [ 1 ]; do
  v4l2-ctl -n
  # Some code to parse the output and see if the "status" field for
current input shows no signal
  # If status shows as locked break
done
v4l2-ctl --stream-mmap=500 --stream-to=/tmp/foo.bin

In the above case I'm actively using the tuner but not holding the
lock most of the time, so a separate process can grab the DVB device
between calls to "v4l2-ctl -n".

However if you're keeping the device locked until STREAMOFF, then
you'll break all sorts of applications which might just close the
filehandle without calling STREAMOFF, and hence you'll have cases
where the tuner is left locked in analog mode *forever*, preventing
apps from using it in digital mode.

Without adding a new ioctl to lock/unlock the analog side of the
device, there is no real way to deal with this perfectly legal use
case.  The downside of that of course is that applications would have
to be modified in order for the locking to be used, and the default
would have to be to not do locking in order to preserve backward
compatibility with existing applications.

What other ioctls have we not thought of?  I think there is an
argument to be made that we're being too aggressive in trying to
control the locking based on the ioctls called.  It might make sense
to simplify the approach to lock on when the device is opened, and
unlock when closed.  This avoids the complexity of trying to figure
out *which* ioctls we need to set the lock on (which likely varies on
a per device basis anyway), at the cost of not allowing the device to
be used when something has the filehandle opened for the other side of
the device (the behavior of which is currently undefined in the spec).
I know there are concerns that some apps might leave the FD open even
when done using it, but that seems like a less likely case than
properly handling fine-grained locking (causing unexpected behavior
for the applications that don't expect -EBUSY to be returned after the
device has been successfully opened).

We can always start with coarse locking on open/close, and do finer
grained locking down the road if needed - or simply change the
currently undefined behavior in the spec to say that you have to close
the device handle before attempting to open the other side of the
device.

On a related note, you should be testing with MythTV - none of the
applications you are currently testing with support both analog *and*
digital, so you are not seeing all the race conditions that can occur
when you close one side of the device and then *immediately* open the
other side.  In particular, there is a known race that occurs when
closing the DVB device and then opening the V4L device, because the
DVB frontend shuts down the tuner asynchronously after the close()
call returns to userland.  Exiting one application and starting
another provides plenty of time for the close() logic to be run, so
you're missing all the race conditions.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
