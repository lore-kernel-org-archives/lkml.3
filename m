Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaB0FOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:14:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0FOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:14:09 -0500
Message-ID: <530EC7D1.3000706@zytor.com>
Date: Wed, 26 Feb 2014 21:06:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
References: <cover.1393462777.git.luto@amacapital.net> <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net> <20140227033920.GI12219@tassilo.jf.intel.com>
In-Reply-To: <20140227033920.GI12219@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 07:39 PM, Andi Kleen wrote:
> On Wed, Feb 26, 2014 at 05:02:13PM -0800, Andy Lutomirski wrote:
>> This makes no difference for 64-bit, bit it's critical for 32-bit code:
>> these functions are called from outside the kernel, so they need to comply
>> with the ABI.
> 
> That's an odd patch. If that was wrong things couldn't have worked at all.
> Probably hidden by inlining? If yes just make it static
> 
> Also you would rather need notrace more often.
> 

It has to support *an* ABI... the syscall vdso entry point uses the old
int $0x80 calling convention rather than the normal ABI.  It would
depend on the test program and eventual glibc implementation.  And sure
enough, the test program has:

int (*vdso_gettimeofday)(struct timeval *tv, struct timezone *tz)
__attribute__ ((regparm (3)));
int (*vdso_clock_gettime)(clockid_t clk_id, struct timespec *tp)
__attribute__ ((regparm (3)));
time_t (*vdso_time)(time_t *t) __attribute__ ((regparm (3)));

That being said, since this code is compiled separately, the compiler
flags there determine what actually matters.  However, there we have:

KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3 -freg-struct-return -fpic

The normal ABI almost certainly makes more sense; as such -mregparm=3 is
probably not what we want, and I suspect it makes more sense to just
drop that from the CFLAGS line?

	-hpa

