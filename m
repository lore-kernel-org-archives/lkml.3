Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3FLHuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:50:05 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:35307 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3FLHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:50:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFANwnuFGQ/khN/2dsb2JhbABZgwmDbbhhgwKBABZ0giMBAQQBI1YQCw4KAgImAgJXBogbBqhYkTSBJo4MB4JMgRQDl0CRQoMROg
X-IronPort-AV: E=Sophos;i="4.87,850,1363132800"; 
   d="scan'208";a="14169528"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH] [media] usbtv: Add driver for Fushicai USBTV007 video frame grabber
Date: Wed, 12 Jun 2013 09:49:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-5.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1370857931-6586-1-git-send-email-lkundrak@v3.sk> <201306101305.05038.hverkuil@xs4all.nl> <1370885934.9757.11.camel@hobbes.kokotovo>
In-Reply-To: <1370885934.9757.11.camel@hobbes.kokotovo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306120949.44163.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10 June 2013 19:38:54 Lubomir Rintel wrote:
> On Mon, 2013-06-10 at 13:05 +0200, Hans Verkuil wrote:
> > > Also, I the hardware uses V4L2_FIELD_ALTERNATE interlacing, but I couldn't make
> > > it work,
> > 
> > What didn't work exactly?
> 
> Both mplayer and gstream v4l2src displayed only half of an image. Not
> sure which combinations of flags did I use anymore.

That makes sense since few if any apps can handle FIELD_ALTERNATE.

> > > +static int usbtv_queryctrl(struct file *file, void *priv,
> > > +				struct v4l2_queryctrl *ctrl)
> > > +{
> > > +	return -EINVAL;
> > > +}
> > 
> > Drop this ioctl. If it doesn't do anything, then don't specify it.
> 
> It actually does something; EINVAL here for any ctrl signals there's
> zero controls.
> 
> When undefined, ENOTTY that is returned is considered invalid by
> gstreamer source.

What version of gstreamer are you using? Looking at the gstreamer code it
seems that it can handle ENOTTY at least since September last year. Not handling
ENOTTY is an application bug (there are other - rare - drivers that do not
have any controls) and as such I really don't like seeing a workaround like
this in a driver, especially since this seems like it should be working fine
with the latest gstreamer.

> > It doesn't look too bad :-) You're using all the latest frameworks which is
> > excellent.
> 
> Thanks for your time. I'll follow up with a new version that aims to
> address all the concerns above (apart for the queryctl change, which
> would break with gstreamer).
> 
> > Can you run the v4l2-compliance tool and post the output of that tool?
> 
> Driver Info:
> 	Driver name   : usbtv
> 	Card type     : usbtv
> 	Bus info      : usb-0000:00:1d.7-5
> 	Driver version: 3.10.0
> 	Capabilities  : 0x85000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x05000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 
> Compliance test for device /dev/video1 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 	test VIDIOC_QUERYCTRL/MENU: OK
> 	test VIDIOC_G/S_CTRL: OK (Not Supported)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 	Standard Controls: 0 Private Controls: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 
> Format ioctls:
> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 	test VIDIOC_G/S_PARM: OK
> 	test VIDIOC_G_FBUF: OK (Not Supported)
> 	test VIDIOC_G_FMT: OK
> 	test VIDIOC_TRY_FMT: OK
> 	test VIDIOC_S_FMT: OK
> 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
> Codec ioctls:
> 	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 
> Total: 36, Succeeded: 36, Failed: 0, Warnings: 0
> 
> 

Nice!

	Hans
