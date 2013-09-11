Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3IKRxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:53:11 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41518 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3IKRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:53:09 -0400
Message-ID: <5230AE02.20101@linaro.org>
Date: Wed, 11 Sep 2013 10:53:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org> <20130911174902.GA23532@Krystal>
In-Reply-To: <20130911174902.GA23532@Krystal>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 10:49 AM, Mathieu Desnoyers wrote:
> Hi John,
>
> * John Stultz (john.stultz@linaro.org) wrote:
>> On 09/11/2013 08:08 AM, Mathieu Desnoyers wrote:
>>> Starting from commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
>>> "timekeeping: Hold timekeepering locks in do_adjtimex and hardpps"
>>> (3.10 kernels), the xtime write seqlock is held across calls to
>>> __do_adjtimex(), which includes a call to notify_cmos_timer(), and hence
>>> schedule_delayed_work().
>>>
>>> This introduces a side-effect for a set of tracepoints, including mainly
>>> the workqueue tracepoints: a tracer hooking on those tracepoints and
>>> reading current time with ktime_get() will cause hard system LOCKUP such
>>> as:
>> Oh bummer. I had just worked this issue out the other day:
>>     https://lkml.org/lkml/2013/9/9/476
>>
>> Apparently it was a schroedinbug of sorts. My apologies for time you
>> spent chasing this down.
> No worries. As soon as I've been able to reproduce it on my test box
> (with serial port), the NMI watchdog had a pretty reasonable explanation
> for the issue.
>
>> My plan is to pull the notify_cmos_timer call to outside of the
>> timekeeper locking (see the patch at the very end of the mail in the
>> above link), as well as try to add lockdep support to seqcount/seqlocks
>> so we can catch these sorts of issues more easily.
> I just tried your patch, and it indeed seems to fix the lockup I've been
> experiencing with lttng-modules. Do you plan pushing this fix into
> master, and submitting it for inclusion into stable 3.10 and stable 3.11 ?
Yea. I was waiting on feedback from the reporter that the fix resolves
the issue but if it fixes it for you I'll go ahead and send it out today.

thanks
-john



