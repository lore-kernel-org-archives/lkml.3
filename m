Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3CTVsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:48:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47821 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3CTVsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:48:21 -0400
Date: Wed, 20 Mar 2013 21:48:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130320214813.GS21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130319202543.GF5222@quack.suse.cz>
 <20130319213831.GK21522@ZenIV.linux.org.uk>
 <20130319221032.GL21522@ZenIV.linux.org.uk>
 <20130320023308.GM21522@ZenIV.linux.org.uk>
 <20130320195222.GG13294@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320195222.GG13294@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 08:52:22PM +0100, Jan Kara wrote:
> > do_bio_filebacked(), with some ugliness between that and callsite.  Note,
> > BTW, that we have a pair of possible vfs_fsync() calls in there; how do those
> > interact with freeze?
>   Freezing code takes care that all dirty data is synced before fs is
> frozen and no new dirty data can be created before fs is thawed. So
> vfs_fsync() should just return without doing anything on frozen filesystem.

Um...  How does it interact with vfs_fsync() already in progress when you
ask to freeze it?

Anyway, I've pulled the fscker out of ->aio_write, ->write and ->splice_write;
on that pathway it's in the do_splice_from() (see vfs.git#experimental).

... and now, for something *really* nasty: where do mandatory file locks
belong in the locking hierarchy?  Relative to fsfreeze one, for starters,
but both for unionmount and overlayfs we need to decide where they live
relative to ->i_mutex on directories.

And that, BTW, may be the strongest argument so far in favour of the scheme
I'd suggested for copyup-via-opened-but-unlinked...
