Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKFRPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:15:04 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:52318 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaKFRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:15:00 -0500
Date: Thu, 6 Nov 2014 09:14:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] input: touchscreen: of: Register multitouch axes
Message-ID: <20141106171455.GA34214@dtor-ws>
References: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
 <1415200070-19346-3-git-send-email-maxime.ripard@free-electrons.com>
 <20141105175635.GA22754@dtor-ws>
 <20141106160621.GM2989@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106160621.GM2989@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:06:21PM +0100, Maxime Ripard wrote:
> Hi,
> 
> On Wed, Nov 05, 2014 at 09:56:35AM -0800, Dmitry Torokhov wrote:
> > On Wed, Nov 05, 2014 at 04:07:49PM +0100, Maxime Ripard wrote:
> > > So far, the DT parsing code was only setting up the regular input axes,
> > > completely ignoring their multitouch counter parts.
> > > 
> > > Fill them with the same parameters than the regular axes.
> > > 
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >  drivers/input/touchscreen/of_touchscreen.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
> > > index 74d6b0eb50ac..cf2a753edd96 100644
> > > --- a/drivers/input/touchscreen/of_touchscreen.c
> > > +++ b/drivers/input/touchscreen/of_touchscreen.c
> > > @@ -42,17 +42,23 @@ void touchscreen_parse_of_params(struct input_dev *dev)
> > >  
> > >  	maximum = of_get_optional_u32(np, "touchscreen-size-x");
> > >  	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-x");
> > > -	if (maximum || fuzz)
> > > +	if (maximum || fuzz) {
> > >  		input_set_abs_params(dev, ABS_X, 0, maximum, fuzz, 0);
> > > +		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, maximum, fuzz, 0);
> > 
> > Not all devices are multitouch so you shoudl not be setting multitouch
> > bits unconditionally.
> 
> Hmmm, right.
> 
> > In I think we should rely on driver to set capability bits properly and
> > then here test them and apply the readings. Probably also issue a
> > warning if we see max/fuzz setting but neither ABS_<N>/ABS_MT_<N>
> > capabilities.
> 
> What I was aiming at was to avoid DT parsing duplication for the
> !multitouch and multitouch axis. I don't think there's a way to copy
> the parameters.
> 
> The mt_init_slots might be a solution, but it does the copy the other
> way around: from the multitouch to the !multitouch axis, and without
> enabling it, which renders using both input_mt_init_slots and the
> of_touchscreen code together impossible.
> 
> Is there a way to just enable an axis without calling
> input_set_abs_params? Is __set_bit enough?

Hmm, not anymore I'm afraid as you still need absinfo being allocated,
but there is input_set_capability() that is basically a fancy
__set_bit(). If you set ABS_* with it that would mean that the device
has unspecified min/max/fuzz.

And then, in DT parsing code, I'd do:

	...read max and fuzz for an axis...
	if (max || fuzz) {
		if (!test_bit(ABS_N, dev->absbit) &&
		    !test_bit(ABS_MT_N, dev->absbit)) {
			dev_warn("... have parameters but axis not set up...");
		} else {
			if (test_bit(ABS_N...)
				input_set_abs_params(dev, ABS_N...);
			if (test_bit(ABS_MT_N...)
				input_set_abs_params(dev, ABS_MT_N...);
	}

Thanks.

-- 
Dmitry
