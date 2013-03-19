Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3CSJAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:00:44 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:48746 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3CSJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:00:42 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com, mszeredi@suse.cz
In-Reply-To: <20130319013805.GG21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk> <20130318153936.GB28508@quack.suse.cz> <20130318215333.GE21522@ZenIV.linux.org.uk> <20130318230103.GF21522@ZenIV.linux.org.uk> <20130319013805.GG21522@ZenIV.linux.org.uk>
Date: Tue, 19 Mar 2013 18:00:37 +0900
Message-ID: <20556.1363683637@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> BTW, I wonder what's the right locking for that sucker; overlayfs is probably
> too heavy - we are talking about copying a file from one fs to another, which
> can obviously take quite a while, so holding ->i_mutex on _parent_ all along
> is asking for very serious contention.  OTOH, there's a pile of unpleasant

Yes, holding parent->i_mutex can be longer.
Using splice function for copy-up is simple and (probably) fastest. But
it doesn't support a "hole" in the file (sparse file). All holes are
filled with NUL byte and consumes a disk block on the upper layer. It is
a problem, especially for users who have smaller tmpfs as his upper
layer.
The copy-up with considering a hole may cost more, but it can save the
storage consumtion.


> Another fun issue is copyup vs. copyup - we want to sit and wait for copyup
> attempt in progress to complete, rather than start another one in parallel.
> And whoever comes the second must check if copyup has succeeded, obviously -
> it's possible to have user run into 5% limit and fail copyup, followed by
> root doing it successfully.

"5% limit" means the reserved are for a superuser on a filesystem,
right? As far as I know, overlayfs (UnionMount too?) solves this problem
as changing the task credential and the capability. But I am not sure
whether it solves the similar problem around the resource limit like
RLIMIT_CPU, RLIMIT_FSIZE or something.


> Another one: overwriting rename() vs. copyup.  Similar to unlink() vs. copyup().

Hmm, do you mean that, just after the parent dir lock on the underlying
fs, the copyup routine should confirm whether the target is still alive?
If so, I agree.


> Another one: read-only open() vs. copyup().  Hell knows - we obviously don't
> want to open a partially copied file; might want to wait or pretend that this
> open() has come first and give it the underlying file.  The same goes for
> stat() vs. copyup().

Exactly.
Moreover users don't want to refer to the lower file which is obsoleted
by copyup.


> FWIW, something like "lock parent, ->create(), ->unlink(), unlock parent,
> copy data and metadata, lock parent, allocate a new dentry in covering layer
> and do ->lookup() on it, verify that it is negative and not a whiteout, lock
> child, use ->link() to put it into directory, unlock everything" would
> probably DTRT for unlink/copyup and rename/copyup.  The rest... hell knows;

Please let me make sure.
You are saying,
- create the file on the upper layer
- get the "struct file" object
- hide it from users
- before copying the file, unlock the parent in order to stop the long
  period locking
- copy the file without the parent lock. it doesn't matter since the
  file is invisible to users.
- confirm that the target name is still available for copyup
- make the completed file visible by ->link()

It is ineteresting to ->link() with the unlinked file. While
vfs_unlink() rejects such case, it may not matter for the underlying fs.
Need to verify FS including jounals.


J. R. Okajima
