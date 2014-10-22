Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaJVPZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:25:22 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4323 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaJVPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:25:18 -0400
Message-ID: <5447CC1D.7090900@xs4all.nl>
Date: Wed, 22 Oct 2014 17:24:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, Takashi Iwai <tiwai@suse.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <5446989A.3010000@osg.samsung.com>
In-Reply-To: <5446989A.3010000@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Some notes below...

On 10/21/2014 07:32 PM, Shuah Khan wrote:
> On 10/21/2014 10:05 AM, Takashi Iwai wrote:
>> At Tue, 21 Oct 2014 17:42:51 +0200,
>> Hans Verkuil wrote:
> 
>>>
>>> Quite often media apps open the alsa device at the start and then switch
>>> between TV, radio or DVB mode. If the alsa device would claim the tuner
>>> just by being opened (as opposed to actually using the tuner, which happens
>>> when you start streaming),
>>
>> What about parameter changes?  The sound devices have to be configured
>> before using.  Don't they influence on others at all, i.e. you can
>> change the PCM sample rate etc during TV, radio or DVB is running?
> 
> Yes. kaffeine uses  snd_usb_capture_ops ioctl -> snd_pcm_lib_ioctl
> 
> Other v4l and vlc (dvb) uses open/close as well as trigger start and
> stop. trigger start/stop is done by a special audio thread in some
> cases. open/close happens from the main thread.
> 
>>
>>> then that would make it impossible for the
>>> application to switch tuner mode. In general you want to avoid that open()
>>> will start configuring hardware since that can quite often be slow. Tuner
>>> configuration in particular can be slow since several common tuners need
>>> to load firmware over i2c. You only want to do that when it is really needed,
>>> and not when some application (udev!) opens the device just to examine what
>>> sort of device it is.
>>
>> But most apps close the device soon after that, no?
>> Which programs keep the PCM device (not the control) opened without
>> actually using?
>>
>>> So claiming the tuner in the trigger seems to be the right place. If
>>> returning EBUSY is a poor error code for alsa, then we can use something else
>>> for that. EACCES perhaps?
>>
>> Sorry, I'm not convinced by that.  If the device has to be controlled
>> exclusively, the right position is the open/close.  Otherwise, the
>> program cannot know when it becomes inaccessible out of sudden during
>> its operation.
>>
>>
> 
> Let me share my test matrix for this patch series. Hans pointed out
> one test case I didn't know about as a result missed testing. Please
> see if any of the tests miss use-cases or break them: you can scroll
> down to the proposal at the end, if this is too much detail :)
> 
> Digital active and analog starting testing:
> kaffeine running
> - v4l2-ctl --all - works

I would recommend using v4l2-ctl --all --list-inputs, this enumerates
inputs as well (which includes reading the tuner status). This would
have failed with all these tests with this patch series.

