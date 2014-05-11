Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaEKAON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 20:14:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48960 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaEKAOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 20:14:08 -0400
Message-ID: <536EC0C1.3090105@oracle.com>
Date: Sat, 10 May 2014 20:13:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: oprofile-list@lists.sf.net
CC: robert.richter@amd.com, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: oprofile: calling debug_smp_processor_id from preemptible code
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[  358.852124] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/24:1/6824
[  358.858753] caller is debug_smp_processor_id+0x17/0x20
[  358.859777] CPU: 23 PID: 6824 Comm: kworker/24:1 Not tainted 3.15.0-rc4-next-2014050
8-sasha-00020-gec9304b-dirty #452
[  358.862844] Workqueue: events wq_sync_buffer
[  358.863786]  ffffffffa97d8801 ffff880585e05cd8 ffffffffa853ba9a 0000000000000002
[  358.865500]  0000000000000017 ffff880585e05d08 ffffffffa5b41439 ffff8805871d3bc0
[  358.866717]  0000000000000018 ffff8805871de000 0000000000000000 ffff880585e05d18
[  358.868075] Call Trace:
[  358.868513] dump_stack (lib/dump_stack.c:52)
[  358.869319] check_preemption_disabled (arch/x86/include/asm/preempt.h:80 lib/smp_processor_id.c:49)
[  358.870679] debug_smp_processor_id (lib/smp_processor_id.c:57)
[  358.871906] wq_sync_buffer (arch/x86/oprofile/../../../drivers/oprofile/cpu_buffer.c:454)
[  358.872974] process_one_work (kernel/workqueue.c:2227 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2232)
[  358.873891] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2220)
[  358.874796] worker_thread (kernel/workqueue.c:2354)
[  358.875830] ? rescuer_thread (kernel/workqueue.c:2303)
[  358.876948] kthread (kernel/kthread.c:210)
[  358.878202] ? kthread_create_on_node (kernel/kthread.c:176)
[  358.879523] ret_from_fork (arch/x86/kernel/entry_64.S:553)
[  358.880744] ? kthread_create_on_node (kernel/kthread.c:176)


Thanks,
Sasha
