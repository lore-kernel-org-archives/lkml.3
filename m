Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab3EXRn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab3EXRnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:43:25 -0400
Date: Fri, 24 May 2013 19:39:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Guy Streeter <streeter@redhat.com>, Eric Paris <eparis@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
Message-ID: <20130524173925.GA17177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_start() does wait_for_auditd() in a loop until
audit_backlog_wait_time passes or audit_skb_queue has a room.

If signal_pending() is true this becomes a busy-wait loop,
schedule() in TASK_INTERRUPTIBLE won't block.

Reported-by: Guy Streeter <streeter@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/kernel/audit.c
+++ x/kernel/audit.c
@@ -1056,7 +1056,7 @@ static inline void audit_get_stamp(struc
 static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_INTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&

