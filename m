Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaE1UOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:14:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54028 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaE1UOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:14:44 -0400
Date: Wed, 28 May 2014 21:14:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528201440.GB18016@ZenIV.linux.org.uk>
References: <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwmoevoA3h5AZhqtHC0kEJegb0crT_jYvXWWD3UWZt9Aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:43:24PM -0700, Linus Torvalds wrote:

> It does require that the dentry shrinking code always hold the RCU
> lock for reading, because others may actually be doing the final
> dput() while the thing is on the shrinking list (and holding the RCU
> lock is what protects the entry from actually being free'd).
> 
> NOTE! I don't claim that this fixes anything, but I do think that it
> makes that whole cross-thread complexity of that DCACHE_MAY_FREE go
> away. I think it's easier to understand, and it removes code in the
> process. Comments?

Unless I'm badly misreading your patch, you are calling dentry_kill()
with rcu_read_lock() held.  And that can trigger all sorts of interesting
things, starting with iput() and tons of disk IO...

What am I missing here?
