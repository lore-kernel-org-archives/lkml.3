Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbaGRKWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:22:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:42937 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761027AbaGRKWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:22:12 -0400
Date: Fri, 18 Jul 2014 06:21:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Florian Weimer <fweimer@redhat.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Message-ID: <20140718102140.GF1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Florian Weimer <fweimer@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	beck@openbsd.org
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
 <53C8EB45.20304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C8EB45.20304@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:39:17AM +0200, Florian Weimer wrote:
> On 07/17/2014 11:38 PM, Theodore Ts'o wrote:
> >	If the GRND_RANDOM flags bit is set, then draw from the
> >	/dev/random pool instead of the /dev/urandom pool.  The
> >	/dev/random pool is limited based on the entropy that can be
> >	obtained from environmental noise, so if there is insufficient
> >	entropy, the requested number of bytes may not be returned.
> >	If there is no entropy available at all, getrandom(2) will
> >	either block, or return an error with errno set to EAGAIN if
> >	the GRND_NONBLOCK bit is set in flags.
> 
> Can we get a GRND_INIT flag or something like that which means "block/return
> EAGAIN until the kernel pool is initialized"?  Thanks.

This is a mandatory, non-optional feature of getrandom(2).

It will always block or return EAGAIN until it has sufficient entropy.
This is true both for the GRND_RANDOM or !GRND_RANDOM modes.

There are already people whining about how they can't use this
interface to get best efforts randomness for srand().  I'm not
planning meeting their request; non-crypto code which wants to use
random() or rand() can either use the standard getpid()/time()
mechanisms to initialize their PRNG, or they can try to open
/dev/urandom and do things the old fashioned way.  Cry me a river.....

Cheers,

					- Ted

P.S.  Because the ARM architecture does not guarantee a cycle counter
(and apparently using the cycle counter when it is not present cause a
crash, and there's apparently no way to determine whether the cycle
counter is present), entropy collection on ARM is a problem, and so
this new behaviour may be problematic on some architectures,
especially if some part of the system like systemd wants to use
getrandom(2) in very early boot.

However, this is a new interface, so if it causes problems on ARM and
other broken architectures, tough noogies.  Hopefully this will
gradually increase pressure on the ARM folks to fix their broken
CPU architectuure specification...
