Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3IKBPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:15:03 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64731 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3IKBPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:15:02 -0400
Message-ID: <522FC411.3030208@linaro.org>
Date: Tue, 10 Sep 2013 18:14:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
References: <10005394.BRCyBMYWy3@tauon> <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com> <20130910203853.GG29237@thunk.org> <522F851D.1040101@linaro.org> <20130910211009.GI29237@thunk.org> <522F984C.2070909@linaro.org> <20130910223326.GD11063@thunk.org> <522FB9F1.3070905@linaro.org> <20130911005047.GA13315@thunk.org>
In-Reply-To: <20130911005047.GA13315@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 05:50 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 05:31:45PM -0700, John Stultz wrote:
>> Yea, that point about "every single interrupt" vs "every timer
>> interrupt". I suspect that if its every timer interrupt, this can be
>> done easily w/ clocksources as we already do that read, but every single
>> interrupt would have potential problems with various other devices with
>> high irq frequency.
> Yep.  The worse case would probably a serial port running at 230400
> bps.  Even with a 16550A UART with the 16-byte FIFO, we're talking
> about close to 2,000 interrupts per second.  A 16450 running at 115200
> bps would give us 11,520 interrupts per second....
>
>> Right so get_cycles() really sounds like the right thing here.
> For those platforms which have them, yes.
>
>> Although I wonder if you run into issues with counters that wrap
>> quickly? Or does that not matter?
> No, it doesn't matter.  It's really the low bits of the counter which
> are really important to us anyway.  For example on MIPS there is a
> register which is bumped on every CPU cycle, but its kept mod the
> number of entries in the TLB (it's used for random TLB eviction).
> That's what we'll probably ending using for MIPS, since its cycle
> counter is not guaranteed to be there, and had a bug which could cause
> timer interrupts to get lost if you tried reading from it at the wrong
> time.
>
>> Right. In many cases jiffies is all that we have. Thus the check for
>> timekeeping_valid_for_hres() can be used to at least flag that case. Not
>> that I know what you want to do if it comes up false.
> Right now, if get_cycles() returns 0, we fall back to only mixing in
> the IP register from the interrupt plus the jiffies counter.  The
> platforms where get_cycles returns 0 is:
>
> - MIPS (solution pending)
> - User mode Linux
> - Sparc 32 bit
> - M68K
> - M32R
> - Hexagon
> - H8/300
> - FR-V
> - CRIS
> - AVR32
> - ARC
> - METAG
> - Microblaze
> - SCORE
> - SH
> - Unicore32
>
> Would I be correct in assuming that most of these probably don't have a
> high-res clocksource, and so would fall back to jiffies anyway?

So some of them (on specific hardware, likely not as an architecture
feature) do have clocksources that are reasonably highres (m68k, sh,
hexagon). I have no sense of the cost to read them, however. I suspect
syncing with the maintainers and seeing if get_cycles can be enabled on
any of these arches, or if we should add an extra flag to the
clocksource drivers to determine if the clocksource is fast enough for
get_cycles/sched_clock usage.

Otherwise yea, I'd avoid trying to read clocksources on every irq.

thanks
-john



