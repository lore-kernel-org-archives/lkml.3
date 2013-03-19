Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3CSBiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:38:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3CSBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:38:14 -0400
Date: Tue, 19 Mar 2013 01:38:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130319013805.GG21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130318230103.GF21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318230103.GF21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:01:03PM +0000, Al Viro wrote:

> I'm looking at the existing callers and I really wonder if we ought to
> push sb_start_write() from ->splice_write()/->aio_write()/etc. into the
> callers.
> 
> Something like file_start_write()/file_end_write(), with check for file
> being regular one might be a good starting point.  As it is, copyup is
> really fucked both in unionmount and overlayfs...

BTW, I wonder what's the right locking for that sucker; overlayfs is probably
too heavy - we are talking about copying a file from one fs to another, which
can obviously take quite a while, so holding ->i_mutex on _parent_ all along
is asking for very serious contention.  OTOH, there's a pile of unpleasant
races that need to be dealt with; consider e.g. chmod("lower_file", 0644) vs.
unlink("lower_file").  The former means creating a copy of lower_file in the
covering layer (and chmod of that copy once it's finished).  The latter
means creating a whiteout in the covering layer.  No matter which comes first,
the result *must* be whiteout in directory + no stray copies left in covering
layer.  chmod() may legitimately return -ENOENT or 0, but resulting state of
fs is unambiguous.  Holding ->i_mutex on parent would, of course, suffice to
serialize them, but it's not particulary nice thing to do wrt contention.

Another fun issue is copyup vs. copyup - we want to sit and wait for copyup
attempt in progress to complete, rather than start another one in parallel.
And whoever comes the second must check if copyup has succeeded, obviously -
it's possible to have user run into 5% limit and fail copyup, followed by
root doing it successfully.

Another one: overwriting rename() vs. copyup.  Similar to unlink() vs. copyup().

Another one: read-only open() vs. copyup().  Hell knows - we obviously don't
want to open a partially copied file; might want to wait or pretend that this
open() has come first and give it the underlying file.  The same goes for
stat() vs. copyup().

FWIW, something like "lock parent, ->create(), ->unlink(), unlock parent,
copy data and metadata, lock parent, allocate a new dentry in covering layer
and do ->lookup() on it, verify that it is negative and not a whiteout, lock
child, use ->link() to put it into directory, unlock everything" would
probably DTRT for unlink/copyup and rename/copyup.  The rest... hell knows;
->i_mutex on child is a non-starter, since we couldn't use the normal ->write()
or ->splice_write() under it.  One possibility is to allocate a structure for
copyup in progress, make it easily located (hash by lower dentry/upper sb
pair) and serialize on that.  Hell knows...

One potential unpleasantness here is dcache lookup coming between ->create()
and ->unlink(); OTOH, there had been fairly reasonable requests for something
like atomic combination of open and unlink and it's not like _that_ would be
hard to implement as a new method - pretty much everything local could just
take part of ->create() and that would be it.  Which might make sense on its
own - open() flag creating a new temporary file, unlinked from the very
beginning and thus killed when we close the damn thing.  Objections?
