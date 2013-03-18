Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3CRPjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:39:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3CRPjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:39:40 -0400
Date: Mon, 18 Mar 2013 16:39:36 +0100
From: Jan Kara <jack@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130318153936.GB28508@quack.suse.cz>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1944.1363525619@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 17-03-13 13:06:59, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Export do_splice_direct() to modules.  Needed by overlay filesystem.
> 
> Apparently you cannot call this from any function that is holding an i_mutex
> if the target of the splice uses generic_file_splice_write().
> 
> The problem is a potential deadlock situation:
> 
> We have places already that do:
> 
> 	mnt_want_write()
> 	mutex_lock()
> 
> This can be found in do_last() for example.
> 
> However, mnt_want_write() calls sb_start_write() as does
> generic_file_splice_write().  So now in ovl_copy_up_locked() you're adding:
> 
> 	mutex_lock()
> 	sb_start_write()
> 
> which lockdep reports as a potential ABBA deadlock.
> 
> Now, looking at __sb_start_write(), I'm not entirely sure how the deadlock
> might operate, so it's possible that this is a false alarm.  Maybe Jan Kara can
> illuminate further, so I've added him to the cc list.
  IMO the deadlock is real. In freeze_super() we wait for all writers to
the filesystem to finish while blocking beginning of any further writes. So
we have a deadlock scenario like:

  THREAD1		THREAD2				THREAD3
mnt_want_write()	mutex_lock(&inode->i_mutex);
...							freeze_super()
block on mutex_lock(&inode->i_mutex)
							  sb_wait_write(sb, SB_FREEZE_WRITE);
			block in sb_start_write()

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
