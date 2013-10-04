Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3JDVPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:15:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49653 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3JDVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:15:30 -0400
Date: Fri, 4 Oct 2013 22:15:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: security: lockless stat() issues
Message-ID: <20131004211526.GR13318@ZenIV.linux.org.uk>
References: <CA+55aFxndx0J0sTLTx0qu25TkoLLfGd+8qiLhdG5CYwpO1NvVQ@mail.gmail.com>
 <20131004201512.GQ13318@ZenIV.linux.org.uk>
 <CA+55aFzt1LN77WgFbdEak0f-JssQH64pSL=1zYAfB7=B8pxwvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzt1LN77WgFbdEak0f-JssQH64pSL=1zYAfB7=B8pxwvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 01:49:13PM -0700, Linus Torvalds wrote:
> That would get ugly.
> 
> However, I don't think we actually really need to do that.  We had a
> similar situation with d_revalidate() passing inode pointers etc
> totally unnecessarily. Yes, the filesystem needs to use ACCESS_ONCE()
> and care about NULL, but it doesn't need anything more than that. And
> we really do have that already.

Not for ->getattr()...  BTW, ->permission() for btrfs in that series
relies on not getting a MAY_WRITE | MAY_NOT_BLOCK combination, and
if you are serious about access(2), we'll need to lazy-delay freeing
struct btrfs_root.  Besides, we'll need to audit all ->permission()
instances for places that do not check for MAY_NOT_BLOCK on such
branches...

> And we already have dentry->d_sb - which is supposed to be valid.
> Again, we already use it under RCU for d_revalidate() and for name
> hashing. So the super-block had better already be ok with RCU.

Umm...  Right you are, so we really need to make freeing these suckers
delayed.  Fixed and pushed.  BTW, I wonder how much does removal of
s_files (next-to-last commit in #experimental) affect scalability on
open/close...  Anybody with perf setup and reasonable amount of
previous data?

BTW^2: what's the FM2R for perf testing of that kind?  E.g. how much
is testable under KVM, etc.?
