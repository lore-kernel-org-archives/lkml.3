Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaGTQ00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 12:26:26 -0400
Received: from ns.horizon.com ([71.41.210.147]:21365 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751500AbaGTQ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 12:26:24 -0400
Date: 20 Jul 2014 12:26:22 -0400
Message-ID: <20140720162622.29664.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tytso@mit.edu
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Cc: linux@horizon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One basic question... why limit this to /dev/random?

If we're trying to avoid fd exhaustion attacks, wouldn't an "atomically
read a file into a buffer" system call (that could be used on
/dev/urandom, or /etc/hostname, or /proc/foo, or...) be more useful?

E.g.

ssize_t readat(int dirfd, char const *path, struct stat *st,
	char *buf, size_t len, int flags);

It's basically equivalent to openat(), optional fstat() (if st is non-NULL),
read(), close(), but it doesn't allocate an fd number.

Is it necessary to have a system call just for entropy?

If you want a "urandom that blocks until seeded", you can always create
another device node for the purpose.

> The main argument I can see for putting in a limit is to encourage the
> "proper" use of the interface.  In practice, anything larger than 128
> probably means the interface is getting misused, either due to a bug
> or some other kind of oversight.

Agreed.  Even 1024 bits is excessive.  32 bytes is the "real" maximum
that people should be asking for with current primitives, so an interface
limitation to 64 is quite defensible.  (But 128 isn't *wildly* excessive.)

If you do stick with a random-specific call, specifying the entropy
in bits (with some specified convention for the last fractional byte)
is anothet interesting idea.  Perhaps too prone to bugs, though.
(People thinking it's bytes and producing low-entropy keys.)
