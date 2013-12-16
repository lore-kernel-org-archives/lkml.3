Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LPAc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 19:32:58 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:65342 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab3LPAc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 19:32:57 -0500
X-AuditID: 12074425-b7fd96d000000c39-be-52ae4a38b491
Date: Sun, 15 Dec 2013 19:32:53 -0500
From: Greg Price <price@MIT.EDU>
To: George Spelvin <linux@horizon.com>
Cc: tytso@MIT.EDU, linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131216003253.GC7790@athena.dialup.mit.edu>
References: <20131215200312.GO27191@athena.dialup.mit.edu>
 <20131215220910.24012.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215220910.24012.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixG6nrmvhtS7IYHGnkMXlXXPYLE6tmcfo
	wOSxfe58Zo/Pm+QCmKK4bFJSczLLUov07RK4Mnof3WIu2ChasWrnJbYGxmWCXYycHBICJhLH
	248yQdhiEhfurWfrYuTiEBKYzSSxftMbRghnI6PE+yOt7BDOL0aJTS8+MIO0sAioStzf9J4d
	xGYTUJD4MX8dWFxEQE3iev88FhCbWUBf4tS/2YwgtrCAl8SVfavYQGxeAUuJv+37wWwhgVyJ
	lnN3WSDighInZz6B6tWSuPHvJdB5HEC2tMTyfxwgJqeArcSyvV4gFaICKhJTTm5jm8AoOAtJ
	8ywkzbMQmhcwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3StdDLzSzRS00p3cQIDl0X1R2MEw4p
	HWIU4GBU4uFVtFwXJMSaWFZcmXuIUZKDSUmUt8kZKMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE
	N+bq2iAh3pTEyqrUonyYlDQHi5I47y0O+yAhgfTEktTs1NSC1CKYrAwHh5IEr7Yn0FDBotT0
	1Iq0zJwShDQTByfIcB6g4dEgNbzFBYm5xZnpEPlTjIpS4rytHkAJAZBERmkeXC8stbxiFAd6
	RZhXDqSdB5iW4LpfAQ1mAhrsvWcVyOCSRISUVAMjf3O5f4jFsYW9Zg28nOe4pE5N26z17dD7
	aRbCdTW7rP+7i8X12j89zefWd5ovYbX8veZZX3ynhfhPWVX75f7OBNc9EXZ85Qq7WyKFNmjs
	+rbvyJO2+s2Wnkb/zrWVKMzjmjBx0Z89ayYf/dt78AP/d25DHcnv7+4/Kfp/YnurCdOzoE2i
	yquuKrEUZyQaajEXFScCAJ2iAikIAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 05:09:10PM -0500, George Spelvin wrote:
> Well, /dev/urandom is documented as being *deliberately* slow.  It's meant
> only to produce 128 to 256 bits of seed material for CPRNG.  I don't
> know if Ted considers speeding it up to be goal or an antigoal. :-)

Hmm, I don't think I've seen that documentation.  I don't see anything
about that point in the comments of drivers/char/random.c.  The
urandom(4) man page says /dev/urandom "is designed for security, not
speed, and is poorly suited to generating large amounts of random
data."  Which is quite different from being designed for slowness!

The great thing about the state of cryptography in 2013 is that we
don't have the kind of tradeoff between speed and security that we had
in the past.  Skein and Salsa20 and some other hashes and ciphers from
within the past decade are all very fast, and they've also been
attacked hard by cryptanalysts (motivated by competitions), and held
up very well.  From my understanding of the literature, moving to
either one from our current SHA-1-based scheme would only increase the
level of confidence one should have in the security of the random driver.

I think it would be great to be able to change the documentation to
"is designed for security and is also very fast and well suited to
generating large amounts of random data".  Users are always tempted by
speed, and if we can reduce that temptation by making our CSPRNG
faster (and still secure), it will be good for security.


> BTW, if it helps on 32-bit platforms I can get you rotate constats for
> a 32-bit version of threefish.  I haven't generated a key scheduling
> constant, though.

Interesting.  So, the generic Skein implementations in the SUPERCOP
testing/benchmarking suite are about four times slower on x86_32 than
x86_64.  Which means Skein should still be about 6x faster than the
current /dev/urandom implementation, but it'd be nice to be faster
still.  I imagine the same rough comparisons will hold on other 64-bit
and 32-bit architectures, though the gap between x86_32 and x86_64 is
probably wider because of the scarcity of registers on x86_32.

I wouldn't want to compromise on security to do it, though.  My
confidence in Skein/Threefish's security comes mostly from the SHA-3
competition, where many expert cryptanalysts attacked it and didn't
get very far except in understanding why it seems to be hard to break.
To make, or even evaluate, a 32-bit variant of Threefish seems like
it'd require much deeper understanding of the design of Threefish and
its cryptanalysis than I've tried to develop.  How do you plan to
evaluate the security of your 32-bit Threefish?

Regards,
Greg
