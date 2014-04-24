Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbaDXQ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:56:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28567 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaDXQ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:56:52 -0400
Message-ID: <53594244.6070305@oracle.com>
Date: Thu, 24 Apr 2014 12:56:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: fs: dcookie: freeing active timer
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:

[  191.835040] WARNING: CPU: 12 PID: 9725 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
[  191.838129] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x20
[  191.840545] Modules linked in:
[  191.841297] CPU: 12 PID: 9725 Comm: trinity-c141 Not tainted 3.15.0-rc2-next-20140423-sasha-00018-gc4ff6c4 #408
[  191.842479]  0000000000000009 ffff88000a8ebc38 ffffffff975271f2 0000000000000001
[  191.842479]  ffff88000a8ebc88 ffff88000a8ebc78 ffffffff9415afcc ffff88000a8a3d98
[  191.842479]  ffff8801b3ad5140 ffffffff98e76200 ffffffff988dc502 ffffffff9b70c870
[  191.842479] Call Trace:
[  191.842479] dump_stack (lib/dump_stack.c:52)
[  191.842479] warn_slowpath_common (kernel/panic.c:430)
[  191.842479] warn_slowpath_fmt (kernel/panic.c:445)
[  191.842479] debug_print_object (lib/debugobjects.c:262)
[  191.842479] ? __queue_work (kernel/workqueue.c:1452)
[  191.842479] __debug_check_no_obj_freed (lib/debugobjects.c:697)
[  191.842479] debug_check_no_obj_freed (lib/debugobjects.c:726)
[  191.842479] kmem_cache_free (mm/slub.c:2689 mm/slub.c:2717)
[  191.871535] ? kmem_cache_destroy (mm/slab_common.c:363)
[  191.871535] kmem_cache_destroy (mm/slab_common.c:363)
[  191.871535] dcookie_unregister (fs/dcookies.c:302 fs/dcookies.c:343)
[  191.871535] event_buffer_release (arch/x86/oprofile/../../../drivers/oprofile/event_buffer.c:153)
[  191.871535] __fput (fs/file_table.c:217)
[  191.871535] ____fput (fs/file_table.c:253)
[  191.871535] task_work_run (kernel/task_work.c:125 (discriminator 1))
[  191.871535] do_notify_resume (include/linux/tracehook.h:196 arch/x86/kernel/signal.c:751)
[  191.871535] int_signal (arch/x86/kernel/entry_64.S:807)


Thanks,
Sasha
