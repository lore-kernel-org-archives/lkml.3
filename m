Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaGUXXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:23:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46409 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaGUXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:23:28 -0400
X-Originating-IP: 10.58.1.144
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2014 01:23:14 +0200
From: hadess@hadess.net
To: Dmitry Torokhov <dtor@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <1451627.FURGiR949u@dtor-glaptop>
References: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org>
 <2443949.K0iePsg3Aa@vostro.rjw.lan> <1693424.kPNUQHOHlX@vostro.rjw.lan>
 <1451627.FURGiR949u@dtor-glaptop>
Message-ID: <00d187033b8082c2400a38175f7a4dd8@hadess.net>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-19 01:16, Dmitry Torokhov wrote:
<snip>
> I'd say no.
> 
> Anyway, even though it is very tempting to declare inhibit a "deeper" 
> state of
> runtime suspend maybe you are right and inhibit should really be 
> separate from
> PM and drivers would have to sort out all the possible state 
> permutations.
> 
> Considering input devices:
> 
> input_open(): check if device is inhibited, if so do nothing. Otherwise 
> try
> waking up itself and parent (via pm_runtime_get_sync() on itself), this 
> will
> power up the device. Do additional configuration if needed.
> 
> input_close(): check if device is inhibited, if not do pm_runtime_put 
> (_sync?
> to make sure we power off properly and not leave device up and running? 
> or
> should we power down manually not waiting for runtime PM)?
> 
> inhibit(): check if device is opened, if opened do 
> pm_runtime_put_sync().
> 
> uninhibit(): if device is opened do pm_runtime_get_sync(), let runtime 
> PM
> bring up the device. Do additional config if needed -> very similar to
> input_open(), different condition.
> 
> runtime_suspend(): power down the device. If not inhibited enable as 
> wakeup
> source.
> 
> runtime_resume(): power up the device if device is opened and not 
> inhibited.
> 
> system_suspend(): check if device is opened, not inhibited and not in
> runtimesuspend  already; power down.
> 
> system_resume(): power up the device if it is opened and not inhibited. 
> I
> guess it's OK to wake up device that shoudl be runtime-PM-idle since it 
> will
> go to back sleep shortly.
> 
> Ugh.. This is complicated...

Seriously complicated. The compositor and/or X.org can handle most of 
that for
input devices already. For the camera, you want the application to know 
that
the device is present, but not usable, instead of making it vanish or 
rendering
it unusable. And if you wanted to implement this in the kernel, even 
with the aid
of a user-space daemon, you're still missing the most important part, 
the device
tagging.

Once you've tagged the devices which would need to be left alone when 
the lid is
closed, or the laptop is in tablet mode, see if the problem can be 
solved within
user-space alone. I'm fairly certain it wouldn't take too long to fix 
Xorg
or a state-of-the-art compositor to behave properly.

All I see right now is making it harder to write devices drivers with no 
real benefits.

Cheers
