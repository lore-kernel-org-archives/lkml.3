Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3EVSsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:48:31 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38330 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EVSsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:48:30 -0400
Date: Tue, 21 May 2013 19:39:22 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new mount is broken w/regard to devnames in /etc/fstab
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <519A8D0D.7090604@tlinx.org> (from lkml@tlinx.org on Mon May 20
	15:52:29 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369183162.2776.8@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 03:52:29 PM, Linda Walsh wrote:
> 
> 
> 
> 
> Rob Landley wrote:
> > On 05/19/2013 12:01:18 AM, Linda Walsh wrote:
> >> 1) How is one supposed to get the real root device?
> >> It's not /dev/root -- and on my system /dev/root doesn't even  
> exist.
> > There was a thread on this a couple months ago:
> >   https://lkml.org/lkml/2013/3/20/315
> >
> > You can get the major/minor of a filesystem with the stat() system
> > call, or even the stat command line utility. That gives you the
> > major/minor of the device the filesystem was mounted from.
> >
> > Note that there's only a major/minor when the filesystem _has_ a
> > backing block device. If it's initramfs or tmpfs: there isn't one.  
> If
> > it's nfs, smbfs, or v9fs: there isn't one.
> ----
>     Indeed.
> 
>     Just that having to go through the extra stat call breaks
> *scripts* that relied on previous behavior.  I mean why the kernel
> can't put /dev/sdc1 in /proc/mounts instead of /dev/root when it
> was specifically passed root=/dev/sdc1 on it's command line
> seems a bit puzzling.

That part, I've never understood.

>     The thing is -- while there is a /dev/root in '/proc/mounts',  
> there
> is no '/dev/root' in '/dev/ NOR is there a "root" or "rootfs" listed
> in '/proc/devices'.  I.e. saying the boot occurred from /dev/root when
> /dev/root doesn't exist is a bit obfuscating, at best.

I taught mdev to make a symlink. I believe this predated the existence  
of devtmpfs. :)

>     That said, it's also incredibly non-portable to have to ...
> call 'stat' on '/'

Dynamically populating /dev is incredibly non-portable. It was all  
static devices back in the 90's.

> As for the boot from ramfs, it's odd that it doesn't list
> dev/ramdisk or /dev/mem as the major.

Because ramfs is not a ramdisk. It's a tiny shim that mounts the disk  
cache as a filesystem, and gives the data nowhere to go so it can't be  
freed unless you delete the files. The dentries are just dentry cache  
with no backing store, the file contents are just page cache with no  
backing store. It allocates more memory when you write files into it,  
and frees memory when you delete files out of it. (tmpfs is a layer on  
top of ramfs that imposes a maximum size so "cat /dev/zero > file"  
won't fill up all memory and kill your system, and adds hooks to copy  
them to swap space when the VM asks the filesystem to flush those pages  
instead of replying "no can do".)

I explicitly listed ramfs and tmpfs in the "no block device" entries  
above.

You're thinking of "ramdisk", in which you take a chunk of memory and  
treat it as a block device, then format it and mount it via a  
filesystem driver. This means that page cache is copied from said block  
device, so there's two copies of the data and an unnecessary filesystem  
driver copying data back and forth. All that's considerably more  
complicated and less efficient than just mounting the disk cache as a  
filesystem directly. (Ramdisk was the old way, ramfs is the new way.  
Between ramfs and loopback devices, ramdisks are pretty thoroughly  
obsolete.)

See Documentation/filesystems/ramfs-rootfs-initramfs.txt

Rob