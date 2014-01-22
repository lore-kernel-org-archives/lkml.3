Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaAVG1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaAVG1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:27:42 -0500
Date: Wed, 22 Jan 2014 01:27:30 -0500
From: Dave Jones <davej@redhat.com>
To: jack@suse.cz
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fanotify use after free.
Message-ID: <20140122062730.GA25601@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, jack@suse.cz,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

since yesterdays changes, on boot I see a flood of messages from slub debug during boot..

=============================================================================
BUG fanotify_event_info (Not tainted): Poison overwritten
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: 0xffff880247e45bc8-0xffff880247e45bcb. First byte 0x0 instead of 0x6b
INFO: Allocated in fanotify_handle_event+0x136/0x390 age=0 cpu=0 pid=293
 __slab_alloc+0x456/0x565
 kmem_cache_alloc+0x1fe/0x260
 fanotify_handle_event+0x136/0x390
 send_to_group+0xd3/0x1c0
 fsnotify+0x1c8/0x340
 open_exec+0xe2/0x120
 load_elf_binary+0x7b7/0x18e0
 search_binary_handler+0x94/0x1b0
 do_execve_common.isra.26+0x5d7/0x7d0
 SyS_execve+0x36/0x50
 stub_execve+0x69/0xa0
INFO: Freed in fanotify_free_event+0x2e/0x40 age=0 cpu=3 pid=290
 __slab_free+0x4a/0x382
 kmem_cache_free+0x1c9/0x210
 fanotify_free_event+0x2e/0x40
 fsnotify_destroy_event+0x21/0x30
 fanotify_read+0x39e/0x5e0
 vfs_read+0x9b/0x160
 SyS_read+0x58/0xb0
 tracesys+0xdd/0xe2
INFO: Slab 0xffffea00091f9100 objects=20 used=20 fp=0x          (null) flags=0x20000000004080
INFO: Object 0xffff880247e45b90 @offset=7056 fp=0xffff880247e44000

Bytes b4 ffff880247e45b80: 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
Object ffff880247e45b90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff880247e45ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff880247e45bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff880247e45bc0: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
Redzone ffff880247e45bd0: bb bb bb bb bb bb bb bb                          ........
Padding ffff880247e45d10: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
CPU: 0 PID: 293 Comm: mount Tainted: G    B        3.13.0+ #28 
 ffff880247e45b90 000000008c7fe87c ffff8800874cbb28 ffffffff9c710632
 ffff88024a776ac0 ffff8800874cbb68 ffffffff9c194dad 0000000000000008
 ffff880200000001 ffff880247e45bcc ffff88024a776ac0 000000000000006b
Call Trace:
 [<ffffffff9c710632>] dump_stack+0x4e/0x7a
 [<ffffffff9c194dad>] print_trailer+0x14d/0x200
 [<ffffffff9c19505f>] check_bytes_and_report+0xcf/0x110
 [<ffffffff9c196037>] check_object+0x1d7/0x250
 [<ffffffff9c1f4ae6>] ? fanotify_handle_event+0x136/0x390
 [<ffffffff9c70ead7>] alloc_debug_processing+0x76/0x118
 [<ffffffff9c70f77d>] __slab_alloc+0x456/0x565
 [<ffffffff9c1f4ae6>] ? fanotify_handle_event+0x136/0x390
 [<ffffffff9c1ccea4>] ? mntput+0x24/0x40
 [<ffffffff9c1b5dc9>] ? terminate_walk+0x69/0x70
 [<ffffffff9c1ba6fe>] ? do_last+0x25e/0x1390
 [<ffffffff9c1b6cf8>] ? inode_permission+0x18/0x50
 [<ffffffff9c1f4ae6>] ? fanotify_handle_event+0x136/0x390
 [<ffffffff9c1980fe>] kmem_cache_alloc+0x1fe/0x260
 [<ffffffff9c1f4ae6>] fanotify_handle_event+0x136/0x390
 [<ffffffff9c1bb8fd>] ? path_openat+0xcd/0x6a0
 [<ffffffff9c1f0e63>] send_to_group+0xd3/0x1c0
 [<ffffffff9c1f0fdf>] ? fsnotify+0x8f/0x340
 [<ffffffff9c1f1118>] fsnotify+0x1c8/0x340
 [<ffffffff9c1a9b4f>] do_sys_open+0x19f/0x230
 [<ffffffff9c1a9bfe>] SyS_open+0x1e/0x20
 [<ffffffff9c723764>] tracesys+0xdd/0xe2
FIX fanotify_event_info: Restoring 0xffff880247e45bc8-0xffff880247e45bcb=0x6b

