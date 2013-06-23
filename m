Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3FWNab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 09:30:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3FWNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 09:30:28 -0400
Date: Sun, 23 Jun 2013 15:30:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: i2c: adv7343: add support for asynchronous probing
In-Reply-To: <Pine.LNX.4.64.1306231525060.13783@axis700.grange>
Message-ID: <Pine.LNX.4.64.1306231527050.13783@axis700.grange>
References: <1371895657-2898-1-git-send-email-prabhakar.csengg@gmail.com>
 <Pine.LNX.4.64.1306231525060.13783@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ZcjIfUWE1Kx3a/GQ4yDvlzwVN6vuLji32iC3qsgfohm
 XPetphmmYD9p1xFbWLTLMAdeVKJhjMTc/xl6YTO3WCbIc3fHUX
 ozmrGASHnCCrUmmfQ4aN9zewYALVeukgSdOT5DC7eGenOlj8Rc
 og58BDn33cDvbFHaWmh9iRdtKTockku2WGqsnQpV1bkXmaJ+83
 xGmRL1Lf4bC1qHVBTBAUEP3NE/ob1YGZtaWu2ZeCodxPYXID4O
 8D/sp1SfvG58HJXxeeu5alF2SLmdimp4GlcbSYhpsJQrTqJOuy
 Y5TiVa967tzLUYK6WbTMaGV01Y+cIyylDCCyfw6LlX+lwbuXw/
 P2Hq4KUd8blQiqeQY/+9NkOGViSVCoodD8MrAxZ7W/WeYp6jxQ
 UAU4iXLEmh0jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jun 2013, Guennadi Liakhovetski wrote:

> On Sat, 22 Jun 2013, Prabhakar Lad wrote:
> 
> > From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> > 
> > Both synchronous and asynchronous adv7343 subdevice probing is supported by
> > this patch.
> > 
> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/media/i2c/adv7343.c |   15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> > index 7606218..8080c2c 100644
> > --- a/drivers/media/i2c/adv7343.c
> > +++ b/drivers/media/i2c/adv7343.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/uaccess.h>
> >  
> >  #include <media/adv7343.h>
> > +#include <media/v4l2-async.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-ctrls.h>
> >  
> > @@ -445,16 +446,21 @@ static int adv7343_probe(struct i2c_client *client,
> >  				       ADV7343_GAIN_DEF);
> >  	state->sd.ctrl_handler = &state->hdl;
> >  	if (state->hdl.error) {
> > -		int err = state->hdl.error;
> > -
> > -		v4l2_ctrl_handler_free(&state->hdl);
> > -		return err;
> > +		err = state->hdl.error;
> > +		goto done;
> 
> What does this have to do with asynchronous probing? Please, remove.

Uhm, sorry, shouldn't review patches after that kind of a weekend :)

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Guennadi

> 
> >  	}
> >  	v4l2_ctrl_handler_setup(&state->hdl);
> >  
> >  	err = adv7343_initialize(&state->sd);
> >  	if (err)
> > +		goto done;
> > +
> > +	err = v4l2_async_register_subdev(&state->sd);
> > +
> > +done:
> 
> This label won't be needed then either.
> 
> Thanks
> Guennadi
> 
> > +	if (err < 0)
> >  		v4l2_ctrl_handler_free(&state->hdl);
> > +
> >  	return err;
> >  }
> >  
> > @@ -463,6 +469,7 @@ static int adv7343_remove(struct i2c_client *client)
> >  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >  	struct adv7343_state *state = to_state(sd);
> >  
> > +	v4l2_async_unregister_subdev(&state->sd);
> >  	v4l2_device_unregister_subdev(sd);
> >  	v4l2_ctrl_handler_free(&state->hdl);
> >  
> > -- 
> > 1.7.9.5
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
