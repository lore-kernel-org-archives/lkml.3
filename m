Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbbAMWvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:51:33 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:57765 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAMWvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLVFLAjCD2Vw6Zue=+RU2GSspCDTBTeRAv-EQMy3iA6oBw@mail.gmail.com>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-7-git-send-email-john.stultz@linaro.org>
	<20150113111146.GL23965@worktop.programming.kicks-ass.net>
	<CALAqxLVFLAjCD2Vw6Zue=+RU2GSspCDTBTeRAv-EQMy3iA6oBw@mail.gmail.com>
Date: Wed, 14 Jan 2015 11:51:30 +1300
X-Google-Sender-Auth: JrhwbpoGVC3IZ6aWlLYWpT2rMjM
Message-ID: <CA+55aFzA3UpROFWVyzADONc0TPY6wmXXF105APvSWm_69vmo5g@mail.gmail.com>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:33 AM, John Stultz <john.stultz@linaro.org> wrote:
>
> So since this is a time reading function, this could be called
> anywhere.

Indeed. Could, and is.

>From within the scheduler, with some very core locks held. From within
printk itself (more really core locks held). From the tracer (which in
turn can be from pretty much anything else). From various lockless and
critical places. And from very early in the boot sequence when almost
nothing is set up yet, etc etc.

You can't print from that context, you can't even disable preemption
(because the boot sequence seems to get unhappy when you re-enable
preemption before things are really set up), you can't do much at all.
It's why my hacky patch just read the state and updated an error flag
(and possibly wrote a backtrace), to be printed out later.

I think we could possibly do more if being very careful. But the code
word really is "very careful indeed". It would probably be ok to use a
raw irq-disable spinlock. Maybe the preempt-disable works too if you
end up using some raw version that still works during boot etc etc.

             Linus
