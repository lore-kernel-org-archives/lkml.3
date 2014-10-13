Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaJMCPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:15:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36323 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaJMCPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:15:01 -0400
Date: Mon, 13 Oct 2014 03:14:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: WTF is d_add_ci() doing with negative dentries?
Message-ID: <20141013021459.GW7996@ZenIV.linux.org.uk>
References: <20141012221817.GU7996@ZenIV.linux.org.uk>
 <318CCEE2-9EBE-4696-8DE9-7297CDCE207D@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <318CCEE2-9EBE-4696-8DE9-7297CDCE207D@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 12:56:11AM +0100, Anton Altaparmakov wrote:

> I am just wondering whether there might be error conditions in which we might end up with a (perhaps invalid) negative dentry in memory which could be found here?  Probably not a problem especially now that d_invalidate() cannot fail any more.

Huh?  Failing d_invalidate() on _negative_ dentry is flat-out impossible;
it would be dropped just fine, and we wouldn't have found it in the first
place.  Check what it used to do all way back to 2.2.0:
        if (dentry->d_count) {
                if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode))
                        return -EBUSY;
        }

So unless you care about 2.1.something (2.0 didn't have dcache at all),
this scenario isn't possible.

In any case, d_add_ci() users that might have negative dentries become
positive cannot afford hashed negative dentries at all - at the very
least they need to treat them as invalid in ->d_revalidate() in such
situations.  Exactly because having a hashed valid negative dentry for
FuBaR after e.g.  mkdir fubar will really hurt - mkdir won't have any way
to know that old dentry was there; there was no variant of fubar in directory
prior to that mkdir (FuBaR _was_ negative) and there's nothing to suggest
looking for it.  So it won't be noticed and it'll bloody well stay negative
and hashed.  I.e. stat FuBaR; mkdir fubar; stat FuBaR will have the second
stat find dentry still hashed and valid negative.

You can get away with that if you store something like timestamp[1] of
the parent directory in those negative dentries and check that in
->d_revalidate().  But that will work just fine, since d_add_ci() is
serialized by ->i_mutex held on parent and whatever it was that added your
"exact spelling" into directory has made all preexisting negative dentries
invalid...

[1] for arbitrary values of time - e.g.
	on positive lookup set ->d_time to 0
	on negative lookup set ->d_time to that of parent dentry
	on mkdir set ->d_time to 0
	on unlink, rmdir and rename victim copy ->d_time from parent dentry
	on any directory modification bump its ->d_time
	on d_revalidate of negative dentry compare ->d_time with that of parent
	dentry and declare invalid on mismatch
will do just fine.
