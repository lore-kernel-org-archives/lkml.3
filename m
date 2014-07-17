Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaGQMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:52:19 -0400
Received: from imap.thunk.org ([74.207.234.97]:40779 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199AbaGQMwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:52:16 -0400
Date: Thu, 17 Jul 2014 08:52:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717125207.GL1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <1405594627.12194.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405594627.12194.9.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:57:07PM +0200, Hannes Frederic Sowa wrote:
> 
> Btw. couldn't libressl etc. fall back to binary_sysctl
> kernel.random.uuid and seed with that as a last resort? We have it
> available for few more years.

Yes, they could.  But trying to avoid more uses of binary_sysctl seems
to be a good thing, I think.  The other thing is that is that this
interface provides is the ability to block until the entropy pool is
initialized, which isn't a big deal for x86 systems, but might be
useful as a gentle forcing function to force ARM systems to figure out
good ways of making sure the entropy pools are initialized (i.e., by
actually providing !@#!@ cycle counter) without breaking userspace
compatibility --- since this is a new interface.

> > +	if (count > 256)
> > +		return -EINVAL;
> > +
> 
> Why this "arbitrary" limitation? Couldn't we just check for > SSIZE_MAX
> or to be more conservative to INT_MAX?

I'm not wedded to this limitation.  OpenBSD's getentropy(2) has an
architected arbitrary limit of 128 bytes.  I haven't made a final
decision if the right answer is to hard code some value, or make this
limit be configurable, or remote the limit entirely (which in practice
would be SSIZE_MAX or INT_MAX).

The main argument I can see for putting in a limit is to encourage the
"proper" use of the interface.  In practice, anything larger than 128
probably means the interface is getting misused, either due to a bug
or some other kind of oversight.

For example, when I started instrumenting /dev/urandom, I caught
Google Chrome pulling 4k out of /dev/urandom --- twice --- at startup
time.  It turns out it was the fault of the NSS library, which was
using fopen() to access /dev/urandom.  (Sigh.)

						- Ted
