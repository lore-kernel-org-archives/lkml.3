Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaEIJMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:12:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaEIJMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:12:03 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 00/11] printk: safe printing in NMI context
Date: Fri,  9 May 2014 11:10:54 +0200
Message-Id: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk() cannot be used safely in NMI context because it uses internal locks
and thus could cause a deadlock. Unfortunately there are circumstances when
calling printk from NMI is very useful. For example, all WARN.*(in_nmi())
would be much more helpful if they didn't lockup the machine.

Another example would be arch_trigger_all_cpu_backtrace for x86 which uses NMI
to dump traces on all CPU (either triggered by sysrq+l or from RCU stall
detector).

This patch set solves the problem by using trylock rather than spin_lock.
If the lock can not be taken, it uses NMI specific buffers to temporary
store the message.

Patches 1-5 are preparation steps to be able to handle more ring buffers
using the same functions.

Patch 6 adds the main logic to handle the NMI messages a safe way.

Patches 7-11 improve various aspects of the NMI messages handling.

It was a long way until I got stable working solution that would fulfill
the most important needs:

    + do not lock up the machine
    + prefer last messages if logging is too slow
    + pass the messages to the console as soon as possible
    + keep the order of messages, especially parts of continuous lines
    + reduce interlacing messages from normal and NMI context

The current solution works pretty well. There are still some corner cases
where the continuous messages are split. I still want to look at it but
I do not want to hide the work any longer. I look forward to hear your
opinion and hints.

Note that the first two patches modifies API that is used by some external
tools, e.g. crash, makedumpfile. The tools would need to get updated.
The API was changed to make the solution cleaner.

I added Paul E. McKenney into CC because there are used memory barriers
in the 6th patch.


The patch set is based on kernel-next. The last commit is a42b108e06bb28348
(Add linux-next specific files for 20140507).

It can be applied also on the Linus' tree if you apply the recent
patches that touch kernel/printk/printk.c

Petr Mladek (11):
  printk: rename struct printk_log to printk_msg
  printk: allow to handle more log buffers
  printk: rename "logbuf_lock" to "main_logbuf_lock"
  printk: add NMI ring and cont buffers
  printk: allow to modify NMI log buffer size using boot parameter
  printk: NMI safe printk
  printk: right ordering of the cont buffers from NMI context
  printk: try hard to print Oops message in NMI context
  printk: merge and flush NMI buffer predictably via IRQ work
  printk: survive rotation of sequence numbers
  printk: avoid staling when merging NMI log buffer

 Documentation/kernel-parameters.txt |   19 +-
 kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
 2 files changed, 878 insertions(+), 359 deletions(-)

-- 
1.8.4
