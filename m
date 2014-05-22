Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEVSAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:00:39 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62580 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaEVSAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:00:37 -0400
Date: Thu, 22 May 2014 11:00:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Flavio Leitner <fbl@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140522180023.GB14814@roeck-us.net>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
 <20140522151048.GB1001@roeck-us.net>
 <20140522155458.GI12759@t520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522155458.GI12759@t520.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 12:54:58PM -0300, Flavio Leitner wrote:
> On Thu, May 22, 2014 at 08:10:48AM -0700, Guenter Roeck wrote:
> > On Wed, May 21, 2014 at 11:19:28PM -0300, Flavio Leitner wrote:
> > > From: Flavio Leitner <fbl@sysclose.org>
> > > 
> > > It is possible to increase left fan speed on a
> > > DELL Precision 490n system up to 3.
> > > 
> > >     value    fan rpm
> > >       1      35460
> > >       2      64740
> > >       3      78510
> > > 
> > > Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> > > ---
> > >  drivers/char/i8k.c       | 4 ++--
> > >  include/uapi/linux/i8k.h | 3 ++-
> > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > > index d915707..99180f0 100644
> > > --- a/drivers/char/i8k.c
> > > +++ b/drivers/char/i8k.c
> > > @@ -519,7 +519,7 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
> > >  	status = i8k_get_fan_status(index);
> > >  	if (status < 0)
> > >  		return -EIO;
> > > -	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
> > > +	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 384));
> > 
> > pwm value range is limited to (0, 255), so we'll have to find another
> > solution.
> 
> You mean in the hw? Because the code today just multiply by 128 so
> you have 0, 128 and 256 as possible pwm values. See below.
> 
No, in the hwmon sysfs ABI.

pwm[1-*]        Pulse width modulation fan control.
                Integer value in the range 0 to 255
		RW
		255 is max or 100%.

> > I think we'll have to define a per-system data structure
> > which holds the fan speed range and the fan multiplier, and attach it
> > to the dmi data. Currently, .driver_data is used directly to override
> > the fan multiplier; it will have to point to a configuration data
> > structure with both fan multiplier and maximum fan speed value.
> > Unless someone has a better idea, of course.
> 
> Sounds good to me.  It could provide a generic one that works as
> today in case there is no specific per-system data structure.
> 
> It could also include the status multiplier so that for systems with
> levels off, minimum and maximum then use x128 and systems with more
> states can use another multiplier.
> 
More likely the maximum accepted value to write into the hw,
but pretty much along that line, correct.

> I volunteer to test on precision 490n and on latitude D520.
> 
Can you send me dmi information for those systems ?
The output of "grep . /sys/class/dmi/id/*" should do.

Guenter
