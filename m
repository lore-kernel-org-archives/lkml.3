Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3BJMqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 07:46:23 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64966 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3BJMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 07:46:21 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
Message-ID: <5117969A.1080909@chronox.de>
Date: Sun, 10 Feb 2013 13:46:18 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Epler <jepler@unpythonic.net>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
References: <51157686.9000404@chronox.de> <20130209180629.GD8091@thunk.org> <20130210015751.GA13690@unpythonic.net>
In-Reply-To: <20130210015751.GA13690@unpythonic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2013 02:57:51, +0100, Jeff Epler <jepler@unpythonic.net> wrote:

Hi Jeff,
> On Sat, Feb 09, 2013 at 01:06:29PM -0500, Theodore Ts'o wrote:
>> For that reasons, what I would suggest doing first is generate a
>> series of outputs of jitterentropy_get_nstime() followed by
>> schedule().  Look and see if there is any pattern.  That's the problem
>> with the FIPS 140-2 tests.  Passing those tests are necessary, but
>> *NOT* sufficient to prove that you have a good cryptographic
>> generator.  Even the tiniest amount of post-processing, even if they
>> aren't cryptographic, can result in an utterly predictable series of
>> numbers to pass the FIPS 140-2 tests.
> In fact, Stephan's 'xor and shift a counter' design, even with zero
> input entropy (a counter incrementing at a constant rate), passes FIPS
> and a surprising fraction of dieharder tests (though some of the tests,
> such as diehard_count_1s_str, have this generator dead to rights); it
> also gives an ent entropy well in excess of 7.9999 bits per byte.  This
> means it's hard to be confident that the entropy measured by ent is
> coming from the input entropy as opposed to the (exceedingly
> minimal-seeming on the surface!) amount of mixing done by the
> xor-and-shift...

I am totally on your side that passing the tests is a necessary
prerequisite for a good RNG but by no means a proof that the RNG
produces entropy.

However, the CPU has timing jitter in the execution of instruction. And
I try to harvest that jitter. The good thing is that this jitter is
always present and can be harvested on demand.
>
> It appears the entropy counted is equal to the log2 of the difference
> between successive samples (minus one?), but even if you have a good
> argument why the ones bit is unpredictable it doesn't seem an argument
> that applies as strongly to the weight-128 bit.

Why are you mentioning 128 bit? The pool I try to fill is 64 bit and it
is filled with at least 16 * 9 clock measurements and an equal amount of
code in-between due to the schedule call.
>
> When the jitterrand loop runs 10 times, the LSB of that first loop has
> only gotten up to the 30th bit, so there are 20+ MSBs of the register
> that have not yet had bits rolled into them that are 'entropic' under
> the definition being used.

If you apply this argument to my suggested code, after executing the 16
loops in jitterentropy_cpu_jitter once, you rolled up to bit 48 (3 *
16). Now, you have at least 9 invocations of this loop of 16. This
implies you rolled over the pool buffer several times.
>
> Finally, in the 'turbid' random number generator
> (http://www.av8n.com/turbid/), the author develops a
> concept of hash saturation.  He concludes that if you have a noise
> source with a known (or assumed!) entropy and a has function that is
> well-distributed over N bits, you'd better put in M > N bits of entropy
> in order to be confident that the output register has N bits.  He
> appears to suggest adding around 10 extra bits of randomness, or 74 bits
> randomness for a 64-bit hash, relatively indepently of the size of the
> hash.  This design gathers only 64 bits if you trust the input entropy
> calculation, which according to the hash saturation calculation means
> that the output will only have about 63.2 bits of randomness per 64
> bits output.

I am not sure how that applies to the suggested code. The entropy source
just generates raw entropy without using a hash. The entropy then is
used to seed a DRNG. The so-called "strong DRNG" is initially seeded
with 48 bytes out of my entropy source. After generating 16 bytes of
output, it is reseeded with another 16 bytes of entropy. And after
reaching 1024 bits of output, it is also re-keyed.

Only the "regular DRNG" is reseeded after 1024 bytes of output and
rekeyed after 1MB of output.

Only those two DRNGs are supposed to be interface for a user to obtain
random data.

Note: reseeding and rekeying are not yet implemented in the kernel
crypto API, but can easily be added.

Thanks
Stephan

>
>
> Here's my 'absolutely zero entropy' version of the jitter random
> algorithm as I understand it:
>
> #include <stdint.h>
> #include <unistd.h>
>
> const uint64_t dt = 65309;
> uint64_t t, r;
>
> static inline uint64_t rol64(uint64_t word, unsigned int shift)
> {
>     return (word << shift) | (word >> (64 - shift));
> }
>
> uint64_t jitterrand() {
>     int i;
>     // each sample from the 'stuck counter' will be accounted as 7 bits of
>     // entropy, so 10 cycles to get >= 63 bits of randomness
>     for(i=0; i<10; i++) {
>         t += dt;
>         r = rol64(r ^ t, 3);
>     }
>     return r;
> }
>
> int main() {
>     while(1) {
>         uint64_t val = jitterrand();
>         ssize_t res = write(1, &val, sizeof(val));
>         if(res < 0) break;
>     }
>     return 0;
> }
>
> // Jeff

-- 
| Cui bono? |

