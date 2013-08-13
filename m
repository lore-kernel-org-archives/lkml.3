Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3HMDWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:22:20 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:55930 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab3HMDWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:22:18 -0400
Date: Mon, 12 Aug 2013 23:22:15 -0400
From: Rich Felker <dalias@aerifal.cx>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Message-ID: <20130813032214.GA221@brightrain.aerifal.cx>
References: <20130803024808.GA26932@brightrain.aerifal.cx>
 <52091E6B.10800@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52091E6B.10800@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:42:03AM -0700, Andy Lutomirski wrote:
> You'll have the same problem that O_TMPFILE had: the kernel currently
> ignores unrecognized flags.  I wonder if it's time to add a new syscall
> (or syscalls) with more sensible semantics.

That's not a problem here. In fact, in the case where O_PATH is not
supported by the kernel, the best possible behavior for O_SEARCH and
O_EXEC would be for them to be the same as O_RDONLY, since this gives
comforming behavior in all ways except that it will fail if you don't
have read access to the file.

Some folks have raised the issue that it would be "dangerous" because
certain devices have side effects on open, even open for read, but
POSIX does not specify that opening for search or exec suppresses such
side effects anyway. It's only applications directly using O_PATH and
expecting the Linux semantics that would be thrown off by getting
O_READ semantics instead. In any case, there are many reasons it's
unsafe for a privileged process to open an untrusted pathname already.

Anyway, the whole point of this discussion is about choosing a value
that has the best fallback behavior on old kernels. O_PATH alone would
meet that requirement almost perfectly, but it has the unfortunate
issue that O_NOFOLLOW is interpreted in a special way with O_PATH: it
causes the symlink itelf to be opened, rather than for open to fail
when encountering a symlink. So we need a new flag by which the kernel
could detect and reject symlinks with O_PATH, _or_ the kernel could
just ignore this new flag, since userspace will have to check (to
support older kernels) that it did not get a symlink, and if so,
simulate failure.

Rich
