Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3CWEl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:41:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3CWEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:41:56 -0400
Date: Sat, 23 Mar 2013 04:41:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        jack@suse.cz, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130323044140.GS21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <13789.1363973875@jrobl>
 <20130322181111.GP21522@ZenIV.linux.org.uk>
 <20130322182107.GQ21522@ZenIV.linux.org.uk>
 <23399.1364006951@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23399.1364006951@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 11:49:11AM +0900, J. R. Okajima wrote:
> 
> Al Viro:
> > The scenario, BTW, looks so:
> > process A does sb_start_write() (on your upper layer)
> > process B tries to freeze said upper layer and blocks, waiting for A to finish
> > process C grabs ->i_mutex in your upper layer
> > process C does vfs_write(), which blocks, since there's a pending attempt to
> > freeze
> > process A tries to grab ->i_mutex held by C and blocks
> 
> According to latest mm/filemap.c:generic_file_aio_write(),
> 	sb_start_write(inode->i_sb);
> 	mutex_lock(&inode->i_mutex);
> 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> 	mutex_unlock(&inode->i_mutex);
> 	:::
> 	sb_end_write(inode->i_sb);
> 
> Process C would block *BEFORE* i_mutex by sb_start_write()? No?

Different ->i_mutex; you are holding one on the parent directory already.

That's the problem - you have ->i_mutex nested both inside that sucker (as
it ought to) and outside.  Which tends to do bad things, obviously, in
particular because something like mkdir(2) will do sb_start_write() (from
mnt_want_write(), called by kern_path_create()) before grabbing directory
->i_mutex.

Thus the activity with lifting the bastard out of ->aio_write(), etc. in
vfs.git#experimental - *any* union-like variant will need the ability to
pull sb_start_write() outside of locking the parent directory on copyup.
And yes, it's a common prerequisite to anything doing copyups - aufs is
in the same boat as overlayfs and unionmount.  Same deadlock for all three
of them.
