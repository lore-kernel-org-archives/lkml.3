Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaD0Oh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:37:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:60094 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753261AbaD0OgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:36:10 -0400
Message-Id: <20140427143608.452489671@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:36:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 2/4] fs: jbd2: pull your plug when waiting for space
References: <20140427143558.300461400@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-fs-jbd2-pull-your-plug-when-waiting-for-space.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.82-rt103-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Two cps in parallel managed to stall the the ext4 fs. It seems that
journal code is either waiting for locks or sleeping waiting for
something to happen. This seems similar to what Mike observed on ext3,
here is his description:

|With an -rt kernel, and a heavy sync IO load, tasks can jam
|up on journal locks without unplugging, which can lead to
|terminal IO starvation.  Unplug and schedule when waiting
|for space.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 fs/jbd2/checkpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index c78841e..a4d273b 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -125,6 +125,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JBD2_ABORT)
 			return;
 		write_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
-- 
1.8.5.3


