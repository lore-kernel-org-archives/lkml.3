Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbbATVjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:39:05 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:11753 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbATVjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:39:03 -0500
Date: Tue, 20 Jan 2015 22:38:58 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Paul Moore <pmoore@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120213858.GA18129@kria>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
 <20150120210202.GI29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150120210202.GI29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20, 21:02:03 +0000, Al Viro wrote:
> On Tue, Jan 20, 2015 at 09:45:04PM +0100, Sabrina Dubroca wrote:
> 
> > printk(KERN_ERR "fn_lookup %s %d\n", name, retval);
> > 
> > and I get:
> > 
> > [    1.618558] fn_lookup bsg/0:0:0:0 -2
> > [    1.619437] fn_lookup bsg 0
> > [    1.620236] fn_lookup bsg/0:0:0:0 -2
> > [    1.625996] fn_lookup sda 0
> > [    1.626609] fn_lookup sda 0
> > [    1.639007] fn_lookup sda1 0
> > [    1.639691] fn_lookup sda1 0
> > [    1.643656] fn_lookup bsg/1:0:0:0 -2
> > [    1.644974] fn_lookup bsg 0
> > [    1.645928] fn_lookup bsg/1:0:0:0 -2
> > [    1.649483] fn_lookup /dev/ram -2
> > [    1.650424] fn_lookup /dev/root -2
> > [    1.651234] VFS: Cannot open root device "sda1" or unknown-block(8,1): error -2
> 
> That -2 is -ENOENT...  Wait a sec, what's in filename, filename->name and
> what do you get from your printk on kernel with that commit reverted?

filename->name matches name. with
printk(KERN_ERR "fn_lookup %s %d, %p %s\n", name, retval, filename, filename->name);

[    1.538646] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
[    1.539704] fn_lookup bsg 0, ffff88001f718000 bsg
[    1.540559] fn_lookup bsg/0:0:0:0 -2, ffff88001f718000 bsg/0:0:0:0
[    1.552611] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
[    1.553689] fn_lookup bsg 0, ffff88001f718000 bsg
[    1.554505] fn_lookup bsg/1:0:0:0 -2, ffff88001f718000 bsg/1:0:0:0
[    1.557554] fn_lookup sda 0, ffff88001f718000 sda
[    1.558368] fn_lookup sda 0, ffff88001f718000 sda
[    1.564190] fn_lookup sda1 0, ffff88001f718000 sda1
[    1.565008] fn_lookup sda1 0, ffff88001f718000 sda1
[    1.570751] fn_lookup /dev/ram -2, ffff88001f71a300 /dev/ram
[    1.571786] fn_lookup /dev/root -2, ffff88001f71b480 /dev/root


and with
printk(KERN_ERR "fn_lookup %s %d, %s\n", name, retval, filename.name);
in the original do_path_lookup:

[    1.426101] fn_lookup bsg/0:0:0:0 -2, bsg/0:0:0:0
[    1.426893] fn_lookup bsg 0, bsg
[    1.427406] fn_lookup bsg/0:0:0:0 0, bsg/0:0:0:0
[    1.431530] fn_lookup sda 0, sda
[    1.438346] fn_lookup bsg/1:0:0:0 0, bsg/1:0:0:0
[    1.443658] fn_lookup sda1 0, sda1
[    1.448344] fn_lookup /dev/ram 0, /dev/ram
[    1.449148] fn_lookup /dev/root 0, /dev/root
[    1.449835] fn_lookup /dev/root 0, /dev/root
[    1.451586] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    1.452954] fn_lookup /dev/root 0, /dev/root
[    1.454292] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    1.456331] fn_lookup /dev/root 0, /dev/root
[    1.480208] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.481323] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.


-- 
Sabrina
