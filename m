Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaJLEhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:37:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34511 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaJLEhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:37:38 -0400
Date: Sun, 12 Oct 2014 05:37:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012043737.GO7996@ZenIV.linux.org.uk>
References: <20141011225808.GA20777@zzz>
 <20141012001259.GM7996@ZenIV.linux.org.uk>
 <20141012040142.GB24463@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012040142.GB24463@zzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 11:01:42PM -0500, Eric Biggers wrote:
> On Sun, Oct 12, 2014 at 01:12:59AM +0100, Al Viro wrote:
> > 
> > Huh?  What's to guarantee that dentry hasn't become negative since the
> > moment we'd fetched the seqcount?  _That_ is the problem we are dealing
> > with here - link_path_walk() relies on nd->inode being non-NULL.
> 
> Hmm, I guess that makes sense.  So the code is actually verifying that the inode
> is still the inode that was referenced from the current or root directory when
> nd->path was set.  But couldn't the problem also be solved by setting nd->inode
> directly in the fs->seq retry loops?

Gets clumsy in set_root_rcu() - you do *not* want it to bugger nd->inode
when done by follow_dotdot_rcu(), so we'd need either some indication which
caller it is, or something like struct inode **inode in argument list,
with NULL passed from follow_dotdot_rcu(), while path_init() would give
it &nd->inode...

Doable, but unpleasant.  And the price of that check is trivial - after all,
in case we *don't* bugger off immediately, we have that ->d_seq in cache -
we'd fetched it just before.
