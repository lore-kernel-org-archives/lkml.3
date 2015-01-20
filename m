Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbbATX1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:27:35 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:12505 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbbATX1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:27:33 -0500
Date: Wed, 21 Jan 2015 00:27:26 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120232726.GA16913@kria>
References: <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
 <20150120210202.GI29656@ZenIV.linux.org.uk>
 <20150120220823.GB18129@kria>
 <20150120221309.GA18589@roeck-us.net>
 <20150120225041.GK29656@ZenIV.linux.org.uk>
 <20150120231725.GL29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150120231725.GL29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20, 23:17:25 +0000, Al Viro wrote:
> On Tue, Jan 20, 2015 at 10:50:41PM +0000, Al Viro wrote:
> > doesn't look at _anything_ other than name->name other than for audit_inode().
> > And name->name is apparently the same.
> > 
> > It looks like something ends up buggering name->name in process, but then
> > the damn thing appears to be normal after return from filename_lookup()...
> 
> If my reconstruction of what's going on is correct, the call chain here
> is do_path_lookup() <- kern_path() <- lookup_bdev() <- blkdev_get_by_path()
> <- mount_bdev() <- some_type.mount() <- mount_fs()
> <- vfs_kern_mount() <- do_new_mount() <- do_mount() <- sys_mount()
> <- do_mount_root() <- mount_block_root() <- mount_root().  Which is
> obscenely long, BTW, but that's a separate story...
> 
> Could you slap
> 	struct stat buf;
> 	int n = sys_newstat(name, &buf);
> 	printk(KERN_ERR "stat(\"%s\") -> %d\n", name, n);
> 	n = sys_newstat("/dev", &buf);
> 	printk(KERN_ERR "stat(\"dev\") -> %d\n", n);
> 
> in the beginning of mount_block_root() (init/do_mounts.c) and see what it
> prints?

I get

stat("/dev/root") -> -2
stat("dev") -> -2
with the patch applied (+panic)


and:

stat("/dev/root") -> 0
stat("dev") -> 0
with the old version of do_path_lookup.

-- 
Sabrina
