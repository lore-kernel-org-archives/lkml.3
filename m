Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947125Ab3BJCIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 21:08:24 -0500
Received: from dsl.unpythonic.net ([206.222.212.217]:35178 "EHLO
	unpythonic.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760896Ab3BJCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 21:08:23 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Feb 2013 21:08:23 EST
Date: Sat, 9 Feb 2013 19:57:51 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Message-ID: <20130210015751.GA13690@unpythonic.net>
References: <51157686.9000404@chronox.de>
 <20130209180629.GD8091@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130209180629.GD8091@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 01:06:29PM -0500, Theodore Ts'o wrote:
> For that reasons, what I would suggest doing first is generate a
> series of outputs of jitterentropy_get_nstime() followed by
> schedule().  Look and see if there is any pattern.  That's the problem
> with the FIPS 140-2 tests.  Passing those tests are necessary, but
> *NOT* sufficient to prove that you have a good cryptographic
> generator.  Even the tiniest amount of post-processing, even if they
> aren't cryptographic, can result in an utterly predictable series of
> numbers to pass the FIPS 140-2 tests.

In fact, Stephan's 'xor and shift a counter' design, even with zero
input entropy (a counter incrementing at a constant rate), passes FIPS
and a surprising fraction of dieharder tests (though some of the tests,
such as diehard_count_1s_str, have this generator dead to rights); it
also gives an ent entropy well in excess of 7.9999 bits per byte.  This
means it's hard to be confident that the entropy measured by ent is
coming from the input entropy as opposed to the (exceedingly
minimal-seeming on the surface!) amount of mixing done by the
xor-and-shift...

It appears the entropy counted is equal to the log2 of the difference
between successive samples (minus one?), but even if you have a good
argument why the ones bit is unpredictable it doesn't seem an argument
that applies as strongly to the weight-128 bit.

When the jitterrand loop runs 10 times, the LSB of that first loop has
only gotten up to the 30th bit, so there are 20+ MSBs of the register
that have not yet had bits rolled into them that are 'entropic' under
the definition being used.

Finally, in the 'turbid' random number generator
(http://www.av8n.com/turbid/), the author develops a
concept of hash saturation.  He concludes that if you have a noise
source with a known (or assumed!) entropy and a has function that is
well-distributed over N bits, you'd better put in M > N bits of entropy
in order to be confident that the output register has N bits.  He
appears to suggest adding around 10 extra bits of randomness, or 74 bits
randomness for a 64-bit hash, relatively indepently of the size of the
hash.  This design gathers only 64 bits if you trust the input entropy
calculation, which according to the hash saturation calculation means
that the output will only have about 63.2 bits of randomness per 64
bits output.


Here's my 'absolutely zero entropy' version of the jitter random
algorithm as I understand it:

#include <stdint.h>
#include <unistd.h>

const uint64_t dt = 65309;
uint64_t t, r;

static inline uint64_t rol64(uint64_t word, unsigned int shift)
{
    return (word << shift) | (word >> (64 - shift));
}

uint64_t jitterrand() {
    int i;
    // each sample from the 'stuck counter' will be accounted as 7 bits of
    // entropy, so 10 cycles to get >= 63 bits of randomness
    for(i=0; i<10; i++) {
        t += dt;
        r = rol64(r ^ t, 3);
    }
    return r;
}

int main() {
    while(1) {
        uint64_t val = jitterrand();
        ssize_t res = write(1, &val, sizeof(val));
        if(res < 0) break;
    }
    return 0;
}

// Jeff
