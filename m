Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBTCz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:55:27 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33780 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752571AbaBTCzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:55:25 -0500
Message-ID: <53056E99.9070900@hurleysoftware.com>
Date: Wed, 19 Feb 2014 21:55:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: locking changes in tty broke low latency feature
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
In-Reply-To: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 06:06 PM, Hal Murray wrote:
>> Can you give me an idea of your device's average and minimum required
>> latency (please be specific)?  Is your target arch x86 [so I can evaluate the
>> the impact of bus-locked instructions relative to your expected]?
>
> The code I'm familiar with is ntpd and gpsd.  They run on almost any hardware
> or OS and talk to a wide collection of devices.
>
> There is no hard requirement for latency.  They just work better with lower
> latency.  The lower the better.
>
> People gripe about the latency due to USB polling which is about a ms.

Have you tried 3.12+ without low_latency? I ripped out a lot of locks
from 3.12+ so it's possible it already meets your requirements.

> I can easily notice a few 10s of microseconds.  I probably wouldn't notice a
> few microseconds, but there are people who would.  The latency isn't
> critical, it's the jitter.  (ntpd has fudge factors to correct for a fixed
> offset.)  Yes, down at the microsecond level luck-of-the-cache is important.

Hopefully you meant "milliseconds" here; single-digit microsecond latency on
any kind of stable duty cycle is linux-rt territory, and simply not a reasonable
goal for mainline.

The jitter is all scheduler and since the user-space app is sleeping waiting
for input, there's nothing the tty core can do about that. Removing one
mandatory scheduling wakeup _may_ help latency, but will probably not make
much difference regarding jitter.

>> Also, how painful would it be if unsupported termios changes were rejected
>> if the port was in low_latency mode and/or if low_latency setting was
>> disallowed because of termios state?
>
> What does "unsupported termios changes" mean?

For example, once the port is in low_latency mode, setting L_ECHO (and its ilk)
would be rejected. And vice versa, if the L_ECHO is set in termios, low_latency
would be rejected.

So running a vt console is low_latency mode is not going to work.

> ntpd has only a few places where it opens a serial port.  I'll collect a list
> of the options that are used if that will help.  The common cases are either
> raw binary, or lines of text.  It doesn't need any fancy editing.
>
>
>> It would be pointless to throttle low_latency, yes?
>
> What does "throttle" mean?  If you mean what I call flow-control, then no,
> it's not interesting.

Yes, whatever the driver currently considers flow-control. The core is
agnostic about the mechanism; throttling is the generic requirement.

> There shouldn't be any problem with ntpd or gpsd grabbing all the data
> promptly.

Ok.

>> What would be an acceptable outcome of being unable to accept input?
>> Corrupted overrun? Dropped i/o? Queued for later? Please explain with
>> comparison to the outcome of missed minimum latency.
>
> Corruption would be evil.  Longer latency would be OK, especially if it
> didn't happen often.  (ntpd has code to discard outliers.)  3% of the time
> would probably not be a problem.  25% might cause problems.
>
> We can allocate a bigger buffer if that helps.

No need, I already solved this step.

> gpsd uses TIOCMIWAIT to get a wakeup from a PPS signal connected to a modem
> control line.  That path might have the same problem and/or some ideas on how
> to handle the data case.

What Alan said. low_latency has no impact on the handling of the PPS signal
through DCD.

Regards,
Peter Hurley

