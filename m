Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaFOG6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:58:10 -0400
Received: from ns.horizon.com ([71.41.210.147]:11058 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750834AbaFOG6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:58:08 -0400
Date: 15 Jun 2014 02:58:03 -0400
Message-ID: <20140615065803.6175.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140615011713.GK6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, could you hold off merging that for a bit?  Or if you really
want to, add a comment that the rotate constants are preliminary and
will be further optimized.

I posted that as WIP, just as evidence that something with better
avalanche could be as fast or faster, and I'd like to go back and do a
careful re-check of the analysis software, then do an exhaustive search
for good rotate constants (there are only 1M possibilities, after all).

I believe the basic structure is solid, and you appear to be persuaded
too, but this is an area littered with embarrassing failures by
cryptographic amateurs and I'd like to be *very* careful before attaching
my S-o-b to it.

Also, credit for inspiration and the analysis techniques: Bob
Jenkins.  I actually started with his analysis software for SpookyHash
(http://www.burtleburtle.net/bob/hash/spooky.html) and then converted
it back to "block function" form.

Appended is the software I'm using.  It began life as
http://www.burtleburtle.net/bob/c/screen.cpp but was translated into
plain C and heavily hacked up.  It's not pretty, but youuld you either
look at it for mistakes or tell me to pretty it up so you can look at it?


The one thing I notice is that your analyze() function is measuring
something totally different than what I'm measuring.

Considering fast_mix as a 128->128 bit function (i.e. ignoring
the input XOR), you appear to be considering
popcount(input[] ^ output[]), and then *minimizing* over a
variety of inputs.

I'm doing basically the following:

	min_score = 128
	for (each 1- or 2-bit delta[]) {
		avalanche[] = 0
		for (5 random arrays input[]) {
			output1[] = fast_mix3(input[])
			output2[] = fast_mix3(input[] ^ delta[])
			avalanche[] |= output1[] ^ output2[]
		}
		score = popcount(avalanche[])
		min_score = min(score, min_score)
	}

For each input delta, consider several random inputs and find
all of the output bits that that input delta can cause to toggle.

The addition carries make the operation non-linear and so the output
delta depends on the input state.  I'm interested in all the bits that
can *possibly* be toggled.

Bob's code considers output deltas other than xor (minimizing over
all of theose), and both forward and reverse mixing functions.

One of the deltas considered is ~(output1[] ^ output2[]), the set of bits
sometimes *not* toggled by an input delta.   If an input delta
*always* changes most of the bits, that's not as interesting either.
(Simple parity and replication can do that.)

More discussion of his analysis ideas here:
http://www.burtleburtle.net/bob/hash/avalanche.html
http://www.burtleburtle.net/bob/hash/evahash.html


The following rotate constants achieve 57 bits of avalanche after
2 iterations:
// (91/238891) score(4/5/6) = 57/87/116: 26 14 19  9
// (113/269149) score(4/5/6) = 57/84/115: 28 29 20  8
// (118/277648) score(4/5/6) = 57/89/121:  4 27  9 24
// (179/462783) score(4/5/6) = 57/93/117: 11 27 14 22

This one does 58 bits after 2 iteration, but later scores (for 2.5
and 3 iterations) are a bit low:
// (191/488173) score(4/5/6) = 58/78/113:  9 23  8 15

This one has high scores for 2, 2.5 and 3 iterations:
// (22/48296) score(4/5/6) = 56/98/122:  8 10 22 15

I might go with that one pending further work (like a proper
exhaustive search; the current code is random).


I'm also experimenting to see if swapping + for - helps, e.g.:
	a ^= b;		c ^= d;
	b = Rotl(b, K1); d = Rotl(d, K2);
	d += a;		b -= c;
	a ^= b;		c ^= d;
	b = Rotl(b, K3); d = Rotl(d, K4);
	d += a;		b -= c;

That has rotate sets like
// (13/484210) score(4/5/6) = 57/90/118:  6 25 16 21
// (14/490774) score(4/5/6) = 56/99/122: 25  9 19  7
// (23/804540) score(4/5/6) = 56/98/122: 17 20 10  4
// (35/1014495) score(4/5/6) = 57/94/119:  7 27  4 20
// (46/1254928) score(4/5/6) = 56/100/120: 20 18  5 10
// (47/1260723) score(4/5/6) = 56/97/120: 13 22  8  5
// (62/1627276) score(4/5/6) = 57/94/120:  6  5 10 20
// (74/1943366) score(4/5/6) = 58/92/121: 12 11 18 26
// (77/2097408) score(4/5/6) = 57/96/119: 19 18  5 11




(The following code was recently hacked up to operate in "half-iterations"
where not every rotate constant is used an equal number of times.
You'll still see residue of the old semantics in places.)

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <assert.h>

#if 1
#define BITS 32
typedef uint32_t word_t;
#define Count(x) __builtin_popcount(x)

#else
#define BITS 64
typedef uint64_t word_t;
#define Count(x) __builtin_popcountll(x)

#endif

static word_t Rotl(word_t x, int k)
{
	return (x << k) | (x >> (BITS-k));
}

static word_t Rotr(word_t x, int k)
{
	return (x << (BITS-k)) | (x >> k);
}

static uint64_t Rotl64(uint64_t x, int k)
{
	return (x << k) | (x >> (64 - k));
}


//
// try to find an adequate long-message mixing function for SpookyHash
//

struct Random {
	uint64_t a, b, c, d;
};

static uint64_t RandValue(struct Random *r)
{
	uint64_t e = r->a - Rotl64(r->b, 23);
	r->a = r->b ^ Rotl64(r->c, 16);
	r->b = r->c + Rotl64(r->d, 11);
	r->c = r->d + e;
	return r->d = e + r->a;
}

static void RandInit(struct Random *r, uint64_t seed)
{
	int i;

	r->a = 0xdeadbeef; 
        r->b = r->c = r->d = seed;
        for (i = 0; i < 20; ++i) 
		(void)RandValue(r);
}

#define VARS 4
#define ROTS 4

struct Sieve {
	int sh[ROTS];
	struct Random r;
};

void
SieveInit(struct Sieve *s, int seed)
{
	RandInit(&s->r, seed);
}

void
SievePrint(struct Sieve const *s, FILE *f)
{
	int i;

	for (i = 0; i < ROTS; i++)
		fprintf(f, " %2d", s->sh[i]);
	putc('\n', f);
}

// generate a new function at random
static void SieveGenerate(struct Sieve *s)
{
	uint64_t v = RandValue(&s->r);
	int i;

	/* Fill in the shift amounts */
	for (i = 0; i < ROTS; i++) {
		s->sh[i] = v % BITS;
		v /= BITS;
	}
}

#if 1
/* Quick option */
#define DO_ROT(a, b, s) (a = Rotl(a, s))
#else
#define DO_ROT(a, b, s) (b = Rotl(b, s))
#endif

#if VARS == 4
// evaluate the function
static void
Fun(int const sh[VARS], word_t state[VARS], int iter)
{
	int i;
	word_t a = state[0];
	word_t b = state[1];
	word_t c = state[2];
	word_t d = state[3];

	for (i = 0; i < 2*iter; i += 2)  {
#if 1
		a ^= b;             c ^= d;
		b = Rotl(b, sh[i%ROTS]); d = Rotl(d, sh[(i+1)%ROTS]);
		d += a;             b += c;
#elif 1
		a += b;		c += d;		d = Rotl(d, sh[i%ROTS]);
		d ^= a;		b ^= c;		c = Rotl(c, sh[(i+1)%ROTS]);
#elif 1
		a += b; b ^= c; c -= d; d = Rotl(d, sh[i%ROTS]);
		c += d; d ^= a; a -= b; b = Rotl(b, sh[(i+1)%ROTS]);
#else
		a += b; c += d; d = Rotl(d, sh[i%ROTS]);
		d ^= a; b ^= c; c = Rotl(c, sh[(2*i+1)%ROTS1]);
#endif
	}

	state[0] = a;
	state[1] = b;
	state[2] = c;
	state[3] = d;
}

static void
RFun(int const sh[VARS], word_t state[VARS], int iter)
{
	int i;
	word_t a = state[0];
	word_t b = state[1];
	word_t c = state[2];
	word_t d = state[3];

	while (iter) {
		i = 2 * --iter;
#if 1
		d -= a;			b -= c;
		b = Rotr(b, sh[i%ROTS]); d = Rotr(d, sh[(i+1)%ROTS]);
		a ^= b;			c ^= d;
#elif 1
		c -= d; d ^= a; a += b; b = Rotr(b, sh[(i+1) % ROTS]);
		a -= b; b ^= c; c += d; d = Rotr(d, sh[i % ROTS]);
#else
		d ^= a; b ^= c; a = Rotr(a, sh[(i+1)%ROTS]);
		a -= b; c -= d; b = Rotr(b, sh[i%ROTS]);
#endif
	}

	state[0] = a;
	state[1] = b;
	state[2] = c;
	state[3] = d;
}
#elif VARS == 2
// evaluate the function
static void
Fun(int const sh[VARS], word_t state[VARS], int iter)
{
	int i;
	word_t a = state[0];
	word_t b = state[1];

	for (i = 0; i < iter; i++) {
		a += b;	b = Rotl(b, sh[0]);
		b ^= a;	a = Rotl(a, sh[1]);
#if ROTS > 2
		a += b;	b = Rotl(b, sh[2]);
		b ^= a;	a = Rotl(a, sh[3]);
#endif
	}

	state[0] = a;
	state[1] = b;
}

static void
RFun(int const sh[VARS], word_t state[VARS], int iter)
{
	int i;
	word_t a = state[0];
	word_t b = state[1];

	for (i = 0; i < iter; i++) {
		a = Rotr(a, sh[3]);	b ^= a;
		b = Rotr(b, sh[2]);	a -= b;
#if ROTS > 2
		a = Rotr(a, sh[1]);	b ^= a;
		b = Rotr(b, sh[0]);	a -= b;
#endif
	}
	state[0] = a;
	state[1] = b;
}
#endif

#define TRIALS 8
#define MEASURES 10

static int
OneTest(struct Sieve *s, bool forward, int limit, int iter)
{
    int minVal = VARS*BITS;
    int i, j, k, l;

    for (i = 0; i < VARS*BITS; i++) {
	for (j = i; j < VARS*BITS; j++) {
	    word_t total[MEASURES][VARS] = { { 0 } };

	    for (k = 0; k < TRIALS; k++) {
		word_t a[VARS], b[VARS];

		for (l = 0; l < VARS; l++)
		    b[l] = a[l] = RandValue(&s->r);
		/* Alter the second one */
		b[i/BITS] ^= (word_t)1 << (i % BITS);
		if (i != j)
		    b[j/BITS] ^= (word_t)1 << (j % BITS);
		/* Run the function */
		if (forward) {
		    Fun(s->sh, a, iter);
		    Fun(s->sh, b, iter);
		} else {
		    RFun(s->sh, a, iter);
		    RFun(s->sh, b, iter);
		}
		/* Now compute differences */
		for (l = 0; l < VARS; l++) {
		    word_t t;

		    total[0][l] |= a[l]; total[5][l] |= ~a[l];
		    total[1][l] |= b[l]; total[6][l] |= ~b[l];

		    t = a[l] ^ b[l];
		    total[2][l] |= t; total[7][l] |= ~t;

		    t = a[l] - b[l];
		    t ^= t >> 1;	/* Gray-code it */
		    total[3][l] |= t; total[8][l] |= ~t;

		    t = a[l] + b[l];
		    t ^= t >> 1;	/* Gray-code it */
		    total[4][l] |= t; total[9][l] |= ~t;
		}
	    }
	    /* Find minimum weight by all measures */
	    for (k = 0; k < MEASURES; k++) {
		int counter = 0;
		for (l = 0; l < VARS; l++)
		    counter += Count(total[k][l]);
		if (counter < minVal) {
		    minVal = counter;
		    if (counter < limit)
			return counter;
		}
	    }
	} /* j = second bit */
    } /* i = first bit */

    return minVal;
}

static int
TwoTest(struct Sieve *s, int limit, int iter)
{
	int score1, score2;
	word_t a[VARS], b[VARS];
	int i;

	/* Quick sanity test */
	for (i = 0; i <= iter; i++) {
		int j;
		for (j = 0; j < VARS; j++)
		    b[j] = a[j] = RandValue(&s->r);
		Fun(s->sh, a, i);
		RFun(s->sh, a, i);
		for (j = 0; j < VARS; j++)
		    assert(a[j] == b[j]);
		RFun(s->sh, a, i);
		Fun(s->sh, a, i);
		for (j = 0; j < VARS; j++)
		    assert(a[j] == b[j]);
	}

	score1 = OneTest(s, true, limit, iter);
	if (score1 < limit)
		return score1;
	score2 = OneTest(s, false, limit, iter);

	return score1 < score2 ? score1 : score2;
}

static void
driver(int seed, FILE *f, unsigned n, int iter, int limit, int limit2)
{
	unsigned i, found = 0;
	struct Sieve s;
	int best = 0;

	SieveInit(&s, seed);

	for (i = 0; found < n; i++) {
		int score0, score, score2;

		if (i % 1000 == 0) {
			printf("%u\r", i);
			fflush(stdout);
		}

		SieveGenerate(&s);
		
		score0 = TwoTest(&s, limit, iter-1);
		if (score0 < limit)
			continue;
		score = TwoTest(&s, limit2, iter);
		if (score < limit2)
			continue;
		if (score > best)
			best = score;

		score2 = TwoTest(&s, 0, iter+1);
		fprintf(f, "// (%u/%u) score(%d/%d/%d) = %d/%d/%d:", found,
			i, iter-1, iter, iter+1, score0, score, score2);
		SievePrint(&s, f);
		found++;
	}
	printf("Best score: %d\n", best);
}

int
main(void)
{
//	driver(21, stdout, 200, 6, 108);
//	driver(21, stdout, 200, 5, 70);
//	driver(21, stdout, 200, 2, 42);
	driver(21, stdout, 200, 5, 45, 70);
//	driver(21, stdout, 200, 4, 72, 90);
	return 0;
}
