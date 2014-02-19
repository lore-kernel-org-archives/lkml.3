Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaBSSnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:43:04 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59975 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbaBSSnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:43:02 -0500
Message-ID: <5304FB32.3090308@hurleysoftware.com>
Date: Wed, 19 Feb 2014 13:42:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grant Edwards <grant.b.edwards@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
References: <20140218093829.GC1741@redhat.com> <5303DABD.9000302@hurleysoftware.com> <20140219130308.GC1851@redhat.com> <le2nmd$p1$1@ger.gmane.org> <5304EC33.5040502@hurleysoftware.com> <le2s6k$qo9$1@ger.gmane.org>
In-Reply-To: <le2s6k$qo9$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 01:12 PM, Grant Edwards wrote:
> On 2014-02-19, Peter Hurley <peter@hurleysoftware.com> wrote:
>> On 02/19/2014 11:55 AM, Grant Edwards wrote:
>
>>>>>> setserial has low_latency option which should minimize receive latency
>>>>>> (scheduler delay). AFAICT it is used if someone talk to external device
>>>>>> via RS-485/RS-232 and need to have quick requests and responses.
>>>
>>> Exactly.
>>
>> But not exactly, because I need a quantified value for "quick",
>
> Only the end-user knows that, and they don't tell us what it is unless
> it's not being met.  :)
>
>> preferably with average latency measurements for 3.11- and 3.12+
>
> It's been a long, long, time since I've done those measurements, and
> whatever data I had is no longer relevent (even if I could find it) --
> so I'll leave that up to somebody who's actually lobbying for getting
> low_latency fixed so that it works from an interrupt context.
>
> Just to be clearn, I'm not lobbying either for or against that. I'm
> just trying to provide some perspective on the low_latency flag,
> why it _was_ there, and who used it.

Yeah, I know; I didn't mean for you to supply those or champion the cause.

But since I'm being quoted on StackExchange, I thought I'd make my
expectations publicly known, so that if someone really feels they
need this feature, they'll speak up and back it up with numbers.

Actually right now, I'm looking into instrumenting the input path
with some event tracers so that I can actually measure that latency,
not in absolute terms, but at least relative to previous.

>> I'm trying to determine if 3.12+ already satisfies the userspace
>> requirement (or if the requirement is infeasible).
>>
>> The assumption is that 3.12+ w/o low_latency is worse than 3.11- w/
>> low_latency, which may not be true.
>
> I haven't heard any complaints for probably 10+ years.  The last time
> I did hear a complaint, I told them to set the low_latency flag and
> that solved the problem.
>
>> Also, as you note, the latency requirement is in userspace, so bound
>> to the behavior of the scheduler anyway. Thus, immediately writing to
>> the read buffer from IRQ may have no different average latency than
>> handling by a worker (as measured by the elapsed time from interrupt
>> to userspace read).
>
> Yes.  And the low_latency flag used to (as in 10 years ago) have a big
> effect on that.  Without the low latency flag, the user read would
> happen up to 10ms (assuming HZ=100) after the data was received by the
> driver.  Setting the low-latency flag eliminated that 10ms jitter.  I
> don't know if these days setting the low_latency flag (in contexts
> where it does work) even has a noticeable effect.
>
>> How can the requirement be for both must-handle-in-minimum-time data
>> (low_latency) and the-userspace-reader-isn't-reading-fast-enough-
>> so-its-ok-to-halt-transmission ?
>>
>> Throttling/unthrottling the sender seems counter to "low latency".
>
> Agreed.
>
> I can _imagine_ a case where an application has a strict limit how
> long it will wait until it sees the first byte of the response, but
> for some isolated cases (uploading large data logs) that response
> might be very large -- large neough that the application may have to
> pause while reading the response and rely on flow control to throttle
> the upload.  But, I can't point to any specific instance of that.
>
>
>>> _Usually_ applications that require low latency are exchanging short
>>> messages (up to a few hundred bytes, but usually more like a few
>>> dozen).  In those cases flow control is not generally needed.
>>>
>>> Does it matter?
>>
>> Driver throttling requires excluding concurrent unthrottle and
>> calling into the driver (and said driver has relied on sleeping locks
>> for many kernel versions).
>
> Is that still an issue for drivers where the flow cotrol is handled by
> the UART?

Every driver pays the cost to evaluate if the throttling is required,
regardless of how it specifically handles flow control. pty is
now special cased in N_TTY because it forces throttling always on.

>> But first I'd like some hard data on whether or not a low latency
>> mode is even necessary (at least for user-space).
>
> I don't have any hard data, but gut anser is that it is probably no
> longer needed.

That's my belief as well.

> The problem that existed for the past few years was
> that there was a user-space way to set the low_latency flag (it didn't
> require root and you could even do it from the command-line with
> setserial) -- and doing so annoyed the kernel.
>
>>> Now that HZ is often 1000 and tickless is commonly used, I don't think
>>> the scheduling delay is nearly as much an issue as it used to be.  I
>>> haven't gotten any complaints since it was largely rendered useless
>>> several years ago.
>>>
>>> Now all my drivers will silently override users if they set the
>>> low_latency flag on a port in situations where it can't be used.
>>
>> Right. I'd rather not 'fix' something that doesn't really need fixing
>> (other than to suppress any WARNING caused by low_latency).
>
> Yes.  I think what currently needs to be done is to prevent any issues
> caused by the user setting the low_latency.  [IMO, warnings from the
> kernel are an issue, even if the serial port continues to operate
> properly.]

Yeah, I'll go fix this.

> If somebody has specific latency requirements that aren't being met,
> the current performance need to be measured, and it needs to be
> decided if a solution is fesable and if the right solution is "fixing"
> the low_latency flag so it's allowed in more contexts.

Exactly.

Regards,
Peter Hurley
