Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaCMP77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:59:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbaCMP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:58:43 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6 v2] printk: Cleanups and softlockup avoidance
Date: Thu, 13 Mar 2014 16:58:32 +0100
Message-Id: <1394726318-2757-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  this is another piece of the printk softlockup saga series. Let me first
remind the problem:

Currently, console_unlock() prints messages from kernel printk buffer to
console while the buffer is non-empty. When serial console is attached,
printing is slow and thus other CPUs in the system have plenty of time
to append new messages to the buffer while one CPU is printing. Thus the
CPU can spend unbounded amount of time doing printing in console_unlock().
This is especially serious since vprintk_emit() calls console_unlock()
with interrupts disabled.
    
In practice users have observed a CPU can spend tens of seconds printing
in console_unlock() (usually during boot when hundreds of SCSI devices
are discovered) resulting in RCU stalls (CPU doing printing doesn't
reach quiescent state for a long time), softlockup reports (IPIs for the
printing CPU don't get served and thus other CPUs are spinning waiting
for the printing CPU to process IPIs), and eventually a machine death
(as messages from stalls and lockups append to printk buffer faster than
we are able to print). So these machines are unable to boot with serial
console attached. Also during artificial stress testing SATA disk
disappears from the system because its interrupts aren't served for too
long.
---

This is a revised series using my new approach to the problem which doesn't
let CPU out of console_unlock() until there's someone else to take over the
printing. The main difference since the last version is that instead of
passing printing duty to different CPUs via IPIs we use dedicated kthreads.
This method is somewhat less reliable (in a sense that there are more
situations in which handover needn't work at all - e.g. when the currently
printing CPU holds a spinlock and the CPU where kthread is scheduled to run is
spinning on this spinlock) but the code is much simpler and in my practical
testing kthread approach was good enough to avoid any problems (with one
exception - see below).

The patch set is organized as follows:

Patch 1 is just a cleanup which can be taken on its own (a result of my
research in kernel history ;).

Patches 2 and 3 change vprintk_emit() to call console_unlock() with interrupts
enabled so they help to reduce interrupt latency in common case when printk()
itself is called with interrupts enabled.

Patch 4 is a cleanup of printk_sched() facility from Steven.

Patch 5 is the meat of this series implementing passing of printing duty from
current CPU after printing printk.offload_chars. We wake up a kthread which
starts spinning on console_sem to take over printing.

Patch 6 fixes lockups in one situation which I hit in my testing - if someone
calls stop_machine(), handing over of printing stops working (see commit
message for details). If you find this too hacky, I'm ok with dropping this
patch at least for now because I'm not sure this problem can be hit without
artificially stressing the machine.

What do you guys think?

						Merry Christmas ;)
								Honza
