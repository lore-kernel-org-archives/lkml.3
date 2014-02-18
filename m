Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaBRSta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:49:30 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54934 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBRSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	<CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
	<CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
Date: Tue, 18 Feb 2014 10:49:27 -0800
X-Google-Sender-Auth: KOPKE-QtvZTaxtchUSgRPOVzHQE
Message-ID: <CA+55aFyfjr7=kXu6W83HhMenOnX9fssOGaZTJv_vj6rQ_+jY3Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter.Sewell@cl.cam.ac.uk
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:21 AM, Peter Sewell
<Peter.Sewell@cl.cam.ac.uk> wrote:
>
> This is a bit more subtle, because (on ARM and POWER) removing the
> dependency and conditional branch is actually in general *not* equivalent
> in the hardware, in a concurrent context.

So I agree, but I think that's a generic issue with non-local memory
ordering, and is not at all specific to the optimization wrt that
"x?42:42" expression.

If you have a value that you loaded with a non-relaxed load, and you
pass that value off to a non-local function that you don't know what
it does, in my opinion that implies that the compiler had better add
the necessary serialization to say "whatever that other function does,
we guarantee the semantics of the load".

So on ppc, if you do a load with "consume" or "acquire" and then call
another function without having had something in the caller that
serializes the load, you'd better add the lwsync or whatever before
the call. Exactly because the function call itself otherwise basically
breaks the visibility into ordering. You've basically turned a
load-with-ordering-guarantees into just an integer that you passed off
to something that doesn't know about the ordering guarantees - and you
need that "lwsync" in order to still guarantee the ordering.

Tough titties. That's what a CPU with weak memory ordering semantics
gets in order to have sufficient memory ordering.

And I don't think it's actually a problem in practice. If you are
doing loads with ordered semantics, you're not going to pass the
result off willy-nilly to random functions (or you really *do* require
the ordering, because the load that did the "acquire" was actually for
a lock!

So I really think that the "local optimization" is correct regardless.

                   Linus
