Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3JCQj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:39:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:41722 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3JCQjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:39:25 -0400
Date: Thu, 3 Oct 2013 12:39:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nikita Danilov <nikita@clusterfs.com>
Subject: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131003163908.GD31721@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Peng Tao <tao.peng@emc.com>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been auditing uses of get_random_bytes() since there are places
where get_random_bytes() is getting used where something weaker, such
as prandom_u32() is quite sufficient.  Basically, if kernel code just
needs a random number which does not have any cryptographic
requirements (such as in ext[234]. which gets the new block group used
for inode allocations using get_random_bytes), then prandom_u32()
should be used instead of get_random_bytes() to save CPU overhead and
to reduce the drain on the /dev/urandom's entropy pool.

Typically, the reason for this is either for historical reasons, since
prandom_u32() hadn't existed when the code was written, or because
historical code was cut and pasted into newer code.

When I came across staging/lustre/lustre/libcfs/prng.c, I saw
something which is **really** weird.  It defines a cfs_rand() which is
functionally identical to prandom_u32().  More puzzlingly, it also
defines cfs_get_random_bytes() which calls get_random_bytes() and then
xor's the result with cfs_rand().  That last step has no cryptographic
effect, so I'm really wondering who thought this as a good idea and/or
necessary.

What I think should happen is that staging/lustre/lustre/libcfs/prng.c
should be removed, and calls to cfs_rand() should get replaced
prandom_u32(), and cfs_get_random_bytes() should get replaced with
get_random_bytes().

Does this sound reasonable?

Cheers,

						- Ted
