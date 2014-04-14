Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaDNRXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:23:16 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56733 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaDNRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
References: <cover.1397487345.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Apr 2014 10:22:54 -0700
Message-ID: <CALCETrV3iP4ogtqK26D_YYXi9eHXfLcjNcLeXP9TNYRwV0ogZw@mail.gmail.com>
Subject: Re: [PATCH resend 0/2] random: Use DRBG sources
To: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 8:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> [Resent because I forgot to email lkml.  This also surreptitiously
>  fixes a silly typo on a patch description.]
>
> This is my attempt to come up with a workable way to use so-called
> entropy sources like a TPM to feed /dev/urandom.
>
> Arguably we should be feeding the input pool as well, but if the
> /dev/random algorithm is correct, this shouldn't matter.  I don't want
> sensible use of TPMs for /dev/urandom to block on a long debate about
> /dev/random, so these patches have no effect on /dev/random.

Please consider these patches withdrawn.  I'll redo them on top of the
hwrng stuff.

Reasons:

 - add_drbg_randomness can probably be replaced with
add_device_randomness.  I'm not convinced that I like
add_device_randomness as a way to add small amounts of entropy: if an
attacker knows the initial state of the nonblocking pool, they can use
it to back out small amounts of entropy added via
add_device_randomness, which allows them to track all input_pool
entropy added by add_device_randomness.  This type of attack is
impractical for large amounts of device randomness added at once, so
this is orthogonal to the purpose of my patches.

 - The hwrng code itself is already a sensible place to do this kind
of initial seeding of the nonblocking pool, so I think that it would
be better to improve the hwrng code a bit instead.

My current thought is to split CONFIG_HW_RANDOM into
CONFIG_HW_RANDOM_DEVICES and CONFIG_HW_RANDOM.
CONFIG_HW_RANDOM_DEVICES will default to m and will expose
hwrng_register but not the /dev/hwrng code.  hwrng_register will call
add_device_randomness, but I'll add logging so that we can tell that
it's working.

I'll also rewrite the tpm hwrng driver.  There should be a hwrng
instance per TPM, and it shouldn't show up until there's actually a
TPM there.

--Andy

>
> Andy Lutomirski (2):
>   random: Add add_drbg_randomness to safely seed urandom from crypto hw
>   tpm,random: Call add_drbg_randomness after selftest
>
>  drivers/char/random.c            | 56 +++++++++++++++++++++++++++++++++++-----
>  drivers/char/tpm/tpm-interface.c | 15 ++++++++++-
>  include/linux/random.h           |  1 +
>  include/trace/events/random.h    | 19 ++++++++++++++
>  4 files changed, 83 insertions(+), 8 deletions(-)
>
> --
> 1.9.0
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
