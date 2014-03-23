Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaCWPJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:09:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:57936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaCWPJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:09:14 -0400
Message-Id: <20140323150557.288925975@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 15:09:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 00/16] timers: Plug debugobject leaks and use del_timer_sync()
 in exit/teardown
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timers on stack must be initialized with init_timer_on_stack() which
creates a tracking object if DEBUG_OBJECTS is enabled. Quite some
places miss the complementary destroy_timer_on_stack(), which frees the
tracking object. So we leak the tracking object in the debug objects
store.

While looking at that, one affected driver also used del_timer()
instead of del_timer_sync() before returning, which is wrong as well
as del_timer() meriliy dequeues an armed timer, but does not wait for
a callback which is executed on a different cpu.

So I started to look through del_timer() sites and fixed a bunch of
obvious teardown, module exit pathes which must use del_timer_sync().

As I'm about to travel, I gave up on reviewing all the usage sites of
del_timer().

Maybe Julia has an idea to automate the scan a bit. The paring for
init_timer_on_stack/destroy_timer_on_stack should be easy enough, but
the del_timer() one is pretty complex and definitly needs manual
auditing, but having a scan assistant to identify potential places
would be definitely helpful.

Thanks,

	tglx
---
 drivers/atm/firestream.c           |    2 +-
 drivers/atm/idt77105.c             |    6 +++---
 drivers/block/cpqarray.c           |    2 +-
 drivers/block/umem.c               |    2 +-
 drivers/block/xsysace.c            |    2 ++
 drivers/bluetooth/bluecard_cs.c    |    2 +-
 drivers/bluetooth/hci_bcsp.c       |    2 +-
 drivers/bluetooth/hci_h5.c         |    2 +-
 drivers/cpufreq/intel_pstate.c     |    2 +-
 drivers/input/serio/hp_sdc.c       |    2 +-
 drivers/s390/char/tape_std.c       |    3 ++-
 drivers/s390/net/lcs.c             |    1 +
 drivers/scsi/qla1280.c             |    1 +
 drivers/thermal/intel_powerclamp.c |    1 +
 kernel/rcu/torture.c               |    4 +++-
 15 files changed, 21 insertions(+), 13 deletions(-)



