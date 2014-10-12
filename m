Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaJLE3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:29:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34502 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaJLE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:29:27 -0400
Date: Sun, 12 Oct 2014 05:29:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012042925.GN7996@ZenIV.linux.org.uk>
References: <20141011225808.GA20777@zzz>
 <20141011234635.GL7996@ZenIV.linux.org.uk>
 <20141012035510.GA24463@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012035510.GA24463@zzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 10:55:10PM -0500, Eric Biggers wrote:
> On Sun, Oct 12, 2014 at 12:46:35AM +0100, Al Viro wrote:
> > 
> > Nope.  What we do is
> > 	* pick parent inode and seqcount (in whatever order)
> > 	* THEN check that child is still unchanged.
> > The second part guarantees that parent dentry had been the parent of
> > child all along, since the moment we'd first fetched _child's_ seqcount.
> > And since a pinned positive dentry can't have its ->d_inode changed,
> > we know that the value of parent's inode we'd fetched remained valid
> > at least until we'd checked the child's seqcount and found it unchanged.
> > Which means that we had it valid at some point after we'd fetched parent's
> > seqcount.
> 
> Ah, very tricky.  And I take it that the other two fetches of d_inode in
> follow_dotdot_rcu() can likewise be unordered with respect to
> read_seqcount_begin(), because the underlying dentries are pinned as either
> mnt_mountpoint or mnt_root ---  which in RCU mode, is only guaranteed because of
> the call to synchronize_rcu() in namespace_unlock() prior to dropping
> references?

The last one is actually covered by read_seqretry(&mount_lock, nd->m_seq) -
if it still matches, we know that whatever we got from __lookup_mnt() must
have been valid through fetching ->d_inode and ->d_seq of its mnt_root.
Which means that those two are consistent regardless of that synchronize_rcu().

The one before it would probably be better off with similar check on mount_lock
as well.  That code *is* correct for the reason you've mentioned, but I wonder
if explicit check of mount_lock would be better - right now it's more subtle
than I'd like it to be.  I don't think the cost would be noticable - it's
smp_rmb() + fetch + comparison when we cross a mountpoint while following ..
in lazy pathwalk, but that needs profiling - handwaving is not good enough...
