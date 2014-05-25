Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEYVLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 17:11:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:60167 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaEYVLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 17:11:37 -0400
Date: Sun, 25 May 2014 17:11:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Plamen Petrov <plamen.sisi@gmail.com>, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        sandeen@redhat.com
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
Message-ID: <20140525211129.GA5243@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Plamen Petrov <plamen.sisi@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	sandeen@redhat.com
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
 <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
> 
> The fact is, I think xfs is just buggy. Returning 38 (ENOSYS) is
> totally insane. "No such system call"? Somebody is on some bad bad
> drugs. Not that the mount_block_root() loop and error handling might
> not be a good thing to perhaps tweak _too_, but at the very least your
> patch means that now it no longer prints out the error number at all.

There's only a single instance of ENOSYS in fs/xfs/xfs_mount.c:

	/*
	 * We must be able to do sector-sized and sector-aligned IO.
	 */
	if (sector_size > sbp->sb_sectsize) {
		if (loud)
			xfs_warn(mp, "device supports %u byte sectors (not %u)",
				sector_size, sbp->sb_sectsize);
		error = ENOSYS;
		goto release_buf;
	}

Plamen, does changing the ENOSYS to EINVAL above fix things for you?

> Anyway, I'm also not seeing why that xfs error would be new to 3.14,
> though.. Adding the XFS people to the cc.

If I had to guess, commit daba5427d is new to 3.14, and it might
explain the change in behavior.

Cheers,

						- Ted
