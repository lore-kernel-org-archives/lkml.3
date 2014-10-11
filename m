Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaJKXqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 19:46:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34222 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 19:46:37 -0400
Date: Sun, 12 Oct 2014 00:46:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141011234635.GL7996@ZenIV.linux.org.uk>
References: <20141011225808.GA20777@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011225808.GA20777@zzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 05:58:08PM -0500, Eric Biggers wrote:

> In follow_dotdot_rcu(), said commit moved loads of the inode to just before
> read_seqcount_begin(), in several instances.  I don't think this is correct,
> because (as I understand it) read_seqcount_begin() is opening a seq-read
> critical section on the new dentry.  So the inode load should come *after* it,
> as in the original, to ensure the inode pointer is correctly matched with the
> sequence count.

Nope.  What we do is
	* pick parent inode and seqcount (in whatever order)
	* THEN check that child is still unchanged.
The second part guarantees that parent dentry had been the parent of
child all along, since the moment we'd first fetched _child's_ seqcount.
And since a pinned positive dentry can't have its ->d_inode changed,
we know that the value of parent's inode we'd fetched remained valid
at least until we'd checked the child's seqcount and found it unchanged.
Which means that we had it valid at some point after we'd fetched parent's
seqcount.

The crucial part is that dentry cannot change its ->d_inode for as long as
there are references to it.
