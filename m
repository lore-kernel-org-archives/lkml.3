Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3JLBqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:46:00 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35208 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3JLBp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:45:58 -0400
MIME-Version: 1.0
In-Reply-To: <2579337.FPgJGgHYdz@tauon>
References: <2579337.FPgJGgHYdz@tauon>
Date: Fri, 11 Oct 2013 21:45:57 -0400
Message-ID: <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 2:38 PM, Stephan Mueller <smueller@chronox.de> wrote:

I like the basic idea. Here I'm alternately reading the email and the
page you link to & commenting on both.

A nitpick in the paper is that you cite RFC 1750. That was superceded
some years back by RFC 4086
http://tools.ietf.org/html/rfc4086

(Ted's comments in the actual driver had the same problem last
I looked. That is excusable since they were written long ago.)

I think you may be missing some other citations that should be
there, to previous work along similar lines. One is the HAVEGE
work, another:
McGuire, Okech & Schiesser,
Analysis of inherent randomness of the Linux kernel,
http://lwn.net/images/conf/rtlws11/random-hardware.pdf

Paper has:

" the time delta is partitioned into chunks of 1 bit starting at the lowest bit
" .... The 64 1 bit chunks of the time value are XORed with each other to
" form a 1 bit value.

As I read that, you are just taking the parity. Why not use that simpler
description & possibly one of several possible optimised algorithms
for the task: http://graphics.stanford.edu/~seander/bithacks.html

If what you are doing is not a parity computation, then you need a
better description so people like me do not misread it.

A bit later you have:

" After obtaining the 1 bit folded and unbiased time stamp,
" how is it mixed into the entropy pool? ... The 1 bit folded
" value is XORed with 1 bit from the entropy pool.

This appears to be missing the cryptographically strong
mixing step which most RNG code includes. If that is
what you are doing, you need to provide some strong
arguments to justify it.

Sometimes doing without is justified; for example my
code along these lines
ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/
does more mixing than I see in yours, but probably
not enough overall. That's OK because I am just
feeding into /dev/random which has plenty of
mixing.

It is OK for your code too if you are feeding into
/dev/random, but it looks problematic if your code
is expected to stand alone.

Ah! You talk about whitening a bit later. However,
you seem to make it optional, up to the user. I
cannot see that that is a good idea.

At the very least I think you need something like
the linear transform from the ARIA cipher -- fast
and cheap, 128 bits in & 128 out and it makes
every output bit depend on every input bit. That
might not be enough, though.

You require compilation without optimisation. How does
that interact with kernel makefiles? Can you avoid
undesirable optimisations in some other way, such as
volatile declartions?

> I am asking whether this RNG would good as an inclusion into the Linux
> kernel for:
>
> - kernel crypto API to provide a true random number generator as part of
> this API (see [2] appendix B for a description)

My first reaction is no. We have /dev/random for the userspace
API and there is a decent kernel API too. I may change my
mind here as I look more at your appendix & maybe the code.

> - inclusion into /dev/random as an entropy provider of last resort when
> the entropy estimator falls low.

Why only 'of last resort'? If it can provide good entropy, we should
use it often.

> I will present the RNG at the Linux Symposium in Ottawa this year. There
> I can give a detailed description of the design and testing.

I live in Ottawa, don't know if I'll make it to the Symposium this
year. Ted; I saw you at one Symposium; are you coming this
year?
