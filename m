Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbaLLEWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:22:03 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10301 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964808AbaLLEV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:21:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocGAIdsilQOAjMVdGdsb2JhbABZg1hYxX+FagKBFRcBAQEBAREBa4QNAQU4HiIBEAgDDgYECRYECwkDAgECASceBgEMAQUCAognDsZ4kQUBAQEBAQEBAQIBAQEBAQEBARqPcgeEKQWMKoE0g1+GPTCIGIFXglGDN4IgHhSBTyswAQEDgj4BAQE
Message-ID: <548A6D63.3010106@internode.on.net>
Date: Fri, 12 Dec 2014 14:51:55 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Colin Watson <cjwatson@debian.org>, 772807@bugs.debian.org,
        linux-kernel@vger.kernel.org, vapier@gentoo.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: Bug#772807: binfmt-support: unable to close /proc/sys/fs/binfmt_misc/register:
 Invalid argument
References: <20141211102439.5047.90481.reportbug@localhost> <20141211104408.GQ3020@riva.ucam.org> <548987B8.8090202@internode.on.net> <20141211124024.GR3020@riva.ucam.org>
In-Reply-To: <20141211124024.GR3020@riva.ucam.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Colin Watson wrote on 11/12/14 23:10:
> On Thu, Dec 11, 2014 at 10:32:00PM +1030, Arthur Marsh wrote:
>> Colin Watson wrote on 11/12/14 21:14:
>>> The latest binfmt_misc module in git has much more detailed debugging
>>> output in dmesg.  What does "dmesg | grep binfmt_misc" say?
>>
>> Hi, I'm seeing:
>>
>> $ dmesg|grep binfmt_misc
>
> Hm.  Does your tree include
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/binfmt_misc.c?id=6b899c4e9a049dfca759d990bd53b14f81c3626c
> ?  If not, it would help to try again with that.
>
> (Hm, I guess you might need CONFIG_DYNAMIC_DEBUG.  Not sure.)
>
> Thanks,
>

The earlier conversation is at:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=772807

Short version, on recent kernels I was seeing:

Thu Dec 11 20:40:29 2014: [....] Enabling additional executable binary 
formats:
binfmt-supportupdate-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument
Thu Dec 11 20:40:30 2014: update-binfmts: warning: unable to close 
/proc/sys/fs/binfmt_misc/register: Invalid argument

and only the first of several binfmt's registered (all the qemu 
binfmt's) when update-binfmts was run at boot time.

A git-bisect revealed:

  git bisect good
6b899c4e9a049dfca759d990bd53b14f81c3626c is the first bad commit
commit 6b899c4e9a049dfca759d990bd53b14f81c3626c
Author: Mike Frysinger <vapier@gentoo.org>
Date:   Wed Dec 10 15:52:08 2014 -0800

     binfmt_misc: add comments & debug logs

     When trying to develop a custom format handler, the errors returned all
     effectively get bucketed as EINVAL with no kernel messages.  The other
     errors (ENOMEM/EFAULT) are internal/obvious and basic.  Thus any time a
     bad handler is rejected, the developer has to walk the dense code and
     try to guess where it went wrong.  Needing to dive into kernel code is
     itself a fairly high barrier for a lot of people.

     To improve this situation, let's deploy extensive pr_debug markers at
     logical parse points, and add comments to the dense parsing logic.  It
     let's you see exactly where the parsing aborts, the string the kernel
     received (useful when dealing with shell code), how it translated the
     buffers to binary data, and how it will apply the mask at runtime.

     Some example output:
       $ echo 
':qemu-foo:M::\x7fELF\xAD\xAD\x01\x00:\xff\xff\xff\xff\xff\x00\xff\x00:/usr/bin/qemu-foo:POC' 
 > register
       $ dmesg
       binfmt_misc: register: received 92 bytes
       binfmt_misc: register: delim: 0x3a {:}
       binfmt_misc: register: name: {qemu-foo}
       binfmt_misc: register: type: M (magic)
       binfmt_misc: register: offset: 0x0
       binfmt_misc: register: magic[raw]: 5c 78 37 66 45 4c 46 5c 78 41 
44 5c 78 41 44 5c  \x7fELF\xAD\xAD\
       binfmt_misc: register: magic[raw]: 78 30 31 5c 78 30 30 00 
                    x01\x00.
       binfmt_misc: register:  mask[raw]: 5c 78 66 66 5c 78 66 66 5c 78 
66 66 5c 78 66 66  \xff\xff\xff\xff
       binfmt_misc: register:  mask[raw]: 5c 78 66 66 5c 78 30 30 5c 78 
66 66 5c 78 30 30  \xff\x00\xff\x00
       binfmt_misc: register:  mask[raw]: 00 
                    .
       binfmt_misc: register: magic/mask length: 8
       binfmt_misc: register: magic[decoded]: 7f 45 4c 46 ad ad 01 00 
                        .ELF....
       binfmt_misc: register:  mask[decoded]: ff ff ff ff ff 00 ff 00 
                        ........
       binfmt_misc: register:  magic[masked]: 7f 45 4c 46 ad 00 01 00 
                        .ELF....
       binfmt_misc: register: interpreter: {/usr/bin/qemu-foo}
       binfmt_misc: register: flag: P (preserve argv0)
       binfmt_misc: register: flag: O (open binary)
       binfmt_misc: register: flag: C (preserve creds)

     The [raw] lines show us exactly what was received from userspace.  The
     lines after that show us how the kernel has decoded things.

     Signed-off-by: Mike Frysinger <vapier@gentoo.org>
     Cc: Al Viro <viro@zeniv.linux.org.uk>
     Cc: Joe Perches <joe@perches.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 d8354a4a420ed15399a6c41aa0914a8a4c6dba9a 
2d491c10c9418cd16f367916f25d6050eb60152d M      fs

Regards,

Arthur.


