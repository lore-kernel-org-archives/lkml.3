Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbbAEWAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:00:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48177 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbAEWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:00:17 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxwell Anselm <silverhammermba@gmail.com>
Subject: Re: [PATCH 1/2] input: synaptics - make image sensors report ABS_MT_TOUCH_MAJOR
Date: Mon, 05 Jan 2015 23:00:13 +0100
Message-ID: <1777845.g1sZJx65aj@xps13>
In-Reply-To: <CAN+gG=Fhaj2aQM7gxXZBaXx3MZQbdMdCZ7KO=nmhzufp4YqnmA@mail.gmail.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com> <1419679889-6582-2-git-send-email-gabriele.mzt@gmail.com> <CAN+gG=Fhaj2aQM7gxXZBaXx3MZQbdMdCZ7KO=nmhzufp4YqnmA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 14:24:30 Benjamin Tissoires wrote:
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

Regarding the last part on cr48 sensors.
Currently these sensors are not reporting widths through ABS_TOOL_WIDTH
and I don't see what could go wrong if they start reporting
ABS_MT_TOUCH_MAJOR. If I understood correctly, they can report widths
only when one finger is on the touchpad. This means that they will
report widths through slot 0, but they won't through slot 1. Nothing
bad should happen.

I've just rebased my patches and included the support for cr48 sensors.
The only change I made was to change the default width value from
5 to 4 since this is the minimum values these sensors can report
(according to the existing code).

Anyway, should I simply include the changes you suggested to handle
widths of sgm packets in what will be the new 2/2?
