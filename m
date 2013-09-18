Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3IRTHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3IRTHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:07:53 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4/8] audit: efficiency fix 1: only wake up if queue shorter than backlog limit
Date: Wed, 18 Sep 2013 15:06:49 -0400
Message-Id: <9257f2c7a9926b85c485e1c0c0c52667df455ddf.1379530867.git.rgb@redhat.com>
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

Only issue a wake_up in kauditd if the length of the skb queue is less than the
backlog limit.  Otherwise, threads waiting in wait_for_auditd() will simply
wake up, discover that the queue is still too long for them to proceed, and go
back to sleep.  This results in wasted context switches and machine cycles.
kauditd_thread() is the only function that removes buffers from audit_skb_queue
so we can't race.  If we did, the timeout in wait_for_auditd() would expire and
the waiting thread would continue.

See: https://lkml.org/lkml/2013/9/2/479

Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 42c68db..25fab2d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -448,8 +448,10 @@ static int kauditd_thread(void *dummy)
 		flush_hold_queue();
 
 		skb = skb_dequeue(&audit_skb_queue);
-		wake_up(&audit_backlog_wait);
+
 		if (skb) {
+			if(skb_queue_len(&audit_skb_queue) <= audit_backlog_limit)
+				wake_up(&audit_backlog_wait);
 			if (audit_pid)
 				kauditd_send_skb(skb);
 			else
-- 
1.7.1

