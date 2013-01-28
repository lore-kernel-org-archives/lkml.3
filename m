Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3A1Qin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:38:43 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43484 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3A1Qik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:40 -0500
From: Igor Lukyanov <igor@lukyanov.org>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Subject: multiple heavy-loaded kvm guests cause NULL pointer in scheduler (kernel v 3.7.4)
Message-Id: <664484EB-E780-4A0C-9932-37E843F76EB7@lukyanov.org>
Date: Mon, 28 Jan 2013 20:38:36 +0400
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
we faced a repeatable scheduler or kvm bug while running multiple heavy-loaded kvm-virtualized winsrv 2008 guests on 3.7.4 kernel based Debian.
Few minutes after 10-15 virtual machines being started for their first time, the host falls into panic with one of the next traces:

TRACE 1:
[  589.970970] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
...
[  592.818372] Call Trace:
[  592.847727]  [<ffffffff81066544>] ? pick_next_task_fair+0x45/0x11e
[  592.921781]  [<ffffffff8105fdfc>] ? pick_next_task+0x1e/0x3f
[  592.989592]  [<ffffffff8136fdad>] ? __schedule+0x251/0x4e8
[  593.055320]  [<ffffffffa069dc8a>] ? trace_kvm_mmio+0x4d/0x4d [kvm]
[  593.129366]  [<ffffffffa06b2692>] ? segmented_read.isra.30+0x83/0xba [kvm]
[  593.211745]  [<ffffffff8107a504>] ? futex_wait_queue_me+0xbb/0xd6
[  593.284734]  [<ffffffff8107b04c>] ? futex_wait+0x10c/0x238
[  593.350484]  [<ffffffff8104cc29>] ? __set_current_blocked+0x2d/0x43
[  593.425555]  [<ffffffff8104cc9b>] ? sigprocmask+0x5c/0x63
[  593.490259]  [<ffffffffa06a588b>] ? kvm_arch_vcpu_ioctl_run+0xc48/0xc9f [kvm]
[  593.575739]  [<ffffffff8107c341>] ? do_futex+0xb3/0x81c
[  593.638350]  [<ffffffffa06a417d>] ? kvm_arch_vcpu_put+0x1b/0x24 [kvm]
[  593.715520]  [<ffffffffa0693127>] ? kvm_vcpu_ioctl+0x427/0x45e [kvm]
[  593.791657]  [<ffffffff8100d829>] ? __switch_to+0x38b/0x3cf
[  593.858415]  [<ffffffff8107cbc5>] ? sys_futex+0x11b/0x14e
[  593.923113]  [<ffffffffa069cdea>] ? kvm_on_user_return+0x36/0x5c [kvm]
[  594.001318]  [<ffffffff8100e62b>] ? do_notify_resume+0x5d/0x65
[  594.071225]  [<ffffffff8109ff3f>] ? rcu_user_enter+0x51/0x89
[  594.139025]  [<ffffffff81375ca9>] ? system_call_fastpath+0x16/0x1b
[  594.213065] Code: 48 09 c2 48 89 11 49 8b 48 08 48 85 c9 74 0c 48 8b 11 83 e2 01 48 09 c2 48 89 11 b9 06 00 00 00 48 89 c7 4c 89 c6 f3 a5 c3 31 c0 <48> 3b 3f 74 30 48 8b 47 08 48 85 c0 75 1e eb 03 48 89 d7 48 8b 
[  594.452471] RIP  [<ffffffff811c1fc1>] rb_next+0x2/0x38
[  594.514252]  RSP <ffff881019ee7b90>
[  594.556063] CR2: 0000000000000010
[  594.595803] ---[ end trace 8356dcba509c850e ]---

(see full trace in http://xdel.ru/downloads/oops-default-kvmintel.txt)

TRACE 2:
[52724.761591] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[52724.770555] Call Trace:
[52724.770626]  [<ffffffff81065709>] ? set_next_entity+0x32/0x52
[52724.770702]  [<ffffffff810665b4>] ? pick_next_task_fair+0xb5/0x11e
[52724.770779]  [<ffffffff8105fdfc>] ? pick_next_task+0x1e/0x3f
…
[52724.770702] RIP  [<ffffffff811c1d57>] rb_erase+0x1de/0x28f

(full trace: http://imgur.com/QUmszYj http://imgur.com/zhqLrCy http://imgur.com/TZipg7F)

In both cases system goes into active context switching (20-30% SYS CPU load) before the crash.

Some words about environment:
1. Traces produced on 3.7.4 kernel, though the same test is fatal for other kernel versions (checked on 3.4 and 3.2, with different traces).
2. CPU control groups are enabled and used for constraining guests' CPU consumption.
3. Bug is stably repeated with and without hyper threading, on 2-head Supermicro server having 2 numa nodes with following cpu layout: '0-5,12-17' and '6-11,18-23'. We haven't been able to produce the bug on a server with single numa node (maybe it's the key to solution).

Thank you for help.