Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3EQV5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:57:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab3EQVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 09/33] tick: Cleanup NOHZ per cpu data on cpu down
Date: Fri, 17 May 2013 14:49:53 -0700
Message-Id: <20130517214917.854315322@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 4b0c0f294f60abcdd20994a8341a95c8ac5eeb96 upstream.

Prarit reported a crash on CPU offline/online. The reason is that on
CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
up. If at cpu online an interrupt happens before the per cpu tick
device is registered the irq_enter() check potentially sees stale data
and dereferences a NULL pointer.

Cleanup the data after the cpu is dead.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Cc: Mike Galbraith <bitbucket@online.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -811,7 +811,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 


