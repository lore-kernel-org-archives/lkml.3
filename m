Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbAUAFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:05:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbbAUAFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:05:15 -0500
From: Paul Moore <pmoore@redhat.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Tue, 20 Jan 2015 19:04:54 -0500
Message-ID: <1517211.UYLV49hvpg@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150120232726.GA16913@kria>
References: <20150120165655.GA10904@kria> <20150120231725.GL29656@ZenIV.linux.org.uk> <20150120232726.GA16913@kria>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 12:27:26 AM Sabrina Dubroca wrote:
> 2015-01-20, 23:17:25 +0000, Al Viro wrote:
> > On Tue, Jan 20, 2015 at 10:50:41PM +0000, Al Viro wrote:
> > > doesn't look at _anything_ other than name->name other than for
> > > audit_inode(). And name->name is apparently the same.
> > > 
> > > It looks like something ends up buggering name->name in process, but
> > > then
> > > the damn thing appears to be normal after return from
> > > filename_lookup()...
> > 
> > If my reconstruction of what's going on is correct, the call chain here
> > is do_path_lookup() <- kern_path() <- lookup_bdev() <-
> > blkdev_get_by_path()
> > <- mount_bdev() <- some_type.mount() <- mount_fs()
> > <- vfs_kern_mount() <- do_new_mount() <- do_mount() <- sys_mount()
> > <- do_mount_root() <- mount_block_root() <- mount_root().  Which is
> > obscenely long, BTW, but that's a separate story...
> > 
> > Could you slap
> > 
> > 	struct stat buf;
> > 	int n = sys_newstat(name, &buf);
> > 	printk(KERN_ERR "stat(\"%s\") -> %d\n", name, n);
> > 	n = sys_newstat("/dev", &buf);
> > 	printk(KERN_ERR "stat(\"dev\") -> %d\n", n);
> > 
> > in the beginning of mount_block_root() (init/do_mounts.c) and see what it
> > prints?
> 
> I get
> 
> stat("/dev/root") -> -2
> stat("dev") -> -2
> with the patch applied (+panic)
> 
> 
> and:
> 
> stat("/dev/root") -> 0
> stat("dev") -> 0
> with the old version of do_path_lookup.

Wait a minute ... at this early stage of boot, I'm pretty sure we don't have a 
valid current->audit_context since we haven't fork'd anything.  If the audit 
context was non-NULL garbage that might explain the panic ...

-- 
paul moore
security @ redhat

