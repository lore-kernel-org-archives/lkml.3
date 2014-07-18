Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbaGRByf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:54:35 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:39619 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaGRBye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:54:34 -0400
Message-ID: <53C87E5B.2060505@linaro.org>
Date: Thu, 17 Jul 2014 20:54:35 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: akpm@linux-foundation.org, pmladek@suse.cz, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] printk: more log flag simplification
References: <1405619953-5475-1-git-send-email-elder@linaro.org> <CAPXgP13LZQTu7-LQp4Amj6YmEh7X+Jk3e27D-wUz60qmSYfOwQ@mail.gmail.com>
In-Reply-To: <CAPXgP13LZQTu7-LQp4Amj6YmEh7X+Jk3e27D-wUz60qmSYfOwQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:37 PM, Kay Sievers wrote:
> On Thu, Jul 17, 2014 at 7:59 PM, Alex Elder <elder@linaro.org> wrote:
>> This series rearranges the log code in such a way that the LOG_CONT
>> and LOG_PREFIX log record flags can be eliminated entirely.  The
>> result should be considerably easier to understand than before.  It
>> builds on another recently-posted series of patches:
>>     https://lkml.org/lkml/2014/7/17/363
>>
>> The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
>> are inverses, and uses LOG_NEWLINE (or its negation) anywhere
>> LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
>> it's eliminated.
>>
>> The next three patches together eliminate LOG_PREFIX.  The effect
>> of LOG_PREFIX is to complete the previous log entry before recording
>> a new one.  Patch 2 arranges to do this directly, marking the previous
>> log record with LOG_NEWLINE whenever a new record is presented with
>> LOG_PREFIX set.  Patch 3 stops saving LOG_PREFIX in any log records,
>> and patch 4 finally gets rid of LOG_PREFIX.
>>
>> The last patch is just some cleanup of the code now that it's gone
>> through this transformation.
> 
> Continuation lines are racy and unreliable by definition, they create
> a problem that cannot be solved properly, so we need to try to make
> the best out of it. The idea of the record buffer flags was to record
> what actually happened when things race against each other. A line
> without a newline is recorded as a line without a newline.

Understood.

> Your simplifying patches changes the code to store how things will
> *look* like when exported, not what actually *happened*; like it
> pretends the earlier line had a newline, while that might not have
> been the case.

What do you mean by "exported?"  Does the result in syslog
or /proc/kmsg (or the console for that matter) actually
differ?  I'll have to look again, but I think they do not.

I believe with the changes I made, all log records are saved in
exactly the same order, and buffered records are merged in exactly
the same way as before.  It's just that !LOG_NEWLINE is now treated
as the same as LOG_CONT, and the effect of LOG_PREFIX is done by
"completing" the previous record.

I do see your point though, that the fact that a newline
was added by a successor entry loses the piece of information
that the previous one didn't have one originally.  Is that
significant information?  I don't believe it's visible outside
the in-core log records.

> Maybe your simplified logic is "good enough" for the common use cases,
> I haven't thought it through, but it sounds a bit strange to pretend
> things in the flags of a record which actually did not happen for this
> record that way, just to save a bit in a flag field.

It is not about saving bits, it's about making the
code more understandable.  As it was, only after
looking very hard at this to see things could be
refactored that I saw that the one case (where PREFIX
did not override a previous CONT flag) had a bug.

My sincere intention was to preserve exactly the same
behavior, but do so with fewer flags.  The net result
is the same, but you're right, I realize now there was
some information loss--I just didn't recognize that
information as important.

I really appreciate your looking this stuff over Kay.

					-Alex


> Thanks,
> Kay
> 

