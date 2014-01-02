Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaABVeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:34:24 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48091 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaABVeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:34:22 -0500
Message-ID: <52C5DB5B.9050604@linaro.org>
Date: Thu, 02 Jan 2014 13:34:19 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: v3.13-rc6+ regression (ARM board)
References: <m3mwjhux0e.fsf@t19.piap.pl>	<20131231104511.GA9688@1wt.eu>	<m3txdmu2ez.fsf@t19.piap.pl>	<20140102101455.GG10158@pengutronix.de>	<m3ppoatwn1.fsf@t19.piap.pl>	<CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com>	<52C5C5F6.70803@linaro.org>	<52C5CC54.4050602@linaro.org> <CA+55aFz2dKw5HXy7DV1Aymoscg0MW7Zz28apan8dugUeqTd1QA@mail.gmail.com>
In-Reply-To: <CA+55aFz2dKw5HXy7DV1Aymoscg0MW7Zz28apan8dugUeqTd1QA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 12:43 PM, Linus Torvalds wrote:
> On Thu, Jan 2, 2014 at 12:30 PM, John Stultz <john.stultz@linaro.org> wrote:
>> So something else may be at play. Even with Linus' patch I reproduced a
>> similar hang here.
>>
>> Still chasing it down, but it looks like a seqlock deadlock where we're
>> calling read while holding the lock.
> Hmm. Only with lockdep, right?

Yep.

> Does lockdep perhaps read the scheduler clock? Afaik, we have
> lockstat_clock(), which uses local_clock(), which in turn translates
> to sched_clock_cpu(smp_processor_id())..
>
> So if that code now tries to read the scheduler clock when
> update_sched_clock() is doing a update and has done a
> write_seqcount_begin()...

Sigh. Deadlock by deadlock detection code.

So yea, it looks like this is the case.. though I've not been able to
get a backtrace during the hang to totally validate it (I'm just using
qemu's info registers and looking at the pc and lr).


So I'm guessing we'll just have to disable the lockdep logic here, which
is a little sad, since I'm a little nervous about the generic
sched_clock's locking (ie: works ok for ARM, but its not NMI safe), and
having some better debugging tools there would be helpful.


Anyway, I'll send out a patch to disable the lockdep usage here shortly.

thanks
-john








