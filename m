Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaGTRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:25:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:46143 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaGTRZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:25:25 -0400
Date: Sun, 20 Jul 2014 13:24:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140720172457.GG5017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140720162622.29664.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720162622.29664.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:26:22PM -0400, George Spelvin wrote:
> One basic question... why limit this to /dev/random?
> 
> If we're trying to avoid fd exhaustion attacks, wouldn't an "atomically
> read a file into a buffer" system call (that could be used on
> /dev/urandom, or /etc/hostname, or /proc/foo, or...) be more useful?
> 
> E.g.
> 
> ssize_t readat(int dirfd, char const *path, struct stat *st,
> 	char *buf, size_t len, int flags);
> 
> It's basically equivalent to openat(), optional fstat() (if st is non-NULL),
> read(), close(), but it doesn't allocate an fd number.
> 
> Is it necessary to have a system call just for entropy?
> 
> If you want a "urandom that blocks until seeded", you can always create
> another device node for the purpose.

I'd really rather not go down this path.  Your readat(2) proposal is
interesting, but it adds a whole lot of complications.  For example,
just simply booting a new kernel doesn't guarantee that a new device
node for "blocks until seeded" will exist.  So that means a lot of
applications will just either continue to use /dev/urandom, or have to
put in fallback code to first try the new device name, and then fall
back to /dev/urandom.  (And of course, they have to deal with what to
do if /dev/urandom doesn't exist --- which presumably would be
raise(SIGKILL), but we're now talking about a number of lines of codes
that application writers would have to get right.)

Readat(2) would also have to get linked into auditing, and LSM, and
honestly, it's a lot more work that I'm not all that interested in
doing and trying to get right.

> If you do stick with a random-specific call, specifying the entropy
> in bits (with some specified convention for the last fractional byte)
> is anothet interesting idea.  Perhaps too prone to bugs, though.
> (People thinking it's bytes and producing low-entropy keys.)

Definitely not worth the complexity.

							- Ted

