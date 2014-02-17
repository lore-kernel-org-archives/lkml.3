Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaBQWsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:48:03 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:60561 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBQWr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:47:59 -0500
MIME-Version: 1.0
In-Reply-To: <1392675939.18779.7063.camel@triegel.csb>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	<1391992071.18779.99.camel@triegel.csb>
	<CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	<1392183564.18779.2187.camel@triegel.csb>
	<20140212180739.GB4250@linux.vnet.ibm.com>
	<CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	<20140213002355.GI4250@linux.vnet.ibm.com>
	<1392321837.18779.3249.camel@triegel.csb>
	<20140214020144.GO4250@linux.vnet.ibm.com>
	<1392352981.18779.3800.camel@triegel.csb>
	<20140214172920.GQ4250@linux.vnet.ibm.com>
	<CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<1392672063.18779.6940.camel@triegel.csb>
	<CA+55aFyay_ck4eb6HEWvD4bTS=3OYY7wX1MVNKAcpUYN0ssWhA@mail.gmail.com>
	<1392675939.18779.7063.camel@triegel.csb>
Date: Mon, 17 Feb 2014 14:47:58 -0800
X-Google-Sender-Auth: YGFG-IoMWvsyslsNg20sczppfLE
Message-ID: <CA+55aFx2jxE8sTZEmNnMg6ktDuU_0xPiEw3=qH0=+xat8p8cAA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
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

On Mon, Feb 17, 2014 at 2:25 PM, Torvald Riegel <triegel@redhat.com> wrote:
> On Mon, 2014-02-17 at 14:02 -0800, Linus Torvalds wrote:
>>
>> The argument was that an lvalue doesn't actually "access" the memory
>> (an rvalue does), so this:
>>
>>    volatile int *p = ...;
>>
>>    *p;
>>
>> doesn't need to generate a load from memory, because "*p" is still an
>> lvalue (since you could assign things to it).
>>
>> This isn't an issue in C, because in C, expression statements are
>> always rvalues, but C++ changed that.
>
> Huhh.  I can see the problems that this creates in terms of C/C++
> compatibility.

That's not the biggest problem.

The biggest problem is that you have compiler writers that don't care
about sane *use* of the features they write a compiler for, they just
care about the standard.

So they don't care about C vs C++ compatibility. Even more
importantly, they don't care about the *user* that uses only C++ and
the fact that their reading of the standard results in *meaningless*
behavior. They point to the standard and say "that's what the standard
says, suck it", and silently generate code (or in this case, avoid
generating code) that makes no sense.

So it's not about C++ being incompatible with C, it's about C++ having
insane and bad semantics unless you just admit that "oh, ok, I need to
not just read the standard, I also need to use my brain, and admit
that a C++ statement expression needs to act as if it is an "access"
wrt volatile variables".

In other words, as a compiler person, you do need to read more than
the paper of standard. You need to also take into account what is
reasonable behavior even when the standard could possibly be read some
other way. And some compiler people don't.

The "volatile access in statement expression" did get resolved,
sanely, at least in gcc. I think gcc warns about some remaining cases.

Btw, afaik, C++11 actually clarifies the standard to require the
reads, because everybody *knew* that not requiring the read was insane
and meaningless behavior, and clearly against the intent of
"volatile".

But that didn't stop compiler writers from saying "hey, the standard
allows my insane and meaningless behavior, so I'll implement it and
not consider it a bug".

                    Linus
