Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3AXBsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:48:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35071 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AXBsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:48:46 -0500
Date: Thu, 24 Jan 2013 01:48:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130124014840.GA4503@ZenIV.linux.org.uk>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
 <20130123155147.25fe49a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123155147.25fe49a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:51:47PM -0800, Andrew Morton wrote:

> > note that
> > 	* file->f_path is already pinned down by open(), path_get() does not
> > provide anything extra.
> > 	* file->f_path.dentry is already pinned by open() *and* path_get()
> > just above that dget().
> > 	* ->d_name.name *IS* *NOT* *PROTECTED* by pinning dentry down,
> > whether it's done once or thrice.
> 
> I guess the first two are obvious (or at least, expected).  But the
> third isn't.

->d_name.name is changed by rename() (as one could expect).  Grabbing
a reference to dentry will not prevent rename() from happening.  ->i_mutex
on parent will, but you either need to play with retries (grab reference
to parent, grab ->i_mutex, check that it's still our parent, if we'd lost
the race and someone had renamed the sucker - unlock ->i_mutex, dput,
repeat) *or* to have our dentry looked up with parent locked, with ->i_mutex
on said parent still held (which happens to cover the majority of valid
uses in fs code - ->lookup(), ->create(), ->unlink(), rename(), etc. are
all called that way, so the name of dentry passed to such methods is stable
for the duration of the method).

->d_lock on dentry is also sufficient, but that obviously means that you
can't block while holding it.

> Where should a kernel developer go to learn these things? 
> include/linux/dcache.h doesn't mention d_name locking rules, nor does
> Documentation/filesystems/vfs.txt.

See directory locking rules in there; the crucial point is that dentry
name is changed by rename() *and* that results of a race can be worse than
just running into a partially rewritten name - long names are allocated
separately and walking through a stale pointer you might end up in freed
memory.

It's a mess, unfortunately, and $BIGNUM other uses of ->i_mutex make it only
nastier.  Once in a while I go hunting for races in that area, usally with
a bunch of fixes coming out of such run ;-/
