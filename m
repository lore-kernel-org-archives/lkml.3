Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaKDXJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:09:05 -0500
Received: from lists.s-osg.org ([54.187.51.154]:43448 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaKDXJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:09:02 -0500
Message-ID: <54595C82.10404@osg.samsung.com>
Date: Tue, 04 Nov 2014 16:08:50 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Takashi Iwai <tiwai@suse.de>,
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
Subject: [RFCv2] Media Token API Spec.
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com> <544804F1.7090606@linux.intel.com> <20141025114115.292ff5d2@recife.lan> <s5hk33n8ccj.wl-tiwai@suse.de> <20141027105237.5f5ec7fd@recife.lan> <5450077F.70101@osg.samsung.com> <20141028214250.27f0c869@recife.lan> <5451109B.3000604@osg.samsung.com> <20141029155639.5529bf70@recife.lan>
In-Reply-To: <20141029155639.5529bf70@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Here is the RFC as promised. I also included the Media controller
as a an alternative and captured the discussion in the thread on
that topic. Please review.

-- Shuah

-----------------------------------------------------------------
RFC Media Token API Specification

Let's start with a diagram of a media device (without IR, eeprom
and others):

http://linuxtv.org/downloads/presentations/typical_hybrid_hardware.png

The dot lines represent the parts of the graph that are switched by
the tuner, DMA or input select.

Please notice that the DMA engines, together with the stuff needed to
control A/V switches is at one single chip. Changing the registers there
can affect the other streams, specially on most sophisticated devices
like cx231xx, where it even has a power management IP block that
validates if a device to be turned on/off won't exceed the maximum
drain current of 500mA. That's basically why we need to do a temporary
lock alsa, dvb, v4l and IR drivers when doing certain changes.

Also, please notice that I2C buses that can be as slow as 10kbps
are used to control for several devices, like:
        - the tuner
        - the Digital TV (DTV) demod
        - Analog and/or Video demod (sometimes embedded at the main
          chip)
        - DTV demux (sometimes embedded at the main chip)
        - The remote controller (sometimes embedded at the main chip)

For some devices, after powered on, or when certain parameters change, a
new firmware (and sometimes a hardware reset) is required. The firmware
size can be about 64KB or even bigger.

Also, the A/V switch it is actually two independent switches (or one
switch for video and one audio mux for audio) that needs to be changed
together when the source changes.

There are two components that are shared there between analog and
digital: the tuner (where the signal is captured) and the DMA engine
used to stream analog and Digital TV (dvb).

PS.: the diagram is over-simplified, as the tuner is just one of the
possible inputs for the analog part of the device. Other possible
inputs are S-Video, composite, HDMI, etc.

Sometimes, the audio DMA is also shared, e. g. just one stream comes
from the hardware. It is up to the driver to split audio and video and
send them to the V4L2 and ALSA APIs. This is the case of tm6000 driver.

Those shared components can be used either at analog or digital mode,
but not at the same time.

Also, programming the V4L2 analog and audio DMA and demods should be
done via V4L2 API, as this API allows the selection of the proper
audio/video input (almost all devices have multiple analog inputs).

Please notice that, if the tuner is on digital mode, the entire analog
path is disabled, including ALSA output.

If the tuner is on analog mode, both ALSA and V4L2 can work at the
same time. However, during the period where the tuner firmware is
loaded, and during the DMA configuration and input selection time,
neither ALSA or V4L2 can stream. Such configuration/firmware load
is commanded via V4L2 API, as ALSA knows nothing about tuner or
input selection.

At a higher level the problem description is:

There are 3 different device files that get created to control
tuner and audio functions on a media device. 4 drivers (dvb,
v4l2, alsa, and the main usb driver for the usb device), and
3 core APIs (dvb-core, v4l-core, audio) that control the tuner
and audio hardware and provide user API to these 3 device files.

The above driver model is simplified, there's 4th component for
some drivers: the mceusb driver, that handles remote controllers.
The mceusb handles the Microsoft Media Center Remote Control
protocol. It supports stand alone remote controller devices, but
it also supports a few USB devices that use a separate interface
for IR.

There are currently some issues on cx231xx and mceusb, as both drivers
can be used at the same time, but, when cx231xx sends certain commands,
the mceusb IR polls fail. This is out of the scope of the audio lock,
but it also needs to be addressed some day.

Most media user applications, drivers and the core have no knowledge
of each other. The only thing that is common across all these drivers
is the parent device for the main usb device which is controlled by
the usb driver.

Some media user applications like MythTV can handle all 3 APIs,
however, MythTV doesn't know how to associate ALSA, V4L2 and DVB
devnodes that belong to the same device. If MythTV finds, 3 V4L2
nodes, 3 ALSA nodes, and 1 DVB node, it doesn't know which device
is associated with the DVB node.

Almost all applications that are aware of V4L2 API are also aware of
ALSA API and may associate audio and video, as there is a way to
associate it using sysfs. However, several applications don't use it.

The premise for the main design idea in this series is creating
a common construct at the parent device structure that is visible
to all drivers to act as a master access control (lock). Let's call
this media token object with two sub-tokens one for tuner and another
for audio.

Each of the APIS evolved separately, hence have their own backwards
compatibility to maintain. Starting with v4l2:

