Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3BISGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 13:06:35 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47530 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760774Ab3BISGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 13:06:33 -0500
Date: Sat, 9 Feb 2013 13:06:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Message-ID: <20130209180629.GD8091@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
References: <51157686.9000404@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51157686.9000404@chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:04:54PM +0100, Stephan Mueller wrote:
> * an array of statistical test suites pass the output of the entropy
> collector
>   (again, the output is not mangled with cryptography)

You're not mangling the output with cryptography, but you are doing
some mangling in jitterentropy_cpu_jitter().

So let's be clear about what the heart of your entropy source is:

You're getting the nanoseconds out of clock_gettime(CLOCK_REALTIME),
and then mixing it using XOR and a ROL(3) into a 64-bit buffer, and
interspersing the calls to clock_gettime() with schedule().

So what a code breaker at the NSA would probably try to do first is to
measure is whether there is any kind of bias or non-entropy in the
nanoseconds returned by CLOCK_REALTIME after calls to schedule().  If
they can find any kind of bias, they can use that to calculate what
kind of patterns or non-random bits might end up showing up after you
do your non-cryptographic mangling.

For that reasons, what I would suggest doing first is generate a
series of outputs of jitterentropy_get_nstime() followed by
schedule().  Look and see if there is any pattern.  That's the problem
with the FIPS 140-2 tests.  Passing those tests are necessary, but
*NOT* sufficient to prove that you have a good cryptographic
generator.  Even the tiniest amount of post-processing, even if they
aren't cryptographic, can result in an utterly predictable series of
numbers to pass the FIPS 140-2 tests.

Regards,

						- Ted
