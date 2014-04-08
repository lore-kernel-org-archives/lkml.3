Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaDHOpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:45:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28356 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaDHOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:45:40 -0400
Message-ID: <53440B8B.1010304@oracle.com>
Date: Tue, 08 Apr 2014 10:45:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>
Subject: fs,seq_file: huge allocations for seq file reads
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following:

[ 2052.444910] WARNING: CPU: 3 PID: 26525 at mm/page_alloc.c:2513 __alloc_pages_slowpat
h+0x6a/0x801()
[ 2052.447575] Modules linked in:
[ 2052.448438] CPU: 3 PID: 26525 Comm: trinity-c3 Tainted: G        W     3.14.0-next-2
0140407-sasha-00023-gd35b0d6 #382
[ 2052.452147]  0000000000000009 ffff88010f485af8 ffffffff9d52ee51 0000000000005d20
[ 2052.454425]  0000000000000000 ffff88010f485b38 ffffffff9a15a2dc 000000174802a016
[ 2052.456676]  00000000001040d0 0000000000000000 0000000000000002 0000000000000000
[ 2052.458851] Call Trace:
[ 2052.459587] dump_stack (lib/dump_stack.c:52)
[ 2052.461211] warn_slowpath_common (kernel/panic.c:419)
[ 2052.462914] warn_slowpath_null (kernel/panic.c:454)
[ 2052.464512] __alloc_pages_slowpath (mm/page_alloc.c:2513 (discriminator 3))
[ 2052.466160] ? get_page_from_freelist (mm/page_alloc.c:1939)
[ 2052.468020] ? sched_clock_local (kernel/sched/clock.c:213)
[ 2052.469633] ? get_parent_ip (kernel/sched/core.c:2471)
[ 2052.471329] __alloc_pages_nodemask (mm/page_alloc.c:2766)
[ 2052.473084] alloc_pages_current (mm/mempolicy.c:2131)
[ 2052.474688] ? __get_free_pages (mm/page_alloc.c:2803)
[ 2052.476273] ? __free_pages_ok (arch/x86/include/asm/paravirt.h:809 (discriminator 2) mm/page_alloc.c:766 (discriminator 2))
[ 2052.477980] __get_free_pages (mm/page_alloc.c:2803)
[ 2052.481082] kmalloc_order_trace (include/linux/slab.h:379 mm/slab_common.c:525)
[ 2052.483193] __kmalloc (include/linux/slab.h:396 mm/slub.c:3303)
[ 2052.485417] ? kfree (mm/slub.c:3395)
[ 2052.486337] traverse (fs/seq_file.c:141)
[ 2052.487289] seq_read (fs/seq_file.c:179 (discriminator 1))
[ 2052.488161] vfs_read (fs/read_write.c:408)
[ 2052.489001] SyS_pread64 (include/linux/file.h:38 fs/read_write.c:557 fs/read_write.c:544)
[ 2052.489959] tracesys (arch/x86/kernel/entry_64.S:749)

It seems that when we attempt to read huge chunks of data from a seq file
there would be no check for the size being read, leading to the kernel
attempting to allocate huge chunks of data internally.

As far as I remember, there was a PAGE_SIZE limitation on those, but I'm
not certain about that. Could someone please confirm it?


Thanks,
Sasha
