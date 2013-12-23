Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3LWUmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:42:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab3LWUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:39:53 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/9] printk: Cleanups and softlockup avoidance
Date: Mon, 23 Dec 2013 21:39:21 +0100
Message-Id: <1387831171-5264-1-git-send-email-jack@suse.cz>
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
the printing.

This patch set implements that idea. It is organized as follows:

First three patches are cleanups of block layer and improvement of
smp_call_function_single() to use lockless lists.  These patches are already
queued in block tree so they are here only for completeness.

Patches 4-5 implement __smp_call_function_any() to IPI any CPU from given
cpumask with own csd structure provided.

Patches 6-8 are the printk cleanup patches I have already posted. They make
sense on their own so even if patch 9 is considered too problematic / needing
more work please consider merging these three.

Patch 9 implements the hand over of console_sem when CPU has printed over
printk.offload_chars characters and another CPU is in
console_trylock_for_printk() and also sending IPI to some other CPU to come and
take over printing if no printk has been called for a long time.

What do you guys think?

						Merry Christmas ;)
								Honza
