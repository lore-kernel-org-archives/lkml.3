Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3KMEHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:07:38 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:41047 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3KMEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:07:32 -0500
Date: Tue, 12 Nov 2013 22:07:07 -0600
From: David Fries <david@fries.net>
To: Evgeny Boger <eugenyboger@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
Message-ID: <20131113040707.GK5509@spacedout.fries.net>
References: <1384180614-9025-1-git-send-email-boger@contactless.ru>
 <10261384211376@web11j.yandex.ru>
 <5281691F.4060604@gmail.com>
 <37621384218204@web11j.yandex.ru>
 <52817F42.2080706@gmail.com>
 <20131112080146.GF5509@spacedout.fries.net>
 <5282D2C8.6030002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5282D2C8.6030002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 12 Nov 2013 22:07:09 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 05:15:52AM +0400, Evgeny Boger wrote:
> 11/12/2013 12:01 PM, David Fries:
> >On Tue, Nov 12, 2013 at 05:07:14AM +0400, Evgeny Boger wrote:
> >>+David Fries <david@fries.net>
> >>
> >>Hi David,
> >>
> >>Would you please comment on this?
> >
> >On Mon, Nov 11, 2013 at 06:36:54PM +0400, Evgeny Boger wrote:
> >>  Strong pullup is emulated by driving pin logic high after write
> >>  command when
> >>  using tri-state push-pull GPIO.

Acked-by: David Fries <david@fries.net>

Looks good to me.

> >Not knowing the hardware involved, is driving the logic high a
> >stronger pullup than the normal weak pullup input high?  Meaning it
> >was already being left high, just with a lessor pullup and this will
> >provide a stronger one?
> 
> 
> 
> 
> Sure. The push-pull GPIO on common SoC's are usually able to provide
> up to 10 mA of current.
> 
> 
> 
> 
> >
> >On Tue, Nov 12, 2013 at 03:09:36AM +0400, Evgeniy Polyakov wrote:
> >>>+ msleep(pdata->pullup_duration);
> >>This doesn't look like a good idea - kernel will sleep for that long
> >>not doing usual w1 job
> >Not speaking for Evgeny Boger, but I'm thinking that's intended here.
> >The original strong pullup code change 6a158c0de791a81 I wrote will
> >msleep in w1_post_write when a hardware pullup isn't available, while
> >the hardware ds2490 ds9490r_set_pullup sleeps for the strong pullup
> >using spu_sleep variable.  The user requests a strong pullup for a
> >given time and any other operations on the bus will interrupt the
> >strong pullup, so locking any other operations sounds desired.
> >
> >>11/12/2013 05:03 AM, Evgeniy Polyakov:
> >>>Hi
> >>>
> >>>12.11.2013, 03:32, "Evgeny Boger" <eugenyboger@gmail.com>:
> >>>>>Why did you drop this check? It has nothing with w1-gpio driver
> >>>>This check prevents master from implementing "set_pullup"  provided it does support only "write_bit" method.
> >>>>The comment above states that
> >>>>>  w1_io.c would need to support calling set_pullup before - * the last write_bit operation of a w1_write_8 which it currently - * doesn't.
> >>>>which is kind of strange, since it describes what w1_io.c actually does support.
> >>>>
> >>>>w1_write_8 (w1_io.c:154, https://github.com/torvalds/linux/blob/master/drivers/w1/w1_io.c#L154):
> >>>>>                 for (i = 0; i < 8; ++i) {
> >>>>>                         if (i == 7)
> >>>>>                                 w1_pre_write(dev);
> >>>>>                         w1_touch_bit(dev, (byte >> i) & 0x1);
> >>>>>                 }
> >>>>It seems like w1_write_8() calls w1_pre_write(), which in turn calls set_pullup() just before the last write_bit().
> >I'm not seeing any harm in removing this check and clear
> >master->set_pullup.  It doesn't seem correct for this code to override
> >a master that claims to provide something of a stronger pullup.  It's
> >been about five years since I wrote that code, I think it was just to
> >protect against a stupid master.
> >
> >With this patch the last w1_write_bit will go logic 1, for 64 or 10 us
> >before returning, then w1_gpio_set_pullup is called to enable the
> >strong pullup.  What I wouldn't know is if in that last bit if the
> >logic 1 would be a go up to the strong pullup, or if it would finish
> >that time slot with a weak pullup and then go to a strong pullup.  I
> >would have to dig into the timing specifications much more than I have
> >time to right now to say what is supposed to happen.  The 18b20
> >datasheet lists, "The DQ line must be switched over to the strong
> >pullup within 10 us maximum after issuing any protocol that involves
> >copying the E2 memory or initiates temperature conversions."  It isn't
> >clear where that 10 us starts from.  You might try to dig around and
> >see if that last bit written should go to weak pullup 1 or strong
> >pullup 1.  It would take more changes if it should go right to a
> >strong pullup.
> 
> 
> I wasn't able to find any support for the latter statement.
> It looks like the strong pull-up should be enabled *after* the last
> bit has been sent
> so no need to set strong pull-up there.

It think that is correct, the 2480b data sheet "Strong Pullup to 5V,
armed, predefined duration", the strong pullup starts after the
timeslot of the last bit completes.

> However setting strong pullup for last bit makes sense just to ensure we
> fit to 10us time window.

They'll be just a couple function calls apart and it would complicate
the code to do so.  I think what you have is good.

> On the other hand, I didn't experienced any problems with the proposed
> implementation.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
