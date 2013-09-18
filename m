Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3IRTIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:08:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3IRTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:08:07 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5/8] audit: efficiency fix 2: request exclusive wait since all need same resource
Date: Wed, 18 Sep 2013 15:06:50 -0400
Message-Id: <5c2035525f6bf06dcaa24a5922071d2f4e4e495e.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

author: Dan Duval <dan.duval@oracle.com>

These and similar errors were seen on a patched 3.8 kernel when the
audit subsystem was overrun during boot:

  udevd[876]: worker [887] unexpectedly returned with status 0x0100
  udevd[876]: worker [887] failed while handling
'/devices/pci0000:00/0000:00:03.0/0000:40:00.0'
  udevd[876]: worker [880] unexpectedly returned with status 0x0100
  udevd[876]: worker [880] failed while handling
'/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1'

  udevadm settle - timeout of 180 seconds reached, the event queue
contains:
    /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1 (3995)
    /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT3F0D:00 (4034)

  audit: audit_backlog=258 > audit_backlog_limit=256
  audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=256

The change below increases the efficiency of the audit code and prevents it
from being overrun:

Use add_wait_queue_exclusive() in wait_for_auditd() to put the
thread on the wait queue.  When kauditd dequeues an skb, all
of the waiting threads are waiting for the same resource, but
only one is going to get it, so there's no need to wake up
more than one waiter.

See: https://lkml.org/lkml/2013/9/2/479

Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 25fab2d..990d02f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1061,7 +1061,7 @@ static unsigned long wait_for_auditd(unsigned long sleep_time)
 	unsigned long timeout = sleep_time;
 	DECLARE_WAITQUEUE(wait, current);
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
+	add_wait_queue_exclusive(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
 	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-- 
1.7.1

