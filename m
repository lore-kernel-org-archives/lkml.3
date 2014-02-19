Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBSXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:16:27 -0500
Received: from ip-64-139-1-69.sjc.megapath.net ([64.139.1.69]:55110 "EHLO
	ip-64-139-1-69.sjc.megapath.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbaBSXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:16:24 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 18:16:24 EST
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: Peter Hurley <peter@hurleysoftware.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
From: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
Subject: Re: locking changes in tty broke low latency feature
In-Reply-To: Message from Stanislaw Gruszka <sgruszka@redhat.com>
   of "Wed, 19 Feb 2014 14:03:09 +0100." <20140219130308.GC1851@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 19 Feb 2014 15:06:23 -0800
Message-Id: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you give me an idea of your device's average and minimum required
> latency (please be specific)?  Is your target arch x86 [so I can evaluate the
> the impact of bus-locked instructions relative to your expected]?

The code I'm familiar with is ntpd and gpsd.  They run on almost any hardware 
or OS and talk to a wide collection of devices.

There is no hard requirement for latency.  They just work better with lower 
latency.  The lower the better.

People gripe about the latency due to USB polling which is about a ms.

I can easily notice a few 10s of microseconds.  I probably wouldn't notice a 
few microseconds, but there are people who would.  The latency isn't 
critical, it's the jitter.  (ntpd has fudge factors to correct for a fixed 
offset.)  Yes, down at the microsecond level luck-of-the-cache is important.


> Also, how painful would it be if unsupported termios changes were rejected
> if the port was in low_latency mode and/or if low_latency setting was
> disallowed because of termios state?

What does "unsupported termios changes" mean?

ntpd has only a few places where it opens a serial port.  I'll collect a list 
of the options that are used if that will help.  The common cases are either 
raw binary, or lines of text.  It doesn't need any fancy editing.


> It would be pointless to throttle low_latency, yes?

What does "throttle" mean?  If you mean what I call flow-control, then no, 
it's not interesting.

There shouldn't be any problem with ntpd or gpsd grabbing all the data 
promptly.


> What would be an acceptable outcome of being unable to accept input?
> Corrupted overrun? Dropped i/o? Queued for later? Please explain with
> comparison to the outcome of missed minimum latency.

Corruption would be evil.  Longer latency would be OK, especially if it 
didn't happen often.  (ntpd has code to discard outliers.)  3% of the time 
would probably not be a problem.  25% might cause problems.

We can allocate a bigger buffer if that helps.

--------

gpsd uses TIOCMIWAIT to get a wakeup from a PPS signal connected to a modem 
control line.  That path might have the same problem and/or some ideas on how 
to handle the data case.



-- 
These are my opinions.  I hate spam.



