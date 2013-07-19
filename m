Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab3GSHtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:49:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965303Ab3GSHtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:49:40 -0400
Date: Fri, 19 Jul 2013 08:49:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] f2fs: update file name in the inode block during
 f2fs_rename
Message-ID: <20130719074937.GD4165@ZenIV.linux.org.uk>
References: <1374138684-28520-1-git-send-email-jaegeuk.kim@samsung.com>
 <20130718092211.GA4165@ZenIV.linux.org.uk>
 <CAOtxgyetWtucBEQJmCU0nLNk9_r42yQSC1+X1i+iHM18rDge+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtxgyetWtucBEQJmCU0nLNk9_r42yQSC1+X1i+iHM18rDge+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:40:47PM +0900, Kim Jaegeuk wrote:
> Hi,
> 
> 2013. 7. 18. ???? 6:22?? "Al Viro" <viro@zeniv.linux.org.uk>???? ????:
> >
> > On Thu, Jul 18, 2013 at 06:11:23PM +0900, Jaegeuk Kim wrote:
> > > The error is reproducible by:
> > >
> > > After this, when we retrieve the inode->i_name of test2 by dump.f2fs,
> we get
> > > test1 instead of test2.
> > > This is because f2fs didn't update the file name during the f2fs_rename.
> >
> > Er...  Correct me if I'm wrong, but f2fs appears to support link(2) and
> > if rename(2) creates some problem for dump.f2fs, I would expect an
> > equivalent link()+unlink() combination to do the same...
> 
> Right. I will check that too.
> Thank you. :)

You do realize that having unlink() hunt for the surviving links would be
both very costly and painful wrt locking, right?

The real question is, what are the warranties for that ->i_name thing?
What should it be while there are multiple links?  Matter of fact,
after looking at the users... What about ->i_pino in the same scenario
(link+unlink instead of rename)?

BTW, while looking at i_pino... Why does get_parent_ino() bother with
igrab/iput?  If you have found an alias, just use parent_ino(dentry)
and be done with that - as it is, you have a race with d_move() there,
so you'd need to reproduce parent_ino() locking anyway (->d_lock on
dentry holds d_move() away and stabilizes ->d_parent->d_inode)
