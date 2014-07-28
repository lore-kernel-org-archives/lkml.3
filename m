Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaG1T63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:58:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44393 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaG1T6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:58:25 -0400
Date: Mon, 28 Jul 2014 12:58:22 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: hadess@hadess.net
Cc: Dmitry Torokhov <dtor@google.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in
 time
Message-ID: <20140728195822.GA20708@google.com>
References: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org>
 <2443949.K0iePsg3Aa@vostro.rjw.lan>
 <1693424.kPNUQHOHlX@vostro.rjw.lan>
 <1451627.FURGiR949u@dtor-glaptop>
 <00d187033b8082c2400a38175f7a4dd8@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00d187033b8082c2400a38175f7a4dd8@hadess.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: Your email arrived here with lines wrapped in a hard-to-read way,
not sure where the problem lies.)

On Tue, Jul 22, 2014 at 01:23:14AM +0200, hadess@hadess.net wrote:
> On 2014-07-19 01:16, Dmitry Torokhov wrote:
> <snip>
> >I'd say no.
> >
> >Anyway, even though it is very tempting to declare inhibit a
> >"deeper" state of
> >runtime suspend maybe you are right and inhibit should really be
> >separate from
> >PM and drivers would have to sort out all the possible state
> >permutations.
> >
> >Considering input devices:
> >
> >input_open(): check if device is inhibited, if so do nothing.
> >Otherwise try
> >waking up itself and parent (via pm_runtime_get_sync() on itself),
> >this will
> >power up the device. Do additional configuration if needed.
> >
> >input_close(): check if device is inhibited, if not do
> >pm_runtime_put (_sync?
> >to make sure we power off properly and not leave device up and
> >running? or
> >should we power down manually not waiting for runtime PM)?
> >
> >inhibit(): check if device is opened, if opened do
> >pm_runtime_put_sync().
> >
> >uninhibit(): if device is opened do pm_runtime_get_sync(), let
> >runtime PM
> >bring up the device. Do additional config if needed -> very similar to
> >input_open(), different condition.
> >
> >runtime_suspend(): power down the device. If not inhibited enable
> >as wakeup
> >source.
> >
> >runtime_resume(): power up the device if device is opened and not
> >inhibited.
> >
> >system_suspend(): check if device is opened, not inhibited and not in
> >runtimesuspend  already; power down.
> >
> >system_resume(): power up the device if it is opened and not
> >inhibited. I
> >guess it's OK to wake up device that shoudl be runtime-PM-idle
> >since it will
> >go to back sleep shortly.
> >
> >Ugh.. This is complicated...
> 
> Seriously complicated. The compositor and/or X.org can handle most
> of that for
> input devices already. For the camera, you want the application to
> know that
> the device is present, but not usable, instead of making it vanish
> or rendering
> it unusable. And if you wanted to implement this in the kernel, even
> with the aid
> of a user-space daemon, you're still missing the most important
> part, the device
> tagging.

I agree that the behaviour for e.g. the camera is debatable. Our primary
concern is input devices for now, but we were trying to see whether such
a functionality might be desired for other device classes as well.

> Once you've tagged the devices which would need to be left alone
> when the lid is
> closed, or the laptop is in tablet mode, see if the problem can be
> solved within
> user-space alone. I'm fairly certain it wouldn't take too long to
> fix Xorg
> or a state-of-the-art compositor to behave properly.

This would not allow you to power down the touchscreen more than to a
"idle" state without further modifications to drivers.

We also want to make sure that the kernel ignores input from these
devices for S3 suspend, so that stray touch inputs do not abort a
suspend that is about to happen.

And also, I think Xorg is not necessarily the proper layer for this.
It's a bit theoretical, but: If there were other users of the input
device, they would also want to ignore the events.

> All I see right now is making it harder to write devices drivers
> with no real benefits.

I don't see this problem at all. Just like drivers don't have to
implement runtime PM, they wouldn't be required to implement inhibit()
and its counterpart. But if they do implement such functionality, we
give them a standard interface to expose it.

If we stick with the example of input devices, we can even have a simple
default implementation in the device class (skipping any generated
events) and bring the basic behaviour to unmodified drivers for free.

Even if you did not have the "inhibit" interface, if you wanted to power
down the touchscreen completely when it's not accessible, this would
require very similar driver modifications.

Regards,
Patrik
