Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3IKKs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:48:56 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:58069 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3IKKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:48:54 -0400
Date: Wed, 11 Sep 2013 13:48:49 +0300
From: Timo Teras <timo.teras@iki.fi>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ASLR creates bad memory layout for PIE
Message-ID: <20130911134849.2c560745@vostro>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that ASLR with PIE binaries (linux-3.11.0-vanilla on ARM)
seems to create bad memory layout - the programs run out of memory
relatively soon, especially if they also mmap() lot of memory.

I believe the problem is that fs/binfmt_elf.c:load_elf_binary() sets
load_bias to 0 when CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE is set (true
for arm).  This causes the following elf_map() to get zero addr (vaddr
is zero also for the main program PT_LOAD), and we get the main binary
mmapped to random position from the regular mmap area. Thus, brk is
also in the same area.

I believe load_elf_binary() should instead manually randomize load_bias
to be within beginning of the user address space (or at least somewhere
close to ELF_ET_DYN_BASE). This would avoid the very restricted heap
size what we get now.

The memory layout I get on my arm board, with PIE executables and
randomize_va_space=2 (boot time default):
b6db2000-b6df4000 r-xp 00000000 00:0f 5682       /usr/lib/libncurses.so.5.9
b6df4000-b6df7000 rw-p 0003a000 00:0f 5682       /usr/lib/libncurses.so.5.9
b6df7000-b6e31000 r-xp 00000000 00:0f 7364       /usr/lib/libreadline.so.6.2
b6e31000-b6e35000 rw-p 00032000 00:0f 7364       /usr/lib/libreadline.so.6.2
b6e35000-b6e36000 rw-p 00000000 00:00 0 
b6e36000-b6eb3000 r-xp 00000000 00:0f 3233       /lib/ld-musl-armhf.so.1
b6eb9000-b6eba000 r-xp 00000000 00:00 0          [sigpage]
b6eba000-b6ebc000 rw-p 0007c000 00:0f 3233       /lib/ld-musl-armhf.so.1
b6ebc000-b6ebd000 rw-p 00000000 00:00 0 
b6ebd000-b6f60000 r-xp 00000000 00:0f 7368       /bin/bash
b6f68000-b6f6c000 rw-p 000a3000 00:0f 7368       /bin/bash
b6f6c000-b6f70000 rw-p 00000000 00:00 0 
b7641000-b764e000 rw-p 00000000 00:00 0          [heap]
becd2000-becf3000 rw-p 00000000 00:00 0          [stack]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]

And with randomize_vaspace=0:
2a000000-2a0a3000 r-xp 00000000 00:0f 7368       /bin/bash
2a0ab000-2a0af000 rw-p 000a3000 00:0f 7368       /bin/bash
2a0af000-2a0bf000 rw-p 00000000 00:00 0          [heap]
b6ef5000-b6f37000 r-xp 00000000 00:0f 5682       /usr/lib/libncurses.so.5.9
b6f37000-b6f3a000 rw-p 0003a000 00:0f 5682       /usr/lib/libncurses.so.5.9
b6f3a000-b6f74000 r-xp 00000000 00:0f 7364       /usr/lib/libreadline.so.6.2
b6f74000-b6f78000 rw-p 00032000 00:0f 7364       /usr/lib/libreadline.so.6.2
b6f78000-b6f79000 rw-p 00000000 00:00 0 
b6f79000-b6ff6000 r-xp 00000000 00:0f 3233       /lib/ld-musl-armhf.so.1
b6ffc000-b6ffd000 r-xp 00000000 00:00 0          [sigpage]
b6ffd000-b6fff000 rw-p 0007c000 00:0f 3233       /lib/ld-musl-armhf.so.1
b6fff000-b7000000 rw-p 00000000 00:00 0 
befdf000-bf000000 rw-p 00000000 00:00 0          [stack]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]

Any comments, or suggestions?
