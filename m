Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaEZQmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:42:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaEZQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:42:50 -0400
Date: Mon, 26 May 2014 17:42:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140526164247.GO18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526152703.GN18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 04:27:03PM +0100, Al Viro wrote:

> Do these livelocks keep happening indefinitely, once triggered?  IOW,
> is that a buggered state of dcache and/or kernfs, or is it a transient pileup
> that happens when we invalidate a subtree there?

Could you slap
	if (dentry->d_sb->s_magic == SYSFS_MAGIC) {
		printk(KERN_INFO "killing %p4d", dentry);
		WARN_ON(1);
	}
in the very beginning of dentry_kill(),
	if (dentry->d_sb->s_magic == SYSFS_MAGIC) {
		printk(KERN_INFO "invalidate %p4d", dentry);
		WARN_ON(1);
	}
right after the
        if (!dentry->d_inode) {
                d_drop(dentry);
                goto out;
        }
in check_submounts_and_drop(), reproduce that shite and see what
gets into the log between USB disconnect and soft lockup?  Warning:
it will produce an obscene amount of output.  If it gets _really_ excessive
(as in "can't even get through the boot without drowning in syslog traffic"),
we could add a sysctl turning those on, but let's try and see if it's
survivable in that form first...
