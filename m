Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaBSUWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:22:20 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33696 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754569AbaBSUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:22:18 -0500
Message-ID: <53051276.2070601@hurleysoftware.com>
Date: Wed, 19 Feb 2014 15:22:14 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Grant Edwards <grant.b.edwards@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
References: <20140218093829.GC1741@redhat.com>	<5303DABD.9000302@hurleysoftware.com>	<20140219130308.GC1851@redhat.com>	<le2nmd$p1$1@ger.gmane.org>	<5304EC33.5040502@hurleysoftware.com> <20140219191717.486ac4d0@alan.etchedpixels.co.uk>
In-Reply-To: <20140219191717.486ac4d0@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 02:17 PM, One Thousand Gnomes wrote:
>> How can the requirement be for both must-handle-in-minimum-time data
>> (low_latency) and the-userspace-reader-isn't-reading-fast-enough-
>> so-its-ok-to-halt-transmission ?
>
> Because low latency is about *turn around* time. There are plenty of
> protocols that can flow control, do flow control and want low latency
> because they are not windowed. It's not mutually exclusive by any means.

But if it's all about turn around time, how can the situation devolve to
needing throttling in the first place?  For N_TTY, throttling only happens
when the read queue is close to overflow (only 128 bytes left in 4k buffer).

If the reader isn't pulling _all_ the data out the instant it's woken,
trying to trim off one worker wakeup (by processing input at interrupt time)
is pointless.

>> But first I'd like some hard data on whether or not a low latency
>> mode is even necessary (at least for user-space).
>
> The easy way to simulate the annoying as crap worst cases from dumbass
> firmware downloaders and the like is to set up a link between two PCs and
> time 2000+ repetitions of
>
> send 64 bytes
> wait for a Y
> send 64 bytes
> wait for a Y
> ....
>
> and the matching far end being a box running an existing kernel or a PIC
> or something doing the responses.

Well this is easy enough to mock up.

> Historically we used to lose about 20mS per cycle which over 2000 got to
> be a bit of a PITA.
>
> Low latency goes back to the days of flip buffers, bottom halves an a
> 100Hz clock. There are certainly better ways to do it now if its needed.

Still, as you've pointed out a couple of times, maybe there's a limited
fastpath that's easy and simple. That's why I was asking about throttling
because it's evaluated even for raw mode.

Regards,
Peter Hurley



