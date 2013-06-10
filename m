Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3FJLRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:17:16 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1271 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3FJLRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:17:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH] [media] usbtv: Add driver for Fushicai USBTV007 video frame grabber
Date: Mon, 10 Jun 2013 13:16:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1370857931-6586-1-git-send-email-lkundrak@v3.sk> <201306101305.05038.hverkuil@xs4all.nl>
In-Reply-To: <201306101305.05038.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101316.55330.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as I sent my reply I realized that my notes w.r.t. field handling
were incomplete. So I'll try to clarify it below.

On Mon June 10 2013 13:05:04 Hans Verkuil wrote:
> Hi Lubomir!
> 
> Thanks for working on this.
> 
> I've got some review comments below...
> 
> On Mon June 10 2013 11:52:11 Lubomir Rintel wrote:
> > Reverse-engineered driver for cheapo video digitizer, made from observations of
> > Windows XP driver. The protocol is not yet completely understood, so far we
> > don't provide any controls, only support a single format out of three and don't
> > support the audio device.
> > 
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > ---
> > Hi everyone,
> > 
> > this is my first experience with v4l2, videobuf2, usb and a video video
> > hardware. Therefore, please be careful reviewing this as I could have made
> > mistakes that are not likely to happen for more experienced people.
> > 
> > I've not figured out the controls for the hardware yet, thus the huge set of
> > unidentified register settings. I've been very unsuccessfully struggling with
> > my Windows installation (the Windows driver for hardware was not usable enough
> > with any other player than the cranky one shipped with it, crashing and
> > deadlocking quite often). It seems quite possible to create a simpler
> > directshow app that would just set the controls; and I plan to do that as time
> > permits.
> > 
> > Also, I the hardware uses V4L2_FIELD_ALTERNATE interlacing, but I couldn't make
> > it work,
> 
> What didn't work exactly?
> 
> > so I'm doing deinterlacing in the driver, which is obviously not the
> > right thing to do. Could anyone educate me on proper way of dealing with data
> > interlaced this way? I could not find a decent example, and I'm not even sure
> > what the sizes in format specification are (like, is the height after or before
> > deinterlacing?).
> 
> FIELD_ALTERNATE means that each buffer contains one field, so the format height
> should be 240/288 (NTSC/PAL).
> 
> Drivers using FIELD_ALTERNATE are very rare.

Given the fact that very few drivers do FIELD_ALTERNATE it makes sense to convert
it in the driver to FIELD_INTERLACED format, which is much more common. While
normally format conversions in the kernel are discouraged I think it is not an
issue here: the data has to be copied into the buffer anyway, so why not copy it
in a way that makes more sense.

Doing this will give buffers that use FIELD_INTERLACED and have as height the full
frame size (480 or 576, depending on the standard).

<snip>

> > +static int usbtv_g_fmt_vid_cap(struct file *file, void *priv,
> > +					struct v4l2_format *f)
> 
> Rename to usbtv_fmt_vid_cap and use this for all g/try/s ops.
> 
> > +{
> > +	f->fmt.pix.width = USBTV_WIDTH;
> > +	f->fmt.pix.height = USBTV_HEIGHT;
> > +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> > +	f->fmt.pix.field = V4L2_FIELD_NONE;
> 
> This should be V4L2_FIELD_ALTERNATE I guess.

Correction: this should be FIELD_INTERLACED.

> 
> > +	f->fmt.pix.bytesperline = USBTV_WIDTH * 2;
> > +	f->fmt.pix.sizeimage = (f->fmt.pix.bytesperline * f->fmt.pix.height);
> > +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> > +	return 0;
> > +}

BTW, one thing that is missing in this driver is that the timestamp isn't
set in the buffer. The correct sequence in usbtv_image_chunk() is:

             buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
             buf->vb.v4l2_buf.sequence = usbtv->sequence++;
	     v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
             vb2_set_plane_payload(&buf->vb, 0, size);
             vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);

Regards,

	Hans
