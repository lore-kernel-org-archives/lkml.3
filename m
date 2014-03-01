Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaCANnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 08:43:49 -0500
Received: from www84.your-server.de ([213.133.104.84]:53334 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaCANns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 08:43:48 -0500
Message-ID: <1393681393.982.10.camel@wall-e.seibold.net>
Subject: Re: [PATCH v2 1/4] x86: Use the default ABI for the 32-bit vDSO
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sat, 01 Mar 2014 14:43:13 +0100
In-Reply-To: <CALCETrXOrJPidKSAshwE94wumnWqZdwDQ0+fWAY8UZxLf+PCdw@mail.gmail.com>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
	 <cover.1393545985.git.luto@amacapital.net>
	 <2f5d45b67dcd2c4ba58ed7ff13cfcd7a4da977fa.1393545985.git.luto@amacapital.net>
	 <1393572505.1019.10.camel@wall-e.seibold.net>
	 <e33a0c21-5d74-4584-ac35-8cd45a905310@email.android.com>
	 <CALCETrXOrJPidKSAshwE94wumnWqZdwDQ0+fWAY8UZxLf+PCdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Freitag, den 28.02.2014, 12:19 -0800 schrieb Andy Lutomirski:
> On Fri, Feb 28, 2014 at 7:06 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > How many internal function calls are there? It seems we should try to avoid those as much as possible by suitable inlining.
> 
> There are no non-static calls at all, except for __x86.get_pc_thunk.
> I imagine that gcc is smart enough to improve the calling convention
> to non-externally-visible functions.
> 
> Amazingly (to me, anyway), the performance of the 32-bit version seems
> to be within 1 ns or so of the 64-bit version on SNB.  I suspect that
> Intel has optimized the crap out of these things.
> 

I did some benchmarks on my Core2 Q9300 / 2.53GHz and against
"-mregparm=3 -freg-struct-return" and "-mregparm=0". 

The system was boot with idle=poll, the scaling_governor was set to
performance, sched_rt_runtime_us was set to 1000000 and  and the
benchmark was executed under realtime priority 99. 

For gettimeday() and time() there is no difference, gettimeofday()  has
an average runtime of 49 ns and time() needs 11 ns. In the default ABI
is a little bit faster measured in sub-nanoseconds.

For the  clock_gettime(CLOCK_MONOTONIC) the results are 47 ns as best
cast for the non default ABI and 46 for the default ABI. In the average
it was more than 1 ns faster.

So the default ABI is faster, in any cases.

One interesting thing is that the HPET code is significant faster when
using kernel parameter idle=poll, it is 953 vs 46 ns, this a factor of
more than 20.

- Stefani

