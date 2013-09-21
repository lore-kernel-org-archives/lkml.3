Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3IUVca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 17:32:30 -0400
Received: from imap.thunk.org ([74.207.234.97]:35432 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab3IUVc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 17:32:28 -0400
Date: Sat, 21 Sep 2013 17:25:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130921212510.GD8606@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130916154026.GA23345@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:40:27AM -0400, Jörn Engel wrote:
> 
> Here is a patch to make add_interrupt_randomness() significantly
> cheaper without significantly impacting the quality.  The second part
> is my personal opinion and others might disagree.
> 
> So far this has only seen userspace performance testing, so don't
> merge it in a hurry.

Performance testing, but your new fast_mix pool has some serious
problems in terms of how well it works.

First of all, I think this is a typo:

> +	for (i = 0; i < 3; i++) {

This means that pool[3] is always 0, and the input[3] is never mixed
in.  Hence, the pool is now only 96 bits instead of 128 bits, and the
last 4 bytes of the input pool are not getting mixed in.

Secondly, if you change this so that we actually use the whole pool,
and you mix in a constant set of inputs like this:

	for (i = 0; i < 100; i++) {
		input[0] = i;
		input[1] = i;
		input[2] = i;
		input[3] = i;
		fast_mix(&pool, input);
		print_pool(&pool);
	}

you see something like this:

pool:
        0x00000000
        0x00000000
        0x00000000
        0x00000000
pool:
        0x00000001
        0x00000001
        0x00000001
        0x00000001
pool:
        0x00000082
        0x00000082
        0x00000082
        0x00000082
pool:
        0x00004103
        0x00004103
        0x00004103
        0x00004103
pool:
        0x00208184
        0x00208184
        0x00208184
        0x00208184
pool:
        0x1040c205
        0x1040c205
        0x1040c205
        0x1040c205

Granted, it's unlikely that we will be mixing numbers like this, but
it's a great demonstration of why I added the input_rotate aspect to
my mixing functions.

See my testing program below.  I need to think a bit more about
whether I'm comfortable with the new fast_mix that you've proposed
with the input_rotate restored, but at the minimum I think the rotate
is needed.

Regards,

						- Ted


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/* #define ORIG_MIX */
#define ADD_ROTATE
/* #define DEBUG_POOL */
#ifdef DEBUG_POOL
#define NUM_LOOPS 32
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
	srandom(42);

	for (i = 0; i < NUM_LOOPS; i++) {
		input[0] = i;
		input[1] = i;
		input[2] = i;
		input[3] = i;
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




