Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaAJCft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:35:49 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:45913 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaAJCfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:35:47 -0500
Date: Thu, 9 Jan 2014 21:35:44 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Unable to load modules from 9p filesystem with kmod 16
Message-ID: <20140110023543.GA6131@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 3.12.7 from kernel.org
With kmod-16, I'm unable to load any modules on my guest kvm machines.
The vm is booted via direct kernel boot.  The modules are located on the
host and is passed to the guest via the fsdev.

I have a mountpoint on the guest filesystem located at /kernel.  It is
mounted like this:
kernel /kernel 9p rw,sync,dirsync,relatime,trans=virtio,version=9p2000.L 0 0

/boot, /lib/modules, and /lib/firmware are tmpfs filesystems like this:
kboot /boot tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
kfirmware /lib/firmware tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
kmodules /lib/modules tmpfs rw,relatime,size=0k,nr_inodes=8 0 0

/lib/modules/$(uname -r) is a symlink to /kernel/lib/modules/$(uname -r)

When trying to load any module, I get 
Error: could not insert module /lib/modules/3.12.7/kernel/crypto/af_alg.ko:
Invalid module format

This module was just one I picked at random, all modules fail the same way.
Strace shows this:
open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f199aebd000
syscall_313(0x3, 0x7f199aaa2de0, 0, 0x3, 0, 0x7f199b7b2010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) = -1 (errno 8)
munmap(0x7f199aebd000, 13822)           = 0
close(3)                                = 0

If I use kmod-9, it works w/o problems.  An strace of kmod-9 shows:
open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f658ba41000
init_module(0x7f658ba41000, 13822, "")  = 0
munmap(0x7f658ba41000, 13822)           = 0
close(3)                                = 0

If I copy the module to /tmp, kmod-16 loads it just fine.  It appears to be
related to the 9p filesystem.

I won't rule out a bug in kmod-16, but I was unable to figure out what the
cause of the error was.  I tried to search through kmod's source and the
kernel source, but I gave up because I don't understand what's going on.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
