Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab3CSWKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:10:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3CSWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:10:42 -0400
Date: Tue, 19 Mar 2013 22:10:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130319221032.GL21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130319202543.GF5222@quack.suse.cz>
 <20130319213831.GK21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319213831.GK21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 09:38:31PM +0000, Al Viro wrote:
> On Tue, Mar 19, 2013 at 09:25:43PM +0100, Jan Kara wrote:
> > > BTW, having sb_start_write() buried in individual ->splice_write() is
> > > asking for trouble; could you describe the rules for that?  E.g. where
> > > does it nest wrt filesystem-private locks?  XFS iolock, for example...
> >   Generally, the freeze protection should be the outermost lock taken (so
> > that we mitigate possibility of blocking readers when waiting for fs to
> > unfreeze). So it ranks above i_mutex, or XFS' ilock and iolock.
> 
> Welcome to deadlock, then:
> xfs_file_splice_write()
> ...
>         xfs_ilock(ip, XFS_IOLOCK_EXCL);
> ...
>         ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
> 
> > It seems that I screwed this up for ->splice_write() :-| If we are going to
> > move out sb_start_write() out of filesystems' hands into do_splice_from()
> > then we should likely do the same with ->aio_write(). Hmm?

... and then there's ext4_file_dio_write(), which cheerfully ignores freeze.
... and udf expanding from inline files to separately allocated before it
gets to sb_start_write()
... and a bunch of guys doing generic_write_sync() after generic_aio_file_write()
... and a lot of other fun stuff.  Ouch...

OK, it's going to be an interesting series - aforementioned tentative patch
was badly incomplete ;-/
