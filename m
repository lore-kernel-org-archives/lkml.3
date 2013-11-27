Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3K0XVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:21:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53797 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab3K0XU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:20:59 -0500
Message-ID: <52967E27.3070906@zytor.com>
Date: Wed, 27 Nov 2013 15:20:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com> <20131127222104.GA748@pd.tnic> <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com> <20131127222944.GB748@pd.tnic> <529674C4.2030906@zytor.com> <20131127231010.GM32267@pd.tnic>
In-Reply-To: <20131127231010.GM32267@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:10 PM, Borislav Petkov wrote:
> On Wed, Nov 27, 2013 at 02:40:04PM -0800, H. Peter Anvin wrote:
>> Also don't forget we need the IPIs, too...
> 
> Yeah, I was simply looking at whether we could get away with executing
> an empty syscall, i.e. save us the CPUID and rely only on the IPIs and
> IRET.
> 
> But we don't IPI ourselves in smp_call_function; actually we remove
> ourselves from the cpumask because of deadlocking scenarios. So on
> this_cpu we only execute the function with IRQs disabled and CLI/STI is
> not serializing.
> 

Although as Linus correctly pointed out, on the modifying CPU itself we
only need a branch.  For the standalone system call that doesn't work,
because you can't assume that the modifying CPU and the syscall CPU are
the same CPU.

> I wonder if we could use MFENCE instead of CPUID, though, and save us
> the clobbering of e*x, maybe even save us some cycles since MFENCE
> should be faster than hundred-ish cycles of microcoded CPUID.
> 

No.  MFENCE doesn't serialize the front end.

	-hpa



