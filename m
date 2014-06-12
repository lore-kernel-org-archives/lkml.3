Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaFLAcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:32:53 -0400
Received: from ns.horizon.com ([71.41.210.147]:14523 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753016AbaFLAcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:32:50 -0400
Date: 11 Jun 2014 20:32:49 -0400
Message-ID: <20140612003249.13680.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140611163818.GD27151@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... but how did you measure the "2/3 the time"?  I've done some
> measurements, using both "time calling fast_mix() and fast_mix2() N
> times and divide by N (where N needs to be quite large).  Using that
> metric, fast_mix2() takes seven times as long to run.

Wow, *massively* different results.  Using a large iteration count,
it's defintiely faster.  Here's with 1,000,000 iterations:

# ./perftest ./random
pool 1 = 6b469698 596ceb8f 70536d2d e262b8ed
pool 2 = 72e2554d fd20e020 a51baf43 19472f63
 0:   40587696   19952756 (-20634940)
 1:   40569444   19986700 (-20582744)
 2:   40529396   19983108 (-20546288)
 3:   40492468   19959528 (-20532940)
 4:   40461808   19977316 (-20484492)
 5:   40421980   19977436 (-20444544)
 6:   40495440   19959904 (-20535536)
 7:   40436676   19975400 (-20461276)
 8:   40454912   19971360 (-20483552)
 9:   40463260   19957324 (-20505936)

Here's with 1 iteration (which you're very right, I failed to test,
and instruction counts matter more when code is not hot in cache)

# ./perftest ./random
pool 1 = 85670974 e96b1f8f 51244abf 5863283f
pool 2 = 03564c6c eba81d03 55c77fa1 760374a7
 0:         76         84 (+8)
 1:         36         36 (+0)
 2:         32         36 (+4)
 3:         32         40 (+8)
 4:         28         40 (+12)
 5:         32         36 (+4)
 6:         32         36 (+4)
 7:         28         40 (+12)
 8:         32         40 (+8)
 9:         28         40 (+12)

Comparable, but slightly slower.  Clearly, I need to do better.
And you can see the first-iteration effects clearly.  Still,
noting *remotely* like 7x!

That seems crazy, as the overall operation counts are
not that dissimilar.


Here's the "perftest" shell wrapper:
#!/bin/sh

old="`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`"

for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
	echo performance > $i
done

"$@"

for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
	echo "$old" > $i
done


And "random.c" is appended.  Apologies for the comemnts and #ifdefs
I used while experimenting; I wanted to give you *exactly* what
I'm running.  Do you see a bug in it anywhere?

I know P4s have slow rotates, so the larger number of them compared
to shifts in the original will definitely cause a hit.  But neither
of us are using that.

Compile line and platform:
cc -W -Wall -m64 -O -march=native    random.c   -o random
model name      : Intel(R) Core(TM) i7-4930K CPU @ 3.40GHz




#include <stdint.h>
typedef uint32_t u32;

static u32 const twist_table[8] = {
	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };

struct fast_pool {
	u32		pool[4];
	unsigned long	last;
	unsigned short	count;
	unsigned char	rotate;
	unsigned char	last_timer_intr;
};

static inline u32 rol32(u32 word, unsigned int shift)
{
        return (word << shift) | (word >> (32 - shift));
}


/*
 * This is a fast mixing routine used by the interrupt randomness
 * collector.  It's hardcoded for an 128 bit pool and assumes that any
 * locks that might be needed are taken by the caller.
 */
void fast_mix(struct fast_pool *f, u32 const input[4])
{
	u32		w;
	unsigned	input_rotate = f->rotate;

	w = rol32(input[0], input_rotate) ^ f->pool[0] ^ f->pool[3];
	f->pool[0] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 14) & 31;
	w = rol32(input[1], input_rotate) ^ f->pool[1] ^ f->pool[0];
	f->pool[1] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;
	w = rol32(input[2], input_rotate) ^ f->pool[2] ^ f->pool[1];
	f->pool[2] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;
	w = rol32(input[3], input_rotate) ^ f->pool[3] ^ f->pool[2];
	f->pool[3] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;

	f->rotate = input_rotate;
	f->count++;
}

