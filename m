Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LOUDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:03:18 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:56726 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab3LOUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:03:16 -0500
X-AuditID: 12074424-b7fa56d000000be4-28-52ae0b031bc2
Date: Sun, 15 Dec 2013 15:03:12 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131215200312.GO27191@athena.dialup.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214215559.10128.qmail@science.horizon.com>
 <20131214192307.GA10457@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsUixCmqrMvMvS7IYNIyA4vLu+awWZxaM4/R
	gclj+9z5zB6fN8kFMEVx2aSk5mSWpRbp2yVwZZydeoGpYKNQxZedR5kbGN/xdTFyckgImEj8
	XD6FCcIWk7hwbz1bFyMXh5DAbCaJ7VumMoMkhAQ2MkrsnVoDkfjFKPHo6S1GkASLgKrEs3mT
	wLrZBBQkfsxfB9TAwSEi4C6x+00sSJgZKPzr3iZWEFtYwEviyr5VbCAlvAJWEpunKYOEeQUE
	JU7OfMICUa4lcePfSyaQEmYBaYnl/zhAwpwCSRJ7554GWyQqoCIx5eQ2tgmMArOQdM9C0j0L
	oXsBI/MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXXO93MwSvdSU0k2MoPBkd1HZwdh8SOkQowAH
	oxIPrwTb2iAh1sSy4srcQ4ySHExKorzK7OuChPiS8lMqMxKLM+KLSnNSiw8xSnAwK4nwxlwF
	KudNSaysSi3Kh0lJc7AoifPe4rAPEhJITyxJzU5NLUgtgsnKcHAoSfBacgENFSxKTU+tSMvM
	KUFIM3FwggznARruC1LDW1yQmFucmQ6RP8WoKCXOu54TKCEAksgozYPrhaWPV4ziQK8I88aB
	VPEAUw9c9yugwUxAg733rAIZXJKIkJJqYNwuvedY0WPP8jWzzLj4Lud5mB+ar2R7sHGBJUOr
	3m61e1tLNmSJnC0sb5cWvCR/MK5s69kn5V/1ZNU5rXZ8aZf7mnc5RHBhe2Ob6/1Dfiz3NzpY
	G1ncnv/zVck5RYHk5KiV9peLX1Yk/v/Nu/PCnfca0y7MnhrlOePqz+/be2vyrjW8MpZf+VqJ
	pTgj0VCLuag4EQB0PyKo+gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 02:23:07PM -0500, Theodore Ts'o wrote:
> I'm much more inclined to think about changing how we generate random
> numbers from the output pool by switching from using SHA to AES in
> some one-way random function mode (i.e., such as the Davies-Meyer
> construction), since that is where we are spending most of our CPU
> time in the random driver at the moment.

I have a draft of a patch series to do something like this.  There's a
good bit of refactoring to make the output pools have a different type
from input_pool.  Then a new cryptographic engine can be swapped in
for the output pools, in place of the current SHA-1-based algorithm.

The refactoring should be basically the same for any change of
algorithm, if the new algorithm is to be used for the output pools and
not the input pool.  Which I think is the right approach -- generally
the state-of-the-art PRNG algorithms aren't optimized for taking input
quickly, as we want to do in an interrupt, so we'll want the current
mix_pool_bytes or something similar for the input pool.  Perhaps the
Brent-Marsaglia algorithms George mentioned, which I haven't yet read
about in detail.

A side benefit of the reseeding rework I sent yesterday is that it
lays the groundwork for that refactoring, by directing all routine
input through the input pool.


On Sat, Dec 14, 2013 at 04:55:59PM -0500, George Spelvin wrote:
> The SHA-3 competition has given us lots of random permutations and
> random functions.  Keccak, Salsa20/ChaCha, Skein/Threefish and SipHash
> are all interesting looking.  AES/Rijndael is actually less so, unless
> you're planning on using hardware support, because of cache timing
> attacks on the lookup tables it needs for software implementation.

My draft patch series uses Skein/Threefish.  The authors conveniently
specified a way to use it as a PRNG, and it's very fast without
special hardware support (consequently, for all kinds of hardware.)
On my laptop, reading from /dev/urandom becomes about 25 times faster
for large reads, and about 40% faster for small reads where the
syscall overhead is more important.

ChaCha or Salsa20 would be a good choice too.  The author didn't
specify a PRNG mode, but they can be plugged into standard
constructions, and they're also very fast.


Regards,
Greg
