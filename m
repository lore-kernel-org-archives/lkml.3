Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaCQLxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:53:55 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60627 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbaCQLxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:53:53 -0400
Message-ID: <5326E24E.1090607@gmail.com>
Date: Mon, 17 Mar 2014 07:53:50 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
CC: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng sources
References: <20140303235148.GA7601@www.outflux.net> <53262C21.6000608@zytor.com>
In-Reply-To: <53262C21.6000608@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-16 18:56, H. Peter Anvin wrote:
> On 03/03/2014 03:51 PM, Kees Cook wrote:
>> When bringing a new RNG source online, it seems like it would make sense
>> to use some of its bytes to make the system entropy pool more random,
>> as done with all sorts of other devices that contain per-device or
>> per-boot differences.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> I would like to raise again the concept of at least optionally using a
> kernel thread, rather than a user-space daemon, to feed hwrng output to
> the kernel pools.  The main service rngd provides is FIPS tests, but
> those FIPS tests were withdrawn as a standard over 10 years ago and are
> known to be extremely weak, at the very best a minimal sanity check.
> Furthermore, they are completely useless against the output of any RNG
> which contains a cryptographic whitener, which is the vast majority of
> commercial sources -- this is especially so since rngd doesn't expect to
> have to do any data reduction for output coming from hwrng.
> 
> Furthermore, if more than one hwrng device is available, rngd will only
> be able to read one of them because of the way /dev/hwrng is implemented
> in the kernel.
> 
> For contrast, the kernel could do data reduction just fine by only
> crediting the entropy coming out of each hwrng driver with a fractional
> amount.
> 
> That does *not* mean that there aren't random number generators which
> require significant computation better done in user space.  For example,
> an audio noise daemon or a lava lamp camera which requires video processing.
> 
> 	-hpa

I definitely second this proposal, not only does it get rid of the
overhead of the FIPS tests (which can be quite significant on embedded
systems), it also removes a significant percentage of the context
switches that rngd needs to make.  This should provide some way of
disabling this behavior, probably either making it a module, or
providing a command-line/sysfs option to disable it.  In fact, it should
probably default to being disabled (at least at first) and require the
user to explicitly opt-in to using it (I know people who run simulations
who use the output from /dev/hwrng directly for the simulation software
exclusively, and /dev/[u]random for everything else).