> - Changing channels works with the same token hold, even when
>   frequency changes. Tested changing channels that force freq
>   change.
> - vlc resource is busy with no disruption to kaffeine
> - xawtv - tuner busy when it tries to do ioctls that change
>   tuner settings - snd_usb_pcm_open detects device is busy
>   ( pcm open called from the same thread, trigger gets called
>     from another thread )
> - tvtime - tuner busy when it tries to do ioctls that change
>   tuner settings with no disruption to kaffeine
>   ( pcm open called from the same thread, trigger gets called
>     from another thread )
> - vlc - audio capture on WinTV HVR-950 - device is busy
>   start vlc with no channels for this test
> - arecord to capture on WinTV HVR-950 - device busy
> 
> vlc running
> vlc -v channels.xspf
> - v4l2-ctl --all - works
> - Changing channels works with the same token hold, even when
>   frequency changes. Tested changing channels that force freq
>   change.
> - kaffeine resource is busy with no disruption to vlc
> - xawtv - tuner busy when it tries to do ioctls that change
>   tuner settings - snd_usb_pcm_open detects device is busy
>   ( pcm open called from the same thread, trigger gets called
>     from another thread )
> - tvtime - tuner busy when it tries to do ioctls that change
>   tuner settings with no disruption to kaffeine
>   ( pcm open called from the same thread, trigger gets called
>     from another thread )
> - vlc - audio capture on WinTV HVR-950 - device is busy
> - arecord to capture on WinTV HVR-950 - device busy
> 
> Analog active and start digital testing:
> xawtv -noalsa -c /dev/video1
> - v4l2-ctl --all - works
> - start kaffeine - fails with device busy and no disruption
> - start vlc - fails with device busy and no disruption
> - tvtime - tuner busy when it tries to do ioctls that change
>   tuner settings with no disruption to kaffeine
> - vlc - audio capture on WinTV HVR-950 - device is busy
> - arecord to capture on WinTV HVR-950 - device busy
> 
> tvtime
> - v4l2-ctl --all - works
> - start kaffeine - fails with device busy and no disruption
> - start vlc - fails with device busy and no disruption
> - xawtv - tuner busy when it tries to do ioctls that change
>   tuner settings with no disruption to kaffeine
> - vlc - audio capture on WinTV HVR-950 - device is busy
> - arecord to capture on WinTV HVR-950 - device busy
> 
> The following audio/video start/stop combination tests:
> ( used arecord as well to test these cases, arecord )
> 
> - tvtime start/vlc start/vlc stop/tvtime stop
>   no disruption to tvtime
> - tvtime start/vlc start/tvtie stop/vlc stop
>   One tvtime stops, could trigger capture manually
> - vlc start/tvtime start/tvtime stop/vlc stop
>   vlc audio capture continues, tvtime detect tuner busy
> - vlc start/tvtime start/vlc stop/tvtime start
>   when vlc stops, tvtime could open the tuner device
> 
> Repeated the above with kaffeine and vlc and arecord audio
> capture combinations.
> 
> Hans pointed out I am missing:
> 
> v4l2-ctl -f 180 --sleep=10
> While it is sleeping you must still be able to set the frequency from
> another console.
> 
> And it doesn't matter which of the two v4l2-ctl processes ends first,
> as long as one has a reference to the tuner you should be blocked
> from switching the tuner to a different mode (radio or dvb)
> 
> I think this above fails because tuner token ownership doesn't
> span processes. Token should act as a lock between dvb/audio/v4l,
> and v4l itself has mechanisms to handle the multiple ownership token
> shouldn't interfere with.
> 
> Provided the only thing that is breaking is the v4l case, I think
> I can get it to work with the bit field approach.
> 
> Here is what I propose for patch v3:
> - make it a module under media
> - collapse tuner and audio tokens into media token
> - change names (get rid of abbreviated tkn stuff)
> - Make other changes Takashi/Lars pointed out in pcm
> - hold token in pcm open/close

I remain skeptical about this. I'm simply not sure what, if anything,
might break after this change. You need to test with applications that
can switch between V4L and DVB and that can handle an alsa device for
audio capture. MythTV is probably one. None of the applications you
are testing can switch between V4L and DVB devices dynamically to my
knowledge.

Today it is no problem for an application to open the alsa device,
start streaming analog video + audio, stop streaming video + audio,
switch to a digital input and start streaming the transport stream
from the dvb input.

This is all valid. But after this change you will no longer be able
to switch back and forth because the alsa open() locks the tuner mode.

I'm afraid that we will break some applications, either open source or
not, by making this change.

By locking the tuner mode only while streaming audio apps would be prevented
from breaking. The only time the trigger function will return an error
is when some other application has the tuner in a different (e.g. DVB)
mode and starting to stream would forcefully switch the tuner to
a different mode. And we *know* that will cause all sorts of unpredictable
behavior which is why we are doing all this effort to prevent that from
happening. Returning an error in that case makes perfect sense to me and
it is something that should not happen during normal use.

> - add a bitfield to struct v4l2_fh to handle
>   the v4l specific multiple ownership cases.
> - v4l-core and au0828-videp patches will see changes.
> - dvb patch should still be good (crossing fingers)

The remainder of the list looks OK to me.

I would also recommend making more use of the various command line tools:
arecord, v4l2-ctl, dvbv5-zap. By combining these you can test scenarios
that are hard to test in applications such as this:

	- make a small utility that just opens the alsa node without streaming
	  and that keeps it open (i.e. sleep(100000) or something). Let's call it alsaopen.
	- run alsaopen.
	- call arecord to start streaming audio (most likely using
	  the analog TV tuner).
	- stream with v4l2-ctl to see if that works (it should)
	- stop v4l2-ctl
	- now use dvbv5-zap to select a DVB channel: I would expect that that
	  fails because you are still streaming audio.
	- stop arecord.
	- try dvbv5-zap again: I think this should work, even though the alsaopen
	  utility still has alsa open, but with the current proposal this will fail.
	- stop alsaopen.
	- now dvbv5-zap should work.

Regards,

	Hans
