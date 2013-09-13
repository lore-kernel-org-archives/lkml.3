Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3IMLzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:55:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:58181 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3IMLzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:55:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thorsten Glaser <tg@mirbsd.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Fri, 13 Sep 2013 11:54:40 +0000 (UTC)
Message-ID: <loom.20130913T134347-937@post.gmane.org>
References: <10005394.BRCyBMYWy3@tauon> <522F984C.2070909@linaro.org> <20130912213148.GE3809@logfs.org> <1974157.PE35U8AyTG@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 94.198.62.204 (Mozilla/5.0 (X11; Linux 3.10-2-amd64 i686) KHTML/4.10.5 (like Gecko) Konqueror/4.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller <at> chronox.de> writes:

> And here the RNG theory breaks: a whitening function (crypto function) 
> like the used SHA1 does not add entropy. Thus, the SHA1 just spreads out 
> the entropy evenly over the output buffer. As entropy can be considered 

That’s why you also use a (faster, less powerful) mixing function
on input.

I was wondering: why not use Jenkins’ one-at-a-time hash there?
I’ve worked with it a bit, and it has good avalanche behaviour;
I didn’t measure any cycles though.

Basically, h be an uint32_t register (usually loaded from a
memory location and stored to one afterwards), then you do:

    (h) += (uint8_t)(b);
#ifdef with_mirabilos_changes
    ++(h);
#endif
    (h) += (h) << 10;
    (h) ^= (h) >> 6;

I’m adding 1 after the first step (adding the byte) in order
to make even NUL bytes make up a difference.

I’m toying with code that has 32 such uint32_t values, making
for a total of 128 Bytes of state, and when asked to add some
memory content into that pool, just distribute the bytes over
the values array, incrementing a counter.

(One could probably do something with cmpxchg to make that
lockless, but I’m not doing any parallel programming myself.)

Then, every once in a while, you’d run the finish function
on every value, which is:

#ifdef with_mirabilos_changes
    (h) += (h) << 10;
    (h) ^= (h) >> 6;
#endif
    (h) += (h) << 3;
    (h) ^= (h) >> 11;
    (h) += (h) << 15;

My change here is because Jenkins’ OAAT has good avalanche
except for the last input byte, so I just fake adding NUL
(which doesn’t get avalanched so well, but doesn’t matter)
to get the last actual data byte avalanched.

Then I write those finialised hash values back to the
128-Byte-buffer then I add that into the main pool using
a cryptographic (hash, or stream cipher rekey) function.
(In my case, arc4random, if someone wonders.)

> >It doesn't matter if you collect predictable data - it neither helps
> 
> Oh yes, it hurts, if you update the entropy estimator on those 
> predictable bits. Because then you get a deterministic RNG like 

I’ve seen Theodore apply exponential backoff to any estimation,
which is probably a good thing. But yes, you probably will want
to guess the entropy of the bytes added and not count things
where you’re not too sure of. (In the interrupt case, we have
jiffies, cycles and num, so we’d probably best estimate how
often interrupts are called, base a number of “timing” bits
on that, and account for num; this may very well be less than
8 bit “credited” for a long and two u_int added to the pool,
but as long as you get that right and don’t blindly credit
a byte as 8 bit, you’re safe. To quote the author of RANDOM.SYS
for DOS: “Every bit counts.” It adds uncertainty to the pool,
at least by stirring around the already-existing entropy without
adding any new (creditable) entropy.)

bye,
//mirabilos

