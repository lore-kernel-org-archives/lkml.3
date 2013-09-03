Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3ICDxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:53:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42713 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3ICDxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:53:52 -0400
Message-ID: <52255D4B.8070602@oracle.com>
Date: Mon, 02 Sep 2013 20:53:47 -0700
From: Chuck Anderson <chuck.anderson@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] audit: Two efficiency fixes for audit mechanism
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit: Two efficiency fixes for audit mechanism

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

The changes below increase the efficiency of the audit code and
prevent it from being overrun:

1. Only issue a wake_up in kauditd if the length of the skb queue
    is less than the backlog limit.  Otherwise, threads waiting in
    wait_for_auditd() will simply wake up, discover that the
    queue is still too long for them to proceed, and go back
    to sleep.  This results in wasted context switches and
    machine cycles.  kauditd_thread() is the only function that
    removes buffers from audit_skb_queue so we can't race.  If we
    did, the timeout in wait_for_auditd() would expire and the
    waiting thread would continue.

2. Use add_wait_queue_exclusive() in wait_for_auditd() to put the
    thread on the wait queue.  When kauditd dequeues an skb, all
    of the waiting threads are waiting for the same resource, but
    only one is going to get it, so there's no need to wake up
    more than one waiter.

Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
---
  kernel/audit.c |    7 +++++--
  1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9a78dde..d87b4dd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -449,8 +449,11 @@ static int kauditd_thread(void *dummy)
  		flush_hold_queue();

  		skb = skb_dequeue(&audit_skb_queue);
-		wake_up(&audit_backlog_wait);
+
  		if (skb) {
+			if(skb_queue_len(&audit_skb_queue) <= audit_backlog_limi
t)
+				wake_up(&audit_backlog_wait);
+
  			if (audit_pid)
  				kauditd_send_skb(skb);
  			else
@@ -1059,7 +1062,7 @@ static void wait_for_auditd(unsigned long 
sleep_time, int
limit)
  {
  	DECLARE_WAITQUEUE(wait, current);
  	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
+	add_wait_queue_exclusive(&audit_backlog_wait, &wait);

  	if (audit_backlog_limit &&
  	    skb_queue_len(&audit_skb_queue) > limit)
-- 
1.7.1
