Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaBSRjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:39:06 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48086 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754719AbaBSRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:39:03 -0500
Message-ID: <5304EC33.5040502@hurleysoftware.com>
Date: Wed, 19 Feb 2014 12:38:59 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grant Edwards <grant.b.edwards@gmail.com>, linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
References: <20140218093829.GC1741@redhat.com> <5303DABD.9000302@hurleysoftware.com> <20140219130308.GC1851@redhat.com> <le2nmd$p1$1@ger.gmane.org>
In-Reply-To: <le2nmd$p1$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 02/19/2014 11:55 AM, Grant Edwards wrote:
> On 2014-02-19, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> Hello,
>>
>> On Tue, Feb 18, 2014 at 05:12:13PM -0500, Peter Hurley wrote:
>>> On 02/18/2014 04:38 AM, Stanislaw Gruszka wrote:
>>>
>>>> setserial has low_latency option which should minimize receive latency
>>>> (scheduler delay). AFAICT it is used if someone talk to external device
>>>> via RS-485/RS-232 and need to have quick requests and responses.
>
> Exactly.

But not exactly, because I need a quantified value for "quick",
preferably with average latency measurements for 3.11- and 3.12+

>>>>
>>>> But after 3.12 tty locking changes, calling flush_to_ldisc() from
>>>> interrupt context is a bug (we got scheduling while atomic bug report
>>>> here: https://bugzilla.redhat.com/show_bug.cgi?id=1065087 )
>>>
>>> Can you give me an idea of your device's average and minimum required
>>> latency (please be specific)?
>
> If by "device" you mean the UART being supported by the the driver in
> question, then there is no answer.
>
> Latency issues and requirements are a user-space application level
> requirement that depend on the specific application's requirements and
> those of the widget on the other end of the serial cable.

I'm trying to determine if 3.12+ already satisfies the userspace requirement
(or if the requirement is infeasible).

The assumption is that 3.12+ w/o low_latency is worse than 3.11- w/ low_latency,
which may not be true.

Also, as you note, the latency requirement is in userspace, so bound
to the behavior of the scheduler anyway. Thus, immediately writing
to the read buffer from IRQ may have no different average latency than
handling by a worker (as measured by the elapsed time from interrupt to
userspace read).

>>> Also, how painful would it be if unsupported termios changes were rejected
>>> if the port was in low_latency mode and/or if low_latency setting was
>>> disallowed because of termios state?
>>>
>>> It would be pointless to throttle low_latency, yes?
>
> By "throttle" I assume you're talking about flow control?

Driver throttle (but the discussion can include auto-flow control devices).

How can the requirement be for both must-handle-in-minimum-time data
(low_latency) and the-userspace-reader-isn't-reading-fast-enough-
so-its-ok-to-halt-transmission ?

Throttling/unthrottling the sender seems counter to "low latency".

> _Usually_ applications that require low latency are exchanging short
> messages (up to a few hundred bytes, but usually more like a few
> dozen).  In those cases flow control is not generally needed.
>
> Does it matter?

Driver throttling requires excluding concurrent unthrottle and calling into
the driver (and said driver has relied on sleeping locks for many
kernel versions).

But first I'd like some hard data on whether or not a low latency
mode is even necessary (at least for user-space).

>>> What would be an acceptable outcome of being unable to accept input?
>>> Corrupted overrun? Dropped i/o? Queued for later? Please explain with
>>> comparison to the outcome of missed minimum latency.
>>
>> I'm sorry, I can not answer your questions.
>>
>> For what I googled it looks like users wanted to get rid of 10ms jitter
>> caused by scheduler.
>
> Yes.  That was the use for the low_latency option. Historically, all
> of my drivers had supported the low_latency options for customers that
> found scheduling delays to be a problem.
>
> However, low_latency has been broken in certain contexts for a long
> time. As a result, drivers have to avoid using it either completely or
> sometimes only where rx data is handled in certain contexts.
>
> For some drivers the end result of that is that you can choose either
> a low-latency I/O mechanism or low-latency TTY layer rx handling, but
> you can't use both at the same time because the low-latency I/O
> mechanism handles rx data in a context where low-latency TTY layer
> stuff can't be used.
>
> Now that HZ is often 1000 and tickless is commonly used, I don't think
> the scheduling delay is nearly as much an issue as it used to be.  I
> haven't gotten any complaints since it was largely rendered useless
> several years ago.
>
> Now all my drivers will silently override users if they set the
> low_latency flag on a port in situations where it can't be used.

Right. I'd rather not 'fix' something that doesn't really need
fixing (other than to suppress any WARNING caused by low_latency).

Regards,
Peter Hurley
