Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbaGUP1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:27:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43806 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932595AbaGUP1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:27:12 -0400
X-Sasl-enc: jC3ZUd2lfEGBvgC4Bim8XGVFRAtONHjna9Fxg+dtjMwG 1405956428
Message-ID: <1405956426.2319.37.camel@localhost>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
Date: Mon, 21 Jul 2014 17:27:06 +0200
In-Reply-To: <20140721112102.19300.qmail@ns.horizon.com>
References: <20140721112102.19300.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2014-07-21 at 07:21 -0400, George Spelvin wrote:
> > I don't like partial reads/writes and think that a lot of people get
> > them wrong, because they often only check for negative return values.
> 
> The v1 patch, which did it right IMHO, didn't do partial reads in the
> case we're talking about:
> 
> +	if (count > 256)
> +		return -EINVAL;

I checked and unfortunately it does not; 256 bytes is way too large to
guarantee non-existence of partial reads. On a typical older system
without rdrand/rdseed you would have to limit the amount of bytes to
extract to about 32. That's way too low. That said, the 512 bytes check
only in case of extracting bytes from blocking pool would serve no
purpose.

> > In case of urandom extraction, I wouldn't actually limit the number of
> > bytes. A lot of applications I have seen already extract more than 128
> > out of urandom (not for seeding a prng but just to mess around with some
> > memory). I don't see a reason why getrandom shouldn't be used for that.
> > It just adds one more thing to look out for if using getrandom() in
> > urandom mode, especially during porting an application over to this new
> > interface.
> 
> Again, I disagree.  If it's "just messing around" code, use /dev/urandom.
> It's more portable and you don't care about the fd exhaustion attacks.
> 
> If it's actual code to be used in anger, fix it to not abuse /dev/urandom.
> 
> You're right that a quick hack might be "broken on purpose", but without
> exception, *all* code that I have seen which reads 64 or more bytes from
> /dev/*random is broken, and highlighting the brokenness is a highly
> desirable thing.
> 
> The sole and exclusive reason for this syscall to exist at all is to
> solve a security problem.  Supporting broken security code does no favors
> to anyone.

Then let's agree to disagree. :)

I think it is dangerous if application will get ported to this new
interface without checking size limitations and will only notice it
after the applications will be rolled out (if at all).

Bye,
Hannes


