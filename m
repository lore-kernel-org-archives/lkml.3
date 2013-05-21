Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3EUWe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:34:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40138 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3EUWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:34:55 -0400
Date: Tue, 21 May 2013 23:34:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Stupid VFS name lookup interface..
Message-ID: <20130521223453.GY25399@ZenIV.linux.org.uk>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 03:22:44PM -0700, Linus Torvalds wrote:
> The *one* insane exception is ncpfs, which actually wants to look at
> the parent (ie directory) inode data in order to decide if it should
> use a case sensitive hash or not. However, even in that case, I'd
> argue that we could just optimistically do a
> ACCESS_ONCE(dentry->d_inode) and do the compare using the information
> we got from that.
> 
> Because we don't care if the dentry->d_inode is unstable: if we got
> some stale inode, we would hit the dentry_rcuwalk_barrier() case for
> that parent when we later check the sequence numbers. So then we'd
> throw away the comparison result anyway.  We check both the dentry and
> the parent sequence count in lookup_fast(), verifying that they've
> been stable over the sequence.
> 
> So as far as I can tell, the only thing we should worry about might be
> a NULL pointer due to a concurrent rmdir(), but the identity of the
> inode itself we really don't care too much about. Take one or the
> other, and don't crash on NULL.
> 
> There's a similat case going on in proc_sys_compare(). Same logic applies.

In principle, yes, but...  I wonder if those two cases are actually
safe (especially ncpfs) right now.  We dereference the parent inode
there and that could get ugly, whether we've got it from caller or
as ->d_inode.  Let me dig around in that code a bit, OK?

Al, enjoying the excuse to take a break from ->readdir() code audit ;-/
