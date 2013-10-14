Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3JNOOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:14:03 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:41065 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JNOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon>
	<CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
	<5356953.K0nNZDGpEZ@tauon>
	<CACXcFm=_jmeKe2YYbHDi-jTGX-23hDsDeu_weWQkr2F_FpE_6g@mail.gmail.com>
	<CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
Date: Mon, 14 Oct 2013 10:14:00 -0400
Message-ID: <CACXcFmnDjSWHrU-4dR=Nb5n-9t=0PmM9Bc_pOFMTi3eotR2g6A@mail.gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 9:38 AM, Sandy Harris <sandyinchina@gmail.com> wrote:

> Stephan Mueller <smueller@chronox.de> wrote:

>> Can you please help me understand why you think that a whitening
>> function (cryptographic or not) is needed in the case of the CPU Jitter
>> RNG, provided that I can show that each individual bit coming from the
>> folding operation has one bit of entropy?
>
> Basically, sheer paranoia. I'd mix and whiten just on general
> principles. Since efficiency is not a large concern, there is little
> reason not to.
>
> On the other hand, most RNGs use a hash because they need
> to distill some large amount of low-entropy input into a smaller
> high-entropy output. With high input entropy, you do not need
> the hash and can choose some cheaper mixer.

You could use strong mixing/whitening:

Feed into random(4) and let it do the mixing.

Use some early outputs from your RNG to key an AES
instance. Then encrypt later outputs; this gives a 64 in 64
out mixer that is cryptographically strong but perhaps a bit
slow in the context.

Alternately, quite a few plausible components for fast cheap
mixing are readily available.

The Aria cipher has one that is 128 in 128 out. It multiplies
a 128-bit object by a fixed Boolean matrix, makes every
output bit depend on many input bits. It is fairly cheap,
used in every round and the cipher is acceptably fast.

The column transform from AES is 32 in 32 out and makes
every output byte depend on every input byte. It is fast; has
to be since it is used four times in every round.

A two-way pseudo-Hadamard transform (PHT) is 2n bits in
and 2n out, requires only two additions, makes both n-bit
outputs depend on both inputs.

PHT can be applied recursively to mix 4n, 8n, ...

My QHT is 32 in 32 out, makes every /bit/ of output
depend on every bit of input. It is a tad expensive;
two multiplications & two modulo operations. File
qht.c at:
ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/

To mix 64 bits, I'd use two qht() calls to mix the 32-bit
halves then a two-way PHT.
