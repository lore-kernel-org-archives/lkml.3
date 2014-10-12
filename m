Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaJLEwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:52:04 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42301 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaJLEvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:51:40 -0400
Date: Sat, 11 Oct 2014 23:51:42 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012045142.GC24463@zzz>
References: <20141011225808.GA20777@zzz>
 <20141012001259.GM7996@ZenIV.linux.org.uk>
 <20141012040142.GB24463@zzz>
 <20141012043737.GO7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012043737.GO7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 05:37:37AM +0100, Al Viro wrote:
> 
> Gets clumsy in set_root_rcu() - you do *not* want it to bugger nd->inode
> when done by follow_dotdot_rcu(), so we'd need either some indication which
> caller it is, or something like struct inode **inode in argument list,
> with NULL passed from follow_dotdot_rcu(), while path_init() would give
> it &nd->inode...
> 
> Doable, but unpleasant.  And the price of that check is trivial - after all,
> in case we *don't* bugger off immediately, we have that ->d_seq in cache -
> we'd fetched it just before.

Or set_root_rcu() can be hand-inlined, like the AT_FDCWD case.  Then the only
caller of set_root_rcu() would be follow_dotdot_rcu(), and the unnecessary
__read_seqcount_begin() could be removed.  (Probably gcc can't optimize it out
currently, because of the ACCESS_ONCE().)
