Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaE0DOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:14:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaE0DOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:14:19 -0400
Date: Tue, 27 May 2014 04:14:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140527031415.GS18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527014054.GR18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 02:40:54AM +0100, Al Viro wrote:
> It looks plausible, but I doubt that serializing check_submounts_and_drop()
> will suffice - shrink_dcache_parent() is just as unpleasant and it *is*
> triggered in the same situations.  Moreover, the lack of loop in memory
> shrinkers doesn't help - we might get shrink_dentry_list() from one of
> those and loops that keep calling d_walk() from check_submounts_and_drop()
> or shrink_dcache_parent()...
> 
> > Anyway, I'd like Mika to test the stupid "let's serialize the dentry
> > shrinking in check_submounts_and_drop()" to see if his problem goes
> > away. I agree that it's not the _proper_ fix, but we're damn late in
> > the rc series..
> 
> That we are...  FWIW, if the nastiness matches the description above,
> the right place to do something probably would be when those two
> suckers get positive return value from d_walk() along with an empty
> shrink list.  I wonder if we should do down_read() in shrink_dentry_list()
> and down_write();up_write() in that case in shrink_dcache_parent() and
> check_submounts_and_drop().  How about the following?

As the matter of fact, let's try this instead - retry the same sucker
immediately in case if trylocks fail.  Comments?

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..d58d4cc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -798,6 +798,7 @@ static void shrink_dentry_list(struct list_head *list)
 
 	while (!list_empty(list)) {
 		dentry = list_entry(list->prev, struct dentry, d_lru);
+again:
 		spin_lock(&dentry->d_lock);
 		/*
 		 * The dispose list is isolated and dentries are not accounted
@@ -830,7 +831,8 @@ static void shrink_dentry_list(struct list_head *list)
 			 */
 			d_shrink_add(dentry, list);
 			spin_unlock(&dentry->d_lock);
-			continue;
+			cpu_relax();
+			goto again;
 		}
 		/*
 		 * We need to prune ancestors too. This is necessary to prevent
