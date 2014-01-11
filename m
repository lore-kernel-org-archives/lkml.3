Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaAKBBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:01:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAKBBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:01:18 -0500
Message-ID: <52D097DB.3020101@infradead.org>
Date: Fri, 10 Jan 2014 17:01:15 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Unable to load modules from 9p filesystem with kmod 16
References: <20140110023543.GA6131@animx.eu.org> <20140110230303.GA19369@animx.eu.org>
In-Reply-To: <20140110230303.GA19369@animx.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Cc:s]

On 01/10/2014 03:03 PM, Wakko Warner wrote:
> Wakko Warner wrote:
>> Kernel 3.12.7 from kernel.org
>> With kmod-16, I'm unable to load any modules on my guest kvm machines.
>> The vm is booted via direct kernel boot.  The modules are located on the
>> host and is passed to the guest via the fsdev.
>>
>> I have a mountpoint on the guest filesystem located at /kernel.  It is
>> mounted like this:
>> kernel /kernel 9p rw,sync,dirsync,relatime,trans=virtio,version=9p2000.L 0 0
>>
>> /boot, /lib/modules, and /lib/firmware are tmpfs filesystems like this:
>> kboot /boot tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
>> kfirmware /lib/firmware tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
>> kmodules /lib/modules tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
>>
>> /lib/modules/$(uname -r) is a symlink to /kernel/lib/modules/$(uname -r)
>>
>> When trying to load any module, I get 
>> Error: could not insert module /lib/modules/3.12.7/kernel/crypto/af_alg.ko:
>> Invalid module format
>>
>> This module was just one I picked at random, all modules fail the same way.
>> Strace shows this:
>> open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
>> mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f199aebd000
>> syscall_313(0x3, 0x7f199aaa2de0, 0, 0x3, 0, 0x7f199b7b2010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) = -1 (errno 8)
>> munmap(0x7f199aebd000, 13822)           = 0
>> close(3)                                = 0
>>
>> If I use kmod-9, it works w/o problems.  An strace of kmod-9 shows:
>> open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
>> mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f658ba41000
>> init_module(0x7f658ba41000, 13822, "")  = 0
>> munmap(0x7f658ba41000, 13822)           = 0
>> close(3)                                = 0
>>
>> If I copy the module to /tmp, kmod-16 loads it just fine.  It appears to be
>> related to the 9p filesystem.
>>
>> I won't rule out a bug in kmod-16, but I was unable to figure out what the
>> cause of the error was.  I tried to search through kmod's source and the
>> kernel source, but I gave up because I don't understand what's going on.
> 
> I did some testing with the various kmod versions between kmod-9 and 16. 
> The problem was introduced in 13.  The change that broke this was the
> addition of finit_module().  Appears that the kernel cannot handle modules
> that is on the 9p filesystem.  On the line that checked err == 0 (around
> line libkmod-module.c:823), I added a test for ENOEXEC.  The finit_module
> still fails,but it uses the old method and works.
> 
> I would say from what I've seen, the problem is in the kernel for
> finit_module().  I don't know enough about the kernel to go any further.
> --


-- 
~Randy
