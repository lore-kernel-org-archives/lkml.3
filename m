Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbaCYRz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:55:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbaCYRzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:55:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v4] printk: Cleanups and softlockup avoidance
Date: Tue, 25 Mar 2014 18:54:53 +0100
Message-Id: <1395770101-24534-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  this is another revision of the printk softlockup series.

Changes since v3:
Fixed bogus warning in console_try_lock_spin() in non-preemptible kernels.
Fixed infinite loop in console_flush() when console was suspended.

Changes since v2:
I have fixed up some small problems pointed out by Andrew, added possibility to
configure out the printk offloading logic (for small systems), and offload
kthreads are now started only once printk.offload_chars is set to value > 0.

Intro for the newcomers to the series below.

---

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

This is a revised series using my new approach to the problem which doesn't
let CPU out of console_unlock() until there's someone else to take over the
printing. The main difference since the last version is that instead of
passing printing duty to different CPUs via IPIs we use dedicated kthreads.
This method is somewhat less reliable (in a sense that there are more
situations in which handover needn't work at all - e.g. when the currently
printing CPU holds a spinlock and the CPU where kthread is scheduled to run is
spinning on this spinlock) but the code is much simpler and in my practical
testing kthread approach was good enough to avoid any problems (with one
exception - see patch 8/8).

								Honza
