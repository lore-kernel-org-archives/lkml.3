Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLCSTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:19:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaLCSTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:19:34 -0500
Date: Wed, 3 Dec 2014 13:19:22 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, rgb@redhat.com, eparis@redhat.com
Subject: audit: rcu_read_lock() used illegally while idle
Message-ID: <20141203181922.GA26916@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	paulmck@linux.vnet.ibm.com, rgb@redhat.com, eparis@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure why this only just started complaining, because this code
hasn't changed in years, but I don't recall seeing this before.
This gets spewed during bootup since I put 3.18-rc7 on my firewall.
Previously it was running rc4 where I didn't see this.

Did something in RCU change recently ?

===============================
[ INFO: suspicious RCU usage. ]
3.18.0-rc7+ #93 Not tainted
-------------------------------
include/linux/rcupdate.h:883 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
RCU used illegally from extended quiescent state!
1 lock held by systemd-sysctl/557:
 #0:  (rcu_read_lock){......}, at: [<ffffffff890f1320>] audit_filter_type+0x0/0x240

stack backtrace:
CPU: 0 PID: 557 Comm: systemd-sysctl Not tainted 3.18.0-rc7+ #93
 0000000000000000 0000000063c50efc ffff88021f51fd28 ffffffff895abec3
 0000000000000000 ffff880234758000 ffff88021f51fd58 ffffffff890a5280
 ffff880221d9c548 00007fd651f320d0 0000000000000514 00000000ffff9012
Call Trace:
 [<ffffffff895abec3>] dump_stack+0x4e/0x68
 [<ffffffff890a5280>] lockdep_rcu_suspicious+0xf0/0x110
 [<ffffffff890f150e>] audit_filter_type+0x1ee/0x240
 [<ffffffff890f1320>] ? audit_filter_user+0x340/0x340
 [<ffffffff890ecd39>] audit_log_start+0x49/0x4a0
 [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
 [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
 [<ffffffff890f1973>] audit_log_exit+0x53/0xcf0
 [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
 [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
 [<ffffffff895b4f0c>] ? sysret_signal+0x5/0x43
 [<ffffffff890f4a65>] __audit_syscall_exit+0x245/0x2a0
 [<ffffffff895b4f61>] sysret_audit+0x17/0x21

