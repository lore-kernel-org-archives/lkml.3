Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3FHRKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 13:10:22 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:34448 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286Ab3FHRKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 13:10:21 -0400
Date: Sat, 8 Jun 2013 19:13:09 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC v2 2/2] saa7115: Remove gm7113c video_std register change
Message-ID: <20130608171309.GA10180@dell.arpanet.local>
References: <1370000426-3324-1-git-send-email-jonarne@jonarne.no>
 <1370000426-3324-3-git-send-email-jonarne@jonarne.no>
 <201306071101.06774.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306071101.06774.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:01:06AM +0200, Hans Verkuil wrote:
> On Fri May 31 2013 13:40:26 Jon Arne Jørgensen wrote:
> > On video std change, the driver would disable the automatic field
> > detection on the gm7113c chip, and force either 50Hz or 60Hz.
> > Don't do this any more.
> 
> Sorry, I'm not entirely sure what is happening here. Why would the gm7113c
> behave different in this respect compared to the saa7113?
> 
> One thing to remember is that the chip should never get in a mode where
> switching from e.g. NTSC to PAL on the input would change the output timings
> to the bridge chip as well to PAL. Because that might cause DMA buffer
> overruns. So if the user calls S_STD, then the bridge should always be
> certain it gets whatever std was specified.
> 
> I'm not sure whether this patch puts the gm7113c in such a mode, but if it
> does, then it should be redone.
>
> Regards,
> 
> 	Hans
>

Ah, you are of course right.
The Somagic EasyCap which I use for testing is basicaly just forwarding the raw
data from the gm7113c chip as isochronous usb transfers to the computer.

Because of this I have to do lots of checks on the incomming data and
local buffers in the smi2021 driver.
I totaly forgot that the chip could be used in other configurations
where you would use DMA transfers. Then the forcing of the video std suddenly
makes sense. I guess I have to drop this part from the next version of
the patch.

Thank you for the review.

Best regards,
Jon Arne Jørgensen

> > 
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > ---
> >  drivers/media/i2c/saa7115.c | 26 ++------------------------
> >  1 file changed, 2 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> > index 4a52b4d..ba18e57 100644
> > --- a/drivers/media/i2c/saa7115.c
> > +++ b/drivers/media/i2c/saa7115.c
> > @@ -479,24 +479,6 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
> >  
> >  /* ============== SAA7715 VIDEO templates (end) =======  */
> >  
> > -/* ============== GM7113C VIDEO templates =============  */
> > -static const unsigned char gm7113c_cfg_60hz_video[] = {
> > -	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
> > -	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
> > -
> > -	0x00, 0x00
> > -};
> > -
> > -static const unsigned char gm7113c_cfg_50hz_video[] = {
> > -	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
> > -	R_0E_CHROMA_CNTL_1, 0x07,
> > -
> > -	0x00, 0x00
> > -};
> > -
> > -/* ============== GM7113C VIDEO templates (end) =======  */
> > -
> > -
> >  static const unsigned char saa7115_cfg_vbi_on[] = {
> >  	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
> >  	R_88_POWER_SAVE_ADC_PORT_CNTL, 0xd0,		/* reset scaler */
> > @@ -981,16 +963,12 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
> >  	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
> >  	if (std & V4L2_STD_525_60) {
> >  		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
> > -		if (state->ident == V4L2_IDENT_GM7113C)
> > -			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
> > -		else
> > +		if (state->ident != V4L2_IDENT_GM7113C)
> >  			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
> >  		saa711x_set_size(sd, 720, 480);
> >  	} else {
> >  		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
> > -		if (state->ident == V4L2_IDENT_GM7113C)
> > -			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
> > -		else
> > +		if (state->ident != V4L2_IDENT_GM7113C)
> >  			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
> >  		saa711x_set_size(sd, 720, 576);
> >  	}
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
