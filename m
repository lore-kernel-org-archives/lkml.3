Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3A2Nly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:41:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3A2Nlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:41:50 -0500
Date: Tue, 29 Jan 2013 14:41:39 +0100
From: Jan Kara <jack@suse.cz>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz, tytso@mit.edu,
        Valdis.Kletnieks@vt.edu, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, zab@zabbo.net, linux-fsdevel@vger.kernel.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-ID: <20130129134139.GD32246@quack.suse.cz>
References: <3544.1358774694@turing-police.cc.vt.edu>
 <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
 <2553.1358890098@turing-police.cc.vt.edu>
 <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
 <13450.1359048141@turing-police.cc.vt.edu>
 <20130124211850.GH26407@google.com>
 <20130124132759.c892fb4c.akpm@linux-foundation.org>
 <20130124221352.GK26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124221352.GK26407@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-01-13 14:13:52, Kent Overstreet wrote:
> On Thu, Jan 24, 2013 at 01:27:59PM -0800, Andrew Morton wrote:
> > Please also take a look at Jan's recent
> > http://www.spinics.net/lists/linux-fsdevel/msg61738.html and have a
> > think about how this plays with your patchset.
> 
> I can't think of any possible interactions - none of my aio stuff messes
> with the way the fput() happens; the aio code does call fput() when the
> kiocb is freed and my patches do touch _that_ code but none of the
> behaviour there changes.
> 
> Might be worth documenting this though, I can't think of any reason it'd
> be obvious looking at the aio code that the fput() has to happen after
> aio_complete(). As with the bugs I just sent you patches for it's not
> terribly clear who owns what in the kiocb when.
> 
> Reading those patches though - the main change is to call
> inode_dio_done() before calling aio_complete(). All inode_dio_done()
> does though is issue a wakeup - to whatever called inode_dio_wait().
  inode_dio_done() does a decrement and wakeup.

> That means whatever called inode_dio_wait() needs its own ref on the
> inode, and from a cursory glance at the code it is _not_ at all clear to
> me that's the case - if inode_dio_wait() is merely finishing things for
> that specific IO that need to be done in process context, I can easily
> imagine it not being the case.
> 
> Assuming whatever does call inode_dio_wait() does have its own ref,
> there was only a real use after free when nothing was waiting on the
> inode.
  Well, but there doesn't have to be any waiter... If there is, it had
better have it's own ref, that's for sure.

> Similarly for the ext4 code to write unwritten extents - and having seen
> and helped chase a bug in that code before, that code _definitely_ needs
> auditing.
  Agreed. That code is a mess. I'm cleaning up some of it but it's not
easy.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
