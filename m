Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaBSSNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:13:09 -0500
Received: from plane.gmane.org ([80.91.229.3]:33401 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbaBSSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:13:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: locking changes in tty broke low latency feature
Date: Wed, 19 Feb 2014 18:12:36 +0000 (UTC)
Message-ID: <le2s6k$qo9$1@ger.gmane.org>
References: <20140218093829.GC1741@redhat.com>
 <5303DABD.9000302@hurleysoftware.com> <20140219130308.GC1851@redhat.com>
 <le2nmd$p1$1@ger.gmane.org> <5304EC33.5040502@hurleysoftware.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl.comtrol.com
User-Agent: slrn/1.0.1 (Linux)
Cc: linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-19, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 02/19/2014 11:55 AM, Grant Edwards wrote:

>>>>> setserial has low_latency option which should minimize receive latency
>>>>> (scheduler delay). AFAICT it is used if someone talk to external device
>>>>> via RS-485/RS-232 and need to have quick requests and responses.
>>
>> Exactly.
>
> But not exactly, because I need a quantified value for "quick",

Only the end-user knows that, and they don't tell us what it is unless
it's not being met.  :)

> preferably with average latency measurements for 3.11- and 3.12+

It's been a long, long, time since I've done those measurements, and
whatever data I had is no longer relevent (even if I could find it) --
so I'll leave that up to somebody who's actually lobbying for getting
low_latency fixed so that it works from an interrupt context.

Just to be clearn, I'm not lobbying either for or against that. I'm
just trying to provide some perspective on the low_latency flag,
why it _was_ there, and who used it.

> I'm trying to determine if 3.12+ already satisfies the userspace
> requirement (or if the requirement is infeasible).
>
> The assumption is that 3.12+ w/o low_latency is worse than 3.11- w/
> low_latency, which may not be true.

I haven't heard any complaints for probably 10+ years.  The last time
I did hear a complaint, I told them to set the low_latency flag and
that solved the problem.

> Also, as you note, the latency requirement is in userspace, so bound
> to the behavior of the scheduler anyway. Thus, immediately writing to
> the read buffer from IRQ may have no different average latency than
> handling by a worker (as measured by the elapsed time from interrupt
> to userspace read).

Yes.  And the low_latency flag used to (as in 10 years ago) have a big
effect on that.  Without the low latency flag, the user read would
happen up to 10ms (assuming HZ=100) after the data was received by the
driver.  Setting the low-latency flag eliminated that 10ms jitter.  I
don't know if these days setting the low_latency flag (in contexts
where it does work) even has a noticeable effect.

> How can the requirement be for both must-handle-in-minimum-time data
> (low_latency) and the-userspace-reader-isn't-reading-fast-enough-
> so-its-ok-to-halt-transmission ?
>
> Throttling/unthrottling the sender seems counter to "low latency".

Agreed.

I can _imagine_ a case where an application has a strict limit how
long it will wait until it sees the first byte of the response, but
for some isolated cases (uploading large data logs) that response
might be very large -- large neough that the application may have to
pause while reading the response and rely on flow control to throttle
the upload.  But, I can't point to any specific instance of that.


>> _Usually_ applications that require low latency are exchanging short
>> messages (up to a few hundred bytes, but usually more like a few
>> dozen).  In those cases flow control is not generally needed.
>>
>> Does it matter?
>
> Driver throttling requires excluding concurrent unthrottle and
> calling into the driver (and said driver has relied on sleeping locks
> for many kernel versions).

Is that still an issue for drivers where the flow cotrol is handled by
the UART?

> But first I'd like some hard data on whether or not a low latency
> mode is even necessary (at least for user-space).

I don't have any hard data, but gut anser is that it is probably no
longer needed.  The problem that existed for the past few years was
that there was a user-space way to set the low_latency flag (it didn't
require root and you could even do it from the command-line with
setserial) -- and doing so annoyed the kernel.

>> Now that HZ is often 1000 and tickless is commonly used, I don't think
>> the scheduling delay is nearly as much an issue as it used to be.  I
>> haven't gotten any complaints since it was largely rendered useless
>> several years ago.
>>
>> Now all my drivers will silently override users if they set the
>> low_latency flag on a port in situations where it can't be used.
>
> Right. I'd rather not 'fix' something that doesn't really need fixing
> (other than to suppress any WARNING caused by low_latency).

Yes.  I think what currently needs to be done is to prevent any issues
caused by the user setting the low_latency.  [IMO, warnings from the
kernel are an issue, even if the serial port continues to operate
properly.]

If somebody has specific latency requirements that aren't being met,
the current performance need to be measured, and it needs to be
decided if a solution is fesable and if the right solution is "fixing"
the low_latency flag so it's allowed in more contexts.

-- 
Grant Edwards               grant.b.edwards        Yow! I can't decide which
                                  at               WRONG TURN to make first!!
                              gmail.com            I wonder if BOB GUCCIONE
                                                   has these problems!

