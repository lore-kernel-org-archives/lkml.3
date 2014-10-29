Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaJ2R4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:56:52 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42543 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaJ2R4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:56:50 -0400
Date: Wed, 29 Oct 2014 15:56:39 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
Subject: Re: [RFCv1] Media Token API needs - Was: Re: [alsa-devel] [PATCH v2
 5/6] sound/usb: pcm changes to use media token api
Message-ID: <20141029155639.5529bf70@recife.lan>
In-Reply-To: <5451109B.3000604@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
	<cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
	<543FB374.8020604@metafoo.de>
	<543FC3CD.8050805@osg.samsung.com>
	<s5h38aow1ub.wl-tiwai@suse.de>
	<543FD1EC.5010206@osg.samsung.com>
	<s5hy4sgumjo.wl-tiwai@suse.de>
	<543FD892.6010209@osg.samsung.com>
	<s5htx34ul3w.wl-tiwai@suse.de>
	<54467EFB.7050800@xs4all.nl>
	<s5hbnp5z9uy.wl-tiwai@suse.de>
	<CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
	<544804F1.7090606@linux.intel.com>
	<20141025114115.292ff5d2@recife.lan>
	<s5hk33n8ccj.wl-tiwai@suse.de>
	<20141027105237.5f5ec7fd@recife.lan>
	<5450077F.70101@osg.samsung.com>
	<20141028214250.27f0c869@recife.lan>
	<5451109B.3000604@osg.samsung.com>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 29 Oct 2014 10:06:51 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 10/28/2014 05:42 PM, Mauro Carvalho Chehab wrote:
