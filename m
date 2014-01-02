Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaABUny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:43:54 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42842 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <52C5CC54.4050602@linaro.org>
References: <m3mwjhux0e.fsf@t19.piap.pl>
	<20131231104511.GA9688@1wt.eu>
	<m3txdmu2ez.fsf@t19.piap.pl>
	<20140102101455.GG10158@pengutronix.de>
	<m3ppoatwn1.fsf@t19.piap.pl>
	<CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com>
	<52C5C5F6.70803@linaro.org>
	<52C5CC54.4050602@linaro.org>
Date: Thu, 2 Jan 2014 12:43:52 -0800
X-Google-Sender-Auth: b0WXlHKh5cTrIUQK2PngymOYA-U
Message-ID: <CA+55aFz2dKw5HXy7DV1Aymoscg0MW7Zz28apan8dugUeqTd1QA@mail.gmail.com>
Subject: Re: v3.13-rc6+ regression (ARM board)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 12:30 PM, John Stultz <john.stultz@linaro.org> wrote:
>
> So something else may be at play. Even with Linus' patch I reproduced a
> similar hang here.
>
> Still chasing it down, but it looks like a seqlock deadlock where we're
> calling read while holding the lock.

Hmm. Only with lockdep, right?

Does lockdep perhaps read the scheduler clock? Afaik, we have
lockstat_clock(), which uses local_clock(), which in turn translates
to sched_clock_cpu(smp_processor_id())..

So if that code now tries to read the scheduler clock when
update_sched_clock() is doing a update and has done a
write_seqcount_begin()...

    Linus
