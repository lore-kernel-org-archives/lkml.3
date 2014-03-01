Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaCACA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:00:57 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34427 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaCACAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:00:55 -0500
MIME-Version: 1.0
In-Reply-To: <1393572124.1019.3.camel@wall-e.seibold.net>
References: <1393443298.1917.5.camel@wall-e.seibold.net> <20140226204524.GA1598@kroah.com>
 <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
 <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com> <1393572124.1019.3.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 28 Feb 2014 18:00:34 -0800
Message-ID: <CALCETrUH1tZcu0upkTV0gsXtpnf-BAY4vmWKnN19=ZXsbqWT8A@mail.gmail.com>
Subject: Re: Final: Add 32 bit VDSO time function support
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:22 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Mittwoch, den 26.02.2014, 16:55 -0800 schrieb Andy Lutomirski:
>>
>> Once I patch it to work, your 32-bit code is considerably faster than
>> the 64-bit case.  It's enough faster that I suspect a bug.  Dumping
>> the in-memory shows some rather suspicious nops before the rdtsc
>> instruction.  I suspect that you've forgotten to run the 32-bit vdso
>> through the alternatives code.  The is a nasty bug: it will appear to
>> work, but you'll see non-monotonic times on some SMP systems.
>>
>
> I didn't know this. My basic test case is a KVM which defaults to 1 cpu.
> Thanks for discovering the issue.

This leads to a potentially interesting question: is rdtsc_barrier()
actually necessary on UP?  IIRC the point is that, if an
rdtsc_barrier(); rdtsc in one thread is "before" (in the sense of
being synchronized by some memory operation) an rdtsc_barrier(); rdtsc
in another thread, then the first rdtsc needs to return an earlier or
equal time to the second one.

I assume that no UP CPU is silly enough to execute two rdtsc
instructions out of order relative to each other in the absence of
barriers.  So this is a nonissue on UP.

On the other hand, suppose that some code does:

volatile long x = *(something that's not in cache)
clock_gettime

I can imagine a modern CPU speculating far enough ahead that the rdtsc
happens *before* the cache miss.  This won't cause visible
non-monotonicity as far as I can see, but it might annoy people who
try to benchmark their code.

Note: actually making this change might be a bit tricky.  I don't know
if the alternatives code is smart enough.

--Andy
