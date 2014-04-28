Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaD1OkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:40:17 -0400
Received: from mail.eperm.de ([89.247.134.16]:43295 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbaD1OkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:40:15 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RFC] /dev/random for in-kernel use
Date: Mon, 28 Apr 2014 16:39:49 +0200
Message-ID: <4858823.gusYfQIdAn@myon.chronox.de>
User-Agent: KMail/4.12.4 (Linux/3.13.10-200.fc20.x86_64; KDE/4.12.4; x86_64; ; )
In-Reply-To: <20140428142350.GB4534@thunk.org>
References: <2174751.G4Kehsg85c@myon.chronox.de> <1692538.agAioWpnT4@myon.chronox.de> <20140428142350.GB4534@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. April 2014, 10:23:50 schrieb Theodore Ts'o:

Hi Theodore,

> > I am not too convinced of RDRAND due to the lack of usable source code
> > (i.e. source code that I can build myself). But that is my personal taste
> > :-)
> The problem is the FIPS validation would presumably require obeying
> the SP-800A requirement for an approved entropy source, and while we
> can't audit RDRAND to satisfy ourselves that the US government hasn't
> introduced a back door, if the only purpose of the FIPS validation is
> so that people can sell into the US government market, presuambly the
> US government is OK with a potential NSA-introduced back door.  :-)

>From a US centric view, you may be right. But there are some FIPS 140-2 
aspects which are helpful in general (albeit just a minority). And for those, 
auditible code is key. Not everybody is delighted to have NSA watching. :-)
> 
> That being said, there is some FIPS compliance code in
> drivers/char/random.c, which was introduced while Matt Mackall was
> maintaining the driver, and it mystifies me, since I never thought
> /dev/random could be an approved FIPS compliant generator --- not that
> I care, since I'm not trying to sell into the US government market,
> but the FIPS compliance code is largely harmless, so I've never
> bothered to remove it.

Ok, let me demystify it, because I was the initial trigger of the code 
changes. Albeit random.c is outside of any FIPS module, NIST requires that 
even seed sources that are outside the module boundary have a so-called 
"continuous selftest" as defined in FIPS specification section 4.9.2. If the 
self test fails, the seed source must become unavailable.
> 
> > Thanks for these suggestions. Shall I take these suggestions and turn them
> > into a full patch?
> 
> Sure, go for it.
> 
> > Moreover, I read that even for in-kernel users we should use the blocking
> > pool. Or shall we conceive of a third output pool, say, a kernel pool that
> > is independent of the output pools to user space? Adding such a pool more
> > or less only requires to define a new struct entropy_pool instance.
> 
> I've audited most of the in-kernel users, and most of them aren't even
> using them for a session key; they're using it for something less
> critical (e.g. ASLR, stack magic, etc.).  CIFS is perhaps the only
> place where it is generating a session key, and session key generation
> is just fine with the /dev/urandom pool.
> 
> So making all of the in-kernel users deal with a blocking interface is
> not worth it, IMHO.

Sorry, I did not make myself clear: for the purpose of the blocking behavior, 
shall we draw from blocking_pool or define a new pool used completely for this 
in-kernel blocking usage? Note, if we use the blocking_pool, any non-root user 
can stall the in-kernel operation indefinitely by simply reading /dev/random. 
As the in-kernel use for blocking random numbers would be limited, I was 
thinking about a new entropy pool that has no user space access.

I do not want to convert any existing in-kernel users of random data to use 
the new entropy pool.

Ciao
Stephan
-- 
| Cui bono? |
