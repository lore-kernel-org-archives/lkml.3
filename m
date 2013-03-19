Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab3CSRDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:03:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42492 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3CSRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:03:36 -0400
Date: Tue, 19 Mar 2013 17:03:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130319170324.GI21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130318230103.GF21522@ZenIV.linux.org.uk>
 <20130319013805.GG21522@ZenIV.linux.org.uk>
 <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:29:41AM +0100, Miklos Szeredi wrote:

> Copy up is a once-in-a-lifetime event for an object.  Optimizing it is
> way down in the list of things to do.  I'd drop splice in a jiffy if
> it's in the way.

What makes you think that write is any better?  Same deadlock there - check
generic_file_aio_write(), it calls the same sb_start_write()...  IOW,
switching from splice to write won't help at all.

> Much more interesting question:  what happens if we crash during a
> rename?  Whiteout implemented in the filesystem won't save us.  And
> the results are interesting: old versions of files become visible and
> similar fun.  Far from likely to happen, but ...
> 
> Add a rename-with-whiteout primitive on filesystems?  That one is not
> going to be as simple as plain whiteout.  Or?

Umm...  If/when we start caring about that kind of atomicity (and I agree
that we ought to) overlayfs approach to whiteouts will actually have much
harder time - it doesn't take much to teach a journalling fs how to do that
kind of ->rename() in a single transaction; the only question is how to tell
it that we want to leave a whiteout behind us.  Hell knows; one variant is
to add a flag, of course.  Another might be more interesting - we want some
kind of "directory is opaque" flag, so if we start reshuffling the methods,
we might try to merge unlink/rmdir/whiteout.  Rules:
	* victim is negative => create a whiteout
	* victim is a directory, parent opaque => rmdir
	* victim is a non-directory, parent opaque => unlink
	* victim is positive, parent _not_ opaque => replace with whiteout
	* old_dir in case of ->rename() is opaque => normal rename
	* old_dir in case of ->rename() is not opaque => leave whiteout behind
Non-unioned => opaque, of course (nothing showing through it).

Getting good behaviour on rename interrupted by crash is going to be _very_
tricky with any strategy other than whiteouts-in-fs, AFAICS.

Again, I have no problem whatsoever with changing the set of directory
methods, as long as the replacement is sane.  We'd done that kind of thing
before and it's not a problem.
