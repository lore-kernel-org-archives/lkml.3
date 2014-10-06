Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJFJ0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:26:08 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39113 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaJFJ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140929150009.GA9102@console-pimps.org>
References: <20140928202702.GB18635@console-pimps.org>
	<20140929124321.GB18825@gmail.com>
	<20140929140516.GL5430@worktop>
	<20140929150009.GA9102@console-pimps.org>
Date: Mon, 6 Oct 2014 11:26:01 +0200
Message-ID: <CAKv+Gu8V=g59c3ef_M_OZDR7G5TA=Vd79qi7Lvb4zpx1jUSbYg@mail.gmail.com>
Subject: Re: [GIT PULL] EFI changes for v3.18
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 September 2014 17:00, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 29 Sep, at 04:05:16PM, Peter Zijlstra wrote:
>>
>> OMFG what a trainwreck... if they are reentrant like that, a lock isn't
>> going to help you in any way. The implementation of these calls must be
>> lockfree otherwise they cannot possibly be correct.
>
> The only way these services are going to be called is if we (the OS)
> invoke them. These NMI shenanigans we're playing in the locking
> functions are actually for our benefit, not the firmware's.
>

The thing to understand here is that these Runtime Services are never
supposed to be *reentrant*, even under NMI. The special case for NMI,
machine check etc allows the OS to issue a concurrent Runtime Services
call that /preempts/ the call that is already in progress. The spec
explicitly mentions that the preempted function call is entirely
expected to fail.

This is exactly why the spec is so specific on which calls can be
issued concurrently: it puts the burden of exclusive access on the OS,
and the implementation can abort/fail a call in progress if another
one comes in concurrently.

This does imply that even the NMI case should take the lock if it is
free, which makes my implementation incorrect.

Note that I am by no means suggesting that relying on any of this
having been implemented correctly in most firmwares is a good idea.

>> Conditional locking like above is just plain broken, disgusting doesn't
>> even begin to cover it. Full NAK on this. If this is required by the EFI
>> spec someone needs to pull their head from their arse and smell the real
>> world.
>
> The conditional locking isn't intended to conform to the spec, it's
> intended to write a pstore object to the EFI variable NVRAM with our
> last dying breath, even if someone was in the middle of a SetVariable()
> call. All the spec says is that, if we're in a non-recoverable state,
> it's OK to do that. Whether that'll be implemented correctly across a
> range of firmware implementations is another matter.
>
> In fact, maybe we shouldn't support that lockless access at all. I've no
> huge problem changing the code in efi_pstore_write() to bail if we can't
> grab the lock, so that we can be serialized all of the time.
>
> That would certainly make the runtime lock code much simpler.
>

I think there is value in the ability to issue those calls under
MCHECK to record fault metadata, and obviously, the authors of the
spec did as well. However, the question is indeed how robust existing
firmware implementations are under this kind of behavior, so I agree
it is better to make the exclusive access unconditional. Note that
these exception are specific to Intel architectures, for arm64 the
locking was unconditional already.

-- 
Ard.
