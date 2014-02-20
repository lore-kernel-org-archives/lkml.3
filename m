Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaBTCUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:20:04 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34763 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbaBTCUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:20:00 -0500
Message-ID: <5305664C.7080701@hurleysoftware.com>
Date: Wed, 19 Feb 2014 21:19:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Grant Edwards <grant.b.edwards@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
References: <20140218093829.GC1741@redhat.com>	<5303DABD.9000302@hurleysoftware.com>	<20140219130308.GC1851@redhat.com>	<le2nmd$p1$1@ger.gmane.org>	<5304EC33.5040502@hurleysoftware.com>	<20140219191717.486ac4d0@alan.etchedpixels.co.uk>	<53051276.2070601@hurleysoftware.com> <20140219214242.406e705b@alan.etchedpixels.co.uk>
In-Reply-To: <20140219214242.406e705b@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 04:42 PM, One Thousand Gnomes wrote:
> It only has to happen *once*, not every time to screw stuff up.
>
>> If the reader isn't pulling _all_ the data out the instant it's woken,
>> trying to trim off one worker wakeup (by processing input at interrupt time)
>> is pointless.
>
> No - because of the statistical corner cases. The standard Linux is not
> remotely hard real time, and even if it were most of the tools involved
> are not.

Ok, so this is still only about "best effort", and really bad
worst case behavior (that the tty core has no control over) is ok.

Going to great lengths to trim one wakeup when nouveau disables interrupts
for 2ms seemed like a waste of time.

>>> Low latency goes back to the days of flip buffers, bottom halves an a
>>> 100Hz clock. There are certainly better ways to do it now if its needed.
>>
>> Still, as you've pointed out a couple of times, maybe there's a limited
>> fastpath that's easy and simple. That's why I was asking about throttling
>> because it's evaluated even for raw mode.
>
> Even if there isn't the goal of low latency was always 'get stuff to
> happen soon' not 'get stuff to happen in the IRQ handler' If you have the
> tty processing happening immediately after the IRQ returns when
> low_latency is set I'm sure the numbers will be just fine and as good as
> historically.
>
> Whether you can always do that I guess depends what happens on really
> slow boxes if you don't do any deferral - eg on Geert's Amiga.

Sure.

I think _some_ effort will yield positive results. For example,
in flush_to_ldisc():

  	if (disc == NULL)
  		return;

-	mutex_lock(&buf->lock);
+	if (!mutex_trylock(&buf->lock))
+		goto deref;

  	while (1) {
  		struct tty_buffer *head = buf->head;

	.....

  	mutex_unlock(&buf->lock);
-
+ deref:
  	tty_ldisc_deref(disc);
  }

This change makes flush_to_ldisc() itself safely callable from
interrupt context, and:
1. doesn't lose data (ie., buffers if the ldisc is filling up)
2. automatically picks the optimum handling whether the input worker
    is running or not
3. doesn't require more locks to exclude flushing or the input worker

This still leaves fixing termios lock, properly handling throttling
and the exclusion logic for incompatible termios options and low_latency.

[For this change to work properly, I still need to solve a race where
the driver has just updated the commit marker but can't grab the buf
lock because tty_buffer_flush() still has the lock but has already
performed the flush -- in this case, the work needs to be restarted
or something because there's still data in the buffer that needs
processing. There's plenty of possible solutions to this; I'm thinking on
which is the right one].

> Flow control even in raw mode is expected Unix behaviour. However do we
> ever need to evaluate it if the tty termios has IXON and CRTSCTS clear ?

It doesn't right now because the assumption is that drivers can
have a whole host of reasons why they want to throttle (the pty driver
leaves it on permanently; the vt driver needs unthrottle to support
paste that no one uses even though I fixed it).

Putting aside for a moment the issue of termios safety inside
the throttle and unthrottle driver methods, the exclusion locks here could
be spinlocks if the drivers can be audited/fixed to not sleep here.

Then that just leaves the termios lock, which is a non-trivial problem, and
I'm not convinced RCU will magically fix it.

Regards,
Peter Hurley
