Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaC1VeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:34:00 -0400
Received: from oproxy12-pub.mail.unifiedlayer.com ([50.87.16.10]:57423 "HELO
	oproxy12-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753228AbaC1Vdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:33:53 -0400
Message-ID: <1396042028.3383.34.camel@Wailaba2>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
From: Olivier Langlois <olivier@trillion01.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Date: Fri, 28 Mar 2014 17:27:08 -0400
In-Reply-To: <16236471.uFSjvbT2di@avalon>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com>
	 <16236471.uFSjvbT2di@avalon>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.179.63.169 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,


On Fri, 2014-03-28 at 17:20 +0100, Laurent Pinchart wrote:
> Hi Olivier,
> 
> Thank you for the patch.
> 
> On Friday 28 March 2014 01:42:38 Olivier Langlois wrote:
> > timestamps in v4l2 buffers returned to userspace are updated in
> > uvc_video_clock_update() which uses timestamps fetched from
> > uvc_video_clock_decode() by calling unconditionally ktime_get_ts().
> > 
> > Hence setting the module clock param to realtime have no effect
> > before this patch.
> > 
> > This has been tested with ffmpeg:
> > 
> > ffmpeg -y -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate 30 -i
> > /dev/video0 \ -f alsa -acodec pcm_s16le -ar 16000 -ac 1 -i default \
> >  -c:v libx264 -preset ultrafast \
> >  -c:a libfdk_aac \
> >  out.mkv
> > 
> > and inspecting the v4l2 input starting timestamp.
> > 
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > Cc: Stable <stable@vger.kernel.org>
> 
> Before applying this, I'm curious, do you have a use case for realtime time 
> stamps ?
> 

Yes. ffmpeg uses wall clock time to create timestamps for audio packets
from ALSA device.

There is a bug in ffmpeg describing problems to synchronize audio and
the video from a v4l2 webcam.

https://trac.ffmpeg.org/ticket/692

To workaround this issue, ffmpeg devs added a switch to convert back
monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:

  -ts                <int>        .D.... set type of timestamps for
grabbed frames (from 0 to 2) (default 0)
     default                      .D.... use timestamps from the kernel
     abs                          .D.... use absolute timestamps (wall
clock)
     mono2abs                     .D.... force conversion from monotonic
to absolute timestamps

If the v4l2 driver is able to send realtime ts, it is easier synchronize
in userspace if all inputs use the same clock.

Greetings,
Olivier