> > Hi Shuah,
> > 
> > I'm understanding that you're collecting comments to write a RFC with the
> > needs by the media token, right?
> > 
> > I'm sending you my contributions to such text. See enclosed.
> > 
> > I suggest to change the subject and submit this on a separate thread, after
> > we finish the review of such document. Anyway, I'm changing the subject
> > of this Thread to reflect that.
> > 
> > Regards,
> > Mauro
> > 
> > Em Tue, 28 Oct 2014 15:15:43 -0600
> > Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> > 
> >> On 10/27/2014 06:52 AM, Mauro Carvalho Chehab wrote:
> >>> Em Sun, 26 Oct 2014 09:27:40 +0100
> >>> Takashi Iwai <tiwai@suse.de> escreveu:
> >>>
> >>
> >>>
> >>> Hmm... this is actually more complex than that. V4L2 driver doesn't
> >>> know if ALSA is streaming or not, or even if ALSA device node is opened
> >>> while he is touching at the hardware configuration or changing the
> >>> state. I mean: it is not an error to set the hardware. The error only
> >>> happens if ALSA and V4L2 tries to do it at the same time on an incompatible
> >>> way.
> >>>
> >>> Also, this won't work for DVB, as on DVB this is really an exclusive
> >>> lock that would prevent both ALSA and V4L2 drivers to stream while in
> >>> DVB mode.
> >>>
> >>> Implementing it with a lock seems to be the best approach, at least on
> >>> my eyes.
> >>>
> >>>> That said, we should go back and start discussing the design goal at
> >>>> first.
> >>>
> >>> Surely.
> >>
> >> This is long, however, hoping it will describe the problem and
> >> solution that is being pursued in detail:
> > 
> > Before starting with the description, this is the simplified diagram of
> > a media device (without IR, eeprom and other beasts):
> > 
> >   +-----------------------------------------------------------------------------------------+
> >   |                                                                                         |
> >   |                   +----------------+     +------------------+-------+----------------+  |
> >   |                   |  demod_video   | <-- |      analog      | tuner |     digital    |  |
> >   |                   +----------------+     +------------------+-------+----------------+  |
> >   |                     |                      |                           |                |
> >   |                     |                      |                           |                |
> >   v                     v                      v                           v                |
> > +--------------+-----+-----------------+     +------------------+        +---------------+  |
> > |     dvb      | DMA |      analog     |     |   demod_audio    |        | digital_demux | -+
> > +--------------+-----+-----------------+     +------------------+        +---------------+
> >   |                     |                      |
> >   |                     |                      |
> >   v                     v                      v
> > +--------------+      +----------------+     +------------------+
> > | devnode dvr0 |      | devnode video0 |     |    audio DMA     |
> > +--------------+      +----------------+     +------------------+
> >                                                |
> >                                                |
> >                                                v
> >                                              +------------------+
> >                                              | devnode pcmC1D0c |
> >                                              +------------------+
> > 
> > There are two components that are shared there between analog and digital:
> > the tuner (where the signal is captured) and the DMA engine used to stream
> > analog and Digital TV (dvb).
> > 
> > PS.: the diagram is over-simplified, as the tuner is just one of the possible
> > inputs for the analog part of the device. Other possible inputs are S-Video,
> > composite, HDMI, etc.
> > 
> > Sometimes, the audio DMA is also shared, e. g. just one stream comes from
> > the hardware. It is up to the driver to split audio and video and send
> > them to the V4L2 and ALSA APIs. This is the case of tm6000 driver.
> > 
> > Those shared components can be used either at analog or digital mode,
> > but not at the same time.
> > 
> > Also, programming the V4L2 analog and audio DMA and demods should be done
> > via V4L2 API, as this API allows the selection of the proper audio/video
> > input (almost all devices have multiple analog inputs).
> > 
> > Please notice that, if the tuner is on digital mode, the entire analog
> > path is disabled, including ALSA output.
> > 
> > If the tuner is on analog mode, both ALSA and V4L2 can work at the
> > same time. However, during the period where the tuner firmware is
> > loaded, and during the DMA configuration and input selection time,
> > neither ALSA or V4L2 can stream. Such configuration/firmware load
> > is commanded via V4L2 API, as ALSA knows nothing about tuner or
> > input selection.
> > 
> >>
> >> At a higher level the problem description is:
> >>
> >> There are 3 different device files that get created to control
> >> tuner and audio functions on a media device. 3 drivers (dvb,
> >> v4l2, alsa), and 3 core apis (dvb-core, v4l-core, audio) that
> >> control the tuner and audio hardware and provide user api to
> >> these 3 device files.
> > 
> > 
> > There's actually a 4th component for some drivers: the mceusb driver,
> > that handles remote controllers. The mceusb handles the Microsoft 
> > Media Center Remote Control protocol. It supports standalone remote
> > controller devices, but it also supports a few USB devices that use
> > a separate interface for IR.
> > 
> > There are currently some issues on cx231xx and mceusb, as both drivers 
> > can be used at the same time, but, when cx231xx sends certain commands, 
> > the mceusb IR polls fail. This is out of the scope of the audio lock,
> > but it also needs to be addressed some day.
> > 
> >> User applications, drivers and the core have no knowledge of each
> >> other. The only thing that is common across all these drivers is
> >> the parent device for the main usb device which is controlled by
> >> the main usb driver.
> > 
> > I would add that there are user applications that can handle all
> > 3 APIs like MythTV. But, at least MythTV doesn't know how to associate
> > ALSA, V4L2 and DVB devnodes that belong to the same device.
> > 
> > I mean: if MythTV finds, let's say, 3 V4L2 nodes, 3 ALSA nodes, 
> > and 1 DVB node, it doesn't know what device is associated with the
> > DVB node.
> > 
> > Almost all applications that are aware of V4L2 API are also aware of
> > ALSA API and may associate audio and video, as there is a way to 
> > associate it using sysfs. However, several apps don't use it.
> > 
> >> The premise for the main design idea in this series is creating
> >> a common construct at the parent device structure that is visible
> >> to all drivers to act as a master access control (lock). Let's call
> >> this media token object with two sub-tokens one for tuner and another
> >> for audio.
> >>
> >> Each of the apis evolved separately, hence have their own backwards
> >> compatibility to maintain. Starting with v4l2:
> >>
> >> v4l2 case:
> >> Multiple v4l2 applications are allowed to open /dev/video0 in
> >> read/write mode with no restrictions as long as the tuner is in
> >> analog mode. v4l2 core handles conflicting requests between v4l2
> >> applications. 
> > 
> >> It doesn't have the knowledge that the tuner is in
> > 
> > To be clear: "It" here refers to v4l2 core. The drivers may have this
> > knowledge as, except for one case (bttv driver), they share some data.
> > 
> >> use by a dvb and/or audio is in use. As soon as a v4l2 application
> >> starts, digital stream glitches and audio glitches.
> >>
> >> dvb case:
> >> Multiple dvb applications can open the dvb device in read only mode.
> > 
> > There's no issue with ALSA on R/O mode, as the application is not
> > allowed to modify anything at the stream. This is used only to monitor
> > an already opened device in R/W mode.
> > 
> >> As soon an application open the device read/write mode a separate
> >> kthread is kicked off to handle the request. Only one application
> >> can open the device in read/write mode. 
> > 
> >> Similar to v4l2 case,
> > 
> > s/v4l2/v4l2 core/
> > 
> >> dvb-core doesn't have any knowledge that the tuner is in use by
> >> v4l2 and/or audio is in use. As soon as a dvb application starts v4l2
> >> video glitches and audio glitches.
> >>
> >> audio case:
> >> Same scenario is applicable to audio application. When a v4l2 or dvb
> >> application starts, audio application gets impacted.
> >>
> >> Problems to address:
> >>
> >> dvb owns tuner and audio: another dvb, v4l2 app and audio app should
> >>                           detect tuner/audio busy right away and exit.
> >>
> >> v4l2 owns tuner and audio: another dvb and audio app should detect
> >>                            tuner/audio busy right away and exit.
> > 
> > Actually, no: audio should not exit. The V4L2 should only hold the
> > token for the required time to initialize the device and/or load the
> > firmware. ALSA applications should wait for V4L2 to finish
> > programming at audio, and should keep working after that.
> > 
> >>                            v4l2 app can continue to use it until it
> >>                            tries to change the tuner/audio state.
> >>
> >>
> >> audio owns audio: dvb and v4l2 apps should detect audio busy and exit.
> > 
> > Actually no. It is, instead:
> > 
> > audio owns audio: dvb apps should detect audio busy and exit.
> > V4L2 apps should work. However, when certain V4L2 ioctls are issued, 
> > the audio device driver should not send any command to the hardware.
> > After such commands, the audio mixers may change.
> > 
> > We need two separate tokens because of that: the behavior is different.
> > 
> > This is basically why we need two separate tokens, and because we cannot
> > implement locking at ALSA open/close.
> > 
> >>
> >> Special cases:
> >>
> >> dvb apps. access tuner and audio in exclusive mode. i.e only one dvb app.
> >> at a time is allowed to open the device read/write mode.
> > 
> > To be clearer: dvb apps won't use the audio node, but audio should be blocked,
> > as the devices can't use audio while in DVB mode.
> > 
> >> As dvb apps.
> >> create threads to handle audio and video, 
> > 
> > No. DVB apps don't handle audio/video. It receives data as MPEG-TS,
> > using a separate device node. Yet, the same DMA engine that provides
> > video (and, sometimes audio) is used by the DVB devnode.
> > 
> >> all threads in that group
> >> should be allowed by the higher level construct to access the tuner and
> >> audio. dvb application will have to hold tuner and audio tokens so v4l2
> >> and audio apps. know they are in use.
> >>
> >> audio apps. access audio in exclusive mode. i.e only one audio app. at
> >> a time is allowed to open the device in read/write mode. Audio apps.
> >> create threads and thread closes and re-opens the audio device. Threads
> >> can do this and hence something that higher level construct has to allow.
> >> audio app. has to hold audio token so dvb and v4l2 know that it is in use.
> >> (Note: I am not sure if I have the audio scenario right)
> >>
> >> v4l2 apps. access tuner and audio in shared v4l2 mode. i.e several v4l2
> >> processes and threads could use tuner and audio at the same time. The
> >> higher level construct has to allow multiple v4l2 apps. to access and
> >> disallow dvb and audio apps. access when they are in use by v4l2.
> > 
> > Actually, V4L2 core handles concurrency. There's just one file handler
> > with full control to start/stop stream at V4L2 side.
> > 
> >>
> >> Adding to this, both dvb and v4l2 open audio device and make snd pcm
> >> capture callbacks.
> > 
> > Huh? DVB won't need to touch at PCM capture callbacks. It should just
> > avoid audio PCM capture to stream while in DVB mode.
> > 
> >> There is no way to tell if dvb or v4l2 or audio
> >> app is the one that is making this request.
> > 
> >> dvb app would like audio
> >> in exclusive mode allowing only one process and its threads to access
> >> it.
> > 
> > No. It just wants to disable the part of the hardware that can now
> > be powered off.
> 
> Hmm. I am seeing some snd_pcm_lib_ioctls coming from dvb application.

