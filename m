Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbaDICwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:52:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:23775 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756800AbaDICwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:52:35 -0400
Message-Id: <20140409024700.702797305@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 08 Apr 2014 22:47:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RT 0/2] rwsem-rt: Make rwsem rt closer to mainline
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at mainline's down_read() I noticed that reader locks of rwsems
are not made to nest. In fact, they should not. Although, it may seem
fine if a down_read() nests as multiple readers can have the lock,
rwsems are fair locks. That is, if a writer were to block on a rwsem
while readers have the lock, a new reader will also block. If a reader
were to try to take the lock again while a writer was waiting, it
would block, and cause a deadlock as it has the lock its trying
to grab and wont let it go as the writer is waiting.

I also found that the rt_mutex_init() is identical in the two places
it is defined in rtmutex.h.

Steven Rostedt (Red Hat) (2):
      rwsem-rt: Do not allow readers to nest
      rtmutex: Remove duplicate rt_mutex_init()

----
 include/linux/rtmutex.h  | 12 +++---------
 include/linux/rwsem_rt.h |  1 -
 kernel/rt.c              | 37 ++++++++-----------------------------
 3 files changed, 11 insertions(+), 39 deletions(-)
