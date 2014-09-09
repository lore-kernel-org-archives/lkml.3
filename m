Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaIIRGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:06:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39814 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaIIRGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:06:40 -0400
Date: Tue, 9 Sep 2014 10:06:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org,
        Andrew Duggan <aduggan@synaptics.com>
Subject: Re: [PATCH] Input: synaptics - add support for ForcePads
Message-ID: <20140909170636.GA28774@core.coreip.homeip.net>
References: <20140908165520.GA35051@core.coreip.homeip.net>
 <540EAFD1.2040307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540EAFD1.2040307@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:44:17AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/08/2014 06:55 PM, Dmitry Torokhov wrote:
> > ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
> > physical buttons, instead they generate primary button click when user
> > presses somewhat hard on the surface of the touchpad. Unfortunately they
> > also report primary button click whenever there are 2 or more contacts
> > on the pad, messing up all multi-finger gestures (2-finger scrolling,
> > multi-finger tapping, etc). To cope with this behavior we introduce a
> > delay (currently 50 msecs) in reporting primary press in case more
> > contacts appear.
> > 
> > For now we are using DMI matching to detect ForcePads, hopefully we'll
> > be able to figure a better way down the road.
> 
> What about using the pnp-id, in my experience with the recent lenovo
> laptops that tends to be more reliable.

Not sure. So far I only know of HP 1040 having it. FWIW:

dtor@dtor-glaptop:~$ cat /sys/bus/pnp/drivers/i8042\ aux/00\:07/id
SYN300d
SYN0100
SYN0002
PNP0f13

I think if we see generalities we can switch over later. I hope
Chris/Andrew will come with a capability bit though :)

> 
> Christopher, Andrew (added to the CC), can one of you tell us if there
> is a capability bit to detect this, and if not can you perhaps provide
> a list of pnp-ids of devices which behave like this ?
> 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  drivers/input/mouse/synaptics.c | 80 ++++++++++++++++++++++++++++++++---------
> >  drivers/input/mouse/synaptics.h |  5 +++
> >  2 files changed, 69 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index e8573c6..5de1bb6 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -618,6 +618,8 @@ static void synaptics_parse_agm(const unsigned char buf[],
> >  	priv->agm_pending = true;
> >  }
> >  
> > +static bool is_forcepad;
> > +
> >  static int synaptics_parse_hw_state(const unsigned char buf[],
> >  				    struct synaptics_data *priv,
> >  				    struct synaptics_hw_state *hw)
> > @@ -629,10 +631,58 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
> >  			 ((buf[0] & 0x04) >> 1) |
> >  			 ((buf[3] & 0x04) >> 2));
> >  
> > +		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
> > +			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
> > +		    hw->w == 2) {
> > +			synaptics_parse_agm(buf, priv, hw);
> > +			return 1;
> > +		}
> > +
> > +		hw->x = (((buf[3] & 0x10) << 8) |
> > +			 ((buf[1] & 0x0f) << 8) |
> > +			 buf[4]);
> > +		hw->y = (((buf[3] & 0x20) << 7) |
> > +			 ((buf[1] & 0xf0) << 4) |
> > +			 buf[5]);
> > +		hw->z = buf[2];
> > +
> >  		hw->left  = (buf[0] & 0x01) ? 1 : 0;
> >  		hw->right = (buf[0] & 0x02) ? 1 : 0;
> >  
> 
> Moving this up means that on clickpads the button will no longer
> be checked + set for hw->w == 2 packets. That seems like an unintended
> side effect.

I guess we can call it a side effect, but it is fine - we parse AGM and
stash the data, then when 2nd packet comes we parse and act upon it. In
the old code we'd parse x, y, z, in AGM etc. and then have it
overwritten with the data from the 2nd packet, here we do not bother.

> If this is intended then this should probably be in its own
> patch.

It does not make sense on its own as ForcePad support needs to know
values of Z and W when deciding how to handle primary click, otherwise
the old code was just fine.

> 
> > -		if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
> > +		if (is_forcepad) {
> > +			/* XXX is there a proper capability bit for this? */
> > +			/*
> > +			 * ForcePads, like Clickpads, use middle button
> > +			 * bits to report primary button clicks.
> > +			 * Unfortunately they report primary button not only
> > +			 * when user presses on the pad above certain threshold,
> > +			 * but also when there are more than one finger on the
> > +			 * touchpad, which interferes with out multi-finger
> > +			 * gestures.
> > +			 */
> > +			if (hw->z == 0) {
> > +				/* No contacts */
> > +				priv->press = priv->report_press = false;
> > +			} else if (hw->w >= 4 && ((buf[0] ^ buf[3]) & 0x01)) {
> > +				/*
> > +				 * Single-finger touch with pressure above
> > +				 * the threshold.
> > +				 */
> > +				if  (!priv->press) {
> > +					priv->press_start = jiffies;
> > +					priv->press = true;
> > +				} else if (time_after(jiffies,
> > +						priv->press_start +
> > +							msecs_to_jiffies(50))) {
> > +					priv->report_press = true;
> > +				}
> 
> You're not setting a timer here, instead relying on there to be further events,
> that is probably ok, but maybe put a comment to that extent here ?

I can, any suggestion on what you want me to say? "If single point
contact held pressure long enough start reporting primary click"?

Thanks.

-- 
Dmitry