void fast_mix2(struct fast_pool *f, u32 const input[4])
{
	/* Copy pool to registers */
	u32 a = f->pool[0] ^ input[0];
	u32 b = f->pool[1] ^ input[1];
	u32 c = f->pool[2] ^ input[2];
	u32 d = f->pool[3] ^ input[3];
#if 1
	int i;

	for (i = 0; i < 2; i++) {
		/*
		 * Inspired by ChaCha QuarterRound, but
		 * modified for much greater parallelism.
		 */
                a += b;			c += d;
                d ^= a;			b ^= c;
//		a = rol32(a, 24);	c = rol32(c, 5);
		a = rol32(a, 27);	c = rol32(c, 7);
//		d = rol32(d, 27);	b = rol32(b, 7);

                a += b;			c += d;
                d ^= a;			b ^= c;
		a = rol32(a, 17);	c = rol32(c, 11);
//		d = rol32(d, 17);	b = rol32(b, 11);
#if 0
                a += b;			c += d;
                d ^= a;			b ^= c;
		a = rol32(a, 24);	c = rol32(c, 5);
#endif
	}
	f->pool[0] = a;
	f->pool[1] = b;
	f->pool[2] = c;
	f->pool[3] = d;
#elif 1

	a ^= a<<15; a ^= a>>4 ^ d ^ d>>21; f->pool[0] = a;
	b ^= b<<15; b ^= b>>4 ^ a ^ a>>21; f->pool[1] = b;
	c ^= c<<15; c ^= c>>4 ^ b ^ b>>21; f->pool[2] = c;
	d ^= d<<15; d ^= d>>4 ^ c ^ c>>21; f->pool[3] = d;
#else
	f->pool[0] = a ^= a<<20 ^ b ^ b>>11 ^ c ^ c<<27 ^ d ^ d >> 6;
	f->pool[1] = b ^= b<<20 ^ c ^ c>>11 ^ d ^ d<<27 ^ a ^ a >> 6;
	f->pool[2] = c ^= c<<20 ^ d ^ d>>11 ^ a ^ a<<27 ^ b ^ b >> 6;
	f->pool[3] = d ^= d<<20 ^ a ^ a>>11 ^ b ^ b<<27 ^ c ^ c >> 6;
#endif

	f->count++;
}

static uint64_t
rdtsc(void)
{
	uint32_t low, high;
	__asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high));
	return ((uint64_t)high  << 32) | low;
}

#include <stdio.h>
#include <stdlib.h>

#define ITER 1
#define N 10

int
main(void)
{
	struct fast_pool fp1 = {
		.pool = {0},
		.count = 0,
		.rotate = 0
	};
	struct fast_pool fp2 = {
		.pool = {0},
		.count = 0
	};
	uint32_t times[N][2];
	int i, j;

	for (i = 0; i < N; i++) {
		uint64_t t1, t2, t3;
		uint32_t data[4];

		for (j = 0; j < 4; j++)
			data[j] = random();

		t1 = rdtsc();
		for (j = 0; j < ITER; j++)
			fast_mix(&fp1, data);
		t2 = rdtsc();
		for (j = 0; j < ITER; j++)
			fast_mix2(&fp2, data);
		t3 = rdtsc();
		times[i][0] = t2 - t1;
		times[i][1] = t3 - t2;
	}
	printf("pool 1 = %08x %08x %08x %08x\n", fp1.pool[0],
		fp1.pool[1], fp1.pool[2], fp1.pool[3]);
	printf("pool 2 = %08x %08x %08x %08x\n", fp2.pool[0],
		fp2.pool[1], fp2.pool[2], fp2.pool[3]);

	for (i = 0; i < N; i++)
		printf("%2d: %10u %10u (%+d)\n",
			i, times[i][0], times[i][1],
			(int)(times[i][1] - times[i][0]));
	return 0;
}
