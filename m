Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaDNQhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:37:20 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33676 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaDNQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140414161359.GD29351@lst.de>
References: <cover.1397487345.git.luto@amacapital.net> <20140414161359.GD29351@lst.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Apr 2014 09:36:56 -0700
Message-ID: <CALCETrVf18nSiVGFox-dAZsmeQ7_2_yscSkbqEgD4nmCvenqGQ@mail.gmail.com>
Subject: Re: [PATCH resend 0/2] random: Use DRBG sources
To: Torsten Duwe <duwe@lst.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 9:13 AM, Torsten Duwe <duwe@lst.de> wrote:
> On Mon, Apr 14, 2014 at 08:49:58AM -0700, Andy Lutomirski wrote:
>> [Resent because I forgot to email lkml.  This also surreptitiously
>>  fixes a silly typo on a patch description.]
>>
>> This is my attempt to come up with a workable way to use so-called
>> entropy sources like a TPM to feed /dev/urandom.
>
> Ahem, The TPM RNGs are true HWRNGs, but they are very limited.
> Their main purpose is to generate enough bits so that the TPM
> can generate a genuine key pair after a few seconds.
>
> Why do you want to put those valuable true random bits into urandom?

I don't consider 256 bits, once per TPM initialization, to be valuable
in the sense that we should try to conserve them.  I consider them
valuable in the sense that we should put them where that matter most,
ASAP.  That place is IMO urandom, since readers of /dev/random will
happily block until /dev/random is adequately seeded.

If urandom is working correctly, seeding it with 256 cryptographically
secure bits, once, is enough.  Seeding it more is nice, but doing that
is IMO much lower priority.

Because urandom can be weak shortly after bootup, the TPM is there,
and putting these bits into urandom will either make urandom quite
secure, if the TPM is trustworthy, or will at least be harmless, if
the TPM is untrustworthy.

As an added benefit, this code is very simple and can easily coexist
with your code.

>
>> Arguably we should be feeding the input pool as well, but if the
>
> Yes.
>
>> /dev/random algorithm is correct, this shouldn't matter.  I don't want
>> sensible use of TPMs for /dev/urandom to block on a long debate about
>> /dev/random, so these patches have no effect on /dev/random.
>
> That confuses me a bit.

Currently there is no quick algorithm to seed urandom from sources
like a TPM.  IMO we should have one.  There are also people who are
nervous about devices like the TPM, and they may object to crediting
any entropy from the TPM.  The amount of entropy credited affects
urandom reseeding, and setting it to zero and/or turning the whole
hwrng/khwrngd thing off should not prevent urandom from getting the
benefit of a TPM.

--Andy
