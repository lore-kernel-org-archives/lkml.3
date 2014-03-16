Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaCPW5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 18:57:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55634 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaCPW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 18:57:07 -0400
Message-ID: <53262C21.6000608@zytor.com>
Date: Sun, 16 Mar 2014 15:56:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
References: <20140303235148.GA7601@www.outflux.net>
In-Reply-To: <20140303235148.GA7601@www.outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 03:51 PM, Kees Cook wrote:
> When bringing a new RNG source online, it seems like it would make sense
> to use some of its bytes to make the system entropy pool more random,
> as done with all sorts of other devices that contain per-device or
> per-boot differences.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

I would like to raise again the concept of at least optionally using a
kernel thread, rather than a user-space daemon, to feed hwrng output to
the kernel pools.  The main service rngd provides is FIPS tests, but
those FIPS tests were withdrawn as a standard over 10 years ago and are
known to be extremely weak, at the very best a minimal sanity check.
Furthermore, they are completely useless against the output of any RNG
which contains a cryptographic whitener, which is the vast majority of
commercial sources -- this is especially so since rngd doesn't expect to
have to do any data reduction for output coming from hwrng.

Furthermore, if more than one hwrng device is available, rngd will only
be able to read one of them because of the way /dev/hwrng is implemented
in the kernel.

For contrast, the kernel could do data reduction just fine by only
crediting the entropy coming out of each hwrng driver with a fractional
amount.

That does *not* mean that there aren't random number generators which
require significant computation better done in user space.  For example,
an audio noise daemon or a lava lamp camera which requires video processing.

	-hpa

