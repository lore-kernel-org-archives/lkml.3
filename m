Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaI3Ddv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaI3Ddu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:33:50 -0400
Date: Mon, 29 Sep 2014 23:33:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: pipe/page fault oddness.
Message-ID: <20140930033327.GA14558@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My fuzz tester ground to a halt, with many child processes blocked
on pipe_lock.  sysrq-t output: http://codemonkey.org.uk/junk/pipe-lock-wtf.txt

Looking at the dump, there's only one running trinity child,
with all the others blocking on it.

trinity-c49     R  running task    12856 19464   7633 0x00000004
ffff8800a09bf960 0000000000000002 ffff8800a09bf9f8 ffff880219650000
00000000001d4080 0000000000000000 ffff8800a09bffd8 00000000001d4080
ffff88023f755bc0 ffff880219650000 ffff8800a09bffd8 ffff88010b017e00
Call Trace:
[<ffffffff9181df46>] preempt_schedule+0x36/0x60
[<ffffffff9100e3d6>] ___preempt_schedule+0x56/0xb0
[<ffffffff911c3c67>] ? handle_mm_fault+0x3a7/0xcd0
[<ffffffff918239f1>] ? _raw_spin_unlock+0x31/0x50
[<ffffffff91823a05>] ? _raw_spin_unlock+0x45/0x50
[<ffffffff911c3c67>] handle_mm_fault+0x3a7/0xcd0
[<ffffffff910cb687>] ? __lock_is_held+0x57/0x80
[<ffffffff91042c84>] __do_page_fault+0x1a4/0x600
[<ffffffff910ce485>] ? mark_held_locks+0x75/0xa0
[<ffffffff910ce5bd>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[<ffffffff910ce68d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff9118eda7>] ? context_tracking_user_exit+0x67/0x1b0
[<ffffffff910430fe>] do_page_fault+0x1e/0x70
[<ffffffff918264b2>] page_fault+0x22/0x30
[<ffffffff911bd7e3>] ? copy_page_to_iter+0x3b3/0x500
[<ffffffff9120eddf>] pipe_read+0xdf/0x330
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff912051a0>] ? do_sync_readv_writev+0xa0/0xa0
[<ffffffff912053b8>] do_iter_readv_writev+0x78/0xc0
[<ffffffff91206bbe>] do_readv_writev+0xce/0x280
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff910cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac8ab>] ? preempt_count_sub+0x6b/0xf0
[<ffffffff91206da9>] vfs_readv+0x39/0x50
[<ffffffff91206e6c>] SyS_readv+0x5c/0x100
[<ffffffff918249e4>] tracesys+0xdd/0xe2

Running the function tracer on that pid shows it spinning forever..
http://codemonkey.org.uk/junk/pipe-trace.txt

Kernel bug (missing EFAULT check somewhere perhaps?), or is this a
case where the fuzzer asked the kernel to do something stupid, and it obliged ?

Trinity's watchdog process has been repeatedly sending SIGKILL's to this
running pid, but we never seem to get out of this state long enough for
it to take effect.

This is 3.17-rc7 fwiw.

	Dave

