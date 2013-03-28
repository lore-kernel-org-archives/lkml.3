Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3C1IOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:14:22 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35857 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3C1IOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:14:18 -0400
Date: Thu, 28 Mar 2013 01:14:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sebastien Royen <sebastien.royen@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        seb <sebastien.royen@armadeus.com>
Subject: Re: [PATCH 1/1] Input: mma8450 - fix signed 12bits to 32bits
 conversion
Message-ID: <20130328081415.GA18754@core.coreip.homeip.net>
References: <1364372263-16848-1-git-send-email-sebastien.royen@armadeus.com>
 <20130328055858.GA6523@core.coreip.homeip.net>
 <CADFrO6HRWfjTxkmLfVdq3+GBEQShNx5QUDEnMwZcTBx7e+SOxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADFrO6HRWfjTxkmLfVdq3+GBEQShNx5QUDEnMwZcTBx7e+SOxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 08:36:52AM +0100, Sebastien Royen wrote:
> Hi Dmitry
> 
> 2013/3/28 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> > Hi Seb,
> >
> > On Wed, Mar 27, 2013 at 09:17:43AM +0100, seb wrote:
> > > Event value is wrong. Should be in range -2048 to 2047, but is in range 0 to 4095.
> > > Use int8_t to int conversion and remove 0xfff mask.
> > >
> > > Signed-off-by: seb <sebastien.royen@armadeus.com>
> > > ---
> > >  drivers/input/misc/mma8450.c |   15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
> > > index 480557f..c3781a1 100644
> > > --- a/drivers/input/misc/mma8450.c
> > > +++ b/drivers/input/misc/mma8450.c
> > > @@ -110,7 +110,7 @@ static void mma8450_poll(struct input_polled_dev *dev)
> > >       struct mma8450 *m = dev->private;
> > >       int x, y, z;
> > >       int ret;
> > > -     u8 buf[6];
> > > +     int8_t buf[6];
> > >
> > >       ret = mma8450_read(m, MMA8450_STATUS);
> > >       if (ret < 0)
> > > @@ -119,13 +119,18 @@ static void mma8450_poll(struct input_polled_dev *dev)
> > >       if (!(ret & MMA8450_STATUS_ZXYDR))
> > >               return;
> > >
> > > -     ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, buf, sizeof(buf));
> > > +     ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, (u8*)buf, sizeof(buf));
> > >       if (ret < 0)
> > >               return;
> > >
> > > -     x = ((buf[1] << 4) & 0xff0) | (buf[0] & 0xf);
> > > -     y = ((buf[3] << 4) & 0xff0) | (buf[2] & 0xf);
> > > -     z = ((buf[5] << 4) & 0xff0) | (buf[4] & 0xf);
> > > +     /* convert 8 MSB from int8_t to int */
> > > +     x = buf[1];
> > > +     y = buf[3];
> > > +     z = buf[5];
> > > +     /* add 4 LSB */
> > > +     x = (x << 4) | (buf[0] & 0xf);
> > > +     y = (y << 4) | (buf[2] & 0xf);
> > > +     z = (z << 4) | (buf[4] & 0xf);
> >
> > Should we just say:
> >
> >         x = ((int)(s8)buf[1] << 4) | (buf[0] & 0xf);
> >         y = ...
> >         z = ...
> >
> > and leave the rest as is?
> >
> > Thanks.
> >
> > --
> > Dmitry
> 
> Yes, it works too and is more close to original version.
> It's my first contrib so I'm not familiar with process,
> do you need another patch with right changes ?

Yes please as I do not have the hardware to test modified patch.

-- 
Dmitry
