Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaC3Xtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:49:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbaC3Xnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Xiaoming Wang" <xiaoming.wang@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Chuansheng Liu" <chuansheng.liu@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.241895700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 148/200] genirq: Remove racy waitqueue_active check
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit c685689fd24d310343ac33942e9a54a974ae9c43 upstream.

We hit one rare case below:

T1 calling disable_irq(), but hanging at synchronize_irq()
always;
The corresponding irq thread is in sleeping state;
And all CPUs are in idle state;

After analysis, we found there is one possible scenerio which
causes T1 is waiting there forever:
CPU0                                       CPU1
 synchronize_irq()
  wait_event()
    spin_lock()
                                           atomic_dec_and_test(&threads_active)
      insert the __wait into queue
    spin_unlock()
                                           if(waitqueue_active)
    atomic_read(&threads_active)
                                             wake_up()

Here after inserted the __wait into queue on CPU0, and before
test if queue is empty on CPU1, there is no barrier, it maybe
cause it is not visible for CPU1 immediately, although CPU0 has
updated the queue list.
It is similar for CPU0 atomic_read() threads_active also.

So we'd need one smp_mb() before waitqueue_active.that, but removing
the waitqueue_active() check solves it as wel l and it makes
things simple and clear.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Xiaoming Wang <xiaoming.wang@intel.com>
Link: http://lkml.kernel.org/r/1393212590-32543-1-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.2: The corresponding check is in irq_thread()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -819,7 +819,7 @@ static int irq_thread(void *data)
 
 		wake = atomic_dec_and_test(&desc->threads_active);
 
-		if (wake && waitqueue_active(&desc->wait_for_threads))
+		if (wake)
 			wake_up(&desc->wait_for_threads);
 	}
 

