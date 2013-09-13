Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3IMRBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:01:18 -0400
Received: from longford.logfs.org ([213.229.74.203]:60302 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IMRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:01:15 -0400
Date: Fri, 13 Sep 2013 11:26:26 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: John Stultz <john.stultz@linaro.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130913152626.GA14525@logfs.org>
References: <10005394.BRCyBMYWy3@tauon>
 <522F984C.2070909@linaro.org>
 <20130912213148.GE3809@logfs.org>
 <1974157.PE35U8AyTG@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1974157.PE35U8AyTG@tauon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 September 2013 07:36:20 +0200, Stephan Mueller wrote:
> Am Donnerstag, 12. September 2013, 17:31:48 schrieb Jörn Engel:
> >
> >The basic principle of Ted's RNG is very simple and quite sane:
> >- You collect as much data as possible, some of which is (hopefully)
> >  unpredictable.
> >- All the data gets dumped into a small buffer.
> >- When reading from the buffer, you create a crypto-hash of the entire
> >  buffer.  Even if most of the buffer is predictable, the few
> >  unpredictable bits will randomly flip every output bit.
> 
> And here the RNG theory breaks: a whitening function (crypto function) 
> like the used SHA1 does not add entropy. Thus, the SHA1 just spreads out 
> the entropy evenly over the output buffer. As entropy can be considered 
> as a kind of percentage value, if you have, say, 10% of your input 
> buffer holding entropy, applying a whitening function, you output buffer 
> still holds 10% of entropy only.

Agreed.  An extreme example were the debian ssh keys.  You couldn't
predict any particular bit of an ssh key, but the entire keyspace was
just 15bit and easily enumerated.

The crucial bit of the RNG is that noone knows the entire pool state
at any time.  If you have a rootkit that controls the kernel, you have
lost.  If root is not trustworthy, you have lost.  If you are running
on a VM and your hypervisor is not trustworthy, you have lost.  If you
don't control physical access to the machine, you have lost - at least
in the most paranoid scenario.

Assuming an unknown state of the pool and a strong crypto-hash it is
hard to argue how entropy is ever removed from the pool, no matter how
often you read from it.  A strong crypto-hash, by definition, makes it
impossible to reconstruct the input bits from the output by any means
easier than brute force.  Brute-forcing a 160bit hash with 80 unknown
bits is unfeasable, so the input buts are completely unguessable by a
consumer of /dev/[u]random.  So if there ever were, say, 80 bits of
entropy in the pool, the random data will remain good forever.

Realistic attacks are the two assumptions.  Sha1 is showing the first
signs of defeat.  We likely have a lot of margin left in it and Ted's
decision to only reveal half the bits while folding the other half
back into the pool means the hash remains usable for /dev/[u]random
even after it has been broken for other purposes.  But it is
conceivable that we will have to change the hash again.

The most realistic attack by far is to simply read out the state of
the pool.  So you have to secure your machine in the usual ways and
not trust random generators on machines you don't trust.

> >- Half of the hash gets returned to the reader, the other half gets
> >  added back into the pool.
> >
> >It doesn't matter if you collect predictable data - it neither helps
> 
> Oh yes, it hurts, if you update the entropy estimator on those 
> predictable bits. Because then you get a deterministic RNG like 
> /dev/urandom in the worst case. Thus you degrade the quality of 
> /dev/random which relies on the blocking nature.

You have to have a conservative estimate of entropy, agreed.  And in
many cases the only sane estimate is zero.

Jörn

--
Fancy algorithms are buggier than simple ones, and they're much harder
to implement. Use simple algorithms as well as simple data structures.
-- Rob Pike
