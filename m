Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab3B0A2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:28:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53305 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab3B0A17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:27:59 -0500
Date: Wed, 27 Feb 2013 00:27:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Jackson <mpfj-list@mimc.co.uk>, linux-next@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: JFFS2 deadlock
Message-ID: <20130227002755.GL4503@ZenIV.linux.org.uk>
References: <512CA290.6050509@mimc.co.uk>
 <20130227101704.90466ae6df78ab9b3aa4ba22@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227101704.90466ae6df78ab9b3aa4ba22@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:17:04AM +1100, Stephen Rothwell wrote:
> Hi Mark,
> 
> On Tue, 26 Feb 2013 11:54:56 +0000 Mark Jackson <mpfj-list@mimc.co.uk> wrote:
> >
> > Just tested the current next-20130226 on a custom AM335X board, and I received the JFFS2 deadlock shown below.
> 
> Is this new today?  is it reproducible? Does if ail for Linus' tree?
> 
> Al, could this be something to do with the new stuff in the vfs tree?

Very unlikely.  jffs2_readdir() does, indeed, grab ->sem on the inode in
question and then calls the callback (which might fault, grabbing ->mmap_sem).
Had been doing that all along.  And if the userland area we are doing
getdents(2) into had been mmapped from jffs2 file, jffs2_readpage() would
be called, which would grab ->sem on the inode of file mmaped in there.
Again, that had been going on all along.  Unlike the situation with ->i_mutex,
this one is probably a false positive - ->sem on directories nests outside of
->mmap_sem, ->sem on non-directories - inside.  But that false positive
shouldn't be something new; hell, both paths are present in 2.6.12 with
the lock orders as in the current tree (except that ->sem used to be
a semaphore instead of a mutex).
