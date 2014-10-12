Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaJLDzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 23:55:17 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:51607 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaJLDzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 23:55:14 -0400
Date: Sat, 11 Oct 2014 22:55:10 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012035510.GA24463@zzz>
References: <20141011225808.GA20777@zzz>
 <20141011234635.GL7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011234635.GL7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 12:46:35AM +0100, Al Viro wrote:
> 
> Nope.  What we do is
> 	* pick parent inode and seqcount (in whatever order)
> 	* THEN check that child is still unchanged.
> The second part guarantees that parent dentry had been the parent of
> child all along, since the moment we'd first fetched _child's_ seqcount.
> And since a pinned positive dentry can't have its ->d_inode changed,
> we know that the value of parent's inode we'd fetched remained valid
> at least until we'd checked the child's seqcount and found it unchanged.
> Which means that we had it valid at some point after we'd fetched parent's
> seqcount.

Ah, very tricky.  And I take it that the other two fetches of d_inode in
follow_dotdot_rcu() can likewise be unordered with respect to
read_seqcount_begin(), because the underlying dentries are pinned as either
mnt_mountpoint or mnt_root ---  which in RCU mode, is only guaranteed because of
the call to synchronize_rcu() in namespace_unlock() prior to dropping
references?