V4L2 case:
Multiple v4l2 applications are allowed to open /dev/video0 in
read/write mode with no restrictions as long as the tuner is in
analog mode. V4L2-core handles conflicting requests between v4l2
applications. V4L2-core doesn't have the knowledge that the tuner
is in use by a dvb and/or audio is in use. Individual drivers
may have this knowledge as, except for one case (bttv driver),
they share some data.

As soon as a V4L2 application starts, digital stream glitches and
audio glitches.

DVB case:
Multiple dvb applications can open the dvb device in read only mode.
As soon an application open the device read/write mode a separate
kthread is kicked off to handle the request. Only one application
can open the device in read/write mode. There's no issue with ALSA
in R/O mode, as the application is not allowed to modify anything
with the stream. This is used only to monitor an already opened
device in R/W mode.

Similar to V4L2-core case, dvb-core doesn't have any knowledge that
the tuner is in use by v4l2 and/or audio is in use. As soon as a
dvb application starts v4l2 video glitches and audio glitches.

Audio case:
Same scenario is applicable to audio application. When a v4l2 or dvb
application starts, audio application gets impacted.

Problems to address:

Dvb owns tuner and audio: another dvb, v4l2 application and
                          ALSA application should detect
                          tuner/audio busy right away and exit.
                          Dvb applications don't use audio node,
                          however, devices can't use audio hardware
                          while in DVB mode.

V4l2 owns tuner and audio: dvb should detect tuner/audio busy
                           right away and exit.
                           The V4L2-core should only hold the token for
                           the required time to initialize the device
                           and/or load the firmware.
                           ALSA applications should wait for v4L2-core
			   to finish programming at audio, and should
                           keep working after that.

Audio owns audio: dvb applications should detect audio busy and
exit. V4L2 applications should work. However, when certain V4L2
ioctls are issued, the audio device driver should not send any
command to the hardware. After such commands, the audio mixers
may change. This is why two tokens are necessary, one for tuner
and another for audio.

Because of the above mentioned difference in behavior between dvb
and v4l applications when audio is busy, two tokens (one for tuner
and another for audio) are necessary and audio token lock should not
be held at ALSA open/close.

Special cases:

Dvb applications access tuner in exclusive mode. i.e only one dvb
application at a time is allowed to open the device read/write mode.
Dvb applications don't use audio node, however, devices can't use
audio hardware while in DVB mode. Dvb applications receive data as
MPEG-TS, using a separate device node. The same DMA engine that
provides video (and, sometimes audio) is used by the DVB device
node, making it inaccessible to audio applications while tuner
is in DVB mode. Hence, the need to prevent audio applications from
accessing audio node when tuner is in DVB mode. As a result, dvb-core
will have to hold tuner and audio tokens so v4l2-core and ALSA know
that audio is not available. Dvb disables audio hardware so it could
be powered-off in some cases.

Audio applications access audio in exclusive mode. i.e only one audio
application at a time is allowed to open the device in read/write mode.
Audio applications create threads and thread closes and re-opens the
audio device. Threads can do this and hence something that higher level
construct has to allow. Audio application has to hold audio token so
dvb and v4l2 know that it is in use.

V4l2 applications access tuner and audio in shared v4l2 mode.
i.e several v4l2 processes and threads could use tuner and audio
at the same time. V4L2 core handles concurrency. There's just
one file handler with full control to start/stop stream at V4L2
side. The higher level construct should not break the ability of
multiple v4l2 applications to access tuner and audio in shared
mode, and disallow dvb and audio applications access when they
are in use by the V4L2-core.

Dvb-core when it gets the tuner, it should also obtain audio right
away. v4l2-core when it gets the tuner, it should get the audio at
the same time. When dvb-core has the tuner, v4l2 shouldn't get it
and vice versa.

When dvb-core has the audio locked, audio application should detect
condition and stop streaming, as part of the hardware can be powered
off. It can only return opening the device after DVB releases audio
token.

When v4l2-core has audio locked, audio application should detect the
condition and stop sending commands to audio hardware. It can only
resume audio access after V4L2 releases audio token.

Open issues:
During testing, snd_pcm_lib_ioctls are coming from dvb application.
It is likely that these are related to the audio output and not audio
capture or the application in question is an hybrid one. This issue
needs further investigation.

Alternatives: (proposed by Sakari Ailus)
Can Media controller be used to solve the problem?

The usage of the media controller for this specific usage is that
we should not force userspace applications to be aware of the
media controller just because of hardware locking.

Currently, media entities may only be entities bound to a given
subsystem, but likely need to change media controller for complex
embedded DVB device support ...

In case of the Media controller, mutual exclusion of different users
is currently performed by adding the entities to a pipeline and
incrementing the streaming count once streaming is enabled --- on
different interfaces streaming may mean a different thing.

However, we'll still need to find a way for ALSA to prevent it to use
the audio demod and DMA engine that will be powered off when DVB is
streaming.

The Media controller interface does not handle serializing potential
users that may wish to configure the device. Handling serializing is
necessary if Media controller is extended instead of pursuing Media
Token API to solve the problem.

Reconfiguring the DMA engine and some other registers via V4L2 API
should be blocked. The same applies to firmware load, if the device
is using tuner input for analog TV.

If we use the media controller, we'll need to add a state to it,
to indicate that a block at the pipeline is being reconfigured.

It is dependent on Media Controller adoption on ALSA as well.

Next steps:

1. Review RFC
2. Evaluate the media controller alternative.
3. Proceed with development once the decision is made.

----------------------------------------------------------------------

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
