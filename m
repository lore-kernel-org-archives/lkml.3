Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3IUVld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 17:41:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:35443 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3IUVlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 17:41:31 -0400
Date: Sat, 21 Sep 2013 17:41:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130921214118.GE8606@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130921212510.GD8606@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, just to give another example of the difference between the mixing
funtions, try compiling the following with and without ORIG_MIX defined...

	      		    	      	       - Ted

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/* #define ORIG_MIX */
#define ADD_ROTATE
#define DEBUG_POOL
#ifdef DEBUG_POOL
#define NUM_LOOPS 100
#else
#define NUM_LOOPS 1000000
#endif

typedef unsigned int __u32;

struct fast_pool {
	__u32		pool[4];
	unsigned long	last;
	unsigned short	count;
	unsigned char	rotate;
	unsigned char	last_timer_intr;
};

static __u32 const twist_table[8] = {
	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };

/**
 * rol32 - rotate a 32-bit value left
 * @word: value to rotate
 * @shift: bits to roll
 */
static inline __u32 rol32(__u32 word, unsigned int shift)
{
	return (word << shift) | (word >> (32 - shift));
}

#ifdef ORIG_MIX
/*
 * This is a fast mixing routine used by the interrupt randomness
 * collector.  It's hardcoded for an 128 bit pool and assumes that any
 * locks that might be needed are taken by the caller.
 */
static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
{
	const char	*bytes = in;
	__u32		w;
	unsigned	i = f->count;
	unsigned	input_rotate = f->rotate;

	while (nbytes--) {
		w = rol32(*bytes++, input_rotate & 31) ^ f->pool[i & 3] ^
			f->pool[(i + 1) & 3];
		f->pool[i & 3] = (w >> 3) ^ twist_table[w & 7];
		input_rotate += (i++ & 3) ? 7 : 14;
	}
	f->count = i;
	f->rotate = input_rotate;
}
#else
static void fast_mix(struct fast_pool *f, __u32 input[4])
{
	int i = f->count;
	__u32 acc, carry = f->pool[3] >> 25;
	unsigned	input_rotate = f->rotate;

	for (i = 0; i < 4; i++) {
#ifdef ADD_ROTATE
		acc = (f->pool[i] << 7) ^ rol32(input[i], input_rotate & 31) ^
			carry;
#else
		acc = (f->pool[i] << 7) ^ input[i] ^ carry;
#endif

		carry = f->pool[i] >> 25;
		f->pool[i] = acc;
		input_rotate += 7;
	}
	f->count++;
	f->rotate = input_rotate;
}
#endif

void print_pool(struct fast_pool *pool)
{
	int i;

	printf("pool:\n");
	for (i = 0; i < 4; i++) {
		printf("\t0x%08x\n", pool->pool[i]);
	}
}


int main(const char *argv, int argc)
{
	struct fast_pool pool;
	int i;
	unsigned int input[4];

	memset(&pool, 0, sizeof(struct fast_pool));
	memset(&input, 0, sizeof(input));
	pool.pool[0] = 1;

	for (i = 0; i < NUM_LOOPS; i++) {
#ifdef ORIG_MIX
		fast_mix(&pool, &input, sizeof(input));
#else
		fast_mix(&pool, input);
#endif
#ifdef DEBUG_POOL
		print_pool(&pool);
#endif
	}
#ifndef DEBUG_POOL
	print_pool(&pool);
#endif
	return 0;
}	
