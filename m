Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaGTVcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:32:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50606 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbaGTVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:32:48 -0400
X-Sasl-enc: Q+DhzZVBwfD6UHiPHtzdB9m9wKUQ3UNFTcwOj90uW9xI 1405891966
Message-ID: <1405891964.9562.42.camel@localhost>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
Date: Sun, 20 Jul 2014 23:32:44 +0200
In-Reply-To: <20140720170306.15274.qmail@ns.horizon.com>
References: <20140720170306.15274.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-07-20 at 13:03 -0400, George Spelvin wrote:
> > In the end people would just recall getentropy in a loop and fetch 256
> > bytes each time. I don't think the artificial limit does make any sense.
> > I agree that this allows a potential misuse of the interface, but
> > doesn't a warning in dmesg suffice?
> 
> It makes their code not work, so they can are forced to think about
> fixing it before adding the obvious workaround.
> 
> > It also makes it easier to port applications from open("/dev/*random"),
> > read(...) to getentropy() by reusing the same limits.
> 
> But such an application *is broken*.  Making it easier to port is
> an anti-goal.  The goal is to make it enough of a hassle that
> people will *fix* their code.
> 
> There's a *reason* that the /dev/random man page explicitly tells
> people not to trust software that reads more than 32 bytes at a time
> from /dev/random:
> 
> > While some safety margin above that minimum is reasonable, as a guard
> > against flaws in the CPRNG algorithm, no cryptographic primitive avail-
> > able today can hope to promise more than 256 bits of security, so if
> > any program reads more than 256 bits (32 bytes) from the kernel random
> > pool per invocation, or per reasonable reseed interval (not less than
> > one minute), that should be taken as a sign that its cryptography is
> > *not* skillfully implemented.
> 
> ("not skilfuly implemented" was the phrase chosen after some discussion to
> convey "either a quick hack or something you dhouldn't trust.")
> 
> To expand on what I said in my mail to Ted, 256 is too high.
> I'd go with OpenBSD's 128 bytes or even drop it to 64.

I don't like partial reads/writes and think that a lot of people get
them wrong, because they often only check for negative return values.

I thought about the following check (as replacement for the old check):

/* we will always generate a partial buffer fill */
if (flags & GRND_RANDOM && count > 512)
	return -EINVAL;

We could also be more conservative and return -EINVAL in case a stray
write happened if one tried to extract less than 512 by checking the
return values of random_read(), but somehow this sounds dangerous to me.

In case of urandom extraction, I wouldn't actually limit the number of
bytes. A lot of applications I have seen already extract more than 128
out of urandom (not for seeding a prng but just to mess around with some
memory). I don't see a reason why getrandom shouldn't be used for that.
It just adds one more thing to look out for if using getrandom() in
urandom mode, especially during porting an application over to this new
interface.

Bye,
Hannes


