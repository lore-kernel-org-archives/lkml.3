Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaGQNPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:15:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49859 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027AbaGQNPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:15:52 -0400
X-Sasl-enc: APSCvVL1Z8f2JojiXvINRAVP6ZFtreq3Me7cAlzqhB+F 1405602945
Message-ID: <1405602943.12194.26.camel@localhost>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Date: Thu, 17 Jul 2014 15:15:43 +0200
In-Reply-To: <20140717125207.GL1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
	 <1405594627.12194.9.camel@localhost> <20140717125207.GL1491@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 2014-07-17 at 08:52 -0400, Theodore Ts'o wrote:
> On Thu, Jul 17, 2014 at 12:57:07PM +0200, Hannes Frederic Sowa wrote:
> > 
> > Btw. couldn't libressl etc. fall back to binary_sysctl
> > kernel.random.uuid and seed with that as a last resort? We have it
> > available for few more years.
> 
> Yes, they could.  But trying to avoid more uses of binary_sysctl seems
> to be a good thing, I think.  The other thing is that is that this
> interface provides is the ability to block until the entropy pool is
> initialized, which isn't a big deal for x86 systems, but might be
> useful as a gentle forcing function to force ARM systems to figure out
> good ways of making sure the entropy pools are initialized (i.e., by
> actually providing !@#!@ cycle counter) without breaking userspace
> compatibility --- since this is a new interface.

I am not questioning this new interface - I like it - just wanted to
mention there is already a safe fallback for LibreSSL in the way they
already seem to do it in OpenBSD (via sysctl).

> 
> > > +	if (count > 256)
> > > +		return -EINVAL;
> > > +
> > 
> > Why this "arbitrary" limitation? Couldn't we just check for > SSIZE_MAX
> > or to be more conservative to INT_MAX?
> 
> I'm not wedded to this limitation.  OpenBSD's getentropy(2) has an
> architected arbitrary limit of 128 bytes.  I haven't made a final
> decision if the right answer is to hard code some value, or make this
> limit be configurable, or remote the limit entirely (which in practice
> would be SSIZE_MAX or INT_MAX).
> 
> The main argument I can see for putting in a limit is to encourage the
> "proper" use of the interface.  In practice, anything larger than 128
> probably means the interface is getting misused, either due to a bug
> or some other kind of oversight.
> 
> For example, when I started instrumenting /dev/urandom, I caught
> Google Chrome pulling 4k out of /dev/urandom --- twice --- at startup
> time.  It turns out it was the fault of the NSS library, which was
> using fopen() to access /dev/urandom.  (Sigh.)

In the end people would just recall getentropy in a loop and fetch 256
bytes each time. I don't think the artificial limit does make any sense.
I agree that this allows a potential misuse of the interface, but
doesn't a warning in dmesg suffice?

It also makes it easier to port applications from open("/dev/*random"),
read(...) to getentropy() by reusing the same limits.

I would vote for warning (at about 256 bytes) + no limit.

Thanks,
Hannes


