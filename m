Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3FZLnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:43:35 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:42618 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3FZLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:43:33 -0400
Date: Wed, 26 Jun 2013 13:43:27 +0200
From: Jan Glauber <jan.glauber@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com
Subject: Ambigiuous thread stack annotation in /proc/pid/[s]maps
Message-ID: <20130626114324.GA3538@hal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b764375 added annotations of thread stacks. This annotation can be
wrong depending on the memory layout of a task (will probably only happen
under 32 bit).

If a large allocation happens before the creation of a thread you can get:

root@box:~# cat /proc/2032/maps 
08048000-08049000 r-xp 00000000 08:01 3407931    /root/pt
08049000-0804a000 r--p 00000000 08:01 3407931    /root/pt
0804a000-0804b000 rw-p 00001000 08:01 3407931    /root/pt
093b8000-093d9000 rw-p 00000000 00:00 0          [heap]
363fe000-363ff000 ---p 00000000 00:00 0 
363ff000-b6c00000 rw-p 00000000 00:00 0          [stack:2036]
b6c00000-b6c21000 rw-p 00000000 00:00 0 
b6c21000-b6d00000 ---p 00000000 00:00 0 
b6d31000-b6d32000 ---p 00000000 00:00 0 
b6d32000-b7534000 rw-p 00000000 00:00 0          [stack:2033]
b7534000-b76d7000 r-xp 00000000 08:01 3145793    /lib/i386-linux-gnu/libc-2.15.so
b76d7000-b76d9000 r--p 001a3000 08:01 3145793    /lib/i386-linux-gnu/libc-2.15.so
b76d9000-b76da000 rw-p 001a5000 08:01 3145793    /lib/i386-linux-gnu/libc-2.15.so
b76da000-b76dd000 rw-p 00000000 00:00 0 
b76dd000-b76f4000 r-xp 00000000 08:01 3149883    /lib/i386-linux-gnu/libpthread-2.15.so
b76f4000-b76f5000 r--p 00016000 08:01 3149883    /lib/i386-linux-gnu/libpthread-2.15.so
b76f5000-b76f6000 rw-p 00017000 08:01 3149883    /lib/i386-linux-gnu/libpthread-2.15.so
b76f6000-b76f8000 rw-p 00000000 00:00 0 
b7707000-b770b000 rw-p 00000000 00:00 0 
b770b000-b770c000 r-xp 00000000 00:00 0          [vdso]
b770c000-b772c000 r-xp 00000000 08:01 3149887    /lib/i386-linux-gnu/ld-2.15.so
b772c000-b772d000 r--p 0001f000 08:01 3149887    /lib/i386-linux-gnu/ld-2.15.so
b772d000-b772e000 rw-p 00020000 08:01 3149887    /lib/i386-linux-gnu/ld-2.15.so
bfb15000-bfb36000 rw-p 00000000 00:00 0          [stack]

Now the stack for thread 2036 is amazingly large for a pthread. Actually it is
the result of:
1. malloc(2048 * 1024 * 1024)
2. pthread_create (with attr=NULL)

My theory is that this can happen anytime because a thread stack is just created
with mmap (MAP_PRIVATE | MAP_ANONYMOUS). The 1. malloc also resulted in a mmap 
(libc fallback on brk failure) with the same flags (MAP_PRIVATE | MAP_ANONYMOUS).

The kernel does not care about thread stacks and tries to merge vma's which seems
to happen here and which is correct from the kernel POV.

Any ideas how that can be fixed? The only solution that comes to my mind
is to prevent merging vma's that are used for thread stacks. There is already a
flag (MAP_STACK) which is set by the libc for mmap'ing thread stacks but the
kernel currently does not care. If the kernel gets an mmap request with
MAP_STACK set we could mark the VMA and avoid merging it with others.

Unfortunately there seems to be no bit left in the vm_flags to store the
MAP_STACK information...

--Jan
