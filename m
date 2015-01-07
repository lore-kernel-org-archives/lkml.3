Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbbAGGeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:34:21 -0500
Received: from leo.clearchain.com ([199.73.29.74]:11161 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbAGGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:34:20 -0500
Date: Wed, 7 Jan 2015 16:02:29 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxwell Anselm <silverhammermba@gmail.com>
Subject: Re: [PATCH 1/2] input: synaptics - make image sensors report
 ABS_MT_TOUCH_MAJOR
Message-ID: <20150107060229.GA17069@jelly.redhat.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
 <1419679889-6582-2-git-send-email-gabriele.mzt@gmail.com>
 <CAN+gG=Fhaj2aQM7gxXZBaXx3MZQbdMdCZ7KO=nmhzufp4YqnmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=Fhaj2aQM7gxXZBaXx3MZQbdMdCZ7KO=nmhzufp4YqnmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (mail.clearchain.com [127.0.0.1]); Wed, 07 Jan 2015 16:32:30 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 02:24:30PM -0500, Benjamin Tissoires wrote:
> Hi Gabriele,
> 
> [Adding Peter and Hans as this change will impact both
> xf86-input-synaptics and libinput]
> 
> On Sat, Dec 27, 2014 at 6:31 AM, Gabriele Mazzotta
> <gabriele.mzt@gmail.com> wrote:
> > Despite claiming to be able to report ABS_TOOL_WIDTH, image sensors
> > were not doing it. Make them report widths and use ABS_MT_TOUCH_MAJOR
> > instead ABS_TOOL_WIDTH.
> 
> It looks like the current xorg-synaptics code already handles
> ABS_MT_TOUCH_MAJOR as finger_width. So I think we should be good in
> replacing the ABS_TOOL_WIDTH event. However, I'd prefer having Peter
> confirm this because xorg-synaptics still relies a lot on the single
> touch emulation.

synaptics doesn't actually use TOUCH_MAJOR for finger width, we just forward
it as axis information (not that anyone uses it).
dropping TOOL_WIDTH would only affect palm detection which unreliable, off
by default and mostly broken. so this is fine with me.

Cheers,
   Peter

> 
> >
> > Since the 'w' slot is used to report the finger count when two or more
> > fingers are on the touchpad, make sure that only meaningful values are
> > emitted, i.e. values greater than or equal to 4, and assign the correct
> > range to ABS_MT_TOUCH_MAJOR.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=77161
> > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> > ---
> >  drivers/input/mouse/synaptics.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index f947292..ea0563e 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -814,6 +814,8 @@ static void synaptics_report_slot(struct input_dev *dev, int slot,
> 
> Just FYI, this does not apply anymore on top of Dmitry's tree.
> synaptics_report_slot() has been removed, and you should now report
> the slot state in synaptics_report_mt_data().
> 
> >         input_report_abs(dev, ABS_MT_POSITION_X, hw->x);
> >         input_report_abs(dev, ABS_MT_POSITION_Y, synaptics_invert_y(hw->y));
> >         input_report_abs(dev, ABS_MT_PRESSURE, hw->z);
> > +       if (hw->w >= 4)
> 
> That I don't like. IMO, at this point, .w should only contain the
> finger width, unconditionally.
> Also, with 2/2, .w is computed accurately for the second finger, but
> not for the first.
> 
> I tried to figure out a way to properly extract the actual width
> information from the sgm packet when the w is 0 or 1, and the only way
> I found was to do the fix in synaptics_image_sensor_process(). I would
> have preferred dealing with that in synaptics_parse_hw_state()
> directly, but I think the final code would be more and more ugly.
> Dealing with the true finger width in synaptics_image_sensor_process()
> is not a problem for cr48 sensors, because they will not have the
> ABS_MT_TOUCH_MAJOR event exported.
> 
> Anyway, something like that "should" work (sorry for the tab/space,
> gmail in use), of course, this is untested when I send the mail :) :
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 95c15451..caf7ccd 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -852,6 +852,17 @@ static void synaptics_image_sensor_process(struct
> psmouse *psmouse,
>         else
>                 num_fingers = 4;
> 
> +       /* When multiple fingers are on the TouchPad, the width is encoded in
> +        * X, Y and Z */
> +       if (sgm->w == 0 || sgm->w == 1) {
> +               sgm->w = ((sgm->x & BIT(1)) >> 1) |
> +                         (sgm->y & BIT(1)) |
> +                        ((sgm->z & BIT(0)) << 1);
> +               sgm->x &= ~BIT(1);
> +               sgm->y &= ~BIT(1);
> +               sgm->z &= ~BIT(0);
> +       }
> +
>         /* Send resulting input events to user space */
>         synaptics_report_mt_data(psmouse, sgm, num_fingers);
>  }
> 
> 
> > +               input_report_abs(dev, ABS_MT_TOUCH_MAJOR, hw->w);
> >  }
> >
> >  static void synaptics_report_mt_data(struct psmouse *psmouse,
> > @@ -1462,8 +1464,13 @@ static void set_input_params(struct psmouse *psmouse,
> >                                         INPUT_MT_TRACK : INPUT_MT_SEMI_MT));
> >         }
> >
> > -       if (SYN_CAP_PALMDETECT(priv->capabilities))
> > -               input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
> > +       if (SYN_CAP_PALMDETECT(priv->capabilities)) {
> > +               if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c))
> > +                       input_set_abs_params(dev,
> > +                                            ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
> > +               else
> > +                       input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
> > +       }
> 
> Again, I'd prefer having Peter's point of view here.
> 
> If we really need both, we will need to change input-mt to also
> emulate ABS_TOOL_WIDTH from ABS_MT_TOUCH_MAJOR like we do between
> ABS_MT_POSITION_X|Y and ABS_X|Y.
> 
> Cheers,
> Benjamin
> 
> >
> >         __set_bit(BTN_TOUCH, dev->keybit);
> >         __set_bit(BTN_TOOL_FINGER, dev->keybit);
> > --
> > 2.1.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-input" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
