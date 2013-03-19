Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab3CSUZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:25:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab3CSUZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:25:46 -0400
Date: Tue, 19 Mar 2013 21:25:43 +0100
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
Message-ID: <20130319202543.GF5222@quack.suse.cz>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318215333.GE21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 21:53:34, Al Viro wrote:
> On Mon, Mar 18, 2013 at 04:39:36PM +0100, Jan Kara wrote:
> >   IMO the deadlock is real. In freeze_super() we wait for all writers to
> > the filesystem to finish while blocking beginning of any further writes. So
> > we have a deadlock scenario like:
> > 
> >   THREAD1		THREAD2				THREAD3
> > mnt_want_write()	mutex_lock(&inode->i_mutex);
> > ...							freeze_super()
> > block on mutex_lock(&inode->i_mutex)
> > 							  sb_wait_write(sb, SB_FREEZE_WRITE);
> > 			block in sb_start_write()
> 
> The bug is on fsfreeze side and this is not the only problem related to it.
> I've missed the implications when I applied "fs: Add freezing handling
> to mnt_want_write() / mnt_drop_write()" last June ;-/
> 
> The thing is, until then mnt_want_write() used to be a counter; it could be
> nested.  Now any such nesting is a deadlock you've just described.  This
> is seriously wrong, IMO.
  Well, but sb_start_write() has to be blocking (blocks when fs is frozen)
and you have to get it somewhere. It seems only natural to get the counter
from original mnt_want_write() at the same place and use one function for
that. Whether I should have changed the name from mnt_want_write() to
something else is questionable...

> BTW, having sb_start_write() buried in individual ->splice_write() is
> asking for trouble; could you describe the rules for that?  E.g. where
> does it nest wrt filesystem-private locks?  XFS iolock, for example...
  Generally, the freeze protection should be the outermost lock taken (so
that we mitigate possibility of blocking readers when waiting for fs to
unfreeze). So it ranks above i_mutex, or XFS' ilock and iolock.

It seems that I screwed this up for ->splice_write() :-| If we are going to
move out sb_start_write() out of filesystems' hands into do_splice_from()
then we should likely do the same with ->aio_write(). Hmm?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