Well, probably it is related to the audio output and not audio
capture (or the application you're looking into is an hybrid one).

> >From what you are saying, these could be for poweroff.
> 
> > 
> >> v4l2 on the other hand would like audio in shared state accessible
> >> to all v4l2 processes. 
> > 
> >> If dvb-core and v4l2-core get tuner and audio
> >> tokens at the same time, the window for having tuner token and not
> >> getting audio token go down.
> > 
> > No. It should not be allowed that both dvb-core and v4l2-core to get
> > the tokens at the same time. This is an exclusive lock.
> 
> I should have explained this better. What I meant was that dvb-core when
> it gets the tuner, it should also obtain audio right away. v4l2-core
> when it gets the tuner, it should get the audio at the same time. When
> dvb-core has the tuner, v4l2 shouldn't get it and vice versa.

Yep.

> > 
> >> In dvb case when dvb device is opened in read/write mode, and v4l2
> >> case when an app. tries to change the status. Audio callbacks have to
> >> detect if audio is busy, if not which mode to request the token in.
> > 
> > Huh?
> 
> ok again bad explaining on my part. Let me try again. When dvb-core has
> the audio locked, audio application should detect the condition and take
> appropriate action. When v4l2-core has audio locked, audio application
> should detect the condition and take appropriate action.
> 
> > 
> >> For dvb and audio app. cases, the audio token should be requested in
> >> exclusive mode and in v4l2 case shared mode. The logic for requesting
> >> audio token will have to be try to get in exclusive mode, if fails,
> >> try to get in shared mode, and if that fails give up.
> > 
> > Huh?
> 
> Consider this flow:
> 
> step 1: dvb-core locks tuner and audio.
> step 2: audio ioctl is initiated (from the application)
> step 3: If dvb-core has the audio locked, how does alsa know if it can
>         proceed with the ioctl request or not?

That's simple: it should stop streaming, as part of the hardware can
be powered off. It can only return opening the device after DVB
releases.

> >> Current status:
> >> Combining patch v1 and patch v2 designs by allowing shared mode token
> >> hold for v4l2, and deciding on where to hold audio token from
> >> alsa driver will solve the above conflict scenarios. That said, the
> >> question is "is this the right approach?" or are there other ways to
> >> solve the problem. One thing is clear, we need some common higher level
> >> construct for all the device drivers and dvb, v4l2, and audio ioctls,
> >> callbacks etc, to detect the hardware is in use.
> > 
> > I think that the current status is that we need to finish the spec
> > first. Then check if the patches are doing what's above.
> > 
> > It seems that we agree to not agree at the requirements so far ;)
> 
> I would say it is more of not having the same understanding of
> the requirements as opposed to wanting to agree to disagree.

True.

> Right I agree that developing a clear RFC spec will help us all be
> on the same page while I continue to find solution for this problem,
> and continuing work towards patch v3.
> 
> I will compile what we discussed so far in RFC and send it out for
> review in a day or two. I will include your diagrams and the scenarios
> I put together with your corrections in it.

Ok. After that, we can proceed with the token patch v3, or to see if
it is possible to use the media controller here, as Sakari suggested.

Regards,
Mauro
