Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBRTAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:00:51 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:45954 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaBRTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAHWkzRSXxAPShfFTAQj=f5M1L4K1E5D6yLmQS72-b1jNGTPpEA@mail.gmail.com>
References: <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<530296CD.5050503@warwick.ac.uk>
	<CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
	<1392737465.18779.7644.camel@triegel.csb>
	<CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	<20140218171609.GP4250@linux.vnet.ibm.com>
	<CAHWkzRSXxAPShfFTAQj=f5M1L4K1E5D6yLmQS72-b1jNGTPpEA@mail.gmail.com>
Date: Tue, 18 Feb 2014 11:00:48 -0800
X-Google-Sender-Auth: GxpmhCjv5mNzXMs8ppbZ-aAjQ1A
Message-ID: <CA+55aFxSPEzm95qM8qiXu3F4zm1DU4EcVx+-UucW5VPt1yCzGQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter.Sewell@cl.cam.ac.uk
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>, Alec Teal <a.teal@warwick.ac.uk>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:23 AM, Peter Sewell
<Peter.Sewell@cl.cam.ac.uk> wrote:
>
> interesting list.  So are you saying that value-range-analysis and
> such-like (I say glibly, without really knowing what "such-like"
> refers to here) are fundamentally incompatible with
> the kernel code

No, it's fine to do things like value-range-analysis, it's just that
you have to do it on a local scope, and not think that you can see
every single write to some variable.

And as Paul points out, this is actually generally true even outside
of kernels. We may be pretty unique in having some things that are
literally done by hardware (eg the page table updates), but we're
certainly not unique in having loadable modules or code that the
compiler doesn't know about by virtue of being compiled separately
(assembly files, JITted, whatever).

And we are actually perfectly fine with compiler barriers. One of our
most common barriers is simply this:

   #define barrier() __asm__ __volatile__("": : :"memory")

which basically tells the compiler "something changes memory in ways
you don't understand, so you cannot assume anything about memory
contents".

Obviously, a compiler is still perfectly fine optimizing things like
local variables etc that haven't had their address taken across such a
barrier (regardless of whether those local variables might be spilled
to the stack frame etc), but equally obviously we'd require that this
kind of thing makes sure that any atomic writes have been finalized by
the time the barrier happens (it does *not* imply a memory ordering,
just a compiler memory access barrier - we have separate things for
ordering requirements, and those obviously often generate actual
barrier instructions)

And we're likely always going to have things like this, but if C11
atomics end up working well for us, we might have *fewer* of them.

              Linus
