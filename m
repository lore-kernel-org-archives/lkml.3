Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaFLDW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:22:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:34576 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaFLDWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:22:55 -0400
Date: Wed, 11 Jun 2014 23:22:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
Message-ID: <20140612032248.GA2437@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140611163818.GD27151@thunk.org>
 <20140612003249.13680.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612003249.13680.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 08:32:49PM -0400, George Spelvin wrote:
> Comparable, but slightly slower.  Clearly, I need to do better.
> And you can see the first-iteration effects clearly.  Still,
> noting *remotely* like 7x!

I redid my numbers, and I can no longer reproduce the 7x slowdown.  I
do see that if you compile w/o -O2, fast_mix2 is twice as slow.  But
it's not 7x slower.

When compiling w/o -O2:

     	       fast_mix		fast_mix2
task-clock     221.3 ms 	460.7 ms

When compiling with -O2 -Os:

     	       fast_mix		fast_mix2
task-clock     115.4 ms		71.5 ms

And here's the numbers I got with a single iteration using rdtsc:

fast_mix: 164		fast_mix2: 237
fast_mix: 168		fast_mix2: 230
fast_mix: 166		fast_mix2: 228
fast_mix: 164		fast_mix2: 230
fast_mix: 166		fast_mix2: 230
fast_mix: 168		fast_mix2: 232
fast_mix: 166		fast_mix2: 228
fast_mix: 164		fast_mix2: 228
fast_mix: 166		fast_mix2: 234
fast_mix: 166		fast_mix2: 230

						- Ted


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

typedef unsigned int __u32;

struct fast_pool {
	__u32		pool[4];
	unsigned long	last;
	unsigned short	count;
	unsigned char	rotate;
	unsigned char	last_timer_intr;
};


/**
 * rol32 - rotate a 32-bit value left
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u32 rol32(__u32 word, unsigned int shift)
{
	return (word << shift) | (word >> (32 - shift));
}

static __u32 const twist_table[8] = {
	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };

/*
 * This is a fast mixing routine used by the interrupt randomness
 * collector.  It's hardcoded for an 128 bit pool and assumes that any
 * locks that might be needed are taken by the caller.
 */
extern void fast_mix(struct fast_pool *f, __u32 input[4])
{
	__u32		w;
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

extern fast_mix2(struct fast_pool *f, __u32 const input[4])
{
	__u32 a = f->pool[0] ^ input[0],  b = f->pool[1] ^ input[1];
	__u32 c = f->pool[2] ^ input[2],  d = f->pool[3] ^ input[3];
	int i;


	for (i = 0; i < 3; i++) {
		/*
		 * Inspired by ChaCha's QuarterRound, but
		 * modified for much greater parallelism.
		 * Surprisingly, rotating a and c seems to work
		 * better than b and d.  And it runs faster.
		 */
		a += b;                 c += d;
		d ^= a;                 b ^= c;
		a = rol32(a, 15);       c = rol32(c, 21);

		a += b;                 c += d;
		d ^= a;                 b ^= c;
		a = rol32(a, 3);	c = rol32(c, 7);
	}
	f->pool[0] = a;  f->pool[1] = b;
	f->pool[2] = c;  f->pool[3] = d;
	f->count++;
}

static __inline__ volatile unsigned long long rdtsc(void)
{
  unsigned long long int x;
     __asm__ volatile (".byte 0x0f, 0x31" : "=A" (x));
     return x;
}

int main(int argc, char **argv)
{
	struct fast_pool f;
	int i;
	__u32 input[4];
	unsigned volatile long long start_time, end_time;

	memset(&f, 0, sizeof(f));
	memset(&input, 0, sizeof(input));
	f.pool[0] = 1;

#if !defined(BENCH_FASTMIX) && !defined(BENCH_FASTMIX2)
	for (i=0; i < 10; i++) {
		usleep(50000);
		start_time = rdtsc();
		fast_mix(&f, input);
		end_time = rdtsc();
		printf("fast_mix: %llu\t", end_time - start_time);
		usleep(50000);
		start_time = rdtsc();
		fast_mix2(&f, input);
		end_time = rdtsc();
		printf("fast_mix2: %llu\n", end_time - start_time);
	}
	
#endif

#ifdef BENCH_FASTMIX
	for (i=0; i < 10240000; i++) {
		fast_mix(&f, input);
	}
#endif

#ifdef BENCH_FASTMIX2
	for (i=0; i < 10240000; i++) {
		fast_mix2(&f, input);
	}
#endif
}
