Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3CRXBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:01:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3CRXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:01:14 -0400
Date: Mon, 18 Mar 2013 23:01:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130318230103.GF21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318215333.GE21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:53:34PM +0000, Al Viro wrote:
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
> 
> BTW, having sb_start_write() buried in individual ->splice_write() is
> asking for trouble; could you describe the rules for that?  E.g. where
> does it nest wrt filesystem-private locks?  XFS iolock, for example...

I'm looking at the existing callers and I really wonder if we ought to
push sb_start_write() from ->splice_write()/->aio_write()/etc. into the
callers.

Something like file_start_write()/file_end_write(), with check for file
being regular one might be a good starting point.  As it is, copyup is
really fucked both in unionmount and overlayfs...
