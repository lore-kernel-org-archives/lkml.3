Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaJURcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:32:25 -0400
Received: from lists.s-osg.org ([54.187.51.154]:41572 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbaJURcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:32:24 -0400
Message-ID: <5446989A.3010000@osg.samsung.com>
Date: Tue, 21 Oct 2014 11:32:10 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>
CC: Lars-Peter Clausen <lars@metafoo.de>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de>
In-Reply-To: <s5hbnp5z9uy.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 10:05 AM, Takashi Iwai wrote:
> At Tue, 21 Oct 2014 17:42:51 +0200,
> Hans Verkuil wrote:

>>
>> Quite often media apps open the alsa device at the start and then switch
>> between TV, radio or DVB mode. If the alsa device would claim the tuner
>> just by being opened (as opposed to actually using the tuner, which happens
>> when you start streaming),
> 
> What about parameter changes?  The sound devices have to be configured
> before using.  Don't they influence on others at all, i.e. you can
> change the PCM sample rate etc during TV, radio or DVB is running?

Yes. kaffeine uses  snd_usb_capture_ops ioctl -> snd_pcm_lib_ioctl

Other v4l and vlc (dvb) uses open/close as well as trigger start and
stop. trigger start/stop is done by a special audio thread in some
cases. open/close happens from the main thread.

> 
>> then that would make it impossible for the
>> application to switch tuner mode. In general you want to avoid that open()
>> will start configuring hardware since that can quite often be slow. Tuner
>> configuration in particular can be slow since several common tuners need
>> to load firmware over i2c. You only want to do that when it is really needed,
>> and not when some application (udev!) opens the device just to examine what
>> sort of device it is.
> 
> But most apps close the device soon after that, no?
> Which programs keep the PCM device (not the control) opened without
> actually using?
> 
>> So claiming the tuner in the trigger seems to be the right place. If
>> returning EBUSY is a poor error code for alsa, then we can use something else
>> for that. EACCES perhaps?
> 
> Sorry, I'm not convinced by that.  If the device has to be controlled
> exclusively, the right position is the open/close.  Otherwise, the
> program cannot know when it becomes inaccessible out of sudden during
> its operation.
> 
> 

Let me share my test matrix for this patch series. Hans pointed out
one test case I didn't know about as a result missed testing. Please
see if any of the tests miss use-cases or break them: you can scroll
down to the proposal at the end, if this is too much detail :)

Digital active and analog starting testing:
kaffeine running
- v4l2-ctl --all - works
- Changing channels works with the same token hold, even when
  frequency changes. Tested changing channels that force freq
  change.
- vlc resource is busy with no disruption to kaffeine
- xawtv - tuner busy when it tries to do ioctls that change
  tuner settings - snd_usb_pcm_open detects device is busy
  ( pcm open called from the same thread, trigger gets called
    from another thread )
- tvtime - tuner busy when it tries to do ioctls that change
  tuner settings with no disruption to kaffeine
  ( pcm open called from the same thread, trigger gets called
    from another thread )
- vlc - audio capture on WinTV HVR-950 - device is busy
  start vlc with no channels for this test
- arecord to capture on WinTV HVR-950 - device busy

vlc running
vlc -v channels.xspf
- v4l2-ctl --all - works
- Changing channels works with the same token hold, even when
  frequency changes. Tested changing channels that force freq
  change.
- kaffeine resource is busy with no disruption to vlc
- xawtv - tuner busy when it tries to do ioctls that change
  tuner settings - snd_usb_pcm_open detects device is busy
  ( pcm open called from the same thread, trigger gets called
    from another thread )
- tvtime - tuner busy when it tries to do ioctls that change
  tuner settings with no disruption to kaffeine
  ( pcm open called from the same thread, trigger gets called
    from another thread )
- vlc - audio capture on WinTV HVR-950 - device is busy
- arecord to capture on WinTV HVR-950 - device busy

Analog active and start digital testing:
xawtv -noalsa -c /dev/video1
- v4l2-ctl --all - works
- start kaffeine - fails with device busy and no disruption
- start vlc - fails with device busy and no disruption
- tvtime - tuner busy when it tries to do ioctls that change
  tuner settings with no disruption to kaffeine
- vlc - audio capture on WinTV HVR-950 - device is busy
- arecord to capture on WinTV HVR-950 - device busy

tvtime
- v4l2-ctl --all - works
- start kaffeine - fails with device busy and no disruption
- start vlc - fails with device busy and no disruption
- xawtv - tuner busy when it tries to do ioctls that change
  tuner settings with no disruption to kaffeine
- vlc - audio capture on WinTV HVR-950 - device is busy
- arecord to capture on WinTV HVR-950 - device busy

The following audio/video start/stop combination tests:
( used arecord as well to test these cases, arecord )

- tvtime start/vlc start/vlc stop/tvtime stop
  no disruption to tvtime
- tvtime start/vlc start/tvtie stop/vlc stop
  One tvtime stops, could trigger capture manually
- vlc start/tvtime start/tvtime stop/vlc stop
  vlc audio capture continues, tvtime detect tuner busy
- vlc start/tvtime start/vlc stop/tvtime start
  when vlc stops, tvtime could open the tuner device

Repeated the above with kaffeine and vlc and arecord audio
capture combinations.

Hans pointed out I am missing:

v4l2-ctl -f 180 --sleep=10
While it is sleeping you must still be able to set the frequency from
another console.

And it doesn't matter which of the two v4l2-ctl processes ends first,
as long as one has a reference to the tuner you should be blocked
from switching the tuner to a different mode (radio or dvb)

I think this above fails because tuner token ownership doesn't
span processes. Token should act as a lock between dvb/audio/v4l,
and v4l itself has mechanisms to handle the multiple ownership token
shouldn't interfere with.

Provided the only thing that is breaking is the v4l case, I think
I can get it to work with the bit field approach.

Here is what I propose for patch v3:
- make it a module under media
- collapse tuner and audio tokens into media token
- change names (get rid of abbreviated tkn stuff)
- Make other changes Takashi/Lars pointed out in pcm
- hold token in pcm open/close
- add a bitfield to struct v4l2_fh to handle
  the v4l specific multiple ownership cases.
- v4l-core and au0828-videp patches will see changes.
- dvb patch should still be good (crossing fingers)

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
