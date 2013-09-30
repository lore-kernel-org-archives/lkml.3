Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3I3OkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:40:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab3I3Oj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:39:58 -0400
Date: Mon, 30 Sep 2013 15:39:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [REGRESSION] jump label safety checks break automatic numa balancing
Message-ID: <20130930143955.GF2425@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_NUMA_BALANCING=y and booting with numa_balancing=enable
there is a crash very early in the lifetime of the system. By setting
earlyprintk=ttyS0,115200 the error is visible and looks something like
this

[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11.0-vanilla+ root=/dev/sda5 reboot=pci console=tty0 console=ttyS0,115200 numa_balancing=enable earlyprintk=ttyS0,115200
[    0.000000] Unexpected op at task_numa_fault+0x1d/0xa0 [ffffffff81085ded] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:53
PANIC: early exception 06 rip 10:ffffffff815b2663 error 0 cr2 ffff88107ffff000
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-vanilla+ #23
[    0.000000] Hardware name: Dell Inc. PowerEdge R810/0TT6JF, BIOS 2.7.4 04/26/2012
[    0.000000]  ffffffff81009220 ffffffff81a01e10 ffffffff815b7e7b 00000000000003f8
[    0.000000]  ffffffff81085ded ffffffff81a01ec8 ffffffff81ad4197 6a2f6c656e72656b
[    0.000000]  2f3638782f686372 000000000000012b 6562616c5f706d75 ffffffff81c68444
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81009220>] ? alternatives_text_reserved+0x80/0x80
[    0.000000]  [<ffffffff815b7e7b>] dump_stack+0x55/0x86
[    0.000000]  [<ffffffff81085ded>] ? task_numa_fault+0x1d/0xa0
[    0.000000]  [<ffffffff81ad4197>] early_idt_handler+0x77/0xa4
[    0.000000]  [<ffffffff815b2663>] ? bug_at+0x45/0x47
[    0.000000]  [<ffffffff815b2663>] ? bug_at+0x45/0x47
[    0.000000]  [<ffffffff81006db6>] __jump_label_transform.isra.0+0x136/0x150
[    0.000000]  [<ffffffff81006ea7>] arch_jump_label_transform_static+0x77/0xc0
[    0.000000]  [<ffffffff81af8596>] jump_label_init+0x81/0xaf
[    0.000000]  [<ffffffff81ad4c02>] start_kernel+0x161/0x3ce
[    0.000000]  [<ffffffff81ad48a0>] ? repair_env_string+0x5e/0x5e
[    0.000000]  [<ffffffff81ad45a5>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81ad469f>] x86_64_start_kernel+0xf8/0xfc
[    0.000000] RIP 0x46

Bisection identified this as the problem commit.

9c85f3bdf400665eecf62658a9106501f6a77a13 is the first bad commit
commit 9c85f3bdf400665eecf62658a9106501f6a77a13
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jan 26 18:38:07 2012 -0500

    x86/jump-label: Add safety checks to jump label conversions

I did no further investigation yet in case this is already a known
problem.

-- 
Mel Gorman
SUSE Labs
