Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaJ1VPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:15:49 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42313 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJ1VPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:15:47 -0400
Message-ID: <5450077F.70101@osg.samsung.com>
Date: Tue, 28 Oct 2014 15:15:43 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Takashi Iwai <tiwai@suse.de>
CC: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sander Eikelenboom <linux@eikelenboom.it>, prabhakar.csengg@gmail.com,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com> <544804F1.7090606@linux.intel.com> <20141025114115.292ff5d2@recife.lan> <s5hk33n8ccj.wl-tiwai@suse.de> <20141027105237.5f5ec7fd@recife.lan>
In-Reply-To: <20141027105237.5f5ec7fd@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 06:52 AM, Mauro Carvalho Chehab wrote:
> Em Sun, 26 Oct 2014 09:27:40 +0100
> Takashi Iwai <tiwai@suse.de> escreveu:
> 

> 
> Hmm... this is actually more complex than that. V4L2 driver doesn't
> know if ALSA is streaming or not, or even if ALSA device node is opened
> while he is touching at the hardware configuration or changing the
> state. I mean: it is not an error to set the hardware. The error only
> happens if ALSA and V4L2 tries to do it at the same time on an incompatible
> way.
> 
> Also, this won't work for DVB, as on DVB this is really an exclusive
> lock that would prevent both ALSA and V4L2 drivers to stream while in
> DVB mode.
> 
> Implementing it with a lock seems to be the best approach, at least on
> my eyes.
> 
>> That said, we should go back and start discussing the design goal at
>> first.
> 
> Surely.

This is long, however, hoping it will describe the problem and
solution that is being pursued in detail:

At a higher level the problem description is:

There are 3 different device files that get created to control
tuner and audio functions on a media device. 3 drivers (dvb,
v4l2, alsa), and 3 core apis (dvb-core, v4l-core, audio) that
control the tuner and audio hardware and provide user api to
these 3 device files.

User applications, drivers and the core have no knowledge of each
other. The only thing that is common across all these drivers is
the parent device for the main usb device which is controlled by
the main usb driver.

The premise for the main design idea in this series is creating
a common construct at the parent device structure that is visible
to all drivers to act as a master access control (lock). Let's call
this media token object with two sub-tokens one for tuner and another
for audio.

Each of the apis evolved separately, hence have their own backwards
compatibility to maintain. Starting with v4l2:

v4l2 case:
Multiple v4l2 applications are allowed to open /dev/video0 in
read/write mode with no restrictions as long as the tuner is in
analog mode. v4l2 core handles conflicting requests between v4l2
applications. It doesn't have the knowledge that the tuner is in
use by a dvb and/or audio is in use. As soon as a v4l2 application
starts, digital stream glitches and audio glitches.

dvb case:
Multiple dvb applications can open the dvb device in read only mode.
As soon an application open the device read/write mode a separate
kthread is kicked off to handle the request. Only one application
can open the device in read/write mode. Similar to v4l2 case,
dvb-core doesn't have any knowledge that the tuner is in use by
v4l2 and/or audio is in use. As soon as a dvb application starts v4l2
video glitches and audio glitches.

audio case:
Same scenario is applicable to audio application. When a v4l2 or dvb
application starts, audio application gets impacted.

Problems to address:

dvb owns tuner and audio: another dvb, v4l2 app and audio app should
                          detect tuner/audio busy right away and exit.

v4l2 owns tuner and audio: another dvb and audio app should detect
                           tuner/audio busy right away and exit.
                           v4l2 app can continue to use it until it
                           tries to change the tuner/audio state.


audio owns audio: dvb and v4l2 apps should detect audio busy and exit.

Special cases:

dvb apps. access tuner and audio in exclusive mode. i.e only one dvb app.
at a time is allowed to open the device read/write mode. As dvb apps.
create threads to handle audio and video, all threads in that group
should be allowed by the higher level construct to access the tuner and
audio. dvb application will have to hold tuner and audio tokens so v4l2
and audio apps. know they are in use.

audio apps. access audio in exclusive mode. i.e only one audio app. at
a time is allowed to open the device in read/write mode. Audio apps.
create threads and thread closes and re-opens the audio device. Threads
can do this and hence something that higher level construct has to allow.
audio app. has to hold audio token so dvb and v4l2 know that it is in use.
(Note: I am not sure if I have the audio scenario right)

v4l2 apps. access tuner and audio in shared v4l2 mode. i.e several v4l2
processes and threads could use tuner and audio at the same time. The
higher level construct has to allow multiple v4l2 apps. to access and
disallow dvb and audio apps. access when they are in use by v4l2.

Adding to this, both dvb and v4l2 open audio device and make snd pcm
capture callbacks. There is no way to tell if dvb or v4l2 or audio
app is the one that is making this request. dvb app would like audio
in exclusive mode allowing only one process and its threads to access
it. v4l2 on the other hand would like audio in shared state accessible
to all v4l2 processes. If dvb-core and v4l2-core get tuner and audio
tokens at the same time, the window for having tuner token and not
getting audio token go down.

In dvb case when dvb device is opened in read/write mode, and v4l2
case when an app. tries to change the status. Audio callbacks have to
detect if audio is busy, if not which mode to request the token in.
For dvb and audio app. cases, the audio token should be requested in
exclusive mode and in v4l2 case shared mode. The logic for requesting
audio token will have to be try to get in exclusive mode, if fails,
try to get in shared mode, and if that fails give up.

Current status:
Combining patch v1 and patch v2 designs by allowing shared mode token
hold for v4l2, and deciding on where to hold audio token from
alsa driver will solve the above conflict scenarios. That said, the
question is "is this the right approach?" or are there other ways to
solve the problem. One thing is clear, we need some common higher level
construct for all the device drivers and dvb, v4l2, and audio ioctls,
callbacks etc, to detect the hardware is in use.

I do think lock/token approach has the best potential to solve the
problems. We are at this point very close to addressing conflicts.
At least the ones I am able to test.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
