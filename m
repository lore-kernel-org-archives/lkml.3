Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaFOBRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 21:17:21 -0400
Received: from imap.thunk.org ([74.207.234.97]:39280 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaFOBRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 21:17:20 -0400
Date: Sat, 14 Jun 2014 21:17:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140615011713.GK6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140614163334.GJ6447@thunk.org>
 <20140615002333.24750.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615002333.24750.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 08:23:33PM -0400, George Spelvin wrote:
> The example I posted:
> 
> // (29/66353) score = 49/121/123:  6 27 16 14
> 
> 	a += b;			c += d;
> 	b = rol32(a, 6);	d = rol32(c, 27);
> 	d ^= a;			b ^= c;
> 
> 	a += b;			c += d;
> 	b = rol32(a, 16);	d = rol32(c, 14);
> 	d ^= a;			b ^= c;
> 
> has, after 2 rounds, a minimum avalanche of 49 bits, taken over all of
> the variables just mentioned.  The only thing maximized over is the
> different starting values.

I'm seeing a minimum delta of 40 bits, actually.  Which makes it
slightly better than your original fast_mix2 (which had a minimum
delta of 39) when using 1024 random samples using random(3) to
generate a starting pool and setting a single bit in each possible bit
position in the input array.  So it's slightly better, and as I
mentioned, on my CPU, I'm really not seeing that much difference
between fast_mix2() and fast_mix3().

But I'm willing to go with this as being quite sufficient as a mixing
function.

						- Ted

(Compile the following with -DANALYZE to see the analysis I did.)

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

typedef unsigned int __u32;
typedef unsigned long long __u64;

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

static inline __u64 rol64(__u64 word, unsigned int shift)
{
	return (word << shift) | (word >> (64 - shift));
}

static __u32 const twist_table[8] = {
	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };

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

extern void fast_mix2(struct fast_pool *f, __u32 const input[4])
{
	__u32 a = f->pool[0] ^ input[0],  b = f->pool[1] ^ input[1];
	__u32 c = f->pool[2] ^ input[2],  d = f->pool[3] ^ input[3];
	int i;

	for (i = 0; i < 2; i++) {
		/*
		 * Inspired by ChaCha's QuarterRound, but
		 * modified for much greater parallelism.
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

extern void fast_mix3(struct fast_pool *f, __u32 const input[4])
{
	__u32 a = f->pool[0] ^ input[0],  b = f->pool[1] ^ input[1];
	__u32 c = f->pool[2] ^ input[2],  d = f->pool[3] ^ input[3];
	int i;


	for (i = 0; i < 2; i++) {
		a += b;                 c += d;
		a = rol32(a, 6);	c = rol32(c, 27);
		d ^= a;                 b ^= c;

		a += b;                 c += d;
		a = rol32(a, 16);	c = rol32(c, 14);
		d ^= a;                 b ^= c;
	}
	f->pool[0] = a;  f->pool[1] = b;
	f->pool[2] = c;  f->pool[3] = d;
	f->count++;
}

extern void fast_mix4(struct fast_pool *f, __u32 const input[4])
{
	__u64 a = ((__u64 *)f->pool)[0] ^ ((__u64 const *)input)[0];
	__u64 b = ((__u64 *)f->pool)[1] ^ ((__u64 const *)input)[1];
	int i;

	for (i = 0; i < 2; i++) {
		a += b; b = rol64(b, 52);
		b ^= a; a = rol64(a, 10);
		a += b; b = rol64(b, 47);
		b ^= a; a = rol64(a, 17);
	}

	((__u64 *)f->pool)[0] = a;
	((__u64 *)f->pool)[1] = b;
	f->count++;
}

static void rotate(__u32 a[4])
{
	int i;
	int carry = 0;
	__u32 tmp;

	for (i=0; i < 4; i++) {
		tmp = a[i];
		a[i] = (tmp << 1) + carry;
		carry = (tmp & 0x80000000) ? 1 : 0;
	}
	if (carry)
		a[0]++;
}

int global_min = 9999;

void analyze(void)
{
	struct fast_pool f;
	int i, pc;
	int sum = 0, max = 0, min=9999;
	__u32 input[4];
	__u32 start[4];

	start[0] = random();
	start[1] = random();
	start[2] = random();
	start[3] = random();
	memset(&f, 0, sizeof(f));
	memset(&input, 0, sizeof(input));
	input[0] = 1;

	for (i=0; i < 32; i++) {
		memcpy(f.pool, start, sizeof(start));
		fast_mix3(&f, input);
		pc = (__builtin_popcount(f.pool[0] ^ start[0]) + 
		      __builtin_popcount(f.pool[1] ^ start[1]) + 
		      __builtin_popcount(f.pool[2] ^ start[2]) + 
		      __builtin_popcount(f.pool[3] ^ start[3]));
		sum += pc;
		if (pc > max)
			max = pc;
		if (pc < min)
			min = pc;
		if (pc < global_min)
			global_min = pc;
		rotate(input);
//		printf("%d ", pc);
	}
//	printf("\n");
//	printf("average popcount: %d, max: %d min %d\n", sum / 128, max, min);
}

static __inline__ unsigned long long rdtsc(void)
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

#ifdef ANALYZE
	for (i=0; i < 1024; i++)
		analyze();
	printf("Global minimum: %d\n", global_min);
	return 0;
#endif

#if !defined(BENCH_FASTMIX) && !defined(BENCH_FASTMIX2)
	for (i=0; i < 20; i++) {
		usleep(50000);
		start_time = rdtsc();
		fast_mix2(&f, input);
		end_time = rdtsc();
		printf("fast_mix2: %llu\t", end_time - start_time);
#if 0
		usleep(50000);
		start_time = rdtsc();
		fast_mix2(&f, input);
		end_time = rdtsc();
		printf("fast_mix2: %llu\t", end_time - start_time);
		usleep(50000);
		start_time = rdtsc();
		fast_mix3(&f, input);
		end_time = rdtsc();
		printf("fast_mix3: %llu\t", end_time - start_time);
#endif
		fputc('\n', stdout);
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

	return 0;
}
