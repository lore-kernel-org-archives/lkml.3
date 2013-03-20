Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3CTWTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:19:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3CTWTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:19:06 -0400
Date: Wed, 20 Mar 2013 23:19:02 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130320221902.GA28432@quack.suse.cz>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130319202543.GF5222@quack.suse.cz>
 <20130319213831.GK21522@ZenIV.linux.org.uk>
 <20130319221032.GL21522@ZenIV.linux.org.uk>
 <20130320023308.GM21522@ZenIV.linux.org.uk>
 <20130320195222.GG13294@quack.suse.cz>
 <20130320214813.GS21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320214813.GS21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-03-13 21:48:13, Al Viro wrote:
> On Wed, Mar 20, 2013 at 08:52:22PM +0100, Jan Kara wrote:
> > > do_bio_filebacked(), with some ugliness between that and callsite.  Note,
> > > BTW, that we have a pair of possible vfs_fsync() calls in there; how do those
> > > interact with freeze?
> >   Freezing code takes care that all dirty data is synced before fs is
> > frozen and no new dirty data can be created before fs is thawed. So
> > vfs_fsync() should just return without doing anything on frozen filesystem.
> 
> Um...  How does it interact with vfs_fsync() already in progress when you
> ask to freeze it?
  So the exact sequence of freezing is:
	sb->s_writers.frozen = SB_FREEZE_WRITE;
        smp_wmb();
        sb_wait_write(sb, SB_FREEZE_WRITE);
Now there are no processes in sb_start_write() - sb_end_write() section.
Then we do the same for SB_FREEZE_PAGEFAULT. After this noone should be
able to dirty a page or inode. Writeback or vfs_fsync() may be still
running (so fs can be creating new transactions in the journal for
writeback etc.).
	sync_filesystem(sb);
After this there should be no dirty data so although we can still be
somewhere inside vfs_fsync() it should have nothing to do.

Now we freeze to state SB_FREEZE_FS (nop for ext4, but for XFS it may
interact e.g. with inode reclaim trimming preallocated blocks) and we are
done.
 
> Anyway, I've pulled the fscker out of ->aio_write, ->write and ->splice_write;
> on that pathway it's in the do_splice_from() (see vfs.git#experimental).
> 
> ... and now, for something *really* nasty: where do mandatory file locks
> belong in the locking hierarchy?  Relative to fsfreeze one, for starters,
> but both for unionmount and overlayfs we need to decide where they live
> relative to ->i_mutex on directories.
  Hum, interesting question :). Relative to fsfreeze, it doesn't seem to
matter much, does it? We don't actually lock / unlock these from write
paths needing freeze protection, we only wait for them. But maybe I miss
some ugly case you have in mind.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
