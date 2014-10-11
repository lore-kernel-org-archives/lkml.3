Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaJKW6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 18:58:12 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34247 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 18:58:11 -0400
Date: Sat, 11 Oct 2014 17:58:08 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141011225808.GA20777@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've been reading through the path lookup code and I believe there may have
been bugs introduced by commit 4023bfc9 ("be careful with nd->inode in
path_init() and follow_dotdot_rcu()").  And I may have found a pre-existing bug
as well.

In follow_dotdot_rcu(), said commit moved loads of the inode to just before
read_seqcount_begin(), in several instances.  I don't think this is correct,
because (as I understand it) read_seqcount_begin() is opening a seq-read
critical section on the new dentry.  So the inode load should come *after* it,
as in the original, to ensure the inode pointer is correctly matched with the
sequence count.

In path_init(), said commit added a call to read_seqcount_retry() after loading
the inode.  I see two problems with this:

  - The read_seqcount_retry() isn't needed just to load the inode pointer, so
    the change doesn't seem to accomplish anything.
  - If the -ECHILD code path actually runs, the reference to the 'struct file'
    can be leaked.

Also: if there were actual problems that were "fixed" by this commit, I wonder
if they were/are actually caused by the fd-relative case in path_init() using:

	nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);

instead of

	nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);

since the former is missing a memory barrier before the starting inode is
loaded.

Eric
