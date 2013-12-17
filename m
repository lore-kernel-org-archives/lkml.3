Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3LQOsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3LQOsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:48:18 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: printk: Cleanup and softlockup avoidance
Date: Tue, 17 Dec 2013 15:48:07 +0100
Message-Id: <1387291691-2224-1-git-send-email-jack@suse.cz>
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

Since my previous attempts to fix softlockups in printk under heavy load met
some resistance, I've decided to try a different approach - do not let
CPU out of the console_unlock() loop until there's someone else to take over
the printing. However that approach will need some changes in how
smp_call_function_any() works (as I need to make sure someone will come
sooner rather than later to rescue the printing CPU) and I don't want to
make already contentious series even worse. So to move at least by a bit,
let me post the following three patches that improve the situation by not
calling console_unlock() with interrupts disabled. I think they make sense
on their own (the third patch is actually an independent cleanup).

What do you guys think?

								Honza
