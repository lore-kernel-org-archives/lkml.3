Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3IVVdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:33:20 -0400
Received: from longford.logfs.org ([213.229.74.203]:57927 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3IVVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:33:09 -0400
Date: Sun, 22 Sep 2013 16:14:36 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130922201436.GA4584@logfs.org>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130921212510.GD8606@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 September 2013 17:25:10 -0400, Theodore Ts'o wrote:
> On Mon, Sep 16, 2013 at 11:40:27AM -0400, Jörn Engel wrote:
> > 
> > Here is a patch to make add_interrupt_randomness() significantly
> > cheaper without significantly impacting the quality.  The second part
> > is my personal opinion and others might disagree.
> > 
> > So far this has only seen userspace performance testing, so don't
> > merge it in a hurry.
> 
> Performance testing, but your new fast_mix pool has some serious
> problems in terms of how well it works.
> 
> First of all, I think this is a typo:
> 
> > +	for (i = 0; i < 3; i++) {
> 
> This means that pool[3] is always 0, and the input[3] is never mixed
> in.  Hence, the pool is now only 96 bits instead of 128 bits, and the
> last 4 bytes of the input pool are not getting mixed in.

Yes, indeed.

> Secondly, if you change this so that we actually use the whole pool,
> and you mix in a constant set of inputs like this:
> 
> 	for (i = 0; i < 100; i++) {
> 		input[0] = i;
> 		input[1] = i;
> 		input[2] = i;
> 		input[3] = i;
> 		fast_mix(&pool, input);
> 		print_pool(&pool);
> 	}
> 
> you see something like this:
> 
> pool:
>         0x00000000
>         0x00000000
>         0x00000000
>         0x00000000
> pool:
>         0x00000001
>         0x00000001
>         0x00000001
>         0x00000001
> pool:
>         0x00000082
>         0x00000082
>         0x00000082
>         0x00000082
> pool:
>         0x00004103
>         0x00004103
>         0x00004103
>         0x00004103
> pool:
>         0x00208184
>         0x00208184
>         0x00208184
>         0x00208184
> pool:
>         0x1040c205
>         0x1040c205
>         0x1040c205
>         0x1040c205
> 
> Granted, it's unlikely that we will be mixing numbers like this, but
> it's a great demonstration of why I added the input_rotate aspect to
> my mixing functions.

Honestly, this is a case of garbage in, garbage out.  If your
"randomness" is the same number repeated four times, the repetitions
don't add anything.  A more complicated mixing function doesn't buy
you much.  In the extreme case, you have the AES-encrypted counter
example.  No entropy on the input side, something that looks random on
the output side, and - because there is no secret key in the
complicated mixing function - anyone willing to sit down and do the
math can predict the output.

The failure case I was personally concerned about was a commutative
mixing function.  Interrupt numbers, for examples, are perfectly
predictable.  The randomness comes from the order or interrupts.  So
mix(a, b) != mix(b, a) is a hard requirement, if you excuse my silly
notation.

One variant that still fails your test above, but ensures every input
bit will eventually influence every output bit (certainly after 64
rounds) would be this:

static void fast_mix(struct fast_pool *f, __u32 input[4])
{
        int i;
        __u32 acc, p, carry = f->pool[3] >> 25;

        for (i = 0; i < 4; i++) {
                p = carry * input[i];
                acc = (f->pool[i] << 7) ^ input[i] ^ carry ^ p;
                carry = f->pool[i] >> 25;
                f->pool[i] = acc;
        }
}

Clearly this is a better mixing function, but I still think we don't
need that much quality.  If there is any randomness at all in the
interrupts, we will quickly make every bit in the pool unpredictable.
And if the interrupts are completely predictable in every bit and in
their order, well, we have lost either way.

Jörn

--
I say what I believe in.  And give reasons.
-- Pervez Hoodbhoy
