Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422803Ab3CVSVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:21:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42684 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422649Ab3CVSVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:21:20 -0400
Date: Fri, 22 Mar 2013 18:21:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        jack@suse.cz, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130322182107.GQ21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <13789.1363973875@jrobl>
 <20130322181111.GP21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322181111.GP21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 06:11:11PM +0000, Al Viro wrote:
> On Sat, Mar 23, 2013 at 02:37:55AM +0900, J. R. Okajima wrote:
> > 
> > David Howells:
> > > Now, looking at __sb_start_write(), I'm not entirely sure how the deadlock
> > > might operate, so it's possible that this is a false alarm.  Maybe Jan Kara can
> > > illuminate further, so I've added him to the cc list.
> > 
> > It is related to the design of UnionMount, isn't it?
> > UnionMount is not a filesystem and doen't have its own superblock.
> > If it was a fs, then
> > - vfs_truncate() acquires sb_writers for the unioning-fs.
> > - the unioning-fs may call vfs_truncate() again for the underlying fs.
> > - this time, sb_writers is for the underlying fs which is a different
> >   sb_writers object from the already acquired one.
> > So there would be no deadlock.
> 
> Doesn't help the situation with copyup - witness overlayfs stepping into the
> same deadlock on copyup.  It wants ->i_mutex held on directory in upper layer
> and it tries to write to file it has created in there.  The problem is
> with the upper layer superblock getting frozen; having a separate one for
> union is irrelevant.  Let me check how aufs does...  Aha.  Your
> au_do_copy_file() ends up calling vfs_write() on the file opened in
> upper layer.  And AFAICS it's called with ->i_mutex held on the directory
> in upper layer, so you've got the same deadlock, sorry.

The scenario, BTW, looks so:
process A does sb_start_write() (on your upper layer)
process B tries to freeze said upper layer and blocks, waiting for A to finish
process C grabs ->i_mutex in your upper layer
process C does vfs_write(), which blocks, since there's a pending attempt to
freeze
process A tries to grab ->i_mutex held by C and blocks
