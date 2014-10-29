Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaJ2A2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:28:06 -0400
Received: from leo.clearchain.com ([199.73.29.74]:26849 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ2A2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:28:04 -0400
X-Greylist: delayed 766 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 20:28:03 EDT
Date: Wed, 29 Oct 2014 10:14:41 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Chung-yih Wang <cywang@chromium.org>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2] input: fix BTN_TOUCH reporting in
 input_mt_report_pointer_emulation
Message-ID: <20141029001441.GA20811@jelly.redhat.com>
References: <1412861506-21732-1-git-send-email-cywang@chromium.org>
 <1414404527-17526-1-git-send-email-cywang@chromium.org>
 <CAN+gG=G+YYntYg3rpGP+rUU8wT6Ejny8nrdG7K_cfyt7BwkWbA@mail.gmail.com>
 <20141028210706.GC7461@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028210706.GC7461@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (mail.clearchain.com [127.0.0.1]); Wed, 29 Oct 2014 10:44:45 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 02:07:06PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 28, 2014 at 04:47:56PM -0400, Benjamin Tissoires wrote:
> > Hi Chung-yih,
> > 
> > On Mon, Oct 27, 2014 at 6:08 AM, Chung-yih Wang <cywang@chromium.org> wrote:
> > >   From the definition of BTN_TOUCH, BTN_TOOL_<name> and BTN_TOUCH codes
> > > are orthogonal. BTN_TOUCH should be zero if there is no physical contact
> > > happened on device. With ABS_MT_DISTANCE information, the patch uses
> > > touch_count and finger_count to get the final reporting code for
> > > BTN_TOUCH and BTN_TOOL_<name>, respectively.
> > >
> > > Signed-off-by: Chung-yih Wang <cywang@chromium.org>
> > > ---
> > >  drivers/input/input-mt.c | 15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> > > index fbe29fc..a2ab8e3 100644
> > > --- a/drivers/input/input-mt.c
> > > +++ b/drivers/input/input-mt.c
> > > @@ -192,18 +192,21 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
> > >  {
> > >         struct input_mt *mt = dev->mt;
> > >         struct input_mt_slot *oldest;
> > > -       int oldid, count, i;
> > > +       int oldid, i;
> > > +       int touch_count, finger_count;
> > >
> > >         if (!mt)
> > >                 return;
> > >
> > >         oldest = NULL;
> > >         oldid = mt->trkid;
> > > -       count = 0;
> > > +       touch_count = 0;
> > > +       finger_count = 0;
> > >
> > >         for (i = 0; i < mt->num_slots; ++i) {
> > >                 struct input_mt_slot *ps = &mt->slots[i];
> > >                 int id = input_mt_get_value(ps, ABS_MT_TRACKING_ID);
> > > +               int distance = input_mt_get_value(ps, ABS_MT_DISTANCE);
> > 
> > I don't really like this statement, even if it works. Some devices do
> > not report ABS_MT_DISTANCE, and the value for them should not be
> > considered as '0' but 'undefined'.
> 
> I think it incidentally still 0 as we zero out memory we allocate.
> 
> > 
> > >
> > >                 if (id < 0)
> > >                         continue;
> > > @@ -211,12 +214,14 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
> > >                         oldest = ps;
> > >                         oldid = id;
> > >                 }
> > > -               count++;
> > > +               finger_count++;
> > > +               if (distance == 0)
> > 
> > I'd rather test here if ABS_MT_DISTANCE is used, and then if the value is 0.

shouldn't you test for absinfo->minimum anyway? or does the kernel guarantee
that 0 is the minimum for distance?

> > 
> > > +                       touch_count++;
> 
> I do not think we should include hovering contacts into finger_count
> either. I.e if I have one finger touching and one finger hovering we
> should be emitting BTN_TOOL_FINGER and not BTN_TOOL_DOUBLETAP.

yes, please. DOUBLETAP for hovering would trigger things like two-finger
scrolling in some clients, not ideal.

> > >         }
> > >
> > > -       input_event(dev, EV_KEY, BTN_TOUCH, count > 0);
> > > +       input_event(dev, EV_KEY, BTN_TOUCH, touch_count > 0);
> > 
> > For the record, I *think* this will not break user space. This is used
> > in the touchpad part of libinput, and does not seemed to be impacted
> > by the change.
> > Adding Peter and Hans in CC who can tell us if I am assuming right.

should be fine, we've treated BTN_TOUCH as signal that at least one touch is
down. in the wacom driver we use it for proximity info, the rest just never
had to worry about proximity, so it's most likely just unhandled.
 
Cheers,
   Peter

> > 
> > >         if (use_count)
> > > -               input_mt_report_finger_count(dev, count);
> > > +               input_mt_report_finger_count(dev, finger_count);
> > >
> > >         if (oldest) {
> > >                 int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
> > > --
> > > 2.1.2
> > >
> 
> Thanks.
> 
> -- 
> Dmitry
