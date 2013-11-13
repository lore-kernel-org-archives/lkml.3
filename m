Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab3KMGGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:06:55 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:46976 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab3KMGGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:06:45 -0500
X-AuditID: 12074425-b7fd96d000000c39-70-528316f40b75
Date: Wed, 13 Nov 2013 01:06:41 -0500
From: Greg Price <price@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113060641.GA8043@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
 <20131112042444.GC30281@thunk.org>
 <20131112224009.GX8043@ringworld.MIT.EDU>
 <20131113033205.GA9214@thunk.org>
 <5282F9C1.3020007@zytor.com>
 <20131113043702.GZ8043@ringworld.MIT.EDU>
 <52830546.8010002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52830546.8010002@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsUixG6nrvtFrDnI4O16G4tpG8Utds9ZzGJx
	edccNgdmjzMLjrB7fN4k53Gi5QtrAHMUl01Kak5mWWqRvl0CV8aLaZvYC85JVPQuVmhgPCXc
	xcjJISFgInFo+jw2CFtM4sK99UA2F4eQwGwmiU2/tzJCOBsZJe7ePwCV+cUo0dJ1kAWkhUVA
	VWL21busIDabgILEj/nrmEFsEQEViek/PzGB2MwCmRLrbnQwgtjCAgYSu3Z2gfXyCphKHJw4
	nwliaD+TRO+Xy8wQCUGJkzOfsEA0a0nc+PcSqIgDyJaWWP6PAyTMKaAp8WbndXYQWxRo15ST
	29gmMArOQtI9C0n3LITuBYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3Qt9HIzS/RSU0o3MYLD
	2UV1B+OEQ0qHGAU4GJV4eC1imoKEWBPLiitzDzFKcjApifKeEWkOEuJLyk+pzEgszogvKs1J
	LT7EKMHBrCTCe0AYKMebklhZlVqUD5OS5mBREue9xWEfJCSQnliSmp2aWpBaBJOV4eBQkuD9
	LwrUKFiUmp5akZaZU4KQZuLgBBnOAzRcVgxkeHFBYm5xZjpE/hSjopQ4bzZIswBIIqM0D64X
	lm5eMYoDvSLMqwDSzgNMVXDdr4AGMwENtihuAhlckoiQkmpg3LWD3S/6/kI2Dt4lxXtt7DTq
	p8SrT/h1Z07JqZUdyU7R1S5bmWpNJDXsA5c3HZi3QyjS5svz2CsOe+95Ws6PaZm9lKHrdu4L
	R4Fg25X7Xu3avMwsb69oswO//JtVsg/3vnU48Df8XVXYCjdVNwn3uPw/St3/rwnYGfXlhbix
	hU491/1Q5dwbJZbijERDLeai4kQASDo2jhIDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:51:18PM -0800, H. Peter Anvin wrote:
> On 11/12/2013 08:37 PM, Greg Price wrote:
> > I'm thinking only of boot-time blocking.  The idea is that once
> > /dev/urandom is seeded with, say, 128 bits of min-entropy in the
> > absolute, information-theoretic sense, it can produce an infinite
> > supply (or something like 2^128 bits, which amounts to the same thing)
> > of bits that can't be distinguished from random, short of breaking or
> > brute-forcing the crypto.  So once it's seeded, it's good forever.
> 
> And, pray tell, how will you know that you have done that?
> 
> Even the best entropy estimation algorithms are nothing but estimations,

Indeed.  We do our best, but we can't be sure we have as much entropy
as we think.

The status quo here is that /dev/urandom will cheerfully answer
requests even when, by our own estimates, we only have a small amount
of entropy and anything we return will be guessable.  What Ted and I
are discussing in this thread is to have it wait until, as best we can
estimate, it has enough entropy to give an unpredictable answer.  The
status quo has the same effect as an arbitrarily too-optimistic
estimate.

The key point when it comes to the question of going *back* to
blocking is that even if the estimates are bad and in reality the
answer is guessable, it won't get any *more* guessable in the future.
If we think we have 128 bits of input min-entropy but we only have
(say) 32, meaning some states we could be in are as likely as 2^(-32),
then once an attacker sees a handful of bytes of output (*) they can
check a guess at our input and predict all our other output with as
few as 2^32 guesses, depending on the distribution.  If the attacker
sees a gigabyte or a petabyte of output, they have exactly the same
ability.  So there's no good reason to stop.

On the other hand, because our estimates may be wrong it certainly
make sense to keep feeding new entropy into the pool.  Maybe a later
seeding will have enough real entropy to make us unpredictable from
then on.  We could also use bigger and bigger reseeds, as a hedge
against our estimates being systematically too low in some
environment.

Does that make sense?  Do you have other ideas for guarding against
the case where our estimates are low?

Greg


(*) Math note: the attacker morally needs only 32 bits.  They actually
need a little more than that, because some of the (at least) 2^32
possible states probably correspond to the same first 32 bits of
output.  By standard probability bounds, for any given set of 2^32
possible input states, if the generator is good then probably no more
than ln(2^32) = 22 or so of them correspond to the same first 32 bits.
About 37 bits of output is enough to probably make all the outputs
different, and with even 64 bits = 8 bytes of output it becomes
overwhelmingly likely that all the outputs are different.  If there
are more than 2^32 possible states because the min-entropy is 32 but
some inputs are less likely, then the attacker needs even less output
to be able to confirm the most likely guesses.
